import 'dart:math';
import 'app_database.dart';
import 'daos/daos.dart';
import '../services/stock_data_sync_service.dart';
import '../../shared/utils/logger.dart';
import 'exceptions/database_exceptions.dart';

enum InitializationStatus {
  uninitialized,
  initializing,
  completed,
  failed,
}

/// 数据库服务单例
class DatabaseService {
  static final DatabaseService _instance = DatabaseService._internal();
  static DatabaseService get instance => _instance;

  late final AppDatabase db;
  
  InitializationStatus _status = InitializationStatus.uninitialized;
  bool _isInitializing = false;

  DatabaseService._internal();

  InitializationStatus get status => _status;

  bool get isInitialized => _status == InitializationStatus.completed;

  /// 初始化数据库
  /// [maxRetries] 最大重试次数，默认为3次
  /// [initialDelayMs] 初始退避延迟(毫秒)，默认为1000ms
  Future<void> initialize({
    int maxRetries = 3,
    int initialDelayMs = 1000,
  }) async {
    if (_isInitializing) {
      appLogger.w('数据库正在初始化中，等待完成...');
      while (_isInitializing) {
        await Future.delayed(const Duration(milliseconds: 100));
      }
      if (_status != InitializationStatus.completed) {
        throw DatabaseInitializationException('数据库初始化失败');
      }
      return;
    }

    if (_status == InitializationStatus.completed) {
      appLogger.i('数据库已初始化完成，跳过初始化');
      return;
    }

    _isInitializing = true;
    _status = InitializationStatus.initializing;

    appLogger.i('开始初始化数据库服务');
    db = AppDatabase();

    int retryCount = 0;
    while (retryCount < maxRetries) {
      try {
        await _initData();
        _status = InitializationStatus.completed;
        _isInitializing = false;
        appLogger.i('数据库服务初始化完成');
        return;
      } catch (e) {
        retryCount++;
        if (retryCount >= maxRetries) {
          _status = InitializationStatus.failed;
          _isInitializing = false;
          appLogger.e('数据库初始化失败，已达到最大重试次数: $maxRetries');
          throw DatabaseInitializationException(
            '数据库初始化失败，已达到最大重试次数',
            cause: e,
          );
        }
        
        final delayMs = initialDelayMs * pow(2, retryCount - 1);
        appLogger.w('数据库初始化失败，正在进行第 $retryCount 次重试，等待 ${delayMs}ms...');
        await Future.delayed(Duration(milliseconds: delayMs.toInt()));
      }
    }

    _isInitializing = false;
    _status = InitializationStatus.failed;
    throw DatabaseInitializationException('数据库初始化失败');
  }

  /// 初始化基础数据
  Future<void> _initData() async {
    try {
      appLogger.i('开始初始化基础数据');

      // 检查数据库中是否已经有数据
      final hasExistingData = await _checkHasExistingData();
      
      if (hasExistingData) {
        appLogger.i('检测到数据库已存在数据，跳过初始化');
        appLogger.i('基础数据初始化完成');
        return;
      }

      await db.configDao.initMarketData();
      appLogger.i('市场数据初始化成功');

      await db.configDao.initSystemConfigs();
      appLogger.i('系统配置初始化成功');

      final syncService = StockDataSyncService(db);
      appLogger.i('开始从外部数据库同步股票数据...');
      final synced = await syncService.syncFromExternalDatabase();

      if (synced) {
        final newCount = await syncService.getStockCount();
        appLogger.i('外部数据同步完成，共 $newCount 支股票');
      } else {
        appLogger.i('外部数据同步失败，初始化示例数据');
        await db.configDao.initSampleStockData();
        appLogger.i('示例股票数据初始化成功');

        await db.configDao.initSampleKlineData();
        appLogger.i('示例K线数据初始化成功');
      }

      appLogger.i('基础数据初始化完成');
    } catch (e, stackTrace) {
      appLogger.e('基础数据初始化失败', error: e, stackTrace: stackTrace);
      rethrow;
    }
  }

  /// 检查数据库中是否已经有数据
  Future<bool> _checkHasExistingData() async {
    try {
      // 检查 symbols 表是否有数据
      final symbolCount = await db.customSelect(
        'SELECT COUNT(*) as count FROM symbols',
      ).getSingle();
      
      final count = symbolCount.data['count'] as int? ?? 0;
      
      if (count > 0) {
        appLogger.i('检测到已有 $count 支股票数据');
        return true;
      }
      
      // 也可以检查 kline_data 表
      final klineCount = await db.customSelect(
        'SELECT COUNT(*) as count FROM kline_data LIMIT 1',
      ).getSingle();
      
      final klineDataCount = klineCount.data['count'] as int? ?? 0;
      
      if (klineDataCount > 0) {
        appLogger.i('检测到已有K线数据');
        return true;
      }
      
      return false;
    } catch (e) {
      // 如果查询失败，可能表还不存在
      appLogger.w('检查现有数据失败: $e');
      return false;
    }
  }

  /// 获取数据库实例
  AppDatabase get database => db;

  /// 获取用户DAO
  UserDao get userDao => db.userDao;

  /// 获取K线DAO
  KlineDao get klineDao => db.klineDao;

  /// 获取市场DAO
  MarketDao get marketDao => db.marketDao;

  /// 获取训练DAO
  TrainingDao get trainingDao => db.trainingDao;

  /// 获取交易DAO
  TradeDao get tradeDao => db.tradeDao;

  /// 获取分析DAO
  AnalysisDao get analysisDao => db.analysisDao;

  /// 获取配置DAO
  ConfigDao get configDao => db.configDao;

  /// 获取选股DAO
  StockFilterDao get stockFilterDao => db.stockFilterDao;

  /// 关闭数据库连接
  Future<void> close() async {
    await db.close();
  }

  /// 重置数据库（开发测试用）
  Future<void> reset() async {
    await db.close();
    // 重新初始化
    await initialize();
  }
}

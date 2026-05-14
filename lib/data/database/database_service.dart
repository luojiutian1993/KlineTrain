import 'app_database.dart';
import 'daos/daos.dart';
import '../../shared/utils/logger.dart';

/// 数据库服务单例
class DatabaseService {
  static final DatabaseService _instance = DatabaseService._internal();
  static DatabaseService get instance => _instance;

  late final AppDatabase db;

  DatabaseService._internal();

  /// 初始化数据库
  /// [maxRetries] 最大重试次数，默认为3次
  Future<void> initialize({int maxRetries = 3}) async {
    appLogger.i('开始初始化数据库服务');
    db = AppDatabase();
    
    int retryCount = 0;
    while (retryCount < maxRetries) {
      try {
        await _initData();
        appLogger.i('数据库服务初始化完成');
        return;
      } catch (e) {
        retryCount++;
        if (retryCount >= maxRetries) {
          appLogger.e('数据库初始化失败，已达到最大重试次数: $maxRetries');
          rethrow;
        }
        appLogger.w('数据库初始化失败，正在进行第 $retryCount 次重试...');
        await Future.delayed(Duration(seconds: retryCount));
      }
    }
  }

  /// 初始化基础数据
  Future<void> _initData() async {
    try {
      appLogger.i('开始初始化基础数据');
      
      await db.configDao.initMarketData();
      appLogger.i('市场数据初始化成功');
      
      await db.configDao.initSystemConfigs();
      appLogger.i('系统配置初始化成功');
      
      appLogger.i('基础数据初始化完成');
    } catch (e, stackTrace) {
      appLogger.e('基础数据初始化失败', error: e, stackTrace: stackTrace);
      rethrow;
    }
  }

  /// 获取数据库实例
  AppDatabase get database => db;

  /// 获取用户DAO
  UserDao get userDao => db.userDao;

  /// 获取K线DAO
  KlineDao get klineDao => db.klineDao;

  /// 获取训练DAO
  TrainingDao get trainingDao => db.trainingDao;

  /// 获取交易DAO
  TradeDao get tradeDao => db.tradeDao;

  /// 获取分析DAO
  AnalysisDao get analysisDao => db.analysisDao;

  /// 获取配置DAO
  ConfigDao get configDao => db.configDao;

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

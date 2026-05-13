import 'app_database.dart';
import 'daos/daos.dart';

/// 数据库服务单例
class DatabaseService {
  static final DatabaseService _instance = DatabaseService._internal();
  static DatabaseService get instance => _instance;

  late final AppDatabase db;

  DatabaseService._internal();

  /// 初始化数据库
  Future<void> initialize() async {
    db = AppDatabase();
    await _initData();
  }

  /// 初始化基础数据
  Future<void> _initData() async {
    try {
      await db.configDao.initMarketData();
      await db.configDao.initSystemConfigs();
    } catch (e) {
      // 日志记录
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

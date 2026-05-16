import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

import 'app.dart';
import 'data/database/database_service.dart';
import 'shared/utils/logger.dart';
import 'shared/widgets/error_page.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  try {
    await dotenv.load();
    appLogger.i('环境配置加载完成');
    
    await DatabaseService.instance.initialize();
    appLogger.i('数据库初始化完成');
    
    runApp(
      const ProviderScope(
        child: MyApp(),
      ),
    );
  } catch (e, stackTrace) {
    appLogger.e('应用初始化失败', error: e, stackTrace: stackTrace);
    
    runApp(
      ErrorPage(
        errorMessage: '应用初始化失败\n${e.toString()}',
        onRetry: () {
          main();
        },
      ),
    );
  }
}
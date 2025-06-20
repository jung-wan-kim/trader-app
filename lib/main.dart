import 'package:flutter/material.dart';
import 'package:flutter/semantics.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'generated/l10n/app_localizations.dart';
import 'screens/splash_screen.dart';
import 'config/app_config.dart';
import 'providers/language_provider.dart';
import 'services/market_service.dart';
import 'services/trading_service.dart';
import 'services/portfolio_service.dart';
import 'services/notification_service.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  // Enable semantics for testing only in debug mode
  if (const bool.fromEnvironment('dart.vm.product') == false) {
    WidgetsBinding.instance.ensureSemantics();
  }
  
  // Load environment variables only in non-test environment
  if (!const bool.fromEnvironment('flutter.test')) {
    try {
      await dotenv.load(fileName: "config/development.env");
    } catch (e) {
      // .env file not found, continue with defaults
      print('Warning: .env file not found, using default values');
    }
  }
  
  // 환경 변수에서 Supabase 설정 가져오기
  final supabaseUrl = dotenv.env['SUPABASE_URL'];
  final supabaseAnonKey = dotenv.env['SUPABASE_ANON_KEY'];
  
  // 환경 변수 필수 체크
  if (supabaseUrl == null || supabaseUrl.isEmpty) {
    throw Exception('SUPABASE_URL is not set in environment variables. '
        'Please check your config/development.env file.');
  }
  
  if (supabaseAnonKey == null || supabaseAnonKey.isEmpty) {
    throw Exception('SUPABASE_ANON_KEY is not set in environment variables. '
        'Please check your config/development.env file.');
  }
  
  // Supabase 초기화
  await Supabase.initialize(
    url: supabaseUrl,
    anonKey: supabaseAnonKey,
  );
  
  runApp(
    const ProviderScope(
      child: MyApp(),
    ),
  );
}

// 전역 Supabase 클라이언트
final supabase = Supabase.instance.client;

class MyApp extends ConsumerWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final locale = ref.watch(languageProvider);
    
    return MaterialApp(
      title: 'Trader App',
      locale: locale,
      localizationsDelegates: const [
        AppLocalizations.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: LanguageNotifier.supportedLocales,
      theme: ThemeData(
        brightness: Brightness.dark,
        primaryColor: Colors.black,
        scaffoldBackgroundColor: Colors.black,
        colorScheme: const ColorScheme.dark(
          primary: Colors.white,
          secondary: Color(0xFF00D632), // 녹색으로 변경 (상승 컬러)
          tertiary: Color(0xFFFF3B30), // 빨간색 (하락 컬러)
        ),
      ),
      debugShowCheckedModeBanner: false,
      showSemanticsDebugger: false, // 디버깅용, 필요시 true로 변경
      home: const SplashScreen(),
    );
  }
}
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
// import 'package:firebase_core/firebase_core.dart';
import 'generated/l10n/app_localizations.dart';
import 'screens/splash_screen.dart';
import 'config/app_config.dart';
import 'providers/language_provider.dart';
import 'services/market_service.dart';
import 'services/trading_service.dart';
import 'services/portfolio_service.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  // Firebase 초기화 (임시 비활성화)
  // await Firebase.initializeApp();
  
  // Supabase 초기화
  await Supabase.initialize(
    url: 'https://lgebgddeerpxdjvtqvoi.supabase.co',
    anonKey: 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6ImxnZWJnZGRlZXJweGRqdnRxdm9pIiwicm9sZSI6ImFub24iLCJpYXQiOjE3NDkxOTc2MDksImV4cCI6MjA2NDc3MzYwOX0.NZxHOwzgRc-Vjw60XktU7L_hKiIMAW_5b_DHis6qKBE',
  );
  
  runApp(
    const ProviderScope(
      child: TraderApp(),
    ),
  );
}

// 전역 Supabase 클라이언트
final supabase = Supabase.instance.client;

class TraderApp extends ConsumerWidget {
  const TraderApp({super.key});

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
      home: const SplashScreen(),
    );
  }
}
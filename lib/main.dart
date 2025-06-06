import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'screens/login_screen.dart';
import 'config/app_config.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  // TODO: 백엔드 연동 시 초기화 코드 추가
  // 현재는 목업 데이터로 개발 진행
  
  runApp(
    const ProviderScope(
      child: TraderApp(),
    ),
  );
}

class TraderApp extends StatelessWidget {
  const TraderApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Trader App',
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
      home: const LoginScreen(),
    );
  }
}
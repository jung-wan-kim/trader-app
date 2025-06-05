import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'screens/main_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  // Supabase 초기화
  await Supabase.initialize(
    url: 'https://puoscoaltsznczqdfjh.supabase.co',
    anonKey: 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6InB1b3Njb2FsdHN6bmN6cWRmamgiLCJyb2xlIjoiYW5vbiIsImlhdCI6MTczMjg2MDk2NSwiZXhwIjoyMDQ4NDM2OTY1fQ.P2FrZXJdcds7O7enI2qLrO-qCgBKu-51lzoMfBU6Nxo',
  );
  
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
      home: const MainScreen(),
    );
  }
}
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:trader_app/generated/l10n/app_localizations.dart';
import 'package:trader_app/providers/language_provider.dart';

/// 테스트를 위한 래퍼 위젯
/// ProviderScope와 MaterialApp을 포함하여 테스트 환경을 구성
class TestWrapper extends StatelessWidget {
  final Widget child;
  final Locale? locale;

  const TestWrapper({
    super.key,
    required this.child,
    this.locale,
  });

  @override
  Widget build(BuildContext context) {
    return ProviderScope(
      child: MaterialApp(
        locale: locale ?? const Locale('en'),
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
            secondary: Color(0xFF00D632),
            tertiary: Color(0xFFFF3B30),
          ),
        ),
        home: child,
      ),
    );
  }
}
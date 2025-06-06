import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LanguageNotifier extends StateNotifier<Locale> {
  LanguageNotifier() : super(const Locale('en')) {
    _loadLanguage();
  }

  static const List<Locale> supportedLocales = [
    Locale('en'), // English
    Locale('ko'), // Korean
    Locale('zh'), // Chinese (Simplified)
    Locale('ja'), // Japanese
    Locale('es'), // Spanish
    Locale('de'), // German
    Locale('fr'), // French
    Locale('pt'), // Portuguese
    Locale('hi'), // Hindi
    Locale('ar'), // Arabic
  ];

  Future<void> _loadLanguage() async {
    final prefs = await SharedPreferences.getInstance();
    final languageCode = prefs.getString('selectedLanguage') ?? 'en';
    
    final locale = supportedLocales.firstWhere(
      (locale) => locale.languageCode == languageCode,
      orElse: () => const Locale('en'),
    );
    
    state = locale;
  }

  Future<void> changeLanguage(String languageCode) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('selectedLanguage', languageCode);
    
    final locale = supportedLocales.firstWhere(
      (locale) => locale.languageCode == languageCode,
      orElse: () => const Locale('en'),
    );
    
    state = locale;
  }

  String getLanguageName(String languageCode) {
    switch (languageCode) {
      case 'en':
        return 'English';
      case 'ko':
        return '한국어';
      case 'zh':
        return '中文简体';
      case 'ja':
        return '日本語';
      case 'es':
        return 'Español';
      case 'de':
        return 'Deutsch';
      case 'fr':
        return 'Français';
      case 'pt':
        return 'Português';
      case 'hi':
        return 'हिन्दी';
      case 'ar':
        return 'العربية';
      default:
        return 'English';
    }
  }

  String getLanguageFlag(String languageCode) {
    switch (languageCode) {
      case 'en':
        return '🇺🇸';
      case 'ko':
        return '🇰🇷';
      case 'zh':
        return '🇨🇳';
      case 'ja':
        return '🇯🇵';
      case 'es':
        return '🇪🇸';
      case 'de':
        return '🇩🇪';
      case 'fr':
        return '🇫🇷';
      case 'pt':
        return '🇧🇷';
      case 'hi':
        return '🇮🇳';
      case 'ar':
        return '🇦🇪';
      default:
        return '🇺🇸';
    }
  }
}

final languageProvider = StateNotifierProvider<LanguageNotifier, Locale>((ref) {
  return LanguageNotifier();
});
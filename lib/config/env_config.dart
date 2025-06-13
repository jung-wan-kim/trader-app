import 'package:flutter_dotenv/flutter_dotenv.dart';

class EnvConfig {
  static const String environment = String.fromEnvironment(
    'ENVIRONMENT',
    defaultValue: 'development',
  );

  static String get apiBaseUrl =>
      dotenv.env['API_BASE_URL'] ?? 'https://api.trader-app.com';

  static String get supabaseUrl =>
      dotenv.env['SUPABASE_URL'] ?? '';

  static String get supabaseAnonKey =>
      dotenv.env['SUPABASE_ANON_KEY'] ?? '';

  // Firebase Configuration
  static String get firebaseProjectId =>
      dotenv.env['FIREBASE_PROJECT_ID'] ?? '';

  static String get firebaseAppIdIOS =>
      dotenv.env['FIREBASE_APP_ID_IOS'] ?? '';

  static String get firebaseAppIdAndroid =>
      dotenv.env['FIREBASE_APP_ID_ANDROID'] ?? '';

  static String get firebaseApiKey =>
      dotenv.env['FIREBASE_API_KEY'] ?? '';

  static String get firebaseMessagingSenderId =>
      dotenv.env['FIREBASE_MESSAGING_SENDER_ID'] ?? '';

  // Finnhub Configuration
  static String get finnhubApiKey =>
      dotenv.env['FINNHUB_API_KEY'] ?? 'cs2m9k9r01qt4r9kq970cs2m9k9r01qt4r9kq97g'; // Free test key as fallback

  // Sentry Configuration
  static String get sentryDsn =>
      dotenv.env['SENTRY_DSN'] ?? '';

  static String get sentryEnvironment =>
      dotenv.env['SENTRY_ENVIRONMENT'] ?? environment;

  static String get sentryReleasePrefix =>
      dotenv.env['SENTRY_RELEASE_PREFIX'] ?? 'trader-app';

  // Feature Flags
  static bool get enableAnalytics =>
      dotenv.env['ENABLE_ANALYTICS']?.toLowerCase() == 'true';

  static bool get enableCrashReporting =>
      dotenv.env['ENABLE_CRASH_REPORTING']?.toLowerCase() == 'true';

  static bool get enablePerformanceMonitoring =>
      dotenv.env['ENABLE_PERFORMANCE_MONITORING']?.toLowerCase() == 'true';

  static bool get enableRemoteConfig =>
      dotenv.env['ENABLE_REMOTE_CONFIG']?.toLowerCase() == 'true';

  // Debug Settings
  static bool get debugMode =>
      dotenv.env['DEBUG_MODE']?.toLowerCase() == 'true';

  static bool get verboseLogging =>
      dotenv.env['VERBOSE_LOGGING']?.toLowerCase() == 'true';

  static bool get mockApiEnabled =>
      dotenv.env['MOCK_API_ENABLED']?.toLowerCase() == 'true';

  static bool get isDevelopment => environment == 'development';
  static bool get isStaging => environment == 'staging';
  static bool get isProduction => environment == 'production';

  static Future<void> init() async {
    final envFile = _getEnvFile();
    await dotenv.load(fileName: envFile);
  }

  static String _getEnvFile() {
    switch (environment) {
      case 'production':
        return 'config/production.env';
      case 'staging':
        return 'config/staging.env';
      case 'development':
      default:
        return 'config/development.env';
    }
  }
}
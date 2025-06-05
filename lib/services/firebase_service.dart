import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:firebase_performance/firebase_performance.dart';
import 'package:firebase_remote_config/firebase_remote_config.dart';
import 'package:flutter/foundation.dart';
import '../config/env_config.dart';

class FirebaseService {
  static FirebaseAnalytics? _analytics;
  static FirebaseAnalyticsObserver? _observer;
  static FirebaseCrashlytics? _crashlytics;
  static FirebasePerformance? _performance;
  static FirebaseRemoteConfig? _remoteConfig;

  static FirebaseAnalytics? get analytics => _analytics;
  static FirebaseAnalyticsObserver? get observer => _observer;
  static FirebaseCrashlytics? get crashlytics => _crashlytics;
  static FirebasePerformance? get performance => _performance;
  static FirebaseRemoteConfig? get remoteConfig => _remoteConfig;

  static Future<void> init() async {
    try {
      await Firebase.initializeApp();
      
      // Initialize Analytics
      if (EnvConfig.enableAnalytics) {
        _analytics = FirebaseAnalytics.instance;
        _observer = FirebaseAnalyticsObserver(analytics: _analytics!);
        
        // Set analytics collection based on environment
        await _analytics!.setAnalyticsCollectionEnabled(
          !EnvConfig.isDevelopment,
        );
        
        // Set user properties
        await _analytics!.setUserProperty(
          name: 'environment',
          value: EnvConfig.environment,
        );
      }

      // Initialize Crashlytics
      if (EnvConfig.enableCrashReporting) {
        _crashlytics = FirebaseCrashlytics.instance;
        
        // Configure Crashlytics
        await _crashlytics!.setCrashlyticsCollectionEnabled(
          !EnvConfig.isDevelopment,
        );
        
        // Set up Flutter error handling
        FlutterError.onError = (errorDetails) {
          _crashlytics!.recordFlutterError(errorDetails);
        };
        
        // Catch errors outside of Flutter
        PlatformDispatcher.instance.onError = (error, stack) {
          _crashlytics!.recordError(error, stack, fatal: true);
          return true;
        };
      }

      // Initialize Performance Monitoring
      if (EnvConfig.enablePerformanceMonitoring) {
        _performance = FirebasePerformance.instance;
        
        // Configure performance monitoring
        await _performance!.setPerformanceCollectionEnabled(
          !EnvConfig.isDevelopment,
        );
      }

      // Initialize Remote Config
      if (EnvConfig.enableRemoteConfig) {
        _remoteConfig = FirebaseRemoteConfig.instance;
        
        // Configure remote config settings
        await _remoteConfig!.setConfigSettings(
          RemoteConfigSettings(
            fetchTimeout: const Duration(minutes: 1),
            minimumFetchInterval: EnvConfig.isDevelopment
                ? const Duration(minutes: 5)
                : const Duration(hours: 12),
          ),
        );
        
        // Set default values
        await _remoteConfig!.setDefaults(_getDefaultRemoteConfigValues());
        
        // Fetch and activate
        await _remoteConfig!.fetchAndActivate();
      }
    } catch (e) {
      debugPrint('Firebase initialization error: $e');
    }
  }

  // Analytics methods
  static Future<void> logEvent({
    required String name,
    Map<String, dynamic>? parameters,
  }) async {
    if (_analytics == null || !EnvConfig.enableAnalytics) return;

    await _analytics!.logEvent(
      name: name,
      parameters: parameters,
    );
  }

  static Future<void> logScreenView({
    required String screenName,
    String? screenClass,
  }) async {
    if (_analytics == null || !EnvConfig.enableAnalytics) return;

    await _analytics!.logScreenView(
      screenName: screenName,
      screenClass: screenClass ?? screenName,
    );
  }

  static Future<void> setUserId(String? userId) async {
    if (_analytics == null || !EnvConfig.enableAnalytics) return;

    await _analytics!.setUserId(id: userId);
    
    if (_crashlytics != null && EnvConfig.enableCrashReporting) {
      _crashlytics!.setUserIdentifier(userId ?? '');
    }
  }

  static Future<void> setUserProperty({
    required String name,
    required String? value,
  }) async {
    if (_analytics == null || !EnvConfig.enableAnalytics) return;

    await _analytics!.setUserProperty(name: name, value: value);
  }

  // Crashlytics methods
  static void recordError(
    dynamic exception,
    StackTrace? stack, {
    String? reason,
    bool fatal = false,
  }) {
    if (_crashlytics == null || !EnvConfig.enableCrashReporting) return;

    _crashlytics!.recordError(
      exception,
      stack,
      reason: reason,
      fatal: fatal,
    );
  }

  static void log(String message) {
    if (_crashlytics == null || !EnvConfig.enableCrashReporting) return;

    _crashlytics!.log(message);
  }

  static void setCustomKey(String key, dynamic value) {
    if (_crashlytics == null || !EnvConfig.enableCrashReporting) return;

    _crashlytics!.setCustomKey(key, value);
  }

  // Performance monitoring methods
  static Trace? newTrace(String name) {
    if (_performance == null || !EnvConfig.enablePerformanceMonitoring) {
      return null;
    }

    return _performance!.newTrace(name);
  }

  static HttpMetric? newHttpMetric(String url, HttpMethod httpMethod) {
    if (_performance == null || !EnvConfig.enablePerformanceMonitoring) {
      return null;
    }

    return _performance!.newHttpMetric(url, httpMethod);
  }

  // Remote Config methods
  static bool getBool(String key) {
    if (_remoteConfig == null || !EnvConfig.enableRemoteConfig) {
      return _getDefaultRemoteConfigValues()[key] ?? false;
    }

    return _remoteConfig!.getBool(key);
  }

  static double getDouble(String key) {
    if (_remoteConfig == null || !EnvConfig.enableRemoteConfig) {
      return _getDefaultRemoteConfigValues()[key] ?? 0.0;
    }

    return _remoteConfig!.getDouble(key);
  }

  static int getInt(String key) {
    if (_remoteConfig == null || !EnvConfig.enableRemoteConfig) {
      return _getDefaultRemoteConfigValues()[key] ?? 0;
    }

    return _remoteConfig!.getInt(key);
  }

  static String getString(String key) {
    if (_remoteConfig == null || !EnvConfig.enableRemoteConfig) {
      return _getDefaultRemoteConfigValues()[key] ?? '';
    }

    return _remoteConfig!.getString(key);
  }

  static Map<String, dynamic> _getDefaultRemoteConfigValues() {
    return {
      'enable_new_feature': false,
      'maintenance_mode': false,
      'min_version': '1.0.0',
      'force_update_version': '0.0.0',
      'api_timeout_seconds': 30,
      'max_retry_attempts': 3,
      'feature_flags': '{}',
    };
  }
}
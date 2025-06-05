import 'package:flutter/foundation.dart';
import 'package:sentry_flutter/sentry_flutter.dart';
import '../config/env_config.dart';

class SentryService {
  static Future<void> init({
    required AppRunner appRunner,
  }) async {
    if (!EnvConfig.enableCrashReporting) {
      return appRunner();
    }

    await SentryFlutter.init(
      (options) {
        options.dsn = EnvConfig.sentryDsn;
        options.environment = EnvConfig.sentryEnvironment;
        options.release = '${EnvConfig.sentryReleasePrefix}@1.0.0+1';
        options.debug = EnvConfig.debugMode;
        options.tracesSampleRate = EnvConfig.enablePerformanceMonitoring ? 0.3 : 0.0;
        options.attachScreenshot = true;
        options.attachViewHierarchy = true;
        options.sendDefaultPii = false;
        
        // Set sample rates based on environment
        if (EnvConfig.isProduction) {
          options.sampleRate = 0.3;
          options.tracesSampleRate = 0.1;
        } else if (EnvConfig.isStaging) {
          options.sampleRate = 0.5;
          options.tracesSampleRate = 0.3;
        } else {
          options.sampleRate = 1.0;
          options.tracesSampleRate = 1.0;
        }

        // Configure integrations
        options.enableAutoPerformanceTracing = EnvConfig.enablePerformanceMonitoring;
        options.enableUserInteractionTracing = true;
        options.enableAutoNativeBreadcrumbs = true;
        options.maxBreadcrumbs = 100;
        
        // Configure event processors
        options.beforeSend = (event, hint) async {
          // Filter out certain errors in production
          if (EnvConfig.isProduction) {
            if (event.throwable is NetworkException) {
              return null; // Don't send network errors
            }
          }
          return event;
        };
      },
      appRunner: appRunner,
    );
  }

  static void captureException(
    dynamic exception, {
    dynamic stackTrace,
    Map<String, dynamic>? extra,
    Severity? level,
  }) {
    if (!EnvConfig.enableCrashReporting) return;

    Sentry.captureException(
      exception,
      stackTrace: stackTrace,
      withScope: (scope) {
        if (extra != null) {
          extra.forEach((key, value) {
            scope.setExtra(key, value);
          });
        }
        if (level != null) {
          scope.level = level;
        }
      },
    );
  }

  static void captureMessage(
    String message, {
    SentryLevel? level,
    Map<String, dynamic>? extra,
  }) {
    if (!EnvConfig.enableCrashReporting) return;

    Sentry.captureMessage(
      message,
      level: level ?? SentryLevel.info,
      withScope: (scope) {
        if (extra != null) {
          extra.forEach((key, value) {
            scope.setExtra(key, value);
          });
        }
      },
    );
  }

  static void addBreadcrumb({
    required String message,
    String? category,
    Map<String, dynamic>? data,
    SentryLevel? level,
  }) {
    if (!EnvConfig.enableCrashReporting) return;

    Sentry.addBreadcrumb(
      Breadcrumb(
        message: message,
        category: category,
        data: data,
        level: level ?? SentryLevel.info,
        timestamp: DateTime.now(),
      ),
    );
  }

  static Future<void> captureUserFeedback({
    required String name,
    required String email,
    required String comments,
  }) async {
    if (!EnvConfig.enableCrashReporting) return;

    final user = SentryUser(
      email: email,
      username: name,
    );

    await Sentry.captureUserFeedback(
      SentryUserFeedback(
        eventId: const SentryId.empty(),
        name: name,
        email: email,
        comments: comments,
      ),
    );
  }

  static ISentrySpan? startTransaction({
    required String name,
    required String operation,
  }) {
    if (!EnvConfig.enablePerformanceMonitoring) return null;

    return Sentry.startTransaction(name, operation);
  }

  static void setUser(SentryUser? user) {
    Sentry.configureScope((scope) => scope.user = user);
  }

  static void setTag(String key, String value) {
    Sentry.configureScope((scope) => scope.setTag(key, value));
  }

  static void setContext(String key, Map<String, dynamic> context) {
    Sentry.configureScope((scope) => scope.setContexts(key, context));
  }
}

class NetworkException implements Exception {
  final String message;
  NetworkException(this.message);
}

typedef AppRunner = Future<void> Function();
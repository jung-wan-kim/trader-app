// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Arabic (`ar`).
class AppLocalizationsAr extends AppLocalizations {
  AppLocalizationsAr([String locale = 'ar']) : super(locale);

  @override
  String get appTitle => 'تطبيق المتداول';

  @override
  String get appSubtitle => 'توصيات الأسهم المدعومة بالذكاء الاصطناعي';

  @override
  String get chooseLanguage => 'اختر لغتك';

  @override
  String get selectLanguageDescription => 'اختر لغتك المفضلة للتطبيق';

  @override
  String get continueButton => 'متابعة';

  @override
  String get onboardingTitle1 => 'استراتيجيات المتداولين الأسطوريين';

  @override
  String get onboardingDesc1 =>
      'استخدم استراتيجيات الاستثمار المجربة لأنجح المتداولين في التاريخ مثل جيسي ليفرمور وويليام أونيل';

  @override
  String get onboardingTitle2 => 'توصيات الأسهم بالذكاء الاصطناعي';

  @override
  String get onboardingDesc2 =>
      'احصل على توصيات أسهم مثلى تتطابق مع استراتيجيات المتداولين الأسطوريين من خلال تحليل السوق المتقدم بالذكاء الاصطناعي';

  @override
  String get onboardingTitle3 => 'إدارة المخاطر';

  @override
  String get onboardingDesc3 =>
      'حقق استثمارات آمنة باستخدام حاسبة حجم المركز واستراتيجيات وقف الخسارة/جني الربح';

  @override
  String get onboardingTitle4 => 'تحليل السوق في الوقت الفعلي';

  @override
  String get onboardingDesc4 =>
      'افهم اتجاهات السوق والتقط التوقيت الأمثل باستخدام الرسوم البيانية في الوقت الفعلي والمؤشرات الفنية';

  @override
  String get getStarted => 'ابدأ';

  @override
  String get next => 'التالي';

  @override
  String get skip => 'تخطي';

  @override
  String get email => 'البريد الإلكتروني';

  @override
  String get password => 'كلمة المرور';

  @override
  String get login => 'تسجيل الدخول';

  @override
  String get or => 'أو';

  @override
  String get signInWithApple => 'تسجيل الدخول بـ Apple';

  @override
  String get demoModeNotice => 'الوضع التجريبي: تم ملء حساب الاختبار تلقائياً';

  @override
  String get privacyPolicy => 'سياسة الخصوصية';

  @override
  String get termsOfService => 'شروط الخدمة';

  @override
  String get investmentWarning => 'للمرجع فقط، ليس نصيحة استثمارية';

  @override
  String get profile => 'الملف الشخصي';

  @override
  String get trader => 'متداول';

  @override
  String get subscriptionManagement => 'إدارة الاشتراك';

  @override
  String subscribedPlan(String planName) {
    return '$planName نشط';
  }

  @override
  String daysRemaining(int days) {
    return '$days يوم متبقي';
  }

  @override
  String get upgradeToPremiun => 'الترقية إلى Premium';

  @override
  String get freePlan => 'الخطة المجانية';

  @override
  String get investmentPerformance => 'أداء الاستثمار';

  @override
  String get performanceDescription => 'تحقق من العوائد وتاريخ التداول';

  @override
  String get watchlist => 'قائمة المراقبة';

  @override
  String get watchlistDescription => 'إدارة الأسهم المحفوظة';

  @override
  String get notificationSettings => 'إعدادات الإشعارات';

  @override
  String get notificationDescription => 'إدارة التوصيات وتنبيهات السوق';

  @override
  String get legalInformation => 'المعلومات القانونية';

  @override
  String get customerSupport => 'دعم العملاء';

  @override
  String get appInfo => 'معلومات التطبيق';

  @override
  String get versionInfo => 'معلومات الإصدار';

  @override
  String get logout => 'تسجيل الخروج';

  @override
  String get investmentWarningTitle => 'تحذير مخاطر الاستثمار';

  @override
  String get investmentWarningText =>
      'جميع المعلومات المقدمة في هذا التطبيق هي للمرجع فقط ولا تشكل نصيحة استثمارية. يجب اتخاذ جميع قرارات الاستثمار تحت حكمكم ومسؤوليتكم الخاصة.';

  @override
  String get settings => 'الإعدادات';

  @override
  String get tradingSignals => 'إشارات التداول';

  @override
  String get realTimeRecommendations =>
      'توصيات في الوقت الفعلي من كبار المتداولين';

  @override
  String get investmentReferenceNotice =>
      'للمرجع الاستثماري. قرارات الاستثمار على مسؤوليتكم.';

  @override
  String get currentPlan => 'الخطة الحالية';

  @override
  String get nextBilling => 'الفاتورة التالية';

  @override
  String get amount => 'المبلغ';

  @override
  String get notScheduled => 'غير مجدول';

  @override
  String get subscriptionInfo => 'معلومات الاشتراك';

  @override
  String get subscriptionTerms => 'شروط الاشتراك';

  @override
  String get subscriptionTermsText =>
      '• يتم تحصيل رسوم الاشتراكات من حساب iTunes الخاص بك عند تأكيد الشراء\\n• تتجدد الاشتراكات تلقائياً ما لم يتم إيقاف التجديد التلقائي قبل 24 ساعة على الأقل من انتهاء الفترة الحالية\\n• يتم تحصيل رسوم التجديد خلال 24 ساعة من انتهاء الفترة الحالية\\n• يمكن إدارة الاشتراكات في إعدادات حسابك بعد الشراء\\n• سيتم فقدان أي جزء غير مستخدم من فترة التجربة المجانية عند شراء اشتراك';

  @override
  String get dataDelayWarning => 'قد تتأخر البيانات الفورية 15 دقيقة';

  @override
  String get dataSource => 'البيانات مقدمة من Finnhub';

  @override
  String get poweredBy => 'مدعوم بواسطة المتداولين الأسطوريين';
}

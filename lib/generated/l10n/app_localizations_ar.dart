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
  String get subscription => 'Subscription';

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

  @override
  String get errorLoadingSubscription => 'Error loading subscription';

  @override
  String get active => 'Active';

  @override
  String get inactive => 'Inactive';

  @override
  String autoRenewalOff(String date) {
    return 'Auto-renewal is off. Your plan will expire on $date';
  }

  @override
  String get availablePlans => 'Available Plans';

  @override
  String get popular => 'POPULAR';

  @override
  String savePercent(int percent) {
    return 'Save $percent%';
  }

  @override
  String get upgrade => 'Upgrade';

  @override
  String get billingHistory => 'Billing History';

  @override
  String get upgradePlan => 'Upgrade Plan';

  @override
  String upgradePlanConfirm(String planName) {
    return 'Upgrade to $planName?';
  }

  @override
  String get price => 'Price';

  @override
  String upgradeSuccessful(String planName) {
    return 'Successfully upgraded to $planName';
  }

  @override
  String get tierDescFree => 'Get started with basic features';

  @override
  String get tierDescBasic => 'For individual traders';

  @override
  String get tierDescPro => 'Advanced tools for serious traders';

  @override
  String get tierDescPremium => 'Everything you need to succeed';

  @override
  String get tierDescEnterprise => 'Custom solutions for teams';

  @override
  String get errorLoadingRecommendations => 'خطأ في تحميل التوصيات';

  @override
  String get retry => 'إعادة المحاولة';

  @override
  String get allActions => 'جميع الإجراءات';

  @override
  String get buy => 'شراء';

  @override
  String get sell => 'بيع';

  @override
  String get hold => 'احتفاظ';

  @override
  String get latest => 'الأحدث';

  @override
  String get confidence => 'الثقة';

  @override
  String get profitPotential => 'إمكانية الربح';

  @override
  String get noRecommendationsFound => 'لم يتم العثور على توصيات';

  @override
  String get portfolio => 'المحفظة';

  @override
  String get errorLoadingPositions => 'خطأ في تحميل المراكز';

  @override
  String get today => 'اليوم';

  @override
  String get winRate => 'معدل الفوز';

  @override
  String get positions => 'المراكز';

  @override
  String get dayPL => 'ربح/خسارة اليوم';

  @override
  String get noOpenPositions => 'لا توجد مراكز مفتوحة';

  @override
  String get startTradingToSeePositions => 'ابدأ التداول لرؤية مراكزك';

  @override
  String get quantity => 'الكمية';

  @override
  String get avgCost => 'متوسط التكلفة';

  @override
  String get current => 'الحالي';

  @override
  String get pl => 'الربح/الخسارة';

  @override
  String get close => 'إغلاق';

  @override
  String get edit => 'تعديل';

  @override
  String get closePosition => 'إغلاق المركز';

  @override
  String closePositionConfirm(int quantity, String stockCode) {
    return 'إغلاق $quantity سهم من $stockCode؟';
  }

  @override
  String get cancel => 'إلغاء';

  @override
  String get positionClosedSuccessfully => 'تم إغلاق المركز بنجاح';

  @override
  String get sl => 'وقف الخسارة';

  @override
  String get tp => 'جني الربح';

  @override
  String get upload => 'رفع';

  @override
  String get uploadVideo => 'رفع فيديو';

  @override
  String get uploadDescription => 'اختر من المعرض أو التقط بالكاميرا';

  @override
  String get gallery => 'المعرض';

  @override
  String get camera => 'الكاميرا';

  @override
  String get inbox => 'صندوق الوارد';

  @override
  String get activity => 'النشاط';

  @override
  String get newLikes => 'إعجابات جديدة';

  @override
  String get lastWeek => 'الأسبوع الماضي';

  @override
  String get yesterday => 'أمس';

  @override
  String get newFollowers => 'متابعون جدد';

  @override
  String get newComments => 'تعليقات جديدة';

  @override
  String hoursAgo(int hours) {
    return 'منذ $hours ساعات';
  }

  @override
  String get messages => 'الرسائل';

  @override
  String get search => 'بحث';

  @override
  String get signals => 'إشارات';

  @override
  String get discover => 'اكتشف';

  @override
  String get premium => 'بريميوم';
}

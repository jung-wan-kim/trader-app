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
  String get subscription => 'الاشتراك';

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
  String get errorLoadingSubscription => 'خطأ في تحميل الاشتراك';

  @override
  String get active => 'نشط';

  @override
  String get inactive => 'غير نشط';

  @override
  String autoRenewalOff(String date) {
    return 'التجديد التلقائي متوقف. ستنتهي خطتك في $date';
  }

  @override
  String get availablePlans => 'الخطط المتاحة';

  @override
  String get popular => 'شائع';

  @override
  String savePercent(int percent) {
    return 'وفر $percent%';
  }

  @override
  String get upgrade => 'ترقية';

  @override
  String get downgrade => 'خفض الخطة';

  @override
  String get billingHistory => 'تاريخ الفواتير';

  @override
  String get upgradePlan => 'ترقية الخطة';

  @override
  String upgradePlanConfirm(String planName) {
    return 'ترقية إلى $planName؟';
  }

  @override
  String get price => 'السعر';

  @override
  String upgradeSuccessful(String planName) {
    return 'تم الترقية بنجاح إلى $planName';
  }

  @override
  String get tierDescFree => 'ابدأ بالميزات الأساسية';

  @override
  String get tierDescBasic => 'للمتداولين الأفراد';

  @override
  String get tierDescPro => 'أدوات متقدمة للمتداولين الجادين';

  @override
  String get tierDescPremium => 'كل ما تحتاجه للنجاح';

  @override
  String get tierDescEnterprise => 'حلول مخصصة للفرق';

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

  @override
  String get planFeatureBasicRecommendations => 'توصيات أساسية';

  @override
  String planFeatureLimitedPositions(int count) {
    return 'محدود بـ $count مراكز';
  }

  @override
  String get planFeatureCommunitySupport => 'دعم المجتمع';

  @override
  String get planFeatureAllFreeFeatures => 'جميع الميزات المجانية';

  @override
  String planFeatureUpToPositions(int count) {
    return 'حتى $count مراكز';
  }

  @override
  String get planFeatureEmailSupport => 'دعم البريد الإلكتروني';

  @override
  String get planFeatureBasicAnalytics => 'تحليلات أساسية';

  @override
  String get planFeatureAllBasicFeatures => 'جميع الميزات الأساسية';

  @override
  String get planFeatureRealtimeRecommendations => 'توصيات في الوقت الفعلي';

  @override
  String get planFeatureAdvancedAnalytics => 'تحليلات متقدمة';

  @override
  String get planFeaturePrioritySupport => 'دعم أولوي';

  @override
  String get planFeatureRiskManagementTools => 'أدوات إدارة المخاطر';

  @override
  String get planFeatureCustomAlerts => 'تنبيهات مخصصة';

  @override
  String get planFeatureAllProFeatures => 'جميع ميزات برو الشهرية';

  @override
  String planFeatureMonthsFree(int count) {
    return '$count أشهر مجاناً';
  }

  @override
  String get planFeatureAnnualReview => 'مراجعة الأداء السنوية';

  @override
  String get planFeatureAllProFeaturesUnlimited => 'جميع ميزات برو';

  @override
  String get planFeatureUnlimitedPositions => 'مراكز غير محدودة';

  @override
  String get planFeatureApiAccess => 'وصول API';

  @override
  String get planFeatureDedicatedManager => 'مدير حساب مخصص';

  @override
  String get planFeatureCustomStrategies => 'استراتيجيات مخصصة';

  @override
  String get planFeatureWhiteLabelOptions => 'خيارات العلامة البيضاء';

  @override
  String get termsTitle => 'Trader App Terms of Service';

  @override
  String get termsEffectiveDate => 'Effective Date: February 21, 2025';

  @override
  String get termsSection1Title => 'Article 1 (Purpose)';

  @override
  String get termsSection1Content =>
      'These terms are intended to stipulate the rights, obligations, and responsibilities of the company and users regarding the use of mobile application services (hereinafter referred to as \"Services\") provided by Trader App (hereinafter referred to as \"Company\").';

  @override
  String get termsSection2Title => 'Article 2 (Definitions)';

  @override
  String get termsSection2Content =>
      '1. \"Service\" refers to the AI-based stock recommendation and investment information service provided by the Company.\n2. \"User\" refers to members and non-members who receive services provided by the Company under these terms.\n3. \"Member\" refers to a person who has registered as a member by providing personal information to the Company, continuously receives Company information, and can continuously use the Service.';

  @override
  String get termsSection3Title =>
      'Article 3 (Effectiveness and Changes to Terms)';

  @override
  String get termsSection3Content =>
      '1. These terms become effective by posting them on the service screen or notifying users through other means.\n2. The Company may change these terms when deemed necessary, and changed terms will be announced 7 days before the application date.';

  @override
  String get termsSection4Title => 'Article 4 (Provision of Services)';

  @override
  String get termsSection4Content =>
      '1. The Company provides the following services:\n   • AI-based stock recommendation service\n   • Legendary trader strategy information\n   • Real-time stock price information\n   • Portfolio management tools\n   • Risk calculator\n\n2. Services are provided 24 hours a day, 365 days a year in principle. However, they may be temporarily suspended due to system maintenance.';

  @override
  String get termsFinancialDisclaimer =>
      'All information provided by this service is for reference only and does not constitute investment advice or investment recommendations.\n\n• All investment decisions must be made under the user\'s own judgment and responsibility.\n• Stock investment carries the risk of principal loss.\n• Past returns do not guarantee future profits.\n• The Company assumes no responsibility for investment results based on the information provided.';

  @override
  String get termsSection5Title => 'Article 5 (Membership Registration)';

  @override
  String get termsSection5Content =>
      '1. Membership registration is concluded when the user agrees to the contents of the terms and applies for membership registration, and the Company approves such application.\n2. The Company may not approve or later terminate the usage contract for applications that fall under the following:\n   • Using a false name or another person\'s name\n   • Providing false information or not providing information requested by the Company\n   • Not meeting other application requirements';

  @override
  String get termsSection6Title => 'Article 6 (User Obligations)';

  @override
  String get termsSection6Content =>
      'Users must not engage in the following activities:\n1. Stealing others\' information\n2. Infringing on the Company\'s intellectual property rights\n3. Intentionally interfering with service operations\n4. Other activities that violate relevant laws and regulations';

  @override
  String get termsSection7Title => 'Article 7 (Service Usage Fees)';

  @override
  String get termsSection7Content =>
      '1. Basic services are provided free of charge.\n2. Premium services require payment of separate usage fees.\n3. Usage fees for paid services follow the fee policy specified within the service.\n4. The Company may change paid service usage fees and will notify 30 days in advance of changes.';

  @override
  String get termsSection8Title => 'Article 8 (Disclaimer)';

  @override
  String get termsSection8Content =>
      '1. The Company is exempt from responsibility for providing services when unable to provide services due to natural disasters or force majeure equivalent thereto.\n2. The Company is not responsible for service usage obstacles due to user\'s fault.\n3. All investment information provided by the Company is for reference only, and the responsibility for investment decisions lies entirely with the user.';

  @override
  String get termsSection9Title => 'Article 9 (Privacy Protection)';

  @override
  String get termsSection9Content =>
      'The Company establishes and complies with a privacy policy to protect users\' personal information. For details, please refer to the Privacy Policy.';

  @override
  String get termsSection10Title => 'Article 10 (Dispute Resolution)';

  @override
  String get termsSection10Content =>
      '1. Disputes between the Company and users shall be resolved through mutual consultation in principle.\n2. If consultation cannot be reached, it shall be resolved in the competent court according to relevant laws.';

  @override
  String get termsSupplementary => 'Supplementary Provisions';

  @override
  String get termsSupplementaryDate =>
      'These terms are effective from February 21, 2025.';

  @override
  String get privacyTitle => 'Trader App Privacy Policy';

  @override
  String get privacyEffectiveDate => 'Effective Date: February 21, 2025';

  @override
  String get privacySection1Title =>
      '1. Purpose of Collection and Use of Personal Information';

  @override
  String get privacySection1Content =>
      'Trader App collects personal information for the following purposes:\n• Member registration and management\n• Providing customized investment information\n• Service improvement and new service development\n• Customer inquiry response';

  @override
  String get privacySection2Title =>
      '2. Items of Personal Information Collected';

  @override
  String get privacySection2Content =>
      '• Required items: Email, password\n• Optional items: Name, phone number, investment interests\n• Automatically collected items: Device information, app usage history, IP address';

  @override
  String get privacySection3Title =>
      '3. Retention and Use Period of Personal Information';

  @override
  String get privacySection3Content =>
      '• Until membership withdrawal\n• However, retained for the required period if preservation is necessary according to relevant laws\n• Contract or subscription withdrawal records under e-commerce law: 5 years\n• Consumer complaint or dispute handling records: 3 years';

  @override
  String get privacySection4Title =>
      '4. Provision of Personal Information to Third Parties';

  @override
  String get privacySection4Content =>
      'Trader App does not provide users\' personal information to third parties in principle.\nHowever, exceptions are made in the following cases:\n• When user consent is obtained\n• When required by laws and regulations';

  @override
  String get privacySection5Title =>
      '5. Personal Information Protection Measures';

  @override
  String get privacySection5Content =>
      '• Personal information encryption\n• Technical measures against hacking\n• Limiting access to personal information\n• Minimizing and training personnel handling personal information';

  @override
  String get privacySection6Title => '6. User Rights';

  @override
  String get privacySection6Content =>
      'Users can exercise the following rights at any time:\n• Request to view personal information\n• Request to correct or delete personal information\n• Request to stop processing personal information\n• Request to transfer personal information';

  @override
  String get privacySection7Title =>
      '7. Personal Information Protection Officer';

  @override
  String get privacySection7Content =>
      'Personal Information Protection Officer: Hong Gil-dong\nEmail: privacy@traderapp.com\nPhone: 02-1234-5678';

  @override
  String get privacySection8Title => '8. Changes to Privacy Policy';

  @override
  String get privacySection8Content =>
      'This privacy policy may be modified to reflect changes in laws and services.\nChanges will be announced through in-app notifications.';
}

// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get appTitle => 'Trader App';

  @override
  String get appSubtitle => 'AI-Powered Stock Recommendations';

  @override
  String get subscription => 'Subscription';

  @override
  String get chooseLanguage => 'Choose Your Language';

  @override
  String get selectLanguageDescription =>
      'Select your preferred language for the app';

  @override
  String get continueButton => 'Continue';

  @override
  String get onboardingTitle1 => 'Legendary Trader Strategies';

  @override
  String get onboardingDesc1 =>
      'Utilize proven investment strategies from history\'s most successful traders like Jesse Livermore and William O\'Neil';

  @override
  String get onboardingTitle2 => 'AI-Powered Stock Recommendations';

  @override
  String get onboardingDesc2 =>
      'Get optimal stock recommendations that match legendary trader strategies through advanced AI market analysis';

  @override
  String get onboardingTitle3 => 'Risk Management';

  @override
  String get onboardingDesc3 =>
      'Achieve safe investing with position size calculator and stop-loss/take-profit strategies';

  @override
  String get onboardingTitle4 => 'Real-time Market Analysis';

  @override
  String get onboardingDesc4 =>
      'Understand market trends and capture optimal timing with real-time charts and technical indicators';

  @override
  String get getStarted => 'Get Started';

  @override
  String get next => 'Next';

  @override
  String get skip => 'Skip';

  @override
  String get email => 'Email';

  @override
  String get password => 'Password';

  @override
  String get login => 'Login';

  @override
  String get or => 'or';

  @override
  String get signInWithApple => 'Sign in with Apple';

  @override
  String get signInWithGoogle => 'Sign in with Google';

  @override
  String get demoModeNotice => 'Demo Mode: Test account auto-filled';

  @override
  String get privacyPolicy => 'Privacy Policy';

  @override
  String get termsOfService => 'Terms of Service';

  @override
  String get investmentWarning => 'For reference only, not investment advice';

  @override
  String get profile => 'Profile';

  @override
  String get trader => 'Trader';

  @override
  String get subscriptionManagement => 'Subscription Management';

  @override
  String subscribedPlan(String planName) {
    return '$planName Active';
  }

  @override
  String daysRemaining(int days) {
    return '$days days remaining';
  }

  @override
  String get upgradeToPremiun => 'Upgrade to Premium';

  @override
  String get freePlan => 'Free Plan';

  @override
  String get investmentPerformance => 'Investment Performance';

  @override
  String get performanceDescription => 'Check returns and trading history';

  @override
  String get watchlist => 'Watchlist';

  @override
  String get watchlistDescription => 'Manage saved stocks';

  @override
  String get notificationSettings => 'Notification Settings';

  @override
  String get notificationDescription =>
      'Manage recommendation and market alerts';

  @override
  String get legalInformation => 'Legal Information';

  @override
  String get customerSupport => 'Customer Support';

  @override
  String get appInfo => 'App Info';

  @override
  String get versionInfo => 'Version Info';

  @override
  String get logout => 'Logout';

  @override
  String get accountManagement => 'Account Management';

  @override
  String get cancelSubscription => 'Cancel Subscription';

  @override
  String get deleteAccount => 'Delete Account';

  @override
  String get cancelSubscriptionTitle => 'Cancel Subscription';

  @override
  String get cancelSubscriptionMessage =>
      'Are you sure you want to cancel your subscription? You will continue to have access until your current billing period ends.';

  @override
  String get cancelSubscriptionConfirm => 'Yes, Cancel';

  @override
  String get deleteAccountTitle => 'Delete Account';

  @override
  String get deleteAccountMessage =>
      'Are you sure you want to delete your account? This action cannot be undone and all your data will be permanently removed.';

  @override
  String get deleteAccountConfirm => 'Yes, Delete Account';

  @override
  String get subscriptionCancelledSuccessfully =>
      'Subscription cancelled successfully';

  @override
  String get accountDeletedSuccessfully => 'Account deleted successfully';

  @override
  String get languageSettings => 'Language Settings';

  @override
  String get investmentWarningTitle => 'Investment Risk Warning';

  @override
  String get investmentWarningText =>
      'All information provided in this app is for reference only and does not constitute investment advice. All investment decisions must be made at your own judgment and responsibility.';

  @override
  String get settings => 'Settings';

  @override
  String get tradingSignals => 'Trading Signals';

  @override
  String get realTimeRecommendations =>
      'Real-time recommendations from top traders';

  @override
  String get investmentReferenceNotice =>
      'For investment reference. Investment decisions are your responsibility.';

  @override
  String get currentPlan => 'Current Plan';

  @override
  String get nextBilling => 'Next Billing';

  @override
  String get amount => 'Amount';

  @override
  String get notScheduled => 'Not scheduled';

  @override
  String get subscriptionInfo => 'Subscription Info';

  @override
  String get subscriptionTerms => 'Subscription Terms';

  @override
  String get subscriptionTermsText =>
      '• Subscriptions are charged to your iTunes account upon purchase confirmation\\n• Subscriptions automatically renew unless auto-renewal is turned off at least 24 hours before the end of the current period\\n• Renewal charges are made within 24 hours of the end of the current period\\n• Subscriptions can be managed in your account settings after purchase\\n• Any unused portion of free trial period will be forfeited when purchasing a subscription';

  @override
  String get dataDelayWarning => 'Real-time data may be delayed by 15 minutes';

  @override
  String get dataSource => 'Data provided by Finnhub';

  @override
  String get poweredBy => 'Powered by Legendary Traders';

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
  String get downgrade => 'Downgrade';

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
  String get errorLoadingRecommendations => 'Error loading recommendations';

  @override
  String get retry => 'Retry';

  @override
  String get allActions => 'All Actions';

  @override
  String get buy => 'Buy';

  @override
  String get sell => 'Sell';

  @override
  String get hold => 'Hold';

  @override
  String get latest => 'Latest';

  @override
  String get confidence => 'Confidence';

  @override
  String get profitPotential => 'Profit Potential';

  @override
  String get noRecommendationsFound => 'No recommendations found';

  @override
  String get portfolio => 'Portfolio';

  @override
  String get errorLoadingPositions => 'Error loading positions';

  @override
  String get today => 'today';

  @override
  String get winRate => 'Win Rate';

  @override
  String get positions => 'Positions';

  @override
  String get dayPL => 'Day P&L';

  @override
  String get noOpenPositions => 'No open positions';

  @override
  String get startTradingToSeePositions =>
      'Start trading to see your positions';

  @override
  String get quantity => 'Quantity';

  @override
  String get avgCost => 'Avg Cost';

  @override
  String get current => 'Current';

  @override
  String get pl => 'P&L';

  @override
  String get close => 'Close';

  @override
  String get edit => 'Edit';

  @override
  String get closePosition => 'Close Position';

  @override
  String closePositionConfirm(int quantity, String stockCode) {
    return 'Close $quantity shares of $stockCode?';
  }

  @override
  String get cancel => 'Cancel';

  @override
  String get positionClosedSuccessfully => 'Position closed successfully';

  @override
  String get sl => 'SL';

  @override
  String get tp => 'TP';

  @override
  String get upload => 'Upload';

  @override
  String get uploadVideo => 'Upload Video';

  @override
  String get uploadDescription => 'Select from gallery or shoot with camera';

  @override
  String get gallery => 'Gallery';

  @override
  String get camera => 'Camera';

  @override
  String get inbox => 'Inbox';

  @override
  String get activity => 'Activity';

  @override
  String get newLikes => 'New Likes';

  @override
  String get lastWeek => 'Last week';

  @override
  String get yesterday => 'Yesterday';

  @override
  String get newFollowers => 'New Followers';

  @override
  String get newComments => 'New Comments';

  @override
  String hoursAgo(int hours) {
    return '$hours hours ago';
  }

  @override
  String get messages => 'Messages';

  @override
  String get search => 'Search';

  @override
  String get signals => 'Signals';

  @override
  String get discover => 'Discover';

  @override
  String get premium => 'Premium';

  @override
  String get planFeatureBasicRecommendations => 'Basic recommendations';

  @override
  String planFeatureLimitedPositions(int count) {
    return 'Limited to $count positions';
  }

  @override
  String get planFeatureCommunitySupport => 'Community support';

  @override
  String get planFeatureAllFreeFeatures => 'All Free features';

  @override
  String planFeatureUpToPositions(int count) {
    return 'Up to $count positions';
  }

  @override
  String get planFeatureEmailSupport => 'Email support';

  @override
  String get planFeatureBasicAnalytics => 'Basic analytics';

  @override
  String get planFeatureAllBasicFeatures => 'All Basic features';

  @override
  String get planFeatureRealtimeRecommendations => 'Real-time recommendations';

  @override
  String get planFeatureAdvancedAnalytics => 'Advanced analytics';

  @override
  String get planFeaturePrioritySupport => 'Priority support';

  @override
  String get planFeatureRiskManagementTools => 'Risk management tools';

  @override
  String get planFeatureCustomAlerts => 'Custom alerts';

  @override
  String get planFeatureAllProFeatures => 'All Pro Monthly features';

  @override
  String planFeatureMonthsFree(int count) {
    return '$count months free';
  }

  @override
  String get planFeatureAnnualReview => 'Annual performance review';

  @override
  String get planFeatureAllProFeaturesUnlimited => 'All Pro features';

  @override
  String get planFeatureUnlimitedPositions => 'Unlimited positions';

  @override
  String get planFeatureApiAccess => 'API access';

  @override
  String get planFeatureDedicatedManager => 'Dedicated account manager';

  @override
  String get planFeatureCustomStrategies => 'Custom strategies';

  @override
  String get planFeatureWhiteLabelOptions => 'White-label options';

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

  @override
  String get totalPortfolioValue => 'Total Portfolio Value';

  @override
  String get portfolioPerformance30Days => 'Portfolio Performance (30 Days)';

  @override
  String get performanceStatistics => 'Performance Statistics';

  @override
  String get avgReturn => 'Avg. Return';

  @override
  String get totalTrades => 'Total Trades';

  @override
  String get bestTrade => 'Best Trade';

  @override
  String get recentTrades => 'Recent Trades';

  @override
  String get monthlyReturns => 'Monthly Returns';

  @override
  String get jan => 'Jan';

  @override
  String get feb => 'Feb';

  @override
  String get mar => 'Mar';

  @override
  String get apr => 'Apr';

  @override
  String get may => 'May';

  @override
  String get jun => 'Jun';

  @override
  String get marketSummary => 'Market Summary';

  @override
  String get addStock => 'Add Stock';

  @override
  String get stocks => 'Stocks';

  @override
  String get searchStocks => 'Search stocks...';

  @override
  String get nothingInWatchlist => 'Nothing in your watchlist yet';

  @override
  String get addStocksToWatchlist => 'Add stocks to track their performance';

  @override
  String get remove => 'Remove';

  @override
  String get addToWatchlist => 'Add to Watchlist';

  @override
  String get stockAddedToWatchlist => 'Stock added to watchlist';

  @override
  String get stockRemovedFromWatchlist => 'Stock removed from watchlist';

  @override
  String get chooseTrader => 'Choose Your Trading Master';

  @override
  String get performance => 'Performance';

  @override
  String get keyStrategy => 'Key Strategy';

  @override
  String get selected => 'Selected';

  @override
  String get continueWithSelection => 'Continue with Selection';
}

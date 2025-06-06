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
}

import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_ar.dart';
import 'app_localizations_de.dart';
import 'app_localizations_en.dart';
import 'app_localizations_es.dart';
import 'app_localizations_fr.dart';
import 'app_localizations_hi.dart';
import 'app_localizations_ja.dart';
import 'app_localizations_ko.dart';
import 'app_localizations_pt.dart';
import 'app_localizations_zh.dart';

// ignore_for_file: type=lint

/// Callers can lookup localized strings with an instance of AppLocalizations
/// returned by `AppLocalizations.of(context)`.
///
/// Applications need to include `AppLocalizations.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'l10n/app_localizations.dart';
///
/// return MaterialApp(
///   localizationsDelegates: AppLocalizations.localizationsDelegates,
///   supportedLocales: AppLocalizations.supportedLocales,
///   home: MyApplicationHome(),
/// );
/// ```
///
/// ## Update pubspec.yaml
///
/// Please make sure to update your pubspec.yaml to include the following
/// packages:
///
/// ```yaml
/// dependencies:
///   # Internationalization support.
///   flutter_localizations:
///     sdk: flutter
///   intl: any # Use the pinned version from flutter_localizations
///
///   # Rest of dependencies
/// ```
///
/// ## iOS Applications
///
/// iOS applications define key application metadata, including supported
/// locales, in an Info.plist file that is built into the application bundle.
/// To configure the locales supported by your app, you’ll need to edit this
/// file.
///
/// First, open your project’s ios/Runner.xcworkspace Xcode workspace file.
/// Then, in the Project Navigator, open the Info.plist file under the Runner
/// project’s Runner folder.
///
/// Next, select the Information Property List item, select Add Item from the
/// Editor menu, then select Localizations from the pop-up menu.
///
/// Select and expand the newly-created Localizations item then, for each
/// locale your application supports, add a new item and select the locale
/// you wish to add from the pop-up menu in the Value field. This list should
/// be consistent with the languages listed in the AppLocalizations.supportedLocales
/// property.
abstract class AppLocalizations {
  AppLocalizations(String locale)
      : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static AppLocalizations? of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations);
  }

  static const LocalizationsDelegate<AppLocalizations> delegate =
      _AppLocalizationsDelegate();

  /// A list of this localizations delegate along with the default localizations
  /// delegates.
  ///
  /// Returns a list of localizations delegates containing this delegate along with
  /// GlobalMaterialLocalizations.delegate, GlobalCupertinoLocalizations.delegate,
  /// and GlobalWidgetsLocalizations.delegate.
  ///
  /// Additional delegates can be added by appending to this list in
  /// MaterialApp. This list does not have to be used at all if a custom list
  /// of delegates is preferred or required.
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates =
      <LocalizationsDelegate<dynamic>>[
    delegate,
    GlobalMaterialLocalizations.delegate,
    GlobalCupertinoLocalizations.delegate,
    GlobalWidgetsLocalizations.delegate,
  ];

  /// A list of this localizations delegate's supported locales.
  static const List<Locale> supportedLocales = <Locale>[
    Locale('ar'),
    Locale('de'),
    Locale('en'),
    Locale('es'),
    Locale('fr'),
    Locale('hi'),
    Locale('ja'),
    Locale('ko'),
    Locale('pt'),
    Locale('zh')
  ];

  /// No description provided for @appTitle.
  ///
  /// In en, this message translates to:
  /// **'Trader App'**
  String get appTitle;

  /// No description provided for @appSubtitle.
  ///
  /// In en, this message translates to:
  /// **'AI-Powered Stock Recommendations'**
  String get appSubtitle;

  /// No description provided for @subscription.
  ///
  /// In en, this message translates to:
  /// **'Subscription'**
  String get subscription;

  /// No description provided for @chooseLanguage.
  ///
  /// In en, this message translates to:
  /// **'Choose Your Language'**
  String get chooseLanguage;

  /// No description provided for @selectLanguageDescription.
  ///
  /// In en, this message translates to:
  /// **'Select your preferred language for the app'**
  String get selectLanguageDescription;

  /// No description provided for @continueButton.
  ///
  /// In en, this message translates to:
  /// **'Continue'**
  String get continueButton;

  /// No description provided for @onboardingTitle1.
  ///
  /// In en, this message translates to:
  /// **'Legendary Trader Strategies'**
  String get onboardingTitle1;

  /// No description provided for @onboardingDesc1.
  ///
  /// In en, this message translates to:
  /// **'Utilize proven investment strategies from history\'s most successful traders like Jesse Livermore and William O\'Neil'**
  String get onboardingDesc1;

  /// No description provided for @onboardingTitle2.
  ///
  /// In en, this message translates to:
  /// **'AI-Powered Stock Recommendations'**
  String get onboardingTitle2;

  /// No description provided for @onboardingDesc2.
  ///
  /// In en, this message translates to:
  /// **'Get optimal stock recommendations that match legendary trader strategies through advanced AI market analysis'**
  String get onboardingDesc2;

  /// No description provided for @onboardingTitle3.
  ///
  /// In en, this message translates to:
  /// **'Risk Management'**
  String get onboardingTitle3;

  /// No description provided for @onboardingDesc3.
  ///
  /// In en, this message translates to:
  /// **'Achieve safe investing with position size calculator and stop-loss/take-profit strategies'**
  String get onboardingDesc3;

  /// No description provided for @onboardingTitle4.
  ///
  /// In en, this message translates to:
  /// **'Real-time Market Analysis'**
  String get onboardingTitle4;

  /// No description provided for @onboardingDesc4.
  ///
  /// In en, this message translates to:
  /// **'Understand market trends and capture optimal timing with real-time charts and technical indicators'**
  String get onboardingDesc4;

  /// No description provided for @getStarted.
  ///
  /// In en, this message translates to:
  /// **'Get Started'**
  String get getStarted;

  /// No description provided for @next.
  ///
  /// In en, this message translates to:
  /// **'Next'**
  String get next;

  /// No description provided for @skip.
  ///
  /// In en, this message translates to:
  /// **'Skip'**
  String get skip;

  /// No description provided for @email.
  ///
  /// In en, this message translates to:
  /// **'Email'**
  String get email;

  /// No description provided for @password.
  ///
  /// In en, this message translates to:
  /// **'Password'**
  String get password;

  /// No description provided for @login.
  ///
  /// In en, this message translates to:
  /// **'Login'**
  String get login;

  /// No description provided for @or.
  ///
  /// In en, this message translates to:
  /// **'or'**
  String get or;

  /// No description provided for @signInWithApple.
  ///
  /// In en, this message translates to:
  /// **'Sign in with Apple'**
  String get signInWithApple;

  /// No description provided for @demoModeNotice.
  ///
  /// In en, this message translates to:
  /// **'Demo Mode: Test account auto-filled'**
  String get demoModeNotice;

  /// No description provided for @privacyPolicy.
  ///
  /// In en, this message translates to:
  /// **'Privacy Policy'**
  String get privacyPolicy;

  /// No description provided for @termsOfService.
  ///
  /// In en, this message translates to:
  /// **'Terms of Service'**
  String get termsOfService;

  /// No description provided for @investmentWarning.
  ///
  /// In en, this message translates to:
  /// **'For reference only, not investment advice'**
  String get investmentWarning;

  /// No description provided for @profile.
  ///
  /// In en, this message translates to:
  /// **'Profile'**
  String get profile;

  /// No description provided for @trader.
  ///
  /// In en, this message translates to:
  /// **'Trader'**
  String get trader;

  /// No description provided for @subscriptionManagement.
  ///
  /// In en, this message translates to:
  /// **'Subscription Management'**
  String get subscriptionManagement;

  /// No description provided for @subscribedPlan.
  ///
  /// In en, this message translates to:
  /// **'{planName} Active'**
  String subscribedPlan(String planName);

  /// No description provided for @daysRemaining.
  ///
  /// In en, this message translates to:
  /// **'{days} days remaining'**
  String daysRemaining(int days);

  /// No description provided for @upgradeToPremiun.
  ///
  /// In en, this message translates to:
  /// **'Upgrade to Premium'**
  String get upgradeToPremiun;

  /// No description provided for @freePlan.
  ///
  /// In en, this message translates to:
  /// **'Free Plan'**
  String get freePlan;

  /// No description provided for @investmentPerformance.
  ///
  /// In en, this message translates to:
  /// **'Investment Performance'**
  String get investmentPerformance;

  /// No description provided for @performanceDescription.
  ///
  /// In en, this message translates to:
  /// **'Check returns and trading history'**
  String get performanceDescription;

  /// No description provided for @watchlist.
  ///
  /// In en, this message translates to:
  /// **'Watchlist'**
  String get watchlist;

  /// No description provided for @watchlistDescription.
  ///
  /// In en, this message translates to:
  /// **'Manage saved stocks'**
  String get watchlistDescription;

  /// No description provided for @notificationSettings.
  ///
  /// In en, this message translates to:
  /// **'Notification Settings'**
  String get notificationSettings;

  /// No description provided for @notificationDescription.
  ///
  /// In en, this message translates to:
  /// **'Manage recommendation and market alerts'**
  String get notificationDescription;

  /// No description provided for @legalInformation.
  ///
  /// In en, this message translates to:
  /// **'Legal Information'**
  String get legalInformation;

  /// No description provided for @customerSupport.
  ///
  /// In en, this message translates to:
  /// **'Customer Support'**
  String get customerSupport;

  /// No description provided for @appInfo.
  ///
  /// In en, this message translates to:
  /// **'App Info'**
  String get appInfo;

  /// No description provided for @versionInfo.
  ///
  /// In en, this message translates to:
  /// **'Version Info'**
  String get versionInfo;

  /// No description provided for @logout.
  ///
  /// In en, this message translates to:
  /// **'Logout'**
  String get logout;

  /// No description provided for @investmentWarningTitle.
  ///
  /// In en, this message translates to:
  /// **'Investment Risk Warning'**
  String get investmentWarningTitle;

  /// No description provided for @investmentWarningText.
  ///
  /// In en, this message translates to:
  /// **'All information provided in this app is for reference only and does not constitute investment advice. All investment decisions must be made at your own judgment and responsibility.'**
  String get investmentWarningText;

  /// No description provided for @settings.
  ///
  /// In en, this message translates to:
  /// **'Settings'**
  String get settings;

  /// No description provided for @tradingSignals.
  ///
  /// In en, this message translates to:
  /// **'Trading Signals'**
  String get tradingSignals;

  /// No description provided for @realTimeRecommendations.
  ///
  /// In en, this message translates to:
  /// **'Real-time recommendations from top traders'**
  String get realTimeRecommendations;

  /// No description provided for @investmentReferenceNotice.
  ///
  /// In en, this message translates to:
  /// **'For investment reference. Investment decisions are your responsibility.'**
  String get investmentReferenceNotice;

  /// No description provided for @currentPlan.
  ///
  /// In en, this message translates to:
  /// **'Current Plan'**
  String get currentPlan;

  /// No description provided for @nextBilling.
  ///
  /// In en, this message translates to:
  /// **'Next Billing'**
  String get nextBilling;

  /// No description provided for @amount.
  ///
  /// In en, this message translates to:
  /// **'Amount'**
  String get amount;

  /// No description provided for @notScheduled.
  ///
  /// In en, this message translates to:
  /// **'Not scheduled'**
  String get notScheduled;

  /// No description provided for @subscriptionInfo.
  ///
  /// In en, this message translates to:
  /// **'Subscription Info'**
  String get subscriptionInfo;

  /// No description provided for @subscriptionTerms.
  ///
  /// In en, this message translates to:
  /// **'Subscription Terms'**
  String get subscriptionTerms;

  /// No description provided for @subscriptionTermsText.
  ///
  /// In en, this message translates to:
  /// **'• Subscriptions are charged to your iTunes account upon purchase confirmation\\n• Subscriptions automatically renew unless auto-renewal is turned off at least 24 hours before the end of the current period\\n• Renewal charges are made within 24 hours of the end of the current period\\n• Subscriptions can be managed in your account settings after purchase\\n• Any unused portion of free trial period will be forfeited when purchasing a subscription'**
  String get subscriptionTermsText;

  /// No description provided for @dataDelayWarning.
  ///
  /// In en, this message translates to:
  /// **'Real-time data may be delayed by 15 minutes'**
  String get dataDelayWarning;

  /// No description provided for @dataSource.
  ///
  /// In en, this message translates to:
  /// **'Data provided by Finnhub'**
  String get dataSource;

  /// No description provided for @poweredBy.
  ///
  /// In en, this message translates to:
  /// **'Powered by Legendary Traders'**
  String get poweredBy;

  /// No description provided for @errorLoadingSubscription.
  ///
  /// In en, this message translates to:
  /// **'Error loading subscription'**
  String get errorLoadingSubscription;

  /// No description provided for @active.
  ///
  /// In en, this message translates to:
  /// **'Active'**
  String get active;

  /// No description provided for @inactive.
  ///
  /// In en, this message translates to:
  /// **'Inactive'**
  String get inactive;

  /// No description provided for @autoRenewalOff.
  ///
  /// In en, this message translates to:
  /// **'Auto-renewal is off. Your plan will expire on {date}'**
  String autoRenewalOff(String date);

  /// No description provided for @availablePlans.
  ///
  /// In en, this message translates to:
  /// **'Available Plans'**
  String get availablePlans;

  /// No description provided for @popular.
  ///
  /// In en, this message translates to:
  /// **'POPULAR'**
  String get popular;

  /// No description provided for @savePercent.
  ///
  /// In en, this message translates to:
  /// **'Save {percent}%'**
  String savePercent(int percent);

  /// No description provided for @upgrade.
  ///
  /// In en, this message translates to:
  /// **'Upgrade'**
  String get upgrade;

  /// No description provided for @billingHistory.
  ///
  /// In en, this message translates to:
  /// **'Billing History'**
  String get billingHistory;

  /// No description provided for @upgradePlan.
  ///
  /// In en, this message translates to:
  /// **'Upgrade Plan'**
  String get upgradePlan;

  /// No description provided for @upgradePlanConfirm.
  ///
  /// In en, this message translates to:
  /// **'Upgrade to {planName}?'**
  String upgradePlanConfirm(String planName);

  /// No description provided for @price.
  ///
  /// In en, this message translates to:
  /// **'Price'**
  String get price;

  /// No description provided for @upgradeSuccessful.
  ///
  /// In en, this message translates to:
  /// **'Successfully upgraded to {planName}'**
  String upgradeSuccessful(String planName);

  /// No description provided for @tierDescFree.
  ///
  /// In en, this message translates to:
  /// **'Get started with basic features'**
  String get tierDescFree;

  /// No description provided for @tierDescBasic.
  ///
  /// In en, this message translates to:
  /// **'For individual traders'**
  String get tierDescBasic;

  /// No description provided for @tierDescPro.
  ///
  /// In en, this message translates to:
  /// **'Advanced tools for serious traders'**
  String get tierDescPro;

  /// No description provided for @tierDescPremium.
  ///
  /// In en, this message translates to:
  /// **'Everything you need to succeed'**
  String get tierDescPremium;

  /// No description provided for @tierDescEnterprise.
  ///
  /// In en, this message translates to:
  /// **'Custom solutions for teams'**
  String get tierDescEnterprise;

  /// No description provided for @errorLoadingRecommendations.
  ///
  /// In en, this message translates to:
  /// **'Error loading recommendations'**
  String get errorLoadingRecommendations;

  /// No description provided for @retry.
  ///
  /// In en, this message translates to:
  /// **'Retry'**
  String get retry;

  /// No description provided for @allActions.
  ///
  /// In en, this message translates to:
  /// **'All Actions'**
  String get allActions;

  /// No description provided for @buy.
  ///
  /// In en, this message translates to:
  /// **'Buy'**
  String get buy;

  /// No description provided for @sell.
  ///
  /// In en, this message translates to:
  /// **'Sell'**
  String get sell;

  /// No description provided for @hold.
  ///
  /// In en, this message translates to:
  /// **'Hold'**
  String get hold;

  /// No description provided for @latest.
  ///
  /// In en, this message translates to:
  /// **'Latest'**
  String get latest;

  /// No description provided for @confidence.
  ///
  /// In en, this message translates to:
  /// **'Confidence'**
  String get confidence;

  /// No description provided for @profitPotential.
  ///
  /// In en, this message translates to:
  /// **'Profit Potential'**
  String get profitPotential;

  /// No description provided for @noRecommendationsFound.
  ///
  /// In en, this message translates to:
  /// **'No recommendations found'**
  String get noRecommendationsFound;

  /// No description provided for @portfolio.
  ///
  /// In en, this message translates to:
  /// **'Portfolio'**
  String get portfolio;

  /// No description provided for @errorLoadingPositions.
  ///
  /// In en, this message translates to:
  /// **'Error loading positions'**
  String get errorLoadingPositions;

  /// No description provided for @today.
  ///
  /// In en, this message translates to:
  /// **'today'**
  String get today;

  /// No description provided for @winRate.
  ///
  /// In en, this message translates to:
  /// **'Win Rate'**
  String get winRate;

  /// No description provided for @positions.
  ///
  /// In en, this message translates to:
  /// **'Positions'**
  String get positions;

  /// No description provided for @dayPL.
  ///
  /// In en, this message translates to:
  /// **'Day P&L'**
  String get dayPL;

  /// No description provided for @noOpenPositions.
  ///
  /// In en, this message translates to:
  /// **'No open positions'**
  String get noOpenPositions;

  /// No description provided for @startTradingToSeePositions.
  ///
  /// In en, this message translates to:
  /// **'Start trading to see your positions'**
  String get startTradingToSeePositions;

  /// No description provided for @quantity.
  ///
  /// In en, this message translates to:
  /// **'Quantity'**
  String get quantity;

  /// No description provided for @avgCost.
  ///
  /// In en, this message translates to:
  /// **'Avg Cost'**
  String get avgCost;

  /// No description provided for @current.
  ///
  /// In en, this message translates to:
  /// **'Current'**
  String get current;

  /// No description provided for @pl.
  ///
  /// In en, this message translates to:
  /// **'P&L'**
  String get pl;

  /// No description provided for @close.
  ///
  /// In en, this message translates to:
  /// **'Close'**
  String get close;

  /// No description provided for @edit.
  ///
  /// In en, this message translates to:
  /// **'Edit'**
  String get edit;

  /// No description provided for @closePosition.
  ///
  /// In en, this message translates to:
  /// **'Close Position'**
  String get closePosition;

  /// No description provided for @closePositionConfirm.
  ///
  /// In en, this message translates to:
  /// **'Close {quantity} shares of {stockCode}?'**
  String closePositionConfirm(int quantity, String stockCode);

  /// No description provided for @cancel.
  ///
  /// In en, this message translates to:
  /// **'Cancel'**
  String get cancel;

  /// No description provided for @positionClosedSuccessfully.
  ///
  /// In en, this message translates to:
  /// **'Position closed successfully'**
  String get positionClosedSuccessfully;

  /// No description provided for @sl.
  ///
  /// In en, this message translates to:
  /// **'SL'**
  String get sl;

  /// No description provided for @tp.
  ///
  /// In en, this message translates to:
  /// **'TP'**
  String get tp;

  /// No description provided for @upload.
  ///
  /// In en, this message translates to:
  /// **'Upload'**
  String get upload;

  /// No description provided for @uploadVideo.
  ///
  /// In en, this message translates to:
  /// **'Upload Video'**
  String get uploadVideo;

  /// No description provided for @uploadDescription.
  ///
  /// In en, this message translates to:
  /// **'Select from gallery or shoot with camera'**
  String get uploadDescription;

  /// No description provided for @gallery.
  ///
  /// In en, this message translates to:
  /// **'Gallery'**
  String get gallery;

  /// No description provided for @camera.
  ///
  /// In en, this message translates to:
  /// **'Camera'**
  String get camera;

  /// No description provided for @inbox.
  ///
  /// In en, this message translates to:
  /// **'Inbox'**
  String get inbox;

  /// No description provided for @activity.
  ///
  /// In en, this message translates to:
  /// **'Activity'**
  String get activity;

  /// No description provided for @newLikes.
  ///
  /// In en, this message translates to:
  /// **'New Likes'**
  String get newLikes;

  /// No description provided for @lastWeek.
  ///
  /// In en, this message translates to:
  /// **'Last week'**
  String get lastWeek;

  /// No description provided for @yesterday.
  ///
  /// In en, this message translates to:
  /// **'Yesterday'**
  String get yesterday;

  /// No description provided for @newFollowers.
  ///
  /// In en, this message translates to:
  /// **'New Followers'**
  String get newFollowers;

  /// No description provided for @newComments.
  ///
  /// In en, this message translates to:
  /// **'New Comments'**
  String get newComments;

  /// No description provided for @hoursAgo.
  ///
  /// In en, this message translates to:
  /// **'{hours} hours ago'**
  String hoursAgo(int hours);

  /// No description provided for @messages.
  ///
  /// In en, this message translates to:
  /// **'Messages'**
  String get messages;

  /// No description provided for @search.
  ///
  /// In en, this message translates to:
  /// **'Search'**
  String get search;

  /// No description provided for @signals.
  ///
  /// In en, this message translates to:
  /// **'Signals'**
  String get signals;

  /// No description provided for @discover.
  ///
  /// In en, this message translates to:
  /// **'Discover'**
  String get discover;

  /// No description provided for @premium.
  ///
  /// In en, this message translates to:
  /// **'Premium'**
  String get premium;
}

class _AppLocalizationsDelegate
    extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) => <String>[
        'ar',
        'de',
        'en',
        'es',
        'fr',
        'hi',
        'ja',
        'ko',
        'pt',
        'zh'
      ].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {
  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'ar':
      return AppLocalizationsAr();
    case 'de':
      return AppLocalizationsDe();
    case 'en':
      return AppLocalizationsEn();
    case 'es':
      return AppLocalizationsEs();
    case 'fr':
      return AppLocalizationsFr();
    case 'hi':
      return AppLocalizationsHi();
    case 'ja':
      return AppLocalizationsJa();
    case 'ko':
      return AppLocalizationsKo();
    case 'pt':
      return AppLocalizationsPt();
    case 'zh':
      return AppLocalizationsZh();
  }

  throw FlutterError(
      'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
      'an issue with the localizations generation tool. Please file an issue '
      'on GitHub with a reproducible sample app and the gen-l10n configuration '
      'that was used.');
}

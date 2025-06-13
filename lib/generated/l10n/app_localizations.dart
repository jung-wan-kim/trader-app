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
    Locale('zh'),
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

  /// No description provided for @signInWithGoogle.
  ///
  /// In en, this message translates to:
  /// **'Sign in with Google'**
  String get signInWithGoogle;

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

  /// No description provided for @accountManagement.
  ///
  /// In en, this message translates to:
  /// **'Account Management'**
  String get accountManagement;

  /// No description provided for @cancelSubscription.
  ///
  /// In en, this message translates to:
  /// **'Cancel Subscription'**
  String get cancelSubscription;

  /// No description provided for @deleteAccount.
  ///
  /// In en, this message translates to:
  /// **'Delete Account'**
  String get deleteAccount;

  /// No description provided for @cancelSubscriptionTitle.
  ///
  /// In en, this message translates to:
  /// **'Cancel Subscription'**
  String get cancelSubscriptionTitle;

  /// No description provided for @cancelSubscriptionMessage.
  ///
  /// In en, this message translates to:
  /// **'Are you sure you want to cancel your subscription? You will continue to have access until your current billing period ends.'**
  String get cancelSubscriptionMessage;

  /// No description provided for @cancelSubscriptionConfirm.
  ///
  /// In en, this message translates to:
  /// **'Yes, Cancel'**
  String get cancelSubscriptionConfirm;

  /// No description provided for @deleteAccountTitle.
  ///
  /// In en, this message translates to:
  /// **'Delete Account'**
  String get deleteAccountTitle;

  /// No description provided for @deleteAccountMessage.
  ///
  /// In en, this message translates to:
  /// **'Are you sure you want to delete your account? This action cannot be undone and all your data will be permanently removed.'**
  String get deleteAccountMessage;

  /// No description provided for @deleteAccountConfirm.
  ///
  /// In en, this message translates to:
  /// **'Yes, Delete Account'**
  String get deleteAccountConfirm;

  /// No description provided for @subscriptionCancelledSuccessfully.
  ///
  /// In en, this message translates to:
  /// **'Subscription cancelled successfully'**
  String get subscriptionCancelledSuccessfully;

  /// No description provided for @accountDeletedSuccessfully.
  ///
  /// In en, this message translates to:
  /// **'Account deleted successfully'**
  String get accountDeletedSuccessfully;

  /// No description provided for @languageSettings.
  ///
  /// In en, this message translates to:
  /// **'Language Settings'**
  String get languageSettings;

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
  /// **'• Subscriptions are charged to your iTunes account upon purchase confirmation\\\\n• Subscriptions automatically renew unless auto-renewal is turned off at least 24 hours before the end of the current period\\\\n• Renewal charges are made within 24 hours of the end of the current period\\\\n• Subscriptions can be managed in your account settings after purchase\\\\n• Any unused portion of free trial period will be forfeited when purchasing a subscription'**
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

  /// No description provided for @downgrade.
  ///
  /// In en, this message translates to:
  /// **'Downgrade'**
  String get downgrade;

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

  /// No description provided for @planFeatureBasicRecommendations.
  ///
  /// In en, this message translates to:
  /// **'Basic recommendations'**
  String get planFeatureBasicRecommendations;

  /// No description provided for @planFeatureLimitedPositions.
  ///
  /// In en, this message translates to:
  /// **'Limited to {count} positions'**
  String planFeatureLimitedPositions(int count);

  /// No description provided for @planFeatureCommunitySupport.
  ///
  /// In en, this message translates to:
  /// **'Community support'**
  String get planFeatureCommunitySupport;

  /// No description provided for @planFeatureAllFreeFeatures.
  ///
  /// In en, this message translates to:
  /// **'All Free features'**
  String get planFeatureAllFreeFeatures;

  /// No description provided for @planFeatureUpToPositions.
  ///
  /// In en, this message translates to:
  /// **'Up to {count} positions'**
  String planFeatureUpToPositions(int count);

  /// No description provided for @planFeatureEmailSupport.
  ///
  /// In en, this message translates to:
  /// **'Email support'**
  String get planFeatureEmailSupport;

  /// No description provided for @planFeatureBasicAnalytics.
  ///
  /// In en, this message translates to:
  /// **'Basic analytics'**
  String get planFeatureBasicAnalytics;

  /// No description provided for @planFeatureAllBasicFeatures.
  ///
  /// In en, this message translates to:
  /// **'All Basic features'**
  String get planFeatureAllBasicFeatures;

  /// No description provided for @planFeatureRealtimeRecommendations.
  ///
  /// In en, this message translates to:
  /// **'Real-time recommendations'**
  String get planFeatureRealtimeRecommendations;

  /// No description provided for @planFeatureAdvancedAnalytics.
  ///
  /// In en, this message translates to:
  /// **'Advanced analytics'**
  String get planFeatureAdvancedAnalytics;

  /// No description provided for @planFeaturePrioritySupport.
  ///
  /// In en, this message translates to:
  /// **'Priority support'**
  String get planFeaturePrioritySupport;

  /// No description provided for @planFeatureRiskManagementTools.
  ///
  /// In en, this message translates to:
  /// **'Risk management tools'**
  String get planFeatureRiskManagementTools;

  /// No description provided for @planFeatureCustomAlerts.
  ///
  /// In en, this message translates to:
  /// **'Custom alerts'**
  String get planFeatureCustomAlerts;

  /// No description provided for @planFeatureAllProFeatures.
  ///
  /// In en, this message translates to:
  /// **'All Pro Monthly features'**
  String get planFeatureAllProFeatures;

  /// No description provided for @planFeatureMonthsFree.
  ///
  /// In en, this message translates to:
  /// **'{count} months free'**
  String planFeatureMonthsFree(int count);

  /// No description provided for @planFeatureAnnualReview.
  ///
  /// In en, this message translates to:
  /// **'Annual performance review'**
  String get planFeatureAnnualReview;

  /// No description provided for @planFeatureAllProFeaturesUnlimited.
  ///
  /// In en, this message translates to:
  /// **'All Pro features'**
  String get planFeatureAllProFeaturesUnlimited;

  /// No description provided for @planFeatureUnlimitedPositions.
  ///
  /// In en, this message translates to:
  /// **'Unlimited positions'**
  String get planFeatureUnlimitedPositions;

  /// No description provided for @planFeatureApiAccess.
  ///
  /// In en, this message translates to:
  /// **'API access'**
  String get planFeatureApiAccess;

  /// No description provided for @planFeatureDedicatedManager.
  ///
  /// In en, this message translates to:
  /// **'Dedicated account manager'**
  String get planFeatureDedicatedManager;

  /// No description provided for @planFeatureCustomStrategies.
  ///
  /// In en, this message translates to:
  /// **'Custom strategies'**
  String get planFeatureCustomStrategies;

  /// No description provided for @planFeatureWhiteLabelOptions.
  ///
  /// In en, this message translates to:
  /// **'White-label options'**
  String get planFeatureWhiteLabelOptions;

  /// No description provided for @termsTitle.
  ///
  /// In en, this message translates to:
  /// **'Trader App Terms of Service'**
  String get termsTitle;

  /// No description provided for @termsEffectiveDate.
  ///
  /// In en, this message translates to:
  /// **'Effective Date: February 21, 2025'**
  String get termsEffectiveDate;

  /// No description provided for @termsSection1Title.
  ///
  /// In en, this message translates to:
  /// **'Article 1 (Purpose)'**
  String get termsSection1Title;

  /// No description provided for @termsSection1Content.
  ///
  /// In en, this message translates to:
  /// **'These terms are intended to stipulate the rights, obligations, and responsibilities of the company and users regarding the use of mobile application services (hereinafter referred to as \"Services\") provided by Trader App (hereinafter referred to as \"Company\").'**
  String get termsSection1Content;

  /// No description provided for @termsSection2Title.
  ///
  /// In en, this message translates to:
  /// **'Article 2 (Definitions)'**
  String get termsSection2Title;

  /// No description provided for @termsSection2Content.
  ///
  /// In en, this message translates to:
  /// **'1. \"Service\" refers to the AI-based stock recommendation and investment information service provided by the Company.\n2. \"User\" refers to members and non-members who receive services provided by the Company under these terms.\n3. \"Member\" refers to a person who has registered as a member by providing personal information to the Company, continuously receives Company information, and can continuously use the Service.'**
  String get termsSection2Content;

  /// No description provided for @termsSection3Title.
  ///
  /// In en, this message translates to:
  /// **'Article 3 (Effectiveness and Changes to Terms)'**
  String get termsSection3Title;

  /// No description provided for @termsSection3Content.
  ///
  /// In en, this message translates to:
  /// **'1. These terms become effective by posting them on the service screen or notifying users through other means.\n2. The Company may change these terms when deemed necessary, and changed terms will be announced 7 days before the application date.'**
  String get termsSection3Content;

  /// No description provided for @termsSection4Title.
  ///
  /// In en, this message translates to:
  /// **'Article 4 (Provision of Services)'**
  String get termsSection4Title;

  /// No description provided for @termsSection4Content.
  ///
  /// In en, this message translates to:
  /// **'1. The Company provides the following services:\n   • AI-based stock recommendation service\n   • Legendary trader strategy information\n   • Real-time stock price information\n   • Portfolio management tools\n   • Risk calculator\n\n2. Services are provided 24 hours a day, 365 days a year in principle. However, they may be temporarily suspended due to system maintenance.'**
  String get termsSection4Content;

  /// No description provided for @termsFinancialDisclaimer.
  ///
  /// In en, this message translates to:
  /// **'All information provided by this service is for reference only and does not constitute investment advice or investment recommendations.\n\n• All investment decisions must be made under the user\'s own judgment and responsibility.\n• Stock investment carries the risk of principal loss.\n• Past returns do not guarantee future profits.\n• The Company assumes no responsibility for investment results based on the information provided.'**
  String get termsFinancialDisclaimer;

  /// No description provided for @termsSection5Title.
  ///
  /// In en, this message translates to:
  /// **'Article 5 (Membership Registration)'**
  String get termsSection5Title;

  /// No description provided for @termsSection5Content.
  ///
  /// In en, this message translates to:
  /// **'1. Membership registration is concluded when the user agrees to the contents of the terms and applies for membership registration, and the Company approves such application.\n2. The Company may not approve or later terminate the usage contract for applications that fall under the following:\n   • Using a false name or another person\'s name\n   • Providing false information or not providing information requested by the Company\n   • Not meeting other application requirements'**
  String get termsSection5Content;

  /// No description provided for @termsSection6Title.
  ///
  /// In en, this message translates to:
  /// **'Article 6 (User Obligations)'**
  String get termsSection6Title;

  /// No description provided for @termsSection6Content.
  ///
  /// In en, this message translates to:
  /// **'Users must not engage in the following activities:\n1. Stealing others\' information\n2. Infringing on the Company\'s intellectual property rights\n3. Intentionally interfering with service operations\n4. Other activities that violate relevant laws and regulations'**
  String get termsSection6Content;

  /// No description provided for @termsSection7Title.
  ///
  /// In en, this message translates to:
  /// **'Article 7 (Service Usage Fees)'**
  String get termsSection7Title;

  /// No description provided for @termsSection7Content.
  ///
  /// In en, this message translates to:
  /// **'1. Basic services are provided free of charge.\n2. Premium services require payment of separate usage fees.\n3. Usage fees for paid services follow the fee policy specified within the service.\n4. The Company may change paid service usage fees and will notify 30 days in advance of changes.'**
  String get termsSection7Content;

  /// No description provided for @termsSection8Title.
  ///
  /// In en, this message translates to:
  /// **'Article 8 (Disclaimer)'**
  String get termsSection8Title;

  /// No description provided for @termsSection8Content.
  ///
  /// In en, this message translates to:
  /// **'1. The Company is exempt from responsibility for providing services when unable to provide services due to natural disasters or force majeure equivalent thereto.\n2. The Company is not responsible for service usage obstacles due to user\'s fault.\n3. All investment information provided by the Company is for reference only, and the responsibility for investment decisions lies entirely with the user.'**
  String get termsSection8Content;

  /// No description provided for @termsSection9Title.
  ///
  /// In en, this message translates to:
  /// **'Article 9 (Privacy Protection)'**
  String get termsSection9Title;

  /// No description provided for @termsSection9Content.
  ///
  /// In en, this message translates to:
  /// **'The Company establishes and complies with a privacy policy to protect users\' personal information. For details, please refer to the Privacy Policy.'**
  String get termsSection9Content;

  /// No description provided for @termsSection10Title.
  ///
  /// In en, this message translates to:
  /// **'Article 10 (Dispute Resolution)'**
  String get termsSection10Title;

  /// No description provided for @termsSection10Content.
  ///
  /// In en, this message translates to:
  /// **'1. Disputes between the Company and users shall be resolved through mutual consultation in principle.\n2. If consultation cannot be reached, it shall be resolved in the competent court according to relevant laws.'**
  String get termsSection10Content;

  /// No description provided for @termsSupplementary.
  ///
  /// In en, this message translates to:
  /// **'Supplementary Provisions'**
  String get termsSupplementary;

  /// No description provided for @termsSupplementaryDate.
  ///
  /// In en, this message translates to:
  /// **'These terms are effective from February 21, 2025.'**
  String get termsSupplementaryDate;

  /// No description provided for @privacyTitle.
  ///
  /// In en, this message translates to:
  /// **'Trader App Privacy Policy'**
  String get privacyTitle;

  /// No description provided for @privacyEffectiveDate.
  ///
  /// In en, this message translates to:
  /// **'Effective Date: February 21, 2025'**
  String get privacyEffectiveDate;

  /// No description provided for @privacySection1Title.
  ///
  /// In en, this message translates to:
  /// **'1. Purpose of Collection and Use of Personal Information'**
  String get privacySection1Title;

  /// No description provided for @privacySection1Content.
  ///
  /// In en, this message translates to:
  /// **'Trader App collects personal information for the following purposes:\n• Member registration and management\n• Providing customized investment information\n• Service improvement and new service development\n• Customer inquiry response'**
  String get privacySection1Content;

  /// No description provided for @privacySection2Title.
  ///
  /// In en, this message translates to:
  /// **'2. Items of Personal Information Collected'**
  String get privacySection2Title;

  /// No description provided for @privacySection2Content.
  ///
  /// In en, this message translates to:
  /// **'• Required items: Email, password\n• Optional items: Name, phone number, investment interests\n• Automatically collected items: Device information, app usage history, IP address'**
  String get privacySection2Content;

  /// No description provided for @privacySection3Title.
  ///
  /// In en, this message translates to:
  /// **'3. Retention and Use Period of Personal Information'**
  String get privacySection3Title;

  /// No description provided for @privacySection3Content.
  ///
  /// In en, this message translates to:
  /// **'• Until membership withdrawal\n• However, retained for the required period if preservation is necessary according to relevant laws\n• Contract or subscription withdrawal records under e-commerce law: 5 years\n• Consumer complaint or dispute handling records: 3 years'**
  String get privacySection3Content;

  /// No description provided for @privacySection4Title.
  ///
  /// In en, this message translates to:
  /// **'4. Provision of Personal Information to Third Parties'**
  String get privacySection4Title;

  /// No description provided for @privacySection4Content.
  ///
  /// In en, this message translates to:
  /// **'Trader App does not provide users\' personal information to third parties in principle.\nHowever, exceptions are made in the following cases:\n• When user consent is obtained\n• When required by laws and regulations'**
  String get privacySection4Content;

  /// No description provided for @privacySection5Title.
  ///
  /// In en, this message translates to:
  /// **'5. Personal Information Protection Measures'**
  String get privacySection5Title;

  /// No description provided for @privacySection5Content.
  ///
  /// In en, this message translates to:
  /// **'• Personal information encryption\n• Technical measures against hacking\n• Limiting access to personal information\n• Minimizing and training personnel handling personal information'**
  String get privacySection5Content;

  /// No description provided for @privacySection6Title.
  ///
  /// In en, this message translates to:
  /// **'6. User Rights'**
  String get privacySection6Title;

  /// No description provided for @privacySection6Content.
  ///
  /// In en, this message translates to:
  /// **'Users can exercise the following rights at any time:\n• Request to view personal information\n• Request to correct or delete personal information\n• Request to stop processing personal information\n• Request to transfer personal information'**
  String get privacySection6Content;

  /// No description provided for @privacySection7Title.
  ///
  /// In en, this message translates to:
  /// **'7. Personal Information Protection Officer'**
  String get privacySection7Title;

  /// No description provided for @privacySection7Content.
  ///
  /// In en, this message translates to:
  /// **'Personal Information Protection Officer: Hong Gil-dong\nEmail: privacy@traderapp.com\nPhone: 02-1234-5678'**
  String get privacySection7Content;

  /// No description provided for @privacySection8Title.
  ///
  /// In en, this message translates to:
  /// **'8. Changes to Privacy Policy'**
  String get privacySection8Title;

  /// No description provided for @privacySection8Content.
  ///
  /// In en, this message translates to:
  /// **'This privacy policy may be modified to reflect changes in laws and services.\nChanges will be announced through in-app notifications.'**
  String get privacySection8Content;

  /// No description provided for @totalPortfolioValue.
  ///
  /// In en, this message translates to:
  /// **'Total Portfolio Value'**
  String get totalPortfolioValue;

  /// No description provided for @portfolioPerformance30Days.
  ///
  /// In en, this message translates to:
  /// **'Portfolio Performance (30 Days)'**
  String get portfolioPerformance30Days;

  /// No description provided for @performanceStatistics.
  ///
  /// In en, this message translates to:
  /// **'Performance Statistics'**
  String get performanceStatistics;

  /// No description provided for @avgReturn.
  ///
  /// In en, this message translates to:
  /// **'Avg. Return'**
  String get avgReturn;

  /// No description provided for @totalTrades.
  ///
  /// In en, this message translates to:
  /// **'Total Trades'**
  String get totalTrades;

  /// No description provided for @bestTrade.
  ///
  /// In en, this message translates to:
  /// **'Best Trade'**
  String get bestTrade;

  /// No description provided for @recentTrades.
  ///
  /// In en, this message translates to:
  /// **'Recent Trades'**
  String get recentTrades;

  /// No description provided for @monthlyReturns.
  ///
  /// In en, this message translates to:
  /// **'Monthly Returns'**
  String get monthlyReturns;

  /// No description provided for @jan.
  ///
  /// In en, this message translates to:
  /// **'Jan'**
  String get jan;

  /// No description provided for @feb.
  ///
  /// In en, this message translates to:
  /// **'Feb'**
  String get feb;

  /// No description provided for @mar.
  ///
  /// In en, this message translates to:
  /// **'Mar'**
  String get mar;

  /// No description provided for @apr.
  ///
  /// In en, this message translates to:
  /// **'Apr'**
  String get apr;

  /// No description provided for @may.
  ///
  /// In en, this message translates to:
  /// **'May'**
  String get may;

  /// No description provided for @jun.
  ///
  /// In en, this message translates to:
  /// **'Jun'**
  String get jun;

  /// No description provided for @marketSummary.
  ///
  /// In en, this message translates to:
  /// **'Market Summary'**
  String get marketSummary;

  /// No description provided for @addStock.
  ///
  /// In en, this message translates to:
  /// **'Add Stock'**
  String get addStock;

  /// No description provided for @stocks.
  ///
  /// In en, this message translates to:
  /// **'Stocks'**
  String get stocks;

  /// No description provided for @searchStocks.
  ///
  /// In en, this message translates to:
  /// **'Search stocks...'**
  String get searchStocks;

  /// No description provided for @nothingInWatchlist.
  ///
  /// In en, this message translates to:
  /// **'Nothing in your watchlist yet'**
  String get nothingInWatchlist;

  /// No description provided for @addStocksToWatchlist.
  ///
  /// In en, this message translates to:
  /// **'Add stocks to track their performance'**
  String get addStocksToWatchlist;

  /// No description provided for @remove.
  ///
  /// In en, this message translates to:
  /// **'Remove'**
  String get remove;

  /// No description provided for @addToWatchlist.
  ///
  /// In en, this message translates to:
  /// **'Add to Watchlist'**
  String get addToWatchlist;

  /// No description provided for @stockAddedToWatchlist.
  ///
  /// In en, this message translates to:
  /// **'Stock added to watchlist'**
  String get stockAddedToWatchlist;

  /// No description provided for @stockRemovedFromWatchlist.
  ///
  /// In en, this message translates to:
  /// **'Stock removed from watchlist'**
  String get stockRemovedFromWatchlist;

  /// No description provided for @chooseTrader.
  ///
  /// In en, this message translates to:
  /// **'Choose Your Trading Master'**
  String get chooseTrader;

  /// No description provided for @performance.
  ///
  /// In en, this message translates to:
  /// **'Performance'**
  String get performance;

  /// No description provided for @keyStrategy.
  ///
  /// In en, this message translates to:
  /// **'Key Strategy'**
  String get keyStrategy;

  /// No description provided for @selected.
  ///
  /// In en, this message translates to:
  /// **'Selected'**
  String get selected;

  /// No description provided for @continueWithSelection.
  ///
  /// In en, this message translates to:
  /// **'Continue with Selection'**
  String get continueWithSelection;
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
    'zh',
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
    'that was used.',
  );
}

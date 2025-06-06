// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for German (`de`).
class AppLocalizationsDe extends AppLocalizations {
  AppLocalizationsDe([String locale = 'de']) : super(locale);

  @override
  String get appTitle => 'Trader App';

  @override
  String get appSubtitle => 'KI-gestützte Aktienempfehlungen';

  @override
  String get subscription => 'Subscription';

  @override
  String get chooseLanguage => 'Wählen Sie Ihre Sprache';

  @override
  String get selectLanguageDescription =>
      'Wählen Sie Ihre bevorzugte Sprache für die App';

  @override
  String get continueButton => 'Weiter';

  @override
  String get onboardingTitle1 => 'Legendäre Trader-Strategien';

  @override
  String get onboardingDesc1 =>
      'Nutzen Sie bewährte Anlagestrategien der erfolgreichsten Trader der Geschichte wie Jesse Livermore und William O\'Neil';

  @override
  String get onboardingTitle2 => 'KI-gestützte Aktienempfehlungen';

  @override
  String get onboardingDesc2 =>
      'Erhalten Sie optimale Aktienempfehlungen, die zu legendären Trader-Strategien durch fortschrittliche KI-Marktanalyse passen';

  @override
  String get onboardingTitle3 => 'Risikomanagement';

  @override
  String get onboardingDesc3 =>
      'Erreichen Sie sicheres Investieren mit Positionsgrößenrechner und Stop-Loss/Take-Profit-Strategien';

  @override
  String get onboardingTitle4 => 'Echtzeit-Marktanalyse';

  @override
  String get onboardingDesc4 =>
      'Verstehen Sie Markttrends und erfassen Sie optimale Zeitpunkte mit Echtzeit-Charts und technischen Indikatoren';

  @override
  String get getStarted => 'Loslegen';

  @override
  String get next => 'Weiter';

  @override
  String get skip => 'Überspringen';

  @override
  String get email => 'E-Mail';

  @override
  String get password => 'Passwort';

  @override
  String get login => 'Anmelden';

  @override
  String get or => 'oder';

  @override
  String get signInWithApple => 'Mit Apple anmelden';

  @override
  String get demoModeNotice => 'Demo-Modus: Testkonto automatisch ausgefüllt';

  @override
  String get privacyPolicy => 'Datenschutzrichtlinie';

  @override
  String get termsOfService => 'Nutzungsbedingungen';

  @override
  String get investmentWarning => 'Nur zur Referenz, keine Anlageberatung';

  @override
  String get profile => 'Profil';

  @override
  String get trader => 'Trader';

  @override
  String get subscriptionManagement => 'Abonnement-Verwaltung';

  @override
  String subscribedPlan(String planName) {
    return '$planName Aktiv';
  }

  @override
  String daysRemaining(int days) {
    return '$days Tage verbleibend';
  }

  @override
  String get upgradeToPremiun => 'Auf Premium upgraden';

  @override
  String get freePlan => 'Kostenloser Plan';

  @override
  String get investmentPerformance => 'Anlageperformance';

  @override
  String get performanceDescription =>
      'Renditen und Handelshistorie überprüfen';

  @override
  String get watchlist => 'Watchlist';

  @override
  String get watchlistDescription => 'Gespeicherte Aktien verwalten';

  @override
  String get notificationSettings => 'Benachrichtigungseinstellungen';

  @override
  String get notificationDescription =>
      'Empfehlungen und Marktalarme verwalten';

  @override
  String get legalInformation => 'Rechtliche Informationen';

  @override
  String get customerSupport => 'Kundensupport';

  @override
  String get appInfo => 'App-Info';

  @override
  String get versionInfo => 'Versionsinformationen';

  @override
  String get logout => 'Abmelden';

  @override
  String get investmentWarningTitle => 'Anlagerisiko-Warnung';

  @override
  String get investmentWarningText =>
      'Alle in dieser App bereitgestellten Informationen dienen nur als Referenz und stellen keine Anlageberatung dar. Alle Anlageentscheidungen müssen unter Ihrem eigenen Urteil und Ihrer Verantwortung getroffen werden.';

  @override
  String get settings => 'Einstellungen';

  @override
  String get tradingSignals => 'Trading-Signale';

  @override
  String get realTimeRecommendations => 'Echtzeitempfehlungen von Top-Tradern';

  @override
  String get investmentReferenceNotice =>
      'Zur Anlagereferenz. Anlageentscheidungen liegen in Ihrer Verantwortung.';

  @override
  String get currentPlan => 'Aktueller Plan';

  @override
  String get nextBilling => 'Nächste Abrechnung';

  @override
  String get amount => 'Betrag';

  @override
  String get notScheduled => 'Nicht geplant';

  @override
  String get subscriptionInfo => 'Abonnement-Informationen';

  @override
  String get subscriptionTerms => 'Abonnement-Bedingungen';

  @override
  String get subscriptionTermsText =>
      '• Abonnements werden bei Kaufbestätigung Ihrem iTunes-Konto belastet\\n• Abonnements erneuern sich automatisch, es sei denn, die automatische Erneuerung wird mindestens 24 Stunden vor Ende des aktuellen Zeitraums deaktiviert\\n• Erneuerungsgebühren werden innerhalb von 24 Stunden vor Ende des aktuellen Zeitraums erhoben\\n• Abonnements können nach dem Kauf in Ihren Kontoeinstellungen verwaltet werden\\n• Jeder ungenutzte Teil der kostenlosen Testphase verfällt beim Kauf eines Abonnements';

  @override
  String get dataDelayWarning =>
      'Echtzeitdaten können um 15 Minuten verzögert sein';

  @override
  String get dataSource => 'Daten bereitgestellt von Finnhub';

  @override
  String get poweredBy => 'Unterstützt von legendären Tradern';

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
  String get errorLoadingRecommendations =>
      'Fehler beim Laden der Empfehlungen';

  @override
  String get retry => 'Erneut versuchen';

  @override
  String get allActions => 'Alle Aktionen';

  @override
  String get buy => 'Kaufen';

  @override
  String get sell => 'Verkaufen';

  @override
  String get hold => 'Halten';

  @override
  String get latest => 'Neueste';

  @override
  String get confidence => 'Vertrauen';

  @override
  String get profitPotential => 'Gewinnpotenzial';

  @override
  String get noRecommendationsFound => 'Keine Empfehlungen gefunden';

  @override
  String get portfolio => 'Portfolio';

  @override
  String get errorLoadingPositions => 'Fehler beim Laden der Positionen';

  @override
  String get today => 'heute';

  @override
  String get winRate => 'Gewinnrate';

  @override
  String get positions => 'Positionen';

  @override
  String get dayPL => 'Tages-G&V';

  @override
  String get noOpenPositions => 'Keine offenen Positionen';

  @override
  String get startTradingToSeePositions =>
      'Beginnen Sie mit dem Handel, um Ihre Positionen zu sehen';

  @override
  String get quantity => 'Menge';

  @override
  String get avgCost => 'Durchschnittliche Kosten';

  @override
  String get current => 'Aktuell';

  @override
  String get pl => 'G&V';

  @override
  String get close => 'Schließen';

  @override
  String get edit => 'Bearbeiten';

  @override
  String get closePosition => 'Position schließen';

  @override
  String closePositionConfirm(int quantity, String stockCode) {
    return '$quantity Aktien von $stockCode schließen?';
  }

  @override
  String get cancel => 'Abbrechen';

  @override
  String get positionClosedSuccessfully => 'Position erfolgreich geschlossen';

  @override
  String get sl => 'SL';

  @override
  String get tp => 'TP';

  @override
  String get upload => 'Hochladen';

  @override
  String get uploadVideo => 'Video hochladen';

  @override
  String get uploadDescription =>
      'Aus der Galerie auswählen oder mit der Kamera aufnehmen';

  @override
  String get gallery => 'Galerie';

  @override
  String get camera => 'Kamera';

  @override
  String get inbox => 'Posteingang';

  @override
  String get activity => 'Aktivität';

  @override
  String get newLikes => 'Neue Likes';

  @override
  String get lastWeek => 'Letzte Woche';

  @override
  String get yesterday => 'Gestern';

  @override
  String get newFollowers => 'Neue Follower';

  @override
  String get newComments => 'Neue Kommentare';

  @override
  String hoursAgo(int hours) {
    return 'vor $hours Stunden';
  }

  @override
  String get messages => 'Nachrichten';

  @override
  String get search => 'Suchen';

  @override
  String get signals => 'Signale';

  @override
  String get discover => 'Entdecken';

  @override
  String get premium => 'Premium';
}

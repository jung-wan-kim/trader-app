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
  String get subscription => 'Abonnement';

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
  String get errorLoadingSubscription => 'Fehler beim Laden des Abonnements';

  @override
  String get active => 'Aktiv';

  @override
  String get inactive => 'Inaktiv';

  @override
  String autoRenewalOff(String date) {
    return 'Automatische Erneuerung ist aus. Ihr Plan läuft am $date ab';
  }

  @override
  String get availablePlans => 'Verfügbare Pläne';

  @override
  String get popular => 'BELIEBT';

  @override
  String savePercent(int percent) {
    return '$percent% sparen';
  }

  @override
  String get upgrade => 'Upgrade';

  @override
  String get downgrade => 'Herabstufen';

  @override
  String get billingHistory => 'Abrechnungshistorie';

  @override
  String get upgradePlan => 'Plan upgraden';

  @override
  String upgradePlanConfirm(String planName) {
    return 'Auf $planName upgraden?';
  }

  @override
  String get price => 'Preis';

  @override
  String upgradeSuccessful(String planName) {
    return 'Erfolgreich auf $planName upgegradet';
  }

  @override
  String get tierDescFree => 'Erste Schritte mit grundlegenden Funktionen';

  @override
  String get tierDescBasic => 'Für einzelne Trader';

  @override
  String get tierDescPro => 'Erweiterte Tools für ernsthafte Trader';

  @override
  String get tierDescPremium => 'Alles was Sie zum Erfolg brauchen';

  @override
  String get tierDescEnterprise => 'Individuelle Lösungen für Teams';

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

  @override
  String get planFeatureBasicRecommendations => 'Grundlegende Empfehlungen';

  @override
  String planFeatureLimitedPositions(int count) {
    return 'Begrenzt auf $count Positionen';
  }

  @override
  String get planFeatureCommunitySupport => 'Community-Support';

  @override
  String get planFeatureAllFreeFeatures => 'Alle kostenlosen Funktionen';

  @override
  String planFeatureUpToPositions(int count) {
    return 'Bis zu $count Positionen';
  }

  @override
  String get planFeatureEmailSupport => 'E-Mail-Support';

  @override
  String get planFeatureBasicAnalytics => 'Grundlegende Analysen';

  @override
  String get planFeatureAllBasicFeatures => 'Alle Basic-Funktionen';

  @override
  String get planFeatureRealtimeRecommendations => 'Echtzeit-Empfehlungen';

  @override
  String get planFeatureAdvancedAnalytics => 'Erweiterte Analysen';

  @override
  String get planFeaturePrioritySupport => 'Prioritäts-Support';

  @override
  String get planFeatureRiskManagementTools => 'Risikomanagement-Tools';

  @override
  String get planFeatureCustomAlerts => 'Benutzerdefinierte Alarme';

  @override
  String get planFeatureAllProFeatures => 'Alle Pro-Monatsfunktionen';

  @override
  String planFeatureMonthsFree(int count) {
    return '$count Monate kostenlos';
  }

  @override
  String get planFeatureAnnualReview => 'Jährliche Leistungsüberprüfung';

  @override
  String get planFeatureAllProFeaturesUnlimited => 'Alle Pro-Funktionen';

  @override
  String get planFeatureUnlimitedPositions => 'Unbegrenzte Positionen';

  @override
  String get planFeatureApiAccess => 'API-Zugang';

  @override
  String get planFeatureDedicatedManager => 'Persönlicher Account-Manager';

  @override
  String get planFeatureCustomStrategies => 'Individuelle Strategien';

  @override
  String get planFeatureWhiteLabelOptions => 'White-Label-Optionen';

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

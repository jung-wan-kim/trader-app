// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Spanish Castilian (`es`).
class AppLocalizationsEs extends AppLocalizations {
  AppLocalizationsEs([String locale = 'es']) : super(locale);

  @override
  String get appTitle => 'Trader App';

  @override
  String get appSubtitle => 'Recomendaciones de Acciones con IA';

  @override
  String get subscription => 'Suscripción';

  @override
  String get chooseLanguage => 'Elige tu idioma';

  @override
  String get selectLanguageDescription =>
      'Selecciona tu idioma preferido para la aplicación';

  @override
  String get continueButton => 'Continuar';

  @override
  String get onboardingTitle1 => 'Estrategias de Traders Legendarios';

  @override
  String get onboardingDesc1 =>
      'Utiliza estrategias de inversión probadas de los traders más exitosos de la historia como Jesse Livermore y William O\'Neil';

  @override
  String get onboardingTitle2 => 'Recomendaciones de Acciones con IA';

  @override
  String get onboardingDesc2 =>
      'Obtén recomendaciones óptimas de acciones que coincidan con las estrategias de traders legendarios a través de análisis de mercado avanzado con IA';

  @override
  String get onboardingTitle3 => 'Gestión de Riesgos';

  @override
  String get onboardingDesc3 =>
      'Logra inversiones seguras con calculadora de tamaño de posición y estrategias de stop-loss/take-profit';

  @override
  String get onboardingTitle4 => 'Análisis de Mercado en Tiempo Real';

  @override
  String get onboardingDesc4 =>
      'Comprende las tendencias del mercado y captura el momento óptimo con gráficos en tiempo real e indicadores técnicos';

  @override
  String get getStarted => 'Comenzar';

  @override
  String get next => 'Siguiente';

  @override
  String get skip => 'Omitir';

  @override
  String get email => 'Correo electrónico';

  @override
  String get password => 'Contraseña';

  @override
  String get login => 'Iniciar sesión';

  @override
  String get or => 'o';

  @override
  String get signInWithApple => 'Iniciar sesión con Apple';

  @override
  String get demoModeNotice =>
      'Modo Demo: Cuenta de prueba rellenada automáticamente';

  @override
  String get privacyPolicy => 'Política de Privacidad';

  @override
  String get termsOfService => 'Términos de Servicio';

  @override
  String get investmentWarning =>
      'Solo para referencia, no es consejo de inversión';

  @override
  String get profile => 'Perfil';

  @override
  String get trader => 'Trader';

  @override
  String get subscriptionManagement => 'Gestión de Suscripción';

  @override
  String subscribedPlan(String planName) {
    return '$planName Activo';
  }

  @override
  String daysRemaining(int days) {
    return '$days días restantes';
  }

  @override
  String get upgradeToPremiun => 'Actualizar a Premium';

  @override
  String get freePlan => 'Plan Gratuito';

  @override
  String get investmentPerformance => 'Rendimiento de Inversión';

  @override
  String get performanceDescription =>
      'Verificar retornos e historial de operaciones';

  @override
  String get watchlist => 'Lista de Seguimiento';

  @override
  String get watchlistDescription => 'Gestionar acciones guardadas';

  @override
  String get notificationSettings => 'Configuración de Notificaciones';

  @override
  String get notificationDescription =>
      'Gestionar recomendaciones y alertas de mercado';

  @override
  String get legalInformation => 'Información Legal';

  @override
  String get customerSupport => 'Soporte al Cliente';

  @override
  String get appInfo => 'Información de la app';

  @override
  String get versionInfo => 'Información de Versión';

  @override
  String get logout => 'Cerrar sesión';

  @override
  String get investmentWarningTitle => 'Advertencia de Riesgo de Inversión';

  @override
  String get investmentWarningText =>
      'Toda la información proporcionada en esta aplicación es solo para referencia y no constituye consejo de inversión. Todas las decisiones de inversión deben tomarse bajo su propio juicio y responsabilidad.';

  @override
  String get settings => 'Configuración';

  @override
  String get tradingSignals => 'Señales de Trading';

  @override
  String get realTimeRecommendations =>
      'Recomendaciones en tiempo real de traders profesionales';

  @override
  String get investmentReferenceNotice =>
      'Para referencia de inversión. Las decisiones de inversión son su responsabilidad.';

  @override
  String get currentPlan => 'Plan Actual';

  @override
  String get nextBilling => 'Próxima Facturación';

  @override
  String get amount => 'Cantidad';

  @override
  String get notScheduled => 'No programado';

  @override
  String get subscriptionInfo => 'Información de Suscripción';

  @override
  String get subscriptionTerms => 'Términos de Suscripción';

  @override
  String get subscriptionTermsText =>
      '• Las suscripciones se cargan a su cuenta de iTunes al confirmar la compra\\n• Las suscripciones se renuevan automáticamente a menos que la renovación automática se desactive al menos 24 horas antes del final del período actual\\n• Los cargos de renovación se realizan dentro de las 24 horas del final del período actual\\n• Las suscripciones se pueden gestionar en la configuración de su cuenta después de la compra\\n• Cualquier parte no utilizada del período de prueba gratuita se perderá al comprar una suscripción';

  @override
  String get dataDelayWarning =>
      'Los datos en tiempo real pueden retrasarse 15 minutos';

  @override
  String get dataSource => 'Datos proporcionados por Finnhub';

  @override
  String get poweredBy => 'Impulsado por Traders Legendarios';

  @override
  String get errorLoadingSubscription => 'Error al cargar la suscripción';

  @override
  String get active => 'Activo';

  @override
  String get inactive => 'Inactivo';

  @override
  String autoRenewalOff(String date) {
    return 'La renovación automática está desactivada. Su plan expirará el $date';
  }

  @override
  String get availablePlans => 'Planes Disponibles';

  @override
  String get popular => 'POPULAR';

  @override
  String savePercent(int percent) {
    return 'Ahorra $percent%';
  }

  @override
  String get upgrade => 'Actualizar';

  @override
  String get downgrade => 'Degradar';

  @override
  String get billingHistory => 'Historial de Facturación';

  @override
  String get upgradePlan => 'Actualizar Plan';

  @override
  String upgradePlanConfirm(String planName) {
    return '¿Actualizar a $planName?';
  }

  @override
  String get price => 'Precio';

  @override
  String upgradeSuccessful(String planName) {
    return 'Actualizado exitosamente a $planName';
  }

  @override
  String get tierDescFree => 'Comienza con funciones básicas';

  @override
  String get tierDescBasic => 'Para traders individuales';

  @override
  String get tierDescPro => 'Herramientas avanzadas para traders serios';

  @override
  String get tierDescPremium => 'Todo lo que necesitas para tener éxito';

  @override
  String get tierDescEnterprise => 'Soluciones personalizadas para equipos';

  @override
  String get errorLoadingRecommendations => 'Error al cargar recomendaciones';

  @override
  String get retry => 'Reintentar';

  @override
  String get allActions => 'Todas las acciones';

  @override
  String get buy => 'Comprar';

  @override
  String get sell => 'Vender';

  @override
  String get hold => 'Mantener';

  @override
  String get latest => 'Más reciente';

  @override
  String get confidence => 'Confianza';

  @override
  String get profitPotential => 'Potencial de beneficio';

  @override
  String get noRecommendationsFound => 'No se encontraron recomendaciones';

  @override
  String get portfolio => 'Portafolio';

  @override
  String get errorLoadingPositions => 'Error al cargar posiciones';

  @override
  String get today => 'hoy';

  @override
  String get winRate => 'Tasa de éxito';

  @override
  String get positions => 'Posiciones';

  @override
  String get dayPL => 'P&G del día';

  @override
  String get noOpenPositions => 'Sin posiciones abiertas';

  @override
  String get startTradingToSeePositions =>
      'Comienza a operar para ver tus posiciones';

  @override
  String get quantity => 'Cantidad';

  @override
  String get avgCost => 'Costo promedio';

  @override
  String get current => 'Actual';

  @override
  String get pl => 'P&G';

  @override
  String get close => 'Cerrar';

  @override
  String get edit => 'Editar';

  @override
  String get closePosition => 'Cerrar posición';

  @override
  String closePositionConfirm(int quantity, String stockCode) {
    return '¿Cerrar $quantity acciones de $stockCode?';
  }

  @override
  String get cancel => 'Cancelar';

  @override
  String get positionClosedSuccessfully => 'Posición cerrada exitosamente';

  @override
  String get sl => 'SL';

  @override
  String get tp => 'TP';

  @override
  String get upload => 'Subir';

  @override
  String get uploadVideo => 'Subir video';

  @override
  String get uploadDescription =>
      'Seleccionar de la galería o grabar con la cámara';

  @override
  String get gallery => 'Galería';

  @override
  String get camera => 'Cámara';

  @override
  String get inbox => 'Bandeja de entrada';

  @override
  String get activity => 'Actividad';

  @override
  String get newLikes => 'Nuevos me gusta';

  @override
  String get lastWeek => 'Semana pasada';

  @override
  String get yesterday => 'Ayer';

  @override
  String get newFollowers => 'Nuevos seguidores';

  @override
  String get newComments => 'Nuevos comentarios';

  @override
  String hoursAgo(int hours) {
    return 'hace $hours horas';
  }

  @override
  String get messages => 'Mensajes';

  @override
  String get search => 'Buscar';

  @override
  String get signals => 'Señales';

  @override
  String get discover => 'Descubrir';

  @override
  String get premium => 'Premium';

  @override
  String get planFeatureBasicRecommendations => 'Recomendaciones básicas';

  @override
  String planFeatureLimitedPositions(int count) {
    return 'Limitado a $count posiciones';
  }

  @override
  String get planFeatureCommunitySupport => 'Soporte de la comunidad';

  @override
  String get planFeatureAllFreeFeatures => 'Todas las funciones gratuitas';

  @override
  String planFeatureUpToPositions(int count) {
    return 'Hasta $count posiciones';
  }

  @override
  String get planFeatureEmailSupport => 'Soporte por correo electrónico';

  @override
  String get planFeatureBasicAnalytics => 'Análisis básicos';

  @override
  String get planFeatureAllBasicFeatures => 'Todas las funciones básicas';

  @override
  String get planFeatureRealtimeRecommendations =>
      'Recomendaciones en tiempo real';

  @override
  String get planFeatureAdvancedAnalytics => 'Análisis avanzados';

  @override
  String get planFeaturePrioritySupport => 'Soporte prioritario';

  @override
  String get planFeatureRiskManagementTools =>
      'Herramientas de gestión de riesgos';

  @override
  String get planFeatureCustomAlerts => 'Alertas personalizadas';

  @override
  String get planFeatureAllProFeatures => 'Todas las funciones Pro mensuales';

  @override
  String planFeatureMonthsFree(int count) {
    return '$count meses gratis';
  }

  @override
  String get planFeatureAnnualReview => 'Revisión anual de rendimiento';

  @override
  String get planFeatureAllProFeaturesUnlimited => 'Todas las funciones Pro';

  @override
  String get planFeatureUnlimitedPositions => 'Posiciones ilimitadas';

  @override
  String get planFeatureApiAccess => 'Acceso a API';

  @override
  String get planFeatureDedicatedManager => 'Gerente de cuenta dedicado';

  @override
  String get planFeatureCustomStrategies => 'Estrategias personalizadas';

  @override
  String get planFeatureWhiteLabelOptions => 'Opciones de marca blanca';

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

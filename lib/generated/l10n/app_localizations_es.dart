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
  String get signInWithGoogle => 'Iniciar sesión con Google';

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
  String get accountManagement => 'Gestión de Cuenta';

  @override
  String get cancelSubscription => 'Cancelar Suscripción';

  @override
  String get deleteAccount => 'Eliminar Cuenta';

  @override
  String get cancelSubscriptionTitle => 'Cancelar Suscripción';

  @override
  String get cancelSubscriptionMessage =>
      '¿Está seguro de que desea cancelar su suscripción? Continuará teniendo acceso hasta que termine su período de facturación actual.';

  @override
  String get cancelSubscriptionConfirm => 'Sí, Cancelar';

  @override
  String get deleteAccountTitle => 'Eliminar Cuenta';

  @override
  String get deleteAccountMessage =>
      '¿Está seguro de que desea eliminar su cuenta? Esta acción no se puede deshacer y todos sus datos serán eliminados permanentemente.';

  @override
  String get deleteAccountConfirm => 'Sí, Eliminar Cuenta';

  @override
  String get subscriptionCancelledSuccessfully =>
      'Suscripción cancelada exitosamente';

  @override
  String get accountDeletedSuccessfully => 'Cuenta eliminada exitosamente';

  @override
  String get languageSettings => 'Configuración de Idioma';

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
      '• Las suscripciones se cargan a su cuenta de iTunes al confirmar la compra\\\\n• Las suscripciones se renuevan automáticamente a menos que la renovación automática se desactive al menos 24 horas antes del final del período actual\\\\n• Los cargos de renovación se realizan dentro de las 24 horas del final del período actual\\\\n• Las suscripciones se pueden gestionar en la configuración de su cuenta después de la compra\\\\n• Cualquier parte no utilizada del período de prueba gratuita se perderá al comprar una suscripción';

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
  String get current => 'Actual';

  @override
  String get target => 'Target';

  @override
  String get potential => 'Potential';

  @override
  String get low => 'Low';

  @override
  String get medium => 'Medium';

  @override
  String get high => 'High';

  @override
  String get justNow => 'Just now';

  @override
  String minutesAgo(int minutes) {
    return '${minutes}m ago';
  }

  @override
  String hoursAgo(int hours) {
    return 'hace $hours horas';
  }

  @override
  String daysAgo(int days) {
    return '${days}d ago';
  }

  @override
  String get portfolio => 'Portafolio';

  @override
  String get errorLoadingPositions => 'Error al cargar posiciones';

  @override
  String get today => 'hoy';

  @override
  String get winRate => 'Tasa de Éxito';

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
  String get termsTitle => 'Términos de Servicio de Trader App';

  @override
  String get termsEffectiveDate => 'Fecha de vigencia: 21 de febrero de 2025';

  @override
  String get termsSection1Title => 'Artículo 1 (Propósito)';

  @override
  String get termsSection1Content =>
      'Estos términos están destinados a estipular los derechos, obligaciones y responsabilidades de la empresa y los usuarios con respecto al uso de servicios de aplicaciones móviles (en adelante denominados \"Servicios\") proporcionados por Trader App (en adelante denominada \"Empresa\").';

  @override
  String get termsSection2Title => 'Artículo 2 (Definiciones)';

  @override
  String get termsSection2Content =>
      '1. \"Servicio\" se refiere al servicio de recomendaciones de acciones basado en IA y información de inversión proporcionado por la Empresa.\n2. \"Usuario\" se refiere a miembros y no miembros que reciben servicios proporcionados por la Empresa bajo estos términos.\n3. \"Miembro\" se refiere a una persona que se ha registrado como miembro proporcionando información personal a la Empresa, recibe continuamente información de la Empresa y puede usar el Servicio continuamente.';

  @override
  String get termsSection3Title =>
      'Artículo 3 (Efectividad y Cambios en los Términos)';

  @override
  String get termsSection3Content =>
      '1. Estos términos entran en vigor al ser publicados en la pantalla del servicio o al notificar a los usuarios por otros medios.\n2. La Empresa puede cambiar estos términos cuando se considere necesario, y los términos modificados se anunciarán 7 días antes de la fecha de aplicación.';

  @override
  String get termsSection4Title => 'Artículo 4 (Provisión de Servicios)';

  @override
  String get termsSection4Content =>
      '1. La Empresa proporciona los siguientes servicios:\n   • Servicio de recomendaciones de acciones basado en IA\n   • Información de estrategias de traders legendarios\n   • Información de precios de acciones en tiempo real\n   • Herramientas de gestión de cartera\n   • Calculadora de riesgo\n\n2. Los servicios se proporcionan 24 horas al día, 365 días al año en principio. Sin embargo, pueden suspenderse temporalmente debido a mantenimiento del sistema.';

  @override
  String get termsFinancialDisclaimer =>
      'Toda la información proporcionada por este servicio es solo para referencia y no constituye asesoramiento de inversión o recomendaciones de inversión.\n\n• Todas las decisiones de inversión deben tomarse bajo su propio juicio y responsabilidad.\n• La inversión en acciones conlleva el riesgo de pérdida de capital.\n• Los rendimientos pasados no garantizan ganancias futuras.\n• La Empresa no asume responsabilidad por los resultados de inversión basados en la información proporcionada.';

  @override
  String get termsSection5Title => 'Artículo 5 (Registro de Membresía)';

  @override
  String get termsSection5Content =>
      '1. El registro de membresía se concluye cuando el usuario acepta el contenido de los términos y solicita el registro de membresía, y la Empresa aprueba dicha solicitud.\n2. La Empresa puede no aprobar o posteriormente terminar el contrato de uso para solicitudes que caigan bajo lo siguiente:\n   • Usar un nombre falso o el nombre de otra persona\n   • Proporcionar información falsa o no proporcionar información solicitada por la Empresa\n   • No cumplir con otros requisitos de solicitud';

  @override
  String get termsSection6Title => 'Artículo 6 (Obligaciones del Usuario)';

  @override
  String get termsSection6Content =>
      'Los usuarios no deben participar en las siguientes actividades:\n1. Robar información de otros\n2. Infringir los derechos de propiedad intelectual de la Empresa\n3. Interferir intencionalmente con las operaciones del servicio\n4. Otras actividades que violan las leyes y regulaciones pertinentes';

  @override
  String get termsSection7Title => 'Artículo 7 (Tarifas de Uso del Servicio)';

  @override
  String get termsSection7Content =>
      '1. Los servicios básicos se proporcionan de forma gratuita.\n2. Los servicios premium requieren el pago de tarifas de uso separadas.\n3. Las tarifas de uso para servicios pagos siguen la política de tarifas especificada dentro del servicio.\n4. La Empresa puede cambiar las tarifas de uso de servicios pagos y notificará 30 días antes de los cambios.';

  @override
  String get termsSection8Title => 'Artículo 8 (Exención de responsabilidad)';

  @override
  String get termsSection8Content =>
      '1. La Empresa está exenta de responsabilidad por proporcionar servicios cuando no puede proporcionar servicios debido a desastres naturales o fuerza mayor equivalente.\n2. La Empresa no es responsable de los obstáculos de uso del servicio debido a la culpa del usuario.\n3. Toda la información de inversión proporcionada por la Empresa es solo para referencia, y la responsabilidad por las decisiones de inversión recae completamente en el usuario.';

  @override
  String get termsSection9Title => 'Artículo 9 (Protección de Privacidad)';

  @override
  String get termsSection9Content =>
      'La Empresa establece y cumple con una política de privacidad para proteger la información personal de los usuarios. Para detalles, consulte la Política de Privacidad.';

  @override
  String get termsSection10Title => 'Artículo 10 (Resolución de Disputas)';

  @override
  String get termsSection10Content =>
      '1. Las disputas entre la Empresa y los usuarios deben resolverse mediante consulta mutua en principio.\n2. Si no se puede alcanzar una consulta, se resolverá en el tribunal competente según las leyes pertinentes.';

  @override
  String get termsSupplementary => 'Disposiciones Suplementarias';

  @override
  String get termsSupplementaryDate =>
      'Estos términos son efectivos desde el 21 de febrero de 2025.';

  @override
  String get privacyTitle => 'Política de Privacidad de Trader App';

  @override
  String get privacyEffectiveDate => 'Fecha de vigencia: 21 de febrero de 2025';

  @override
  String get privacySection1Title =>
      '1. Propósito de Recopilación y Uso de Información Personal';

  @override
  String get privacySection1Content =>
      'Trader App recopila información personal para los siguientes propósitos:\n• Registro y gestión de miembros\n• Proporcionar información de inversión personalizada\n• Mejora del servicio y desarrollo de nuevos servicios\n• Respuesta a consultas de clientes';

  @override
  String get privacySection2Title =>
      '2. Elementos de Información Personal Recopilados';

  @override
  String get privacySection2Content =>
      '• Elementos requeridos: Correo electrónico, contraseña\n• Elementos opcionales: Nombre, número de teléfono, intereses de inversión\n• Elementos recopilados automáticamente: Información del dispositivo, historial de uso de la aplicación, dirección IP';

  @override
  String get privacySection3Title =>
      '3. Período de Retención y Uso de Información Personal';

  @override
  String get privacySection3Content =>
      '• Hasta la retirada de la membresía\n• Sin embargo, retenida durante el período requerido si la preservación es necesaria según las leyes pertinentes\n• Registros de contrato o retirada de suscripción bajo la ley de comercio electrónico: 5 años\n• Registros de quejas de consumidores o manejo de disputas: 3 años';

  @override
  String get privacySection4Title =>
      '4. Provisión de Información Personal a Terceros';

  @override
  String get privacySection4Content =>
      'Trader App no proporciona información personal de los usuarios a terceros en principio.\nSin embargo, se hacen excepciones en los siguientes casos:\n• Cuando se obtiene el consentimiento del usuario\n• Cuando es requerido por leyes y regulaciones';

  @override
  String get privacySection5Title =>
      '5. Medidas de Protección de Información Personal';

  @override
  String get privacySection5Content =>
      '• Cifrado de información personal\n• Medidas técnicas contra hackeo\n• Limitación del acceso a información personal\n• Minimización y capacitación del personal que maneja información personal';

  @override
  String get privacySection6Title => '6. Derechos del Usuario';

  @override
  String get privacySection6Content =>
      'Los usuarios pueden ejercer los siguientes derechos en cualquier momento:\n• Solicitar ver información personal\n• Solicitar corregir o eliminar información personal\n• Solicitar detener el procesamiento de información personal\n• Solicitar transferir información personal';

  @override
  String get privacySection7Title =>
      '7. Oficial de Protección de Información Personal';

  @override
  String get privacySection7Content =>
      'Oficial de Protección de Información Personal: Hong Gil-dong\nCorreo electrónico: privacy@traderapp.com\nTeléfono: 02-1234-5678';

  @override
  String get privacySection8Title => '8. Cambios en la Política de Privacidad';

  @override
  String get privacySection8Content =>
      'Esta política de privacidad puede modificarse para reflejar cambios en las leyes y servicios.\nLos cambios se anunciarán a través de notificaciones en la aplicación.';

  @override
  String get totalPortfolioValue => 'Valor Total del Portafolio';

  @override
  String get portfolioPerformance30Days =>
      'Rendimiento del Portafolio (30 días)';

  @override
  String get performanceStatistics => 'Estadísticas de Rendimiento';

  @override
  String get avgReturn => 'Rendimiento Promedio';

  @override
  String get totalTrades => 'Total de Operaciones';

  @override
  String get bestTrade => 'Mejor Operación';

  @override
  String get recentTrades => 'Operaciones Recientes';

  @override
  String get monthlyReturns => 'Rendimientos Mensuales';

  @override
  String get jan => 'Ene';

  @override
  String get feb => 'Feb';

  @override
  String get mar => 'Mar';

  @override
  String get apr => 'Abr';

  @override
  String get may => 'May';

  @override
  String get jun => 'Jun';

  @override
  String get marketSummary => 'Resumen del Mercado';

  @override
  String get addStock => 'Agregar Acción';

  @override
  String get stocks => 'Acciones';

  @override
  String get searchStocks => 'Buscar acciones...';

  @override
  String get nothingInWatchlist => 'No hay acciones en tu lista';

  @override
  String get addStocksToWatchlist =>
      'Agrega acciones para seguir su rendimiento';

  @override
  String get remove => 'Eliminar';

  @override
  String get addToWatchlist => 'Agregar a Lista';

  @override
  String get stockAddedToWatchlist => 'Acción agregada a la lista';

  @override
  String get stockRemovedFromWatchlist => 'Acción eliminada de la lista';

  @override
  String get chooseTrader => 'Elige a Tu Maestro del Trading';

  @override
  String get performance => 'Rendimiento';

  @override
  String get keyStrategy => 'Estrategia Clave';

  @override
  String get selected => 'Seleccionado';

  @override
  String get continueWithSelection => 'Continuar con la Selección';
}

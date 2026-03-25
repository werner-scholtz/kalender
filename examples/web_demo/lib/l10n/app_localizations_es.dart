// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Spanish Castilian (`es`).
class AppLocalizationsEs extends AppLocalizations {
  AppLocalizationsEs([String locale = 'es']) : super(locale);

  @override
  String get appTitle => 'Kalender Demo Web';

  @override
  String get helloWorld => '¡Hola Mundo!';

  @override
  String get changeTheme => 'Cambiar tema';

  @override
  String get changeLocale => 'Cambiar idioma';

  @override
  String get changeTextDirection => 'Cambiar dirección del texto';

  @override
  String get singleCalendar => 'Vista de calendario único';

  @override
  String get multiCalendar => 'Vista de multi-calendario';

  @override
  String get newEvent => 'Nuevo evento';

  @override
  String get allowResizing => 'Permitir redimensionar';

  @override
  String get allowRescheduling => 'Permitir reprogramar';

  @override
  String get allowEventCreation => 'Permitir crear eventos';

  @override
  String get snapToOtherEvents => 'Ajustar a otros eventos';

  @override
  String get snapToTimeIndicator => 'Ajustar al indicador de tiempo';

  @override
  String get snapInterval => 'Intervalo de ajuste';

  @override
  String get snapRange => 'Rango de ajuste';

  @override
  String get firstDayOfWeek => 'Primer día de la semana';

  @override
  String minutesLabel(Object minutes) {
    return '$minutes minuto(s)';
  }

  @override
  String get bodyConfiguration => 'Configuración del cuerpo';

  @override
  String get showMultiDayEvents => 'Mostrar eventos de varios días';

  @override
  String get eventPaddingLR => 'Margen de eventos (ID)';

  @override
  String get minimumTileHeight => 'Altura mínima de mosaico';

  @override
  String get none => 'Ninguno';

  @override
  String get tileHeight => 'Altura de mosaico';

  @override
  String get eventPaddingLRTB => 'Margen de eventos (IDSA)';

  @override
  String get emptyDayBehavior => 'Comportamiento de día vacío';

  @override
  String get headerConfiguration => 'Configuración del encabezado';

  @override
  String get showHeader => 'Mostrar encabezado';

  @override
  String showHeaderForView(Object view) {
    return 'Mostrar encabezado para la vista $view';
  }

  @override
  String get showTiles => 'Mostrar mosaicos';

  @override
  String get maxNumberOfVerticalEvents => 'Máx. eventos verticales';

  @override
  String get unlimited => 'Ilimitado';

  @override
  String viewConfigurationTitle(Object name) {
    return 'Configuración de $name';
  }

  @override
  String get numberOfDays => 'Número de días';

  @override
  String get startTime => 'Hora de inicio';

  @override
  String get endTime => 'Hora de fin';

  @override
  String get noViewConfigurationOptions => 'No hay opciones de configuración disponibles para este tipo de vista.';

  @override
  String get title => 'Título';

  @override
  String get delete => 'Eliminar';

  @override
  String get preReleaseTitle => 'Ejemplo preliminar';

  @override
  String get preReleaseContent =>
      'Este es un ejemplo preliminar para v0.16.0 que aún no se ha publicado.\n\nConsulte la rama \'main-wip\' para ver el progreso.';

  @override
  String get gotIt => 'Entendido';

  @override
  String get preReleaseInfo => 'Info preliminar';

  @override
  String get language => 'Idioma';

  @override
  String get calendarLayout => 'Disposición del calendario';

  @override
  String get previous => 'Anterior';

  @override
  String get next => 'Siguiente';

  @override
  String get today => 'Hoy';

  @override
  String get viewType => 'Tipo de vista';

  @override
  String get timezone => 'Zona horaria';

  @override
  String get configuration => 'Configuración';

  @override
  String get start => 'Inicio';

  @override
  String get end => 'Fin';

  @override
  String get newEventTitle => 'Nuevo evento';

  @override
  String get hideConfiguration => 'Ocultar configuración';

  @override
  String get showConfiguration => 'Mostrar configuración';
}

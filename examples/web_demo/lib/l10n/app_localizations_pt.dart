// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Portuguese (`pt`).
class AppLocalizationsPt extends AppLocalizations {
  AppLocalizationsPt([String locale = 'pt']) : super(locale);

  @override
  String get appTitle => 'Kalender Demo Web';

  @override
  String get helloWorld => 'Olá Mundo!';

  @override
  String get changeTheme => 'Mudar tema';

  @override
  String get changeLocale => 'Mudar idioma';

  @override
  String get changeTextDirection => 'Mudar direção do texto';

  @override
  String get singleCalendar => 'Vista de calendário único';

  @override
  String get multiCalendar => 'Vista de multi-calendário';

  @override
  String get newEvent => 'Novo evento';

  @override
  String get allowResizing => 'Permitir redimensionamento';

  @override
  String get allowRescheduling => 'Permitir reagendamento';

  @override
  String get allowEventCreation => 'Permitir criação de eventos';

  @override
  String get snapToOtherEvents => 'Encaixar em outros eventos';

  @override
  String get snapToTimeIndicator => 'Encaixar no indicador de tempo';

  @override
  String get snapInterval => 'Intervalo de encaixe';

  @override
  String get snapRange => 'Alcance de encaixe';

  @override
  String get firstDayOfWeek => 'Primeiro dia da semana';

  @override
  String minutesLabel(Object minutes) {
    return '$minutes minuto(s)';
  }

  @override
  String get bodyConfiguration => 'Configuração do corpo';

  @override
  String get showMultiDayEvents => 'Mostrar eventos de vários dias';

  @override
  String get eventPaddingLR => 'Margem dos eventos (ED)';

  @override
  String get minimumTileHeight => 'Altura mínima do bloco';

  @override
  String get none => 'Nenhum';

  @override
  String get tileHeight => 'Altura do bloco';

  @override
  String get eventPaddingLRTB => 'Margem dos eventos (EDCB)';

  @override
  String get emptyDayBehavior => 'Comportamento de dia vazio';

  @override
  String get headerConfiguration => 'Configuração do cabeçalho';

  @override
  String get showHeader => 'Mostrar cabeçalho';

  @override
  String showHeaderForView(Object view) {
    return 'Mostrar cabeçalho para a vista $view';
  }

  @override
  String get showTiles => 'Mostrar blocos';

  @override
  String get maxNumberOfVerticalEvents => 'Máx. eventos verticais';

  @override
  String get unlimited => 'Ilimitado';

  @override
  String viewConfigurationTitle(Object name) {
    return 'Configuração de $name';
  }

  @override
  String get numberOfDays => 'Número de dias';

  @override
  String get startTime => 'Hora de início';

  @override
  String get endTime => 'Hora de fim';

  @override
  String get noViewConfigurationOptions => 'Nenhuma opção de configuração disponível para este tipo de vista.';

  @override
  String get title => 'Título';

  @override
  String get delete => 'Eliminar';

  @override
  String get preReleaseTitle => 'Exemplo pré-lançamento';

  @override
  String get preReleaseContent =>
      'Este é um exemplo pré-lançamento para v0.16.0 que ainda não foi publicado.\n\nVeja a branch \'main-wip\' para o progresso.';

  @override
  String get gotIt => 'Entendido';

  @override
  String get preReleaseInfo => 'Info pré-lançamento';

  @override
  String get language => 'Idioma';

  @override
  String get calendarLayout => 'Layout do calendário';

  @override
  String get previous => 'Anterior';

  @override
  String get next => 'Seguinte';

  @override
  String get today => 'Hoje';

  @override
  String get viewType => 'Tipo de vista';

  @override
  String get timezone => 'Fuso horário';

  @override
  String get configuration => 'Configuração';

  @override
  String get start => 'Início';

  @override
  String get end => 'Fim';

  @override
  String get newEventTitle => 'Novo evento';

  @override
  String get hideConfiguration => 'Ocultar configuração';

  @override
  String get showConfiguration => 'Mostrar configuração';

  @override
  String get tileLayout => 'Layout de blocos';
}

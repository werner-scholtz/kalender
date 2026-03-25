// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Italian (`it`).
class AppLocalizationsIt extends AppLocalizations {
  AppLocalizationsIt([String locale = 'it']) : super(locale);

  @override
  String get appTitle => 'Kalender Demo Web';

  @override
  String get helloWorld => 'Ciao Mondo!';

  @override
  String get changeTheme => 'Cambia tema';

  @override
  String get changeLocale => 'Cambia lingua';

  @override
  String get changeTextDirection => 'Cambia direzione del testo';

  @override
  String get singleCalendar => 'Vista calendario singolo';

  @override
  String get multiCalendar => 'Vista multi-calendario';

  @override
  String get newEvent => 'Nuovo evento';

  @override
  String get allowResizing => 'Consenti ridimensionamento';

  @override
  String get allowRescheduling => 'Consenti ripianificazione';

  @override
  String get allowEventCreation => 'Consenti creazione eventi';

  @override
  String get snapToOtherEvents => 'Aggancia ad altri eventi';

  @override
  String get snapToTimeIndicator => 'Aggancia all\'indicatore di tempo';

  @override
  String get snapInterval => 'Intervallo di aggancio';

  @override
  String get snapRange => 'Raggio di aggancio';

  @override
  String get firstDayOfWeek => 'Primo giorno della settimana';

  @override
  String minutesLabel(Object minutes) {
    return '$minutes minuto/i';
  }

  @override
  String get bodyConfiguration => 'Configurazione del corpo';

  @override
  String get showMultiDayEvents => 'Mostra eventi multi-giorno';

  @override
  String get eventPaddingLR => 'Margine eventi (SD)';

  @override
  String get minimumTileHeight => 'Altezza minima riquadro';

  @override
  String get none => 'Nessuno';

  @override
  String get tileHeight => 'Altezza riquadro';

  @override
  String get eventPaddingLRTB => 'Margine eventi (SDAB)';

  @override
  String get emptyDayBehavior => 'Comportamento giorno vuoto';

  @override
  String get headerConfiguration => 'Configurazione intestazione';

  @override
  String get showHeader => 'Mostra intestazione';

  @override
  String showHeaderForView(Object view) {
    return 'Mostra intestazione per la vista $view';
  }

  @override
  String get showTiles => 'Mostra riquadri';

  @override
  String get maxNumberOfVerticalEvents => 'Max eventi verticali';

  @override
  String get unlimited => 'Illimitato';

  @override
  String viewConfigurationTitle(Object name) {
    return 'Configurazione $name';
  }

  @override
  String get numberOfDays => 'Numero di giorni';

  @override
  String get startTime => 'Ora di inizio';

  @override
  String get endTime => 'Ora di fine';

  @override
  String get noViewConfigurationOptions => 'Nessuna opzione di configurazione disponibile per questo tipo di vista.';

  @override
  String get title => 'Titolo';

  @override
  String get delete => 'Elimina';
}

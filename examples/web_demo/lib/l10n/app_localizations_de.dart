// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for German (`de`).
class AppLocalizationsDe extends AppLocalizations {
  AppLocalizationsDe([String locale = 'de']) : super(locale);

  @override
  String get appTitle => 'Kalender Web-Demo';

  @override
  String get helloWorld => 'Hallo Welt!';

  @override
  String get changeTheme => 'Thema ändern';

  @override
  String get changeLocale => 'Sprache ändern';

  @override
  String get changeTextDirection => 'Textrichtung ändern';

  @override
  String get singleCalendar => 'Einzelkalenderansicht';

  @override
  String get multiCalendar => 'Multikalenderansicht';

  @override
  String get newEvent => 'Neues Ereignis';

  @override
  String get allowResizing => 'Größenänderung erlauben';

  @override
  String get allowRescheduling => 'Umplanung erlauben';

  @override
  String get allowEventCreation => 'Ereigniserstellung erlauben';

  @override
  String get snapToOtherEvents => 'An anderen Ereignissen einrasten';

  @override
  String get snapToTimeIndicator => 'Am Zeitindikator einrasten';

  @override
  String get snapInterval => 'Einrastintervall';

  @override
  String get snapRange => 'Einrastbereich';

  @override
  String get firstDayOfWeek => 'Erster Wochentag';

  @override
  String minutesLabel(Object minutes) {
    return '$minutes Minute(n)';
  }

  @override
  String get bodyConfiguration => 'Körperkonfiguration';

  @override
  String get showMultiDayEvents => 'Mehrtägige Ereignisse anzeigen';

  @override
  String get eventPaddingLR => 'Ereignisabstand (LR)';

  @override
  String get minimumTileHeight => 'Minimale Kachelhöhe';

  @override
  String get none => 'Keine';

  @override
  String get tileHeight => 'Kachelhöhe';

  @override
  String get eventPaddingLRTB => 'Ereignisabstand (LROU)';

  @override
  String get emptyDayBehavior => 'Verhalten bei leerem Tag';

  @override
  String get headerConfiguration => 'Kopfzeilenkonfiguration';

  @override
  String get showHeader => 'Kopfzeile anzeigen';

  @override
  String showHeaderForView(Object view) {
    return 'Kopfzeile für $view-Ansicht anzeigen';
  }

  @override
  String get showTiles => 'Kacheln anzeigen';

  @override
  String get maxNumberOfVerticalEvents => 'Max. vertikale Ereignisse';

  @override
  String get unlimited => 'Unbegrenzt';

  @override
  String viewConfigurationTitle(Object name) {
    return '$name-Konfiguration';
  }

  @override
  String get numberOfDays => 'Anzahl der Tage';

  @override
  String get startTime => 'Startzeit';

  @override
  String get endTime => 'Endzeit';

  @override
  String get noViewConfigurationOptions => 'Für diesen Ansichtstyp sind keine Konfigurationsoptionen verfügbar.';

  @override
  String get title => 'Titel';

  @override
  String get delete => 'Löschen';

  @override
  String get preReleaseTitle => 'Vorab-Beispiel';

  @override
  String get preReleaseContent =>
      'Dies ist ein Vorab-Beispiel für v0.16.0, das noch nicht veröffentlicht wurde.\n\nSiehe den \'main-wip\'-Branch für den Fortschritt.';

  @override
  String get gotIt => 'Verstanden';

  @override
  String get preReleaseInfo => 'Vorab-Info';

  @override
  String get language => 'Sprache';

  @override
  String get calendarLayout => 'Kalenderansicht';

  @override
  String get previous => 'Zurück';

  @override
  String get next => 'Weiter';

  @override
  String get today => 'Heute';

  @override
  String get viewType => 'Ansichtstyp';

  @override
  String get timezone => 'Zeitzone';

  @override
  String get configuration => 'Konfiguration';

  @override
  String get start => 'Beginn';

  @override
  String get end => 'Ende';

  @override
  String get newEventTitle => 'Neues Ereignis';

  @override
  String get hideConfiguration => 'Konfiguration ausblenden';

  @override
  String get showConfiguration => 'Konfiguration anzeigen';

  @override
  String get tileLayout => 'Kachel-Layout';
}

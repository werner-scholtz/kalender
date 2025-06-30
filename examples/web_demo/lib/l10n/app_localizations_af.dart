// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Afrikaans (`af`).
class AppLocalizationsAf extends AppLocalizations {
  AppLocalizationsAf([String locale = 'af']) : super(locale);

  @override
  String get appTitle => 'Kalender Web Demo';

  @override
  String get helloWorld => 'Hallo Wêreld!';

  @override
  String get changeTheme => 'Verander tema';

  @override
  String get changeLocale => 'Verander taal';

  @override
  String get changeTextDirection => 'Verander teksrigting';

  @override
  String get singleCalendar => 'Enkel Kalender Uitsig';

  @override
  String get multiCalendar => 'Multi Kalender Uitsig';

  @override
  String get newEvent => 'Nuwe item';

  @override
  String get allowResizing => 'Laat Grootte Verander';

  @override
  String get allowRescheduling => 'Laat Herskedulering Toe';

  @override
  String get allowEventCreation => 'Laat Gebeurtenis Skep Toe';

  @override
  String get snapToOtherEvents => 'Snaps na ander gebeurtenisse';

  @override
  String get snapToTimeIndicator => 'Snaps na tyd-aanwyser';

  @override
  String get snapInterval => 'Snap-interval';

  @override
  String get snapRange => 'Snap-bereik';

  @override
  String get firstDayOfWeek => 'Eerste dag van die week';

  @override
  String minutesLabel(Object minutes) {
    return '$minutes minuut(e)';
  }

  @override
  String get bodyConfiguration => 'Liggaam Konfigurasie';

  @override
  String get showMultiDayEvents => 'Wys multi-dag gebeurtenisse';

  @override
  String get eventPaddingLR => 'Gebeurtenis Rand (LR)';

  @override
  String get minimumTileHeight => 'Minimum teël hoogte';

  @override
  String get none => 'Geen';

  @override
  String get tileHeight => 'Teël Hoogte';

  @override
  String get eventPaddingLRTB => 'Gebeurtenis Rand (LRTB)';

  @override
  String get emptyDayBehavior => 'Leë Dag Gedrag';

  @override
  String get headerConfiguration => 'Kopkonfigurasie';

  @override
  String get showHeader => 'Wys Kop';

  @override
  String showHeaderForView(Object view) {
    return 'Wys kop vir $view aansig';
  }

  @override
  String get showTiles => 'Wys Teëls';

  @override
  String get maxNumberOfVerticalEvents => 'Maksimum aantal vertikale gebeurtenisse';

  @override
  String get unlimited => 'Onbeperk';

  @override
  String viewConfigurationTitle(Object name) {
    return '$name Konfigurasie';
  }

  @override
  String get numberOfDays => 'Aantal dae';

  @override
  String get startTime => 'Begintyd';

  @override
  String get endTime => 'Eindtyd';

  @override
  String get noViewConfigurationOptions => 'Geen konfigurasie-opsies beskikbaar vir hierdie aansig nie.';

  @override
  String get title => 'Titel';

  @override
  String get delete => 'Verwyder';
}

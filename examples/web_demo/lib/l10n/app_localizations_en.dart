// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get appTitle => 'Kalender Web Demo';

  @override
  String get helloWorld => 'Hello World!';

  @override
  String get changeTheme => 'Change theme';

  @override
  String get changeLocale => 'Change language';

  @override
  String get changeTextDirection => 'Change text direction';

  @override
  String get singleCalendar => 'Single Calendar View';

  @override
  String get multiCalendar => 'Multi Calendar View';

  @override
  String get newEvent => 'New event';

  @override
  String get allowResizing => 'Allow Resizing';

  @override
  String get allowRescheduling => 'Allow Rescheduling';

  @override
  String get allowEventCreation => 'Allow Event Creation';

  @override
  String get snapToOtherEvents => 'Snap to other events';

  @override
  String get snapToTimeIndicator => 'Snap to time indicator';

  @override
  String get snapInterval => 'Snap interval';

  @override
  String get snapRange => 'Snap range';

  @override
  String get firstDayOfWeek => 'First day of week';

  @override
  String minutesLabel(Object minutes) {
    return '$minutes minute(s)';
  }

  @override
  String get bodyConfiguration => 'Body Configuration';

  @override
  String get showMultiDayEvents => 'Show multi day events';

  @override
  String get eventPaddingLR => 'Event Padding (LR)';

  @override
  String get minimumTileHeight => 'Minimum tile height';

  @override
  String get none => 'None';

  @override
  String get tileHeight => 'Tile Height';

  @override
  String get eventPaddingLRTB => 'Event Padding (LRTB)';

  @override
  String get emptyDayBehavior => 'Empty Day Behavior';

  @override
  String get headerConfiguration => 'Header Configuration';

  @override
  String get showHeader => 'Show Header';

  @override
  String showHeaderForView(Object view) {
    return 'Show header for $view view';
  }

  @override
  String get showTiles => 'Show Tiles';

  @override
  String get maxNumberOfVerticalEvents => 'Max number of vertical events';

  @override
  String get unlimited => 'Unlimited';

  @override
  String viewConfigurationTitle(Object name) {
    return '$name Configuration';
  }

  @override
  String get numberOfDays => 'Number of days';

  @override
  String get startTime => 'Start Time';

  @override
  String get endTime => 'End Time';

  @override
  String get noViewConfigurationOptions => 'No view configuration options available for this view type.';

  @override
  String get title => 'Title';

  @override
  String get delete => 'Delete';
}

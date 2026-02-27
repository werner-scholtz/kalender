import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:kalender/kalender.dart';

class CalendarConfiguration extends ChangeNotifier {
  /// The view configuration of the calendar.
  late final viewConfigurationNotifier = ValueNotifier(viewConfigurations[1]);
  ViewConfiguration get viewConfiguration => viewConfigurationNotifier.value;
  set viewConfiguration(ViewConfiguration value) {
    if (viewConfigurationNotifier.value == value) return;
    viewConfigurationNotifier.value = value;
    notifyListeners();
  }

  /// The display range of the calendar.
  final _displayRange = DateTimeRange(
    start: DateTime(2018),
    end: DateTime(DateTime.now().year + 10),
  );

  /// The available view configurations of the calendar.
  late final viewConfigurations = [
    MultiDayViewConfiguration.singleDay(displayRange: _displayRange),
    MultiDayViewConfiguration.week(displayRange: _displayRange),
    MultiDayViewConfiguration.workWeek(displayRange: _displayRange),
    MultiDayViewConfiguration.custom(numberOfDays: 3, name: "Custom 3 Days", displayRange: _displayRange),
    MonthViewConfiguration.singleMonth(displayRange: _displayRange),
    ScheduleViewConfiguration.continuous(name: "Schedule", displayRange: _displayRange),
    ScheduleViewConfiguration.paginated(name: "Paginated Schedule", displayRange: _displayRange),
    MultiDayViewConfiguration.freeScroll(numberOfDays: 3, name: "FreeScroll (WIP)", displayRange: _displayRange),
  ];

  /// The body configuration of the calendar.
  final multiDayBodyConfigurationNotifier = ValueNotifier(const MultiDayBodyConfiguration());
  MultiDayBodyConfiguration get multiDayBodyConfiguration => multiDayBodyConfigurationNotifier.value;
  set multiDayBodyConfiguration(MultiDayBodyConfiguration value) {
    if (multiDayBodyConfigurationNotifier.value == value) return;
    multiDayBodyConfigurationNotifier.value = value;
    notifyListeners();
  }

  /// The header configuration of the calendar.
  final multiDayHeaderConfigurationNotifier = ValueNotifier(const MultiDayHeaderConfiguration());
  MultiDayHeaderConfiguration get multiDayHeaderConfiguration => multiDayHeaderConfigurationNotifier.value;
  set multiDayHeaderConfiguration(MultiDayHeaderConfiguration value) {
    if (multiDayHeaderConfigurationNotifier.value == value) return;
    multiDayHeaderConfigurationNotifier.value = value;
    notifyListeners();
  }

  /// The month body configuration of the calendar.
  final monthBodyConfigurationNotifier = ValueNotifier(MonthBodyConfiguration());
  MonthBodyConfiguration get monthBodyConfiguration => monthBodyConfigurationNotifier.value;
  set monthBodyConfiguration(MonthBodyConfiguration value) {
    if (monthBodyConfigurationNotifier.value == value) return;
    monthBodyConfigurationNotifier.value = value;
    notifyListeners();
  }

  final scheduleBodyConfigurationNotifier = ValueNotifier(ScheduleBodyConfiguration());
  ScheduleBodyConfiguration get scheduleBodyConfiguration => scheduleBodyConfigurationNotifier.value;
  set scheduleBodyConfiguration(ScheduleBodyConfiguration value) {
    if (scheduleBodyConfigurationNotifier.value == value) return;
    scheduleBodyConfigurationNotifier.value = value;
    notifyListeners();
  }

  /// The header interaction of the calendar.
  late final ValueNotifier<CalendarInteraction> interactionHeader = ValueNotifier(CalendarInteraction(
    createEventGesture: isMobile ? CreateEventGesture.longPress : CreateEventGesture.tap,
  ));

  /// The body interaction of the calendar.
  late final ValueNotifier<CalendarInteraction> interactionBody = ValueNotifier(CalendarInteraction(
    createEventGesture: isMobile ? CreateEventGesture.longPress : CreateEventGesture.tap,
  ));

  /// The snapping configuration of the calendar.
  final ValueNotifier<CalendarSnapping> snapping = ValueNotifier(const CalendarSnapping());

  /// Whether to show the header of the calendar.
  ValueNotifier<bool> showHeaderNotifier = ValueNotifier(true);
  bool get showHeader => showHeaderNotifier.value;
  set showHeader(bool value) {
    if (showHeaderNotifier.value == value) return;
    showHeaderNotifier.value = value;
    notifyListeners();
  }

  bool get isMobile => defaultTargetPlatform == TargetPlatform.iOS || defaultTargetPlatform == TargetPlatform.android;

  @override
  operator ==(Object other) {
    if (identical(this, other)) return true;
    if (other is! CalendarConfiguration) return false;
    return viewConfiguration == other.viewConfiguration &&
        multiDayBodyConfiguration == other.multiDayBodyConfiguration &&
        multiDayHeaderConfiguration == other.multiDayHeaderConfiguration &&
        monthBodyConfiguration == other.monthBodyConfiguration &&
        interactionHeader == other.interactionHeader &&
        interactionBody == other.interactionBody &&
        snapping == other.snapping &&
        showHeader == other.showHeader;
  }

  @override
  int get hashCode => Object.hash(
        viewConfiguration,
        multiDayBodyConfiguration,
        multiDayHeaderConfiguration,
        monthBodyConfiguration,
        interactionHeader,
        interactionBody,
        snapping,
        showHeader,
      );
}

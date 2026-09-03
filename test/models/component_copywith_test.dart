import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:kalender/kalender.dart';

/// Every components class has to survive a `copyWith`, and every field on it has
/// to be reachable through one.
///
/// A `copyWith` that silently drops a field is a no-op with no error, which the
/// package has shipped twice: `MonthBodyConfiguration.copyWith` dropped
/// `eventPadding` (#252) and `PageTriggerConfiguration.copyWith` dropped
/// `triggerWidth` (#302). These classes had no test at all.
///
/// Two checks cover it, without naming each field twice:
///   * `copyWith()` with no arguments returns an equal instance, so no field is
///     dropped on the way through.
///   * setting each field on an empty instance breaks equality, so every field
///     is applied, and reaches `==` and `hashCode`.
///
/// What this does not catch is a `copyWith` that sets a second field of the same
/// type as a side effect, since the copy still differs from the empty instance.
/// The analyzer catches the version of that where the types differ.
void main() {
  /// Asserts [full] survives a no-argument copy, and that each mutation in
  /// [mutations] changes [empty].
  void checkClass<T extends Object>(
    String name, {
    required T full,
    required T empty,
    required T Function() copyWithNothing,
    required Map<String, T Function()> mutations,
  }) {
    group(name, () {
      test('a copy with no arguments keeps every field', () {
        expect(copyWithNothing(), equals(full), reason: 'copyWith() dropped a field');
        expect(copyWithNothing().hashCode, equals(full.hashCode));
      });

      test('a fully populated instance differs from an empty one', () {
        expect(full, isNot(equals(empty)));
        expect(full.hashCode, isNot(equals(empty.hashCode)));
      });

      for (final entry in mutations.entries) {
        test('copyWith applies ${entry.key}', () {
          final copy = entry.value();
          expect(copy, isNot(equals(empty)), reason: '${entry.key} is missing from copyWith or from ==');
          expect(copy.hashCode, isNot(equals(empty.hashCode)), reason: '${entry.key} is missing from hashCode');
        });
      }
    });
  }

  const overlayBuilders = OverlayBuilders(
    multiDayOverlayBuilder: _overlay,
    multiDayOverlayPortalBuilder: _overlayPortal,
    multiDayPortalOverlayButtonBuilder: _overlayButton,
    multiDayPortalOverlayButtonStringBuilder: _hiddenCount,
  );

  const monthBody = MonthBodyComponents(
    monthGridBuilder: _grid,
    monthDayHeaderBuilder: _dateWidget,
    monthDayHeaderStringBuilder: _dateString,
    monthDayCellBuilder: _dayCell,
    weekNumberBuilder: _weekNumber,
    leftTriggerBuilder: _horizontalTrigger,
    rightTriggerBuilder: _horizontalTrigger,
    overlayBuilders: overlayBuilders,
  );

  const monthHeader = MonthHeaderComponents(
    weekDayHeaderBuilder: _dateWidget,
    weekDayHeaderStringBuilder: _dateString,
  );

  const multiDayHeader = MultiDayHeaderComponents(
    dayHeaderBuilder: _dateWidget,
    dayHeaderStringBuilder: _dateString,
    dayHeaderNumberStringBuilder: _dateString,
    weekNumberBuilder: _weekNumber,
    leftTriggerBuilder: _horizontalTrigger,
    rightTriggerBuilder: _horizontalTrigger,
    overlayBuilders: overlayBuilders,
  );

  const multiDayBody = MultiDayBodyComponents(
    hourLines: _hourLines,
    timeline: _timeline,
    timelineStringBuilder: _timeString,
    timelineWidth: _timelineWidth,
    daySeparator: _daySeparator,
    timeIndicator: _timeIndicator,
    leftTriggerBuilder: _horizontalTrigger,
    rightTriggerBuilder: _horizontalTrigger,
    topTriggerBuilder: _verticalTrigger,
    bottomTriggerBuilder: _verticalTrigger,
  );

  const schedule = ScheduleComponents(
    leadingDateBuilder: _scheduleDate,
    leadingDateStringBuilder: _dateString,
    scheduleTileHighlightBuilder: _tileHighlight,
    emptyItemBuilder: _rangeWidget,
    monthItemBuilder: _rangeWidget,
  );

  const month = MonthComponents(bodyComponents: monthBody, headerComponents: monthHeader);
  const multiDay = MultiDayComponents(headerComponents: multiDayHeader, bodyComponents: multiDayBody);

  const calendar = CalendarComponents(
    monthComponents: month,
    multiDayComponents: multiDay,
    scheduleComponents: schedule,
    overlayBuilders: overlayBuilders,
  );

  checkClass(
    'OverlayBuilders',
    full: overlayBuilders,
    empty: const OverlayBuilders(),
    copyWithNothing: overlayBuilders.copyWith,
    mutations: {
      'multiDayOverlayBuilder': () => const OverlayBuilders().copyWith(multiDayOverlayBuilder: _overlay),
      'multiDayOverlayPortalBuilder': () =>
          const OverlayBuilders().copyWith(multiDayOverlayPortalBuilder: _overlayPortal),
      'multiDayPortalOverlayButtonBuilder': () =>
          const OverlayBuilders().copyWith(multiDayPortalOverlayButtonBuilder: _overlayButton),
      'multiDayPortalOverlayButtonStringBuilder': () =>
          const OverlayBuilders().copyWith(multiDayPortalOverlayButtonStringBuilder: _hiddenCount),
    },
  );

  checkClass(
    'MonthBodyComponents',
    full: monthBody,
    empty: const MonthBodyComponents(),
    copyWithNothing: monthBody.copyWith,
    mutations: {
      'monthGridBuilder': () => const MonthBodyComponents().copyWith(monthGridBuilder: _grid),
      'monthDayHeaderBuilder': () => const MonthBodyComponents().copyWith(monthDayHeaderBuilder: _dateWidget),
      'monthDayHeaderStringBuilder': () =>
          const MonthBodyComponents().copyWith(monthDayHeaderStringBuilder: _dateString),
      'monthDayCellBuilder': () => const MonthBodyComponents().copyWith(monthDayCellBuilder: _dayCell),
      'weekNumberBuilder': () => const MonthBodyComponents().copyWith(weekNumberBuilder: _weekNumber),
      'leftTriggerBuilder': () => const MonthBodyComponents().copyWith(leftTriggerBuilder: _horizontalTrigger),
      'rightTriggerBuilder': () => const MonthBodyComponents().copyWith(rightTriggerBuilder: _horizontalTrigger),
      'overlayBuilders': () => const MonthBodyComponents().copyWith(overlayBuilders: overlayBuilders),
    },
  );

  checkClass(
    'MonthHeaderComponents',
    full: monthHeader,
    empty: const MonthHeaderComponents(),
    copyWithNothing: monthHeader.copyWith,
    mutations: {
      'weekDayHeaderBuilder': () => const MonthHeaderComponents().copyWith(weekDayHeaderBuilder: _dateWidget),
      'weekDayHeaderStringBuilder': () =>
          const MonthHeaderComponents().copyWith(weekDayHeaderStringBuilder: _dateString),
    },
  );

  checkClass(
    'MonthComponents',
    full: month,
    empty: const MonthComponents(),
    copyWithNothing: month.copyWith,
    mutations: {
      'bodyComponents': () => const MonthComponents().copyWith(bodyComponents: monthBody),
      'headerComponents': () => const MonthComponents().copyWith(headerComponents: monthHeader),
    },
  );

  checkClass(
    'MultiDayHeaderComponents',
    full: multiDayHeader,
    empty: const MultiDayHeaderComponents(),
    copyWithNothing: multiDayHeader.copyWith,
    mutations: {
      'dayHeaderBuilder': () => const MultiDayHeaderComponents().copyWith(dayHeaderBuilder: _dateWidget),
      'dayHeaderStringBuilder': () => const MultiDayHeaderComponents().copyWith(dayHeaderStringBuilder: _dateString),
      'dayHeaderNumberStringBuilder': () =>
          const MultiDayHeaderComponents().copyWith(dayHeaderNumberStringBuilder: _dateString),
      'weekNumberBuilder': () => const MultiDayHeaderComponents().copyWith(weekNumberBuilder: _weekNumber),
      'leftTriggerBuilder': () => const MultiDayHeaderComponents().copyWith(leftTriggerBuilder: _horizontalTrigger),
      'rightTriggerBuilder': () => const MultiDayHeaderComponents().copyWith(rightTriggerBuilder: _horizontalTrigger),
      'overlayBuilders': () => const MultiDayHeaderComponents().copyWith(overlayBuilders: overlayBuilders),
    },
  );

  checkClass(
    'MultiDayBodyComponents',
    full: multiDayBody,
    empty: const MultiDayBodyComponents(),
    copyWithNothing: multiDayBody.copyWith,
    mutations: {
      'hourLines': () => const MultiDayBodyComponents().copyWith(hourLines: _hourLines),
      'timeline': () => const MultiDayBodyComponents().copyWith(timeline: _timeline),
      'timelineStringBuilder': () => const MultiDayBodyComponents().copyWith(timelineStringBuilder: _timeString),
      'timelineWidth': () => const MultiDayBodyComponents().copyWith(timelineWidth: _timelineWidth),
      'daySeparator': () => const MultiDayBodyComponents().copyWith(daySeparator: _daySeparator),
      'timeIndicator': () => const MultiDayBodyComponents().copyWith(timeIndicator: _timeIndicator),
      'leftTriggerBuilder': () => const MultiDayBodyComponents().copyWith(leftTriggerBuilder: _horizontalTrigger),
      'rightTriggerBuilder': () => const MultiDayBodyComponents().copyWith(rightTriggerBuilder: _horizontalTrigger),
      'topTriggerBuilder': () => const MultiDayBodyComponents().copyWith(topTriggerBuilder: _verticalTrigger),
      'bottomTriggerBuilder': () => const MultiDayBodyComponents().copyWith(bottomTriggerBuilder: _verticalTrigger),
    },
  );

  checkClass(
    'MultiDayComponents',
    full: multiDay,
    empty: const MultiDayComponents(),
    copyWithNothing: multiDay.copyWith,
    mutations: {
      'headerComponents': () => const MultiDayComponents().copyWith(headerComponents: multiDayHeader),
      'bodyComponents': () => const MultiDayComponents().copyWith(bodyComponents: multiDayBody),
    },
  );

  checkClass(
    'ScheduleComponents',
    full: schedule,
    empty: const ScheduleComponents(),
    copyWithNothing: schedule.copyWith,
    mutations: {
      'leadingDateBuilder': () => const ScheduleComponents().copyWith(leadingDateBuilder: _scheduleDate),
      'leadingDateStringBuilder': () => const ScheduleComponents().copyWith(leadingDateStringBuilder: _dateString),
      'scheduleTileHighlightBuilder': () =>
          const ScheduleComponents().copyWith(scheduleTileHighlightBuilder: _tileHighlight),
      'emptyItemBuilder': () => const ScheduleComponents().copyWith(emptyItemBuilder: _rangeWidget),
      'monthItemBuilder': () => const ScheduleComponents().copyWith(monthItemBuilder: _rangeWidget),
    },
  );

  checkClass(
    'CalendarComponents',
    full: calendar,
    empty: const CalendarComponents(),
    copyWithNothing: calendar.copyWith,
    mutations: {
      'monthComponents': () => const CalendarComponents().copyWith(monthComponents: month),
      'multiDayComponents': () => const CalendarComponents().copyWith(multiDayComponents: multiDay),
      'scheduleComponents': () => const CalendarComponents().copyWith(scheduleComponents: schedule),
      'overlayBuilders': () => const CalendarComponents().copyWith(overlayBuilders: overlayBuilders),
    },
  );
}

// One named function per builder shape. A tear-off of the same function compares
// equal, which is what lets the "no arguments" copy be checked with `==`.

Widget _overlay(
  BuildContext context, {
  required DateTime date,
  required List<CalendarEvent> events,
  required double tileHeight,
  required OverlayPortalController portalController,
  required RenderBoxCallback getMultiDayEventLayoutRenderBox,
  required RenderBoxCallback getOverlayPortalRenderBox,
  required MultiDayOverlayEventTileBuilder overlayTileBuilder,
}) =>
    const SizedBox();

Widget _overlayPortal(
  BuildContext context, {
  required DateTime date,
  required List<CalendarEvent> events,
  required int numberOfHiddenRows,
  required double tileHeight,
  required RenderBoxCallback getMultiDayEventLayoutRenderBox,
  required MultiDayOverlayEventTileBuilder overlayTileBuilder,
  required OverlayBuilders? overlayBuilders,
}) =>
    const SizedBox();

Widget _overlayButton(BuildContext context, OverlayPortalController controller, int hidden) => const SizedBox();
String _hiddenCount(BuildContext context, int hidden) => '$hidden';
Widget _grid(BuildContext context, int numberOfRows) => const SizedBox();
Widget _dateWidget(BuildContext context, DateTime date) => const SizedBox();
String _dateString(BuildContext context, DateTime date) => '';
Widget _dayCell(BuildContext context, MonthDayCellDetails details) => const SizedBox();
Widget _weekNumber(BuildContext context, KalenderDateTimeRange range) => const SizedBox();
Widget _horizontalTrigger(BuildContext context, double pageWidth) => const SizedBox();
Widget _verticalTrigger(BuildContext context, double viewPortHeight) => const SizedBox();
Widget _hourLines(BuildContext context, double heightPerMinute, TimeOfDayRange range) => const SizedBox();

Widget _timeline(
  BuildContext context,
  double heightPerMinute,
  TimeOfDayRange range,
  ValueNotifier<CalendarEvent?> eventBeingDragged,
  ValueNotifier<KalenderDateTimeRange?> visibleDateTimeRange,
) =>
    const SizedBox();

String _timeString(BuildContext context, TimeOfDay time) => '';
double _timelineWidth(BuildContext context, TimeOfDayRange range) => 56;
Widget _daySeparator(BuildContext context) => const SizedBox();

Widget _timeIndicator(BuildContext context, TimeOfDayRange range, double heightPerMinute, Location? location) =>
    const SizedBox();

Widget _scheduleDate(BuildContext context, InternalDateTime date) => const SizedBox();

Widget _tileHighlight(
  BuildContext context,
  InternalDateTime date,
  ValueNotifier<InternalDateTimeRange?> dateTimeRange,
  Widget child,
) =>
    child;

Widget _rangeWidget(BuildContext context, KalenderDateTimeRange range) => const SizedBox();

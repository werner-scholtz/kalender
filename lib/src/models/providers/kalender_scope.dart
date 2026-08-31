import 'package:flutter/material.dart';
import 'package:kalender/kalender.dart';
import 'package:kalender/src/models/providers/calendar_provider.dart';

/// Reads the state of the [KalenderView] a widget is built inside.
///
/// A custom component receives a [BuildContext] and reads what it needs from it,
/// the way `MediaQuery.sizeOf` and `Theme.of` are read. Each accessor depends on
/// one value, so a widget reading the locale does not rebuild when the location
/// changes.
///
/// Every accessor returns the nearest value. Most of these exist once per
/// calendar, but [interactionOf], [callbacksOf], [componentsOf] and
/// [tileComponentsOf] can differ between the header and the body, since
/// [CalendarHeader] and [CalendarBody] each take their own.
///
/// The `of` form throws where there is no [KalenderView] above the context. The
/// `maybeOf` form returns null there instead.
abstract final class KalenderScope {
  /// The [EventsController] driving the calendar.
  static EventsController eventsControllerOf(BuildContext context) => EventsControllerProvider.of(context);

  /// The [EventsController] driving the calendar, or null outside a [KalenderView].
  static EventsController? maybeEventsControllerOf(BuildContext context) {
    return context.dependOnInheritedWidgetOfExactType<EventsControllerProvider>()?.eventsController;
  }

  /// The [CalendarController] driving the calendar.
  static CalendarController calendarControllerOf(BuildContext context) => CalendarControllerProvider.of(context);

  /// The [CalendarController] driving the calendar, or null outside a [KalenderView].
  static CalendarController? maybeCalendarControllerOf(BuildContext context) {
    return context.dependOnInheritedWidgetOfExactType<CalendarControllerProvider>()?.notifier;
  }

  /// The locale the calendar formats its own dates and times with.
  ///
  /// This is `KalenderView.locale`, which is not necessarily the app's locale.
  /// Pass it to intl's `DateFormat` or `NumberFormat`, or to the localized
  /// extensions on [DateTime].
  static Locale? localeOf(BuildContext context) => LocaleProvider.of(context);

  /// The IANA location the calendar displays its events in, or null when it has none.
  static Location? locationOf(BuildContext context) => LocationProvider.of(context);

  /// The components the calendar builds with.
  static CalendarComponents componentsOf(BuildContext context) => Components.of(context);

  /// The callbacks the calendar reports to, or null when it has none.
  static CalendarCallbacks? callbacksOf(BuildContext context) => Callbacks.of(context);

  /// What the calendar allows at this point in the tree.
  ///
  /// [CalendarHeader] and [CalendarBody] each take their own, so this is the
  /// nearest one rather than the calendar's.
  static CalendarInteraction interactionOf(BuildContext context) => Interaction.of(context);

  /// How a dragged event snaps at this point in the tree.
  static CalendarSnapping snappingOf(BuildContext context) => Snapping.of(context);

  /// The tile components in use at this point in the tree.
  ///
  /// These differ between the header and the body, and per view type.
  static TileComponents tileComponentsOf(BuildContext context) => TileComponentProvider.of(context);

  /// The height one minute occupies in the multi-day body.
  static double heightPerMinuteOf(BuildContext context) => HeightPerMinute.of(context);

  /// The rule deciding whether an event spans multiple days.
  static MultiDayRule multiDayRuleOf(BuildContext context) => context.multiDayRule;
}

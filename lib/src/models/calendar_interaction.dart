import 'package:kalender/src/platform.dart';

/// The [EventSnapStrategy] typedef defines a function that snaps events to specific intervals.
///
/// This function takes a [cursorDate] and a [startOfDay] date, and returns a new date that is snapped
/// based on the defined strategy.
typedef EventSnapStrategy = DateTime Function(DateTime cursorDate, DateTime startOfDay, int snapIntervalMinutes);

/// The default snap strategy used to snap events to a the [snapIntervalMinutes].
DateTime defaultSnapStrategy(DateTime cursorDate, DateTime startOfDay, int snapIntervalMinutes) {
  final minutes = cursorDate.difference(startOfDay).inMinutes;
  final numberOfIntervals = (minutes / snapIntervalMinutes).round();
  final snappedMinutes = numberOfIntervals * snapIntervalMinutes;
  final snappedDate = startOfDay.add(Duration(minutes: snappedMinutes));
  return snappedDate;
}

/// The [CreateEventGesture] is used to differentiate between the different ways to create an event.
///
/// TODO: Rename this to EventInteractionGesture.
enum CreateEventGesture {
  /// Creates event on tap gesture.
  tap,

  /// Creates event on tap hold gesture.
  longPress,
}

/// The [CalendarInteraction] class defines the interaction settings for the calendar.
///
/// This class allows you to configure various aspects of how users can interact with the calendar,
/// such as resizing, rescheduling, and creating events. It also provides settings for snapping
/// events to specific intervals or other events.
///
/// Example usage:
/// ```dart
/// CalendarInteraction(
///   allowResizing: true,
///   allowRescheduling: true,
///   allowEventCreation: true,
/// );
/// ```
class CalendarInteraction {
  /// Allow the resizing of events.
  ///
  /// If set to `true`, users can resize events by dragging their edges.
  final bool allowResizing;
  static const defaultAllowResizing = true;

  /// Allow the rescheduling of events.
  ///
  /// If set to `true`, users can reschedule events by dragging them to a different time slot.
  final bool allowRescheduling;
  static const defaultAllowRescheduling = true;

  /// Allow the creation of events.
  ///
  /// If set to `true`, users can create new events by interacting with the calendar.
  final bool allowEventCreation;
  static const defaultAllowEventCreation = true;

  /// The gesture used to create an event.
  ///
  /// This gesture determines how users can create new events in the calendar.
  /// It can be either a tap or a long press gesture.
  final CreateEventGesture createEventGesture;
  static const defaultCreateEventGesture = CreateEventGesture.tap;
  static const defaultMobileCreateEventGesture = CreateEventGesture.longPress;

  /// The gesture used to modify an event.
  ///
  /// This gesture determines how users can modify existing events in the calendar.
  /// It can be either a tap or a long press gesture.
  final CreateEventGesture modifyEventGesture;
  static const defaultModifyEventGesture = CreateEventGesture.tap;
  static const defaultMobileModifyEventGesture = CreateEventGesture.longPress;

  /// The number of milliseconds to throttle the interaction events.
  ///
  /// This is used to prevent excessive updates during drag operations.
  /// This can be adjusted based on the performance needs of the application.
  final int throttleMilliseconds;
  static const defaultThrottleMilliseconds = 16;

  /// Creates a new [CalendarInteraction] instance with the specified settings.
  ///
  /// All parameters are optional and default to the values defined in the class.
  CalendarInteraction({
    this.allowResizing = defaultAllowResizing,
    this.allowRescheduling = defaultAllowRescheduling,
    this.allowEventCreation = defaultAllowEventCreation,
    this.throttleMilliseconds = defaultThrottleMilliseconds,
    CreateEventGesture? createEventGesture,
    CreateEventGesture? modifyEventGesture,
  })  : createEventGesture =
            createEventGesture ?? (isMobileDevice ? defaultMobileCreateEventGesture : defaultCreateEventGesture),
        modifyEventGesture =
            modifyEventGesture ?? (isMobileDevice ? defaultMobileModifyEventGesture : defaultModifyEventGesture);

  /// Creates a copy of this [CalendarInteraction] but with the given fields replaced with the new values.
  /// If the fields are not provided, the original values will be used.
  CalendarInteraction copyWith({
    bool? allowResizing,
    bool? allowRescheduling,
    bool? allowEventCreation,
    int? throttleMilliseconds,
    CreateEventGesture? createEventGesture,
  }) {
    return CalendarInteraction(
      allowResizing: allowResizing ?? this.allowResizing,
      allowRescheduling: allowRescheduling ?? this.allowRescheduling,
      allowEventCreation: allowEventCreation ?? this.allowEventCreation,
      throttleMilliseconds: throttleMilliseconds ?? this.throttleMilliseconds,
      createEventGesture: createEventGesture ?? this.createEventGesture,
    );
  }

  @override
  operator ==(Object other) {
    return other is CalendarInteraction &&
        other.allowResizing == allowResizing &&
        other.allowRescheduling == allowRescheduling &&
        other.allowEventCreation == allowEventCreation;
  }

  @override
  int get hashCode => Object.hash(
        allowResizing,
        allowRescheduling,
        allowEventCreation,
      );
}

/// The [EventInteraction] class defines the interaction settings for individual calendar events.
///
/// This class allows you to configure how users can interact with specific events,
/// such as resizing the start/end times and rescheduling. Unlike [CalendarInteraction] which
/// applies globally, [EventInteraction] is applied per event for fine-grained control.
///
/// Example usage:
/// ```dart
/// EventInteraction(
///   allowStartResize: true,
///   allowEndResize: true,
///   allowRescheduling: true,
/// );
/// ```
class EventInteraction {
  /// Whether the start of the event can be resized.
  ///
  /// If set to `true`, users can resize the event's start time by dragging the top edge.
  final bool allowStartResize;

  /// Whether the end of the event can be resized.
  ///
  /// If set to `true`, users can resize the event's end time by dragging the bottom edge.
  final bool allowEndResize;

  /// Whether the event can be rescheduled.
  ///
  /// If set to `true`, users can reschedule the event by dragging it to a different time slot.
  final bool allowRescheduling;

  /// Creates a new [EventInteraction] instance with the specified settings.
  ///
  /// All parameters are optional and default to `true`, allowing all interactions.
  EventInteraction({
    this.allowStartResize = true,
    this.allowEndResize = true,
    this.allowRescheduling = true,
  });

  /// Creates an [EventInteraction] from the now deprecated [canModify] property.
  ///
  /// This constructor maintains backward compatibility by setting all interaction
  /// permissions based on a single boolean value.
  EventInteraction.fromCanModify(bool canModify)
      : allowStartResize = canModify,
        allowEndResize = canModify,
        allowRescheduling = canModify;

  /// Creates an [EventInteraction] that disables all interactions.
  ///
  /// This is equivalent to creating an instance with all parameters set to `false`.
  EventInteraction.allowNone()
      : allowStartResize = false,
        allowEndResize = false,
        allowRescheduling = false;

  /// Creates an [EventInteraction] that enables all interactions.
  ///
  /// This is equivalent to creating an instance with all parameters set to `true`.
  EventInteraction.allowAll()
      : allowStartResize = true,
        allowEndResize = true,
        allowRescheduling = true;

  @override
  operator ==(Object other) {
    return other is EventInteraction &&
        other.allowStartResize == allowStartResize &&
        other.allowEndResize == allowEndResize &&
        other.allowRescheduling == allowRescheduling;
  }

  @override
  int get hashCode => Object.hash(allowStartResize, allowEndResize, allowRescheduling);
}

/// The [CalendarSnapping] class defines the snapping settings for the calendar.
///
/// This class allows you to configure various aspects of how events snap to specific intervals
/// or other events in the calendar.
///
/// Example usage:
/// ```dart
/// CalendarSnapping(
///   snapIntervalMinutes: 15,
///   snapToTimeIndicator: true,
///   snapToOtherEvents: true,
///   snapRange: Duration(minutes: 10),
/// );
/// ```
class CalendarSnapping {
  /// The snap interval in minutes for events.
  ///
  /// This interval is used when snapping events to the nearest time slot.
  /// For example, if set to 15, events will snap to the nearest 15-minute interval.
  final int snapIntervalMinutes;
  static const defaultSnapIntervalMinutes = 10;

  /// Whether to snap to the time indicator when altering an event.
  ///
  /// If set to `true`, events will snap to the current time indicator when being moved or resized.
  final bool snapToTimeIndicator;
  static const defaultSnapToTimeIndicator = true;

  /// Whether to snap to other events when altering an event.
  ///
  /// If set to `true`, events will snap to the edges of other events when being moved or resized.
  final bool snapToOtherEvents;
  static const defaultSnapToOtherEvents = true;

  /// The [Duration] in which events will snap to other events.
  ///
  /// This duration defines the range within which events will snap to other events.
  final Duration snapRange;
  static const defaultSnapRange = Duration(minutes: 15);

  /// The strategy used to snap events to specific intervals.
  ///
  /// This strategy is only used by the multi-day body.
  final EventSnapStrategy eventSnapStrategy;

  /// Creates a new [CalendarSnapping] instance with the specified settings.
  ///
  /// All parameters are optional and default to the values defined in the class.
  const CalendarSnapping({
    this.snapIntervalMinutes = defaultSnapIntervalMinutes,
    this.snapToTimeIndicator = defaultSnapToTimeIndicator,
    this.snapToOtherEvents = defaultSnapToOtherEvents,
    this.snapRange = defaultSnapRange,
    this.eventSnapStrategy = defaultSnapStrategy,
  });

  /// Creates a copy of this [CalendarSnapping] but with the given fields replaced with the new values.
  /// If the fields are not provided, the original values will be used.
  CalendarSnapping copyWith({
    int? snapIntervalMinutes,
    bool? snapToTimeIndicator,
    bool? snapToOtherEvents,
    Duration? snapRange,
  }) {
    return CalendarSnapping(
      snapIntervalMinutes: snapIntervalMinutes ?? this.snapIntervalMinutes,
      snapToTimeIndicator: snapToTimeIndicator ?? this.snapToTimeIndicator,
      snapToOtherEvents: snapToOtherEvents ?? this.snapToOtherEvents,
      snapRange: snapRange ?? this.snapRange,
    );
  }

  @override
  operator ==(Object other) {
    return other is CalendarSnapping &&
        other.snapIntervalMinutes == snapIntervalMinutes &&
        other.snapToTimeIndicator == snapToTimeIndicator &&
        other.snapToOtherEvents == snapToOtherEvents &&
        other.snapRange == snapRange;
  }

  @override
  int get hashCode => Object.hash(
        snapIntervalMinutes,
        snapToTimeIndicator,
        snapToOtherEvents,
        snapRange,
      );
}

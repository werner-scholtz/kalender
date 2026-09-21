// This file is part of kalender.
//
// SPDX-FileCopyrightText: 2023 Klarälvdalens Datakonsult AB, a KDAB Group company <info@kdab.com>
//
// SPDX-License-Identifier: MIT

import 'package:kalender/src/models/view_configurations/view_configuration.dart';
import 'package:kalender/src/platform.dart';

/// The strategy a calendar uses when nothing overrides it.
///
/// {@category Interaction}
const kDefaultSnapStrategy = EventSnapStrategy.interval();

/// Decides where a dragged event lands, given the position of the cursor.
///
/// Set on [KalenderSnapping.eventSnapStrategy], which is compared with `==`, so subclasses define `==` and `hashCode`.
///
/// {@category Interaction}
abstract class EventSnapStrategy {
  const EventSnapStrategy();

  /// Snaps to the nearest multiple of [KalenderSnapping.snapIntervalMinutes]
  /// measured from the start of the day. The default.
  const factory EventSnapStrategy.interval() = IntervalSnapStrategy;

  /// Leaves the cursor position alone.
  const factory EventSnapStrategy.none() = NoSnapStrategy;

  /// The time the event snaps to.
  ///
  /// [cursorDate] is where the cursor sits, [startOfDay] is the start of the day
  /// it sits in, and [snapIntervalMinutes] comes from
  /// [KalenderSnapping.snapIntervalMinutes].
  FloatingDateTime snap({
    required FloatingDateTime cursorDate,
    required FloatingDateTime startOfDay,
    required int snapIntervalMinutes,
  });
}

/// Snaps to the nearest multiple of the snap interval.
///
/// {@category Interaction}
class IntervalSnapStrategy extends EventSnapStrategy {
  const IntervalSnapStrategy();

  @override
  FloatingDateTime snap({
    required FloatingDateTime cursorDate,
    required FloatingDateTime startOfDay,
    required int snapIntervalMinutes,
  }) {
    final minutes = cursorDate.difference(startOfDay).inMinutes;
    final numberOfIntervals = (minutes / snapIntervalMinutes).round();
    final snappedMinutes = numberOfIntervals * snapIntervalMinutes;
    return startOfDay.add(Duration(minutes: snappedMinutes));
  }

  @override
  bool operator ==(Object other) => other.runtimeType == runtimeType;

  @override
  int get hashCode => (IntervalSnapStrategy).hashCode;
}

/// Returns the cursor position unchanged.
///
/// {@category Interaction}
class NoSnapStrategy extends EventSnapStrategy {
  const NoSnapStrategy();

  @override
  FloatingDateTime snap({
    required FloatingDateTime cursorDate,
    required FloatingDateTime startOfDay,
    required int snapIntervalMinutes,
  }) {
    return cursorDate;
  }

  @override
  bool operator ==(Object other) => other.runtimeType == runtimeType;

  @override
  int get hashCode => (NoSnapStrategy).hashCode;
}

/// The [InputMode] defines the type of input the calendar should optimize for.
///
/// This affects how resize handles are positioned and how visibility is triggered.
///
/// {@category Interaction}
enum InputMode {
  /// Automatically detect input type.
  ///
  /// Uses the platform heuristic as a fallback (iOS/Android → [imprecise], otherwise → [precise]).
  /// At runtime, hover events indicate precise input and selection indicates imprecise input.
  auto,

  /// Precise input mode (mouse, stylus, trackpad).
  ///
  /// Resize handles span the full width/height of the event tile and are shown on hover.
  precise,

  /// Imprecise input mode (touch/finger).
  ///
  /// Resize handles are positioned at corners for easier targeting and are shown when the event is selected.
  imprecise,
}

/// The [EventInteractionGesture] is used to differentiate between the different ways to create and modify an event.
///
/// {@category Interaction}
enum EventInteractionGesture {
  /// Uses a tap gesture.
  tap,

  /// Uses a tap and hold gesture.
  longPress,
}

/// What users may do with the calendar: resize, reschedule and create events, and with which gestures.
///
/// {@category Interaction}
class KalenderInteraction {
  /// Allow the resizing of events.
  final bool allowResizing;
  static const defaultAllowResizing = true;

  /// Allow the rescheduling of events.
  final bool allowRescheduling;
  static const defaultAllowRescheduling = true;

  /// Allow the creation of events.
  final bool allowEventCreation;
  static const defaultAllowEventCreation = true;

  /// The gesture used to create an event.
  final EventInteractionGesture createEventGesture;
  static const defaultCreateEventGesture = EventInteractionGesture.tap;
  static const defaultMobileCreateEventGesture = EventInteractionGesture.longPress;

  /// The gesture used to modify an event.
  final EventInteractionGesture modifyEventGesture;
  static const defaultModifyEventGesture = EventInteractionGesture.tap;
  static const defaultMobileModifyEventGesture = EventInteractionGesture.longPress;

  /// The input mode for the calendar.
  final InputMode inputMode;
  static const defaultInputMode = InputMode.auto;

  /// Whether to allow horizontal resize handles in [InputMode.imprecise] mode.
  final bool allowHorizontalImpreciseResize;
  static const defaultAllowHorizontalImpreciseResize = false;

  /// Resolves whether the current input mode is imprecise.
  ///
  /// If [inputMode] is [InputMode.auto], falls back to a platform heuristic
  /// (iOS/Android → imprecise, otherwise → precise).
  bool resolveIsImprecise() {
    return switch (inputMode) {
      InputMode.precise => false,
      InputMode.imprecise => true,
      InputMode.auto => isMobileDevice,
    };
  }

  KalenderInteraction({
    this.allowResizing = defaultAllowResizing,
    this.allowRescheduling = defaultAllowRescheduling,
    this.allowEventCreation = defaultAllowEventCreation,
    this.inputMode = defaultInputMode,
    this.allowHorizontalImpreciseResize = defaultAllowHorizontalImpreciseResize,
    EventInteractionGesture? createEventGesture,
    EventInteractionGesture? modifyEventGesture,
  }) : createEventGesture =
           createEventGesture ?? (isMobileDevice ? defaultMobileCreateEventGesture : defaultCreateEventGesture),
       modifyEventGesture =
           modifyEventGesture ?? (isMobileDevice ? defaultMobileModifyEventGesture : defaultModifyEventGesture);

  KalenderInteraction copyWith({
    bool? allowResizing,
    bool? allowRescheduling,
    bool? allowEventCreation,
    InputMode? inputMode,
    bool? allowHorizontalImpreciseResize,
    EventInteractionGesture? createEventGesture,
    EventInteractionGesture? modifyEventGesture,
  }) {
    return KalenderInteraction(
      allowResizing: allowResizing ?? this.allowResizing,
      allowRescheduling: allowRescheduling ?? this.allowRescheduling,
      allowEventCreation: allowEventCreation ?? this.allowEventCreation,
      inputMode: inputMode ?? this.inputMode,
      allowHorizontalImpreciseResize: allowHorizontalImpreciseResize ?? this.allowHorizontalImpreciseResize,
      createEventGesture: createEventGesture ?? this.createEventGesture,
      modifyEventGesture: modifyEventGesture ?? this.modifyEventGesture,
    );
  }

  @override
  operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is KalenderInteraction &&
        other.allowResizing == allowResizing &&
        other.allowRescheduling == allowRescheduling &&
        other.allowEventCreation == allowEventCreation &&
        other.inputMode == inputMode &&
        other.allowHorizontalImpreciseResize == allowHorizontalImpreciseResize &&
        other.createEventGesture == createEventGesture &&
        other.modifyEventGesture == modifyEventGesture;
  }

  @override
  int get hashCode => Object.hash(
    allowResizing,
    allowRescheduling,
    allowEventCreation,
    inputMode,
    allowHorizontalImpreciseResize,
    createEventGesture,
    modifyEventGesture,
  );
}

/// What users may do with one event: resize its start, resize its end and reschedule it.
///
/// {@category Interaction}
class EventInteraction {
  /// Whether the start of the event can be resized.
  final bool allowStartResize;

  /// Whether the end of the event can be resized.
  final bool allowEndResize;

  /// Whether the event can be rescheduled.
  final bool allowRescheduling;

  EventInteraction({this.allowStartResize = true, this.allowEndResize = true, this.allowRescheduling = true});

  /// Creates an [EventInteraction] with every permission set to [canModify].
  EventInteraction.fromCanModify(bool canModify)
    : allowStartResize = canModify,
      allowEndResize = canModify,
      allowRescheduling = canModify;

  /// Creates an [EventInteraction] that disables all interactions.
  ///
  /// This is equivalent to creating an instance with all parameters set to `false`.
  EventInteraction.allowNone() : allowStartResize = false, allowEndResize = false, allowRescheduling = false;

  /// Creates an [EventInteraction] that enables all interactions.
  ///
  /// This is equivalent to creating an instance with all parameters set to `true`.
  EventInteraction.allowAll() : allowStartResize = true, allowEndResize = true, allowRescheduling = true;

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

/// How a dragged or resized event snaps to time intervals, the time indicator and other events.
///
/// {@category Interaction}
class KalenderSnapping {
  /// The snap interval in minutes for events.
  final int snapIntervalMinutes;
  static const defaultSnapIntervalMinutes = 10;

  /// Whether to snap to the time indicator when altering an event.
  final bool snapToTimeIndicator;
  static const defaultSnapToTimeIndicator = true;

  /// Whether to snap to other events when altering an event.
  final bool snapToOtherEvents;
  static const defaultSnapToOtherEvents = true;

  /// The [Duration] in which events will snap to other events.
  final Duration snapRange;
  static const defaultSnapRange = Duration(minutes: 15);

  /// The strategy used to snap events to specific intervals.
  ///
  /// This strategy is only used by the multi-day body.
  final EventSnapStrategy eventSnapStrategy;

  const KalenderSnapping({
    this.snapIntervalMinutes = defaultSnapIntervalMinutes,
    this.snapToTimeIndicator = defaultSnapToTimeIndicator,
    this.snapToOtherEvents = defaultSnapToOtherEvents,
    this.snapRange = defaultSnapRange,
    this.eventSnapStrategy = kDefaultSnapStrategy,
  });

  KalenderSnapping copyWith({
    int? snapIntervalMinutes,
    bool? snapToTimeIndicator,
    bool? snapToOtherEvents,
    Duration? snapRange,
    EventSnapStrategy? eventSnapStrategy,
  }) {
    return KalenderSnapping(
      snapIntervalMinutes: snapIntervalMinutes ?? this.snapIntervalMinutes,
      snapToTimeIndicator: snapToTimeIndicator ?? this.snapToTimeIndicator,
      snapToOtherEvents: snapToOtherEvents ?? this.snapToOtherEvents,
      snapRange: snapRange ?? this.snapRange,
      eventSnapStrategy: eventSnapStrategy ?? this.eventSnapStrategy,
    );
  }

  @override
  operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is KalenderSnapping &&
        other.snapIntervalMinutes == snapIntervalMinutes &&
        other.snapToTimeIndicator == snapToTimeIndicator &&
        other.snapToOtherEvents == snapToOtherEvents &&
        other.snapRange == snapRange &&
        other.eventSnapStrategy == eventSnapStrategy;
  }

  @override
  int get hashCode =>
      Object.hash(snapIntervalMinutes, snapToTimeIndicator, snapToOtherEvents, snapRange, eventSnapStrategy);
}

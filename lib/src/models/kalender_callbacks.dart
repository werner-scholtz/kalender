// This file is part of kalender.
//
// SPDX-FileCopyrightText: 2023 Klarälvdalens Datakonsult AB, a KDAB Group company <info@kdab.com>
//
// SPDX-License-Identifier: MIT

import 'package:flutter/widgets.dart';
import 'package:kalender/kalender.dart';
import 'package:kalender/src/models/kalender_events/draggable_event.dart';
import 'package:kalender/src/widgets/drag_targets/horizontal_drag_target.dart';
import 'package:kalender/src/widgets/drag_targets/vertical_drag_target.dart';

/// The callbacks used by the [KalenderView].
///
/// {@category Controllers and callbacks}
class KalenderCallbacks {
  /// The callback for when an event is tapped.
  ///
  /// If you provide neither [onEventTapped] nor [onEventTappedWithDetail], the [GestureDetector] is not enabled,
  /// and a gesture detector inside your own tile receives the gesture instead. See [DayEventTileUtils] and
  /// [MultiDayEventTileUtils] for tiles that resolve the tapped position themselves.
  final OnEventTapped? onEventTapped;

  /// The callback for when an event is tapped, with details.
  final OnEventTappedWithDetail? onEventTappedWithDetail;

  /// The callback for when an event is secondary tapped.
  final OnEventTapped? onEventSecondaryTapped;

  /// The callback for when an event is secondary tapped, with details.
  final OnEventTappedWithDetail? onEventSecondaryTappedWithDetail;

  /// The callback for when an event is about to be created.
  ///
  /// Not called when [onEventCreateWithDetail] is set.
  final OnEventCreate? onEventCreate;

  /// The callback for when an event is about to be created.
  final OnEventCreateWithDetail? onEventCreateWithDetail;

  /// The callback for when an event is created.
  final OnEventCreated? onEventCreated;

  /// The callback for when an event is about to be changed.
  final OnEventChange? onEventChange;

  /// The callback for when an event is changed.
  final OnEventChanged? onEventChanged;

  /// The callback for when the calendar page is changed.
  final OnPageChanged? onPageChanged;

  /// The callback for when the vertical scroll position of a multi-day view changes.
  ///
  /// The provided [KalenderTime] is the time currently aligned with the top of the
  /// visible viewport. Only fires for views with vertical scroll (day/week/etc).
  final OnScrollPositionChanged? onScrollPositionChanged;

  /// The callback for when a user taps on the calendar.
  final OnTapped? onTapped;

  /// The callback for when a user taps on the calendar with details.
  final OnTappedWithDetail? onTappedWithDetail;

  /// The callback for when a user secondary taps on the calendar.
  final OnTapped? onSecondaryTapped;

  /// The callback for when a user secondary taps on the calendar with details.
  final OnTappedWithDetail? onSecondaryTappedWithDetail;

  /// The callback for when a user long presses on the calendar.
  final OnLongPressed? onLongPressed;

  /// The callback for when a user long presses on the calendar with details.
  final OnLongPressedWithDetail? onLongPressedWithDetail;

  /// The callback for when a user secondary long presses on the calendar.
  final OnLongPressed? onSecondaryLongPressed;

  /// The callback for when a user secondary long presses on the calendar with details.
  final OnLongPressedWithDetail? onSecondaryLongPressedWithDetail;

  /// The callback for when a drag target is evaluating whether to accept a draggable, on a vertical view.
  ///
  /// When overriding this please see [VerticalDragTarget.onWillAcceptWithDetails] for default behavior.
  final OnWillAcceptWithDetailsVertical? onWillAcceptWithDetailsVertical;

  /// The callback for when a drag target is evaluating whether to accept a draggable, on a horizontal view.
  ///
  /// When overriding this please see [HorizontalDragTarget.onWillAcceptWithDetails] for default behavior.
  final OnWillAcceptWithDetailsHorizontal? onWillAcceptWithDetailsHorizontal;

  /// The gestures on a date label: the day number and day name in the day header, the month day header, the schedule
  /// date and the multi-day overlay.
  ///
  /// Also reported for a label built by a custom builder.
  final GestureCallbacks<DayDetail>? dateLabel;

  /// The gestures on a week number, in the multi-day header and the month view.
  ///
  /// [MultiDayDetail.dateTimeRange] is the range the week number shows. Also reported for a week number built by a
  /// custom builder.
  final GestureCallbacks<MultiDayDetail>? weekNumber;

  /// Creates a set of callbacks for the [KalenderView].
  const KalenderCallbacks({
    this.onEventTapped,
    this.onEventTappedWithDetail,
    this.onEventSecondaryTapped,
    this.onEventSecondaryTappedWithDetail,
    this.onEventChange,
    this.onEventChanged,
    this.onEventCreate,
    this.onEventCreateWithDetail,
    this.onEventCreated,
    this.onPageChanged,
    this.onScrollPositionChanged,
    this.onTapped,
    this.onTappedWithDetail,
    this.onSecondaryTapped,
    this.onSecondaryTappedWithDetail,
    this.onLongPressed,
    this.onLongPressedWithDetail,
    this.onSecondaryLongPressed,
    this.onSecondaryLongPressedWithDetail,
    this.onWillAcceptWithDetailsVertical,
    this.onWillAcceptWithDetailsHorizontal,
    this.dateLabel,
    this.weekNumber,
  });

  bool get hasOnEventTapped => onEventTapped != null || onEventTappedWithDetail != null;
  bool get hasOnEventSecondaryTapped => onEventSecondaryTapped != null || onEventSecondaryTappedWithDetail != null;
  bool get hasOnLongPressed => onLongPressed != null || onLongPressedWithDetail != null;
  bool get hasOnSecondaryLongPressed => onSecondaryLongPressed != null || onSecondaryLongPressedWithDetail != null;
  bool get hasOnTapped => onTapped != null || onTappedWithDetail != null;
  bool get hasOnSecondaryTapped => onSecondaryTapped != null || onSecondaryTappedWithDetail != null;
  bool get hasOnScrollPositionChanged => onScrollPositionChanged != null;

  KalenderCallbacks copyWith({
    OnEventTapped? onEventTapped,
    OnEventTappedWithDetail? onEventTappedWithDetail,
    OnEventTapped? onEventSecondaryTapped,
    OnEventTappedWithDetail? onEventSecondaryTappedWithDetail,
    OnEventCreate? onEventCreate,
    OnEventCreateWithDetail? onEventCreateWithDetail,
    OnEventCreated? onEventCreated,
    OnEventChange? onEventChange,
    OnEventChanged? onEventChanged,
    OnPageChanged? onPageChanged,
    OnScrollPositionChanged? onScrollPositionChanged,
    OnTapped? onTapped,
    OnTappedWithDetail? onTappedWithDetail,
    OnTapped? onSecondaryTapped,
    OnTappedWithDetail? onSecondaryTappedWithDetail,
    OnLongPressed? onLongPressed,
    OnLongPressedWithDetail? onLongPressedWithDetail,
    OnLongPressed? onSecondaryLongPressed,
    OnLongPressedWithDetail? onSecondaryLongPressedWithDetail,
    OnWillAcceptWithDetailsVertical? onWillAcceptWithDetailsVertical,
    OnWillAcceptWithDetailsHorizontal? onWillAcceptWithDetailsHorizontal,
    GestureCallbacks<DayDetail>? dateLabel,
    GestureCallbacks<MultiDayDetail>? weekNumber,
  }) {
    return KalenderCallbacks(
      onEventTapped: onEventTapped ?? this.onEventTapped,
      onEventTappedWithDetail: onEventTappedWithDetail ?? this.onEventTappedWithDetail,
      onEventSecondaryTapped: onEventSecondaryTapped ?? this.onEventSecondaryTapped,
      onEventSecondaryTappedWithDetail: onEventSecondaryTappedWithDetail ?? this.onEventSecondaryTappedWithDetail,
      onEventCreate: onEventCreate ?? this.onEventCreate,
      onEventCreateWithDetail: onEventCreateWithDetail ?? this.onEventCreateWithDetail,
      onEventCreated: onEventCreated ?? this.onEventCreated,
      onEventChange: onEventChange ?? this.onEventChange,
      onEventChanged: onEventChanged ?? this.onEventChanged,
      onPageChanged: onPageChanged ?? this.onPageChanged,
      onScrollPositionChanged: onScrollPositionChanged ?? this.onScrollPositionChanged,
      onTapped: onTapped ?? this.onTapped,
      onTappedWithDetail: onTappedWithDetail ?? this.onTappedWithDetail,
      onSecondaryTapped: onSecondaryTapped ?? this.onSecondaryTapped,
      onSecondaryTappedWithDetail: onSecondaryTappedWithDetail ?? this.onSecondaryTappedWithDetail,
      onLongPressed: onLongPressed ?? this.onLongPressed,
      onLongPressedWithDetail: onLongPressedWithDetail ?? this.onLongPressedWithDetail,
      onSecondaryLongPressed: onSecondaryLongPressed ?? this.onSecondaryLongPressed,
      onSecondaryLongPressedWithDetail: onSecondaryLongPressedWithDetail ?? this.onSecondaryLongPressedWithDetail,
      onWillAcceptWithDetailsVertical: onWillAcceptWithDetailsVertical ?? this.onWillAcceptWithDetailsVertical,
      onWillAcceptWithDetailsHorizontal: onWillAcceptWithDetailsHorizontal ?? this.onWillAcceptWithDetailsHorizontal,
      dateLabel: dateLabel ?? this.dateLabel,
      weekNumber: weekNumber ?? this.weekNumber,
    );
  }
}

/// The callback for when an event is tapped.
///
/// Use [OnEventTappedWithDetail] to also receive the tapped date and the
/// [RenderBox] of the event tile.
///
/// {@category Controllers and callbacks}
typedef OnEventTapped = void Function(KalenderEvent event);

/// The callback for when an event is tapped.
///
/// - The [detail] can be a [DayDetail] or a [MultiDayDetail].
/// - [TapDetail.renderBox] is the [RenderBox] of the event tile.
///
/// {@category Controllers and callbacks}
typedef OnEventTappedWithDetail = void Function(KalenderEvent event, TapDetail detail);

/// The callback for when an event is about to be changed.
///
/// {@category Controllers and callbacks}
typedef OnEventChange = void Function(KalenderEvent event);

/// The callback for when an event is changed.
///
/// {@category Controllers and callbacks}
typedef OnEventChanged = void Function(KalenderEvent event, KalenderEvent updatedEvent);

/// The call back for creating a new event.
///
/// {@category Controllers and callbacks}
typedef OnEventCreate = KalenderEvent? Function(KalenderEvent event);

/// The call back for creating a new event with details.
///
/// {@category Controllers and callbacks}
typedef OnEventCreateWithDetail = KalenderEvent? Function(KalenderEvent event, TapDetail detail);

/// The callback for a new event has been created.
///
/// {@category Controllers and callbacks}
typedef OnEventCreated = void Function(KalenderEvent event);

/// The callback for when a calendar page is changed.
///
/// {@category Controllers and callbacks}
typedef OnPageChanged = void Function(KalenderDateTimeRange dateTimeRange);

/// The callback for when the vertical scroll position of a multi-day view changes.
///
/// {@category Controllers and callbacks}
typedef OnScrollPositionChanged = void Function(KalenderTime visibleTimeOfDay);

/// The callback for when a user taps on an empty space in the calendar.
///
/// If you need more details, use [KalenderCallbacks.onTappedWithDetail].
///
/// {@category Controllers and callbacks}
typedef OnTapped = void Function(DateTime date);

/// The callback for when a user taps on an empty space in the calendar with details.
///
/// {@category Controllers and callbacks}
typedef OnTappedWithDetail = void Function(TapDetail detail);

/// The callback for when a user long presses on an empty space in the calendar.
///
/// If you need more details, use [KalenderCallbacks.onLongPressedWithDetail].
///
/// {@category Controllers and callbacks}
typedef OnLongPressed = void Function(DateTime date);

/// The callback for when a user long presses on an empty space in the calendar with details.
///
/// {@category Controllers and callbacks}
typedef OnLongPressedWithDetail = void Function(TapDetail detail);

/// The callback for when a drag target is evaluating whether to accept a draggable.
///
/// [details] contains the details of the drag operation.
/// [controller] is the controller of the calendar.
/// [configuration] is the configuration of the vertical view.
///
/// See [VerticalDragTarget.onWillAcceptWithDetails] for default behavior.
///
/// {@category Interaction}
typedef OnWillAcceptWithDetailsVertical =
    bool Function(
      DragTargetDetails<Object?> details,
      KalenderController controller,
      VerticalConfiguration configuration,
    );

/// The callback for when a drag target is evaluating whether to accept a draggable.
///
/// [details] contains the details of the drag operation.
/// [controller] is the controller of the calendar.
/// [configuration] is the configuration of the horizontal view.
///
/// By default the calendar will only accept draggables that are of type [Create], [Resize], or [Reschedule].
///
/// See [HorizontalDragTarget.onWillAcceptWithDetails] for default behavior.
///
/// {@category Interaction}
typedef OnWillAcceptWithDetailsHorizontal =
    bool Function(
      DragTargetDetails<Object?> details,
      KalenderController controller,
      HorizontalConfiguration configuration,
    );

/// A callback for a gesture on one part of the calendar.
///
/// {@category Controllers and callbacks}
typedef OnGesture<T extends TapDetail> = void Function(T detail);

/// The gestures reported for one part of the calendar, such as [KalenderCallbacks.dateLabel].
///
/// The part only listens for the gestures that are set.
///
/// {@category Controllers and callbacks}
class GestureCallbacks<T extends TapDetail> {
  /// Creates a set of gesture callbacks.
  const GestureCallbacks({this.onTap, this.onSecondaryTap, this.onLongPress, this.onSecondaryLongPress});

  /// Called when the part is tapped.
  final OnGesture<T>? onTap;

  /// Called when the part is tapped with the secondary button.
  final OnGesture<T>? onSecondaryTap;

  /// Called when the part is long pressed.
  final OnGesture<T>? onLongPress;

  /// Called when the part is long pressed with the secondary button.
  final OnGesture<T>? onSecondaryLongPress;

  /// Whether any callback is set.
  bool get hasAny => onTap != null || onSecondaryTap != null || onLongPress != null || onSecondaryLongPress != null;

  /// Creates a copy with the given callbacks replaced.
  GestureCallbacks<T> copyWith({
    OnGesture<T>? onTap,
    OnGesture<T>? onSecondaryTap,
    OnGesture<T>? onLongPress,
    OnGesture<T>? onSecondaryLongPress,
  }) {
    return GestureCallbacks<T>(
      onTap: onTap ?? this.onTap,
      onSecondaryTap: onSecondaryTap ?? this.onSecondaryTap,
      onLongPress: onLongPress ?? this.onLongPress,
      onSecondaryLongPress: onSecondaryLongPress ?? this.onSecondaryLongPress,
    );
  }
}

/// The detail of a gesture on the calendar, a [DayDetail] or a [MultiDayDetail] depending on the calendar view.
///
/// {@category Controllers and callbacks}
abstract class TapDetail {
  /// The render box of the gesture detector that was tapped.
  final RenderBox renderBox;

  /// The local offset of the tap.
  final Offset localOffset;

  const TapDetail({required this.renderBox, required this.localOffset});

  /// Returns true if the detail is a [DayDetail].
  bool get isDayDetail => this is DayDetail;

  /// Returns true if the detail is a [MultiDayDetail].
  bool get isMultiDayDetail => this is MultiDayDetail;
}

/// The detail for when the calendar is tapped.
///
/// {@category Controllers and callbacks}
class DayDetail extends TapDetail {
  /// The date that was tapped.
  final DateTime date;

  /// Creates a new [DayDetail] with the given date.
  const DayDetail({required this.date, required super.renderBox, required super.localOffset});
}

/// The detail for when a multi-day range is tapped.
///
/// {@category Controllers and callbacks}
class MultiDayDetail extends TapDetail {
  /// The date range that was tapped.
  final KalenderDateTimeRange dateTimeRange;

  /// Creates a new [MultiDayDetail] with the given date range.
  const MultiDayDetail({required this.dateTimeRange, required super.renderBox, required super.localOffset});
}

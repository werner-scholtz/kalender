import 'package:flutter/material.dart';
import 'package:kalender/src/enumerations.dart';
import 'package:kalender/src/layout_delegates/event_layout_delegate.dart';
import 'package:kalender/src/layout_delegates/multi_day_event_layout_delegate.dart';

export 'package:kalender/kalender_extensions.dart';

/// The base class for all [ViewConfiguration]s.
///
/// [ViewConfiguration]s are used to configure the view of the calendar.
abstract class ViewConfiguration {
  const ViewConfiguration({required this.name});

  /// The name of the [ViewConfiguration].
  final String name;
}

const defaultTileHeight = 24.0;
const defaultNewEventDuration = Duration(minutes: 30);
const defaultAllowEventCreation = true;
const defaultAllowResizing = true;
const defaultAllowRescheduling = true;
const defaultCreateEventTrigger = CreateEventGesture.tap;
const defaultShowMultiDayEvents = false;
const defaultEventLayoutStrategy = overlapLayoutStrategy;
const defaultMultiDayEventLayoutStrategy = defaultMultiDayLayoutStrategy;
const defaultFirstDayOfWeek = DateTime.monday;
const defaultSnapToTimeIndicator = true;
const defaultSnapToOtherEvents = true;
const defaultSnapRange = Duration(minutes: 15);
const defaultSnapIntervalMinutes = 10;
const defaultShowEventTiles = true;
const defaultInitialTimeOfDay = TimeOfDay(hour: 0, minute: 0);
const defaultHeightPerMinute = 0.7;
import 'package:kalender/src/enumerations.dart';
import 'package:kalender/src/layout_delegates/event_group_layout_delegate.dart';

/// The base class for all [ViewConfiguration]s.
///
/// [ViewConfiguration]s are used to configure the view of the calendar.
abstract class ViewConfiguration {
  const ViewConfiguration({required this.name});

  /// The name of the [ViewConfiguration].
  final String name;
}

const defaultTileHeight = 24.0;
const defaultTimeLineWith = 48.0;
const defaultLeftPageClip = 40.0;
const defaultNewEventDuration = Duration(minutes: 30);
const defaultAllowEventCreation = true;
const defaultAllowResizing = true;
const defaultAllowRescheduling = true;
const defaultCreateEventTrigger = CreateEventTrigger.tap;
const defaultShowMultiDayEvents = false;
const defaultLayoutStrategy = overlapLayoutStrategy;
const defaultFirstDayOfWeek = DateTime.monday;
const defaultSnapToTimeIndicator = true;
const defaultSnapToOtherEvents = true;
const defaultSnapRange = Duration(minutes: 15);
const defaultSnapIntervalMinutes = 10;
const defaultShowEventTiles = true;

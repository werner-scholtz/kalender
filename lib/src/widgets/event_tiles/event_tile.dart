import 'package:flutter/material.dart';

import 'package:kalender/kalender_extensions.dart';
import 'package:kalender/src/enumerations.dart';
import 'package:kalender/src/models/calendar_callbacks.dart';
import 'package:kalender/src/models/calendar_event.dart';
import 'package:kalender/src/models/components/tile_components.dart';
import 'package:kalender/src/models/controllers/calendar_controller.dart';
import 'package:kalender/src/models/controllers/events_controller.dart';
import 'package:kalender/src/models/resize_event.dart';
import 'package:kalender/src/type_definitions.dart';

// TODO: document this.
abstract class EventTile<T extends Object?> extends StatelessWidget {
  final EventsController<T> eventsController;
  final CalendarController<T> controller;
  final CalendarEvent<T> event;
  final CalendarCallbacks<T>? callbacks;
  final TileComponents<T> tileComponents;

  /// Whether the event can be resized.
  final bool allowResizing;

  /// Whether the event can be rescheduled.
  final bool allowRescheduling;

  /// The dateTimeRange of this tile
  final DateTimeRange dateTimeRange;

  const EventTile({
    super.key,
    required this.controller,
    required this.eventsController,
    required this.callbacks,
    required this.tileComponents,
    required this.event,
    required this.allowRescheduling,
    required this.allowResizing,
    required this.dateTimeRange,
  });

  DateTimeRange get localDateTimeRange => dateTimeRange.asLocal;
  DragAnchorStrategy? get dragAnchorStrategy => tileComponents.dragAnchorStrategy;
  ValueNotifier<Size> get feedbackWidgetSize => eventsController.feedbackWidgetSize;
  ValueNotifier<CalendarEvent<T>?> get selectedEvent => controller.selectedEvent;

  OnEventTapped<T>? get onEventTapped => callbacks?.onEventTapped;

  TileBuilder<T> get tileBuilder => tileComponents.tileBuilder;
  TileWhenDraggingBuilder<T>? get tileWhenDraggingBuilder => tileComponents.tileWhenDraggingBuilder;
  FeedbackTileBuilder<T>? get feedbackTileBuilder => tileComponents.feedbackTileBuilder;
  Widget? get verticalResizeHandle => tileComponents.verticalResizeHandle;
  Widget? get horizontalResizeHandle => tileComponents.horizontalResizeHandle;

  bool get continuesBefore => event.continuesBefore(dateTimeRange.start);
  bool get continuesAfter => event.continuesAfter(dateTimeRange.end);
  bool get showStart => allowRescheduling && event.canModify && !continuesBefore;
  bool get showEnd => allowRescheduling && event.canModify && !continuesAfter;
  bool get canReschedule => allowRescheduling && event.canModify;

  // (DateTime date, List<DateTime> dates) eventDates(DateTime date) => (date, event.datesSpanned);

  ResizeEvent<T> resizeEvent(ResizeDirection direction) => ResizeEvent<T>(event, direction);

  void selectEvent() {
    controller.selectEvent(event, internal: true);
    callbacks?.onEventChange?.call(event);
  }
}

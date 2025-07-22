import 'package:flutter/material.dart';
import 'package:kalender/kalender_extensions.dart';
import 'package:kalender/src/enumerations.dart';
import 'package:kalender/src/models/calendar_callbacks.dart';
import 'package:kalender/src/models/calendar_events/calendar_event.dart';
import 'package:kalender/src/models/calendar_events/draggable_event.dart';
import 'package:kalender/src/models/calendar_interaction.dart';
import 'package:kalender/src/models/components/tile_components.dart';
import 'package:kalender/src/models/controllers/calendar_controller.dart';
import 'package:kalender/src/models/controllers/events_controller.dart';

/// The base class for all event tiles.
///
/// Event tiles are used to display events in the calendar.
abstract class EventTile<T extends Object?> extends StatelessWidget {
  final EventsController<T> eventsController;
  final CalendarController<T> controller;
  final CalendarEvent<T> event;
  final CalendarCallbacks<T>? callbacks;
  final TileComponents<T> tileComponents;

  final CalendarInteraction interaction;

  /// The dateTimeRange of this tile
  final DateTimeRange dateTimeRange;

  /// Creates a new [EventTile] widget.
  const EventTile({
    super.key,
    required this.controller,
    required this.eventsController,
    required this.callbacks,
    required this.tileComponents,
    required this.event,
    required this.interaction,
    required this.dateTimeRange,
  });

  DateTimeRange get localDateTimeRange => dateTimeRange.asLocal;
  DragAnchorStrategy? get dragAnchorStrategy => tileComponents.dragAnchorStrategy;
  ValueNotifier<Size> get feedbackWidgetSize => eventsController.feedbackWidgetSize;
  ValueNotifier<CalendarEvent<T>?> get selectedEvent => controller.selectedEvent;

  OnEventTapped<T>? get onEventTapped => callbacks?.onEventTapped;
  OnEventTappedWithDetail<T>? get onEventTappedWithDetail => callbacks?.onEventTappedWithDetail;

  TileBuilder<T> get tileBuilder => tileComponents.tileBuilder;
  TileBuilder<T> get overlayTileBuilder => tileComponents.overlayTileBuilder ?? tileBuilder;
  TileWhenDraggingBuilder<T>? get tileWhenDraggingBuilder => tileComponents.tileWhenDraggingBuilder;
  FeedbackTileBuilder<T>? get feedbackTileBuilder => tileComponents.feedbackTileBuilder;
  Widget? get verticalResizeHandle => tileComponents.verticalResizeHandle;
  Widget? get horizontalResizeHandle => tileComponents.horizontalResizeHandle;

  bool get continuesBefore => event.startAsUtc.isBefore(dateTimeRange.start);
  bool get continuesAfter => event.endAsUtc.isAfter(dateTimeRange.end);
  bool get showStart => interaction.allowResizing && event.canModify && !continuesBefore;
  bool get showEnd => interaction.allowResizing && event.canModify && !continuesAfter;
  bool get canReschedule => interaction.allowRescheduling && event.canModify;

  Reschedule<T> get rescheduleEvent => Reschedule<T>(event: event);
  Resize<T> resizeEvent(ResizeDirection direction) => Resize<T>(event: event, direction: direction);

  void selectEvent() {
    controller.selectEvent(event, internal: true);
    callbacks?.onEventChange?.call(event);
  }
}

import 'package:flutter/material.dart';
import 'package:kalender/kalender_extensions.dart';
import 'package:kalender/src/enumerations.dart';
import 'package:kalender/src/models/calendar_callbacks.dart';
import 'package:kalender/src/models/calendar_events/calendar_event.dart';
import 'package:kalender/src/models/calendar_events/draggable_event.dart';
import 'package:kalender/src/models/calendar_interaction.dart';
import 'package:kalender/src/models/components/tile_components.dart';
import 'package:kalender/src/models/providers/calendar_provider.dart';
import 'package:kalender/src/platform.dart' show isMobileDevice;

/// The base class for all event tiles.
///
/// Event tiles are used to display events in the calendar.
abstract class EventTile<T extends Object?> extends StatelessWidget {
  final CalendarEvent<T> event;
  final CalendarCallbacks<T>? callbacks;
  final TileComponents<T> tileComponents;
  final CalendarInteraction interaction;
  final DateTimeRange dateTimeRange;

  /// Creates a new [EventTile] widget.
  const EventTile({
    super.key,
    required this.callbacks,
    required this.tileComponents,
    required this.event,
    required this.interaction,
    required this.dateTimeRange,
  });

  DateTimeRange get localDateTimeRange => dateTimeRange.asLocal;
  OnEventTapped<T>? get onEventTapped => callbacks?.onEventTapped;
  OnEventTappedWithDetail<T>? get onEventTappedWithDetail => callbacks?.onEventTappedWithDetail;
  TileBuilder<T> get tileBuilder => tileComponents.tileBuilder;
  TileBuilder<T> get overlayTileBuilder => tileComponents.overlayTileBuilder ?? tileBuilder;
  bool get continuesBefore => event.startAsUtc.isBefore(dateTimeRange.start);
  bool get continuesAfter => event.endAsUtc.isAfter(dateTimeRange.end);
  bool get showStart => interaction.allowResizing && event.interaction.allowStartResize && !continuesBefore;
  bool get showEnd => interaction.allowResizing && event.interaction.allowEndResize && !continuesAfter;
  bool get canReschedule => interaction.allowRescheduling && event.interaction.allowRescheduling;
}

mixin EventModification<T extends Object?> {
  CalendarEvent<T> get event;
  TileComponents<T> get tileComponents;
  DragAnchorStrategy? get dragAnchorStrategy => tileComponents.dragAnchorStrategy;
  TileBuilder<T> get tileBuilder => tileComponents.tileBuilder;
  TileBuilder<T> get overlayTileBuilder => tileComponents.overlayTileBuilder ?? tileBuilder;
  TileWhenDraggingBuilder<T>? get tileWhenDraggingBuilder => tileComponents.tileWhenDraggingBuilder;
  FeedbackTileBuilder<T>? get feedbackTileBuilder => tileComponents.feedbackTileBuilder;
  Widget? get verticalResizeHandle => tileComponents.verticalResizeHandle;
  Widget? get horizontalResizeHandle => tileComponents.horizontalResizeHandle;
  Reschedule<T> get rescheduleEvent => Reschedule<T>(event: event);
  Resize<T> resizeEvent(ResizeDirection direction) => Resize<T>(event: event, direction: direction);
  void selectEvent(BuildContext context) {
    context.calendarController<T>().selectEvent(event, internal: true);
    context.callbacks<T>()?.onEventChange?.call(event);
  }
}

class EventResize<T extends Object?> extends StatelessWidget with EventModification<T> {
  final ResizeDirection direction;
  @override
  final CalendarEvent<T> event;

  @override
  final TileComponents<T> tileComponents;

  const EventResize({super.key, required this.event, required this.tileComponents, required this.direction});

  @override
  Widget build(BuildContext context) {
    final resizeHandle = direction == ResizeDirection.left || direction == ResizeDirection.right
        ? horizontalResizeHandle
        : verticalResizeHandle;

    return Draggable<Resize<T>>(
      data: resizeEvent(direction),
      feedback: const SizedBox(),
      dragAnchorStrategy: pointerDragAnchorStrategy,
      onDragStarted: () => selectEvent(context),
      child: resizeHandle ?? Container(color: Colors.transparent),
    );
  }
}

/// The [Reschedule] widget allows the user to reschedule an event by dragging it.
class EventReschedule<T extends Object?> extends StatelessWidget with EventModification<T> {
  final Widget tile;

  @override
  final CalendarEvent<T> event;
  @override
  final TileComponents<T> tileComponents;

  const EventReschedule({super.key, required this.event, required this.tileComponents, required this.tile});

  @override
  Widget build(BuildContext context) {
    final controller = context.calendarController<T>();
    final isDragging = controller.selectedEventId == event.id && controller.internalFocus;
    final tileWhenDragging = tileWhenDraggingBuilder?.call(event);

    late final feedback = FeedbackWidget(
      event: event,
      feedbackWidgetSizeNotifier: context.feedbackWidgetSizeNotifier<T>(),
      feedbackTileBuilder: feedbackTileBuilder,
    );

    return isMobileDevice
        ? LongPressDraggable<Reschedule<T>>(
            data: rescheduleEvent,
            feedback: feedback,
            childWhenDragging: tileWhenDragging,
            dragAnchorStrategy: dragAnchorStrategy ?? childDragAnchorStrategy,
            onDragStarted: () => selectEvent(context),
            maxSimultaneousDrags: 1,
            child: isDragging && tileWhenDragging != null ? tileWhenDragging : tile,
          )
        : Draggable<Reschedule<T>>(
            data: rescheduleEvent,
            feedback: feedback,
            childWhenDragging: tileWhenDragging,
            dragAnchorStrategy: dragAnchorStrategy ?? childDragAnchorStrategy,
            onDragStarted: () => selectEvent(context),
            child: isDragging && tileWhenDragging != null ? tileWhenDragging : tile,
          );
  }
}

/// A widget that provides a feedback widget for event dragging.
class FeedbackWidget<T extends Object?> extends StatefulWidget {
  final CalendarEvent<T> event;
  final FeedbackTileBuilder<T>? feedbackTileBuilder;
  final ValueNotifier<Size> feedbackWidgetSizeNotifier;
  const FeedbackWidget({
    super.key,
    required this.event,
    this.feedbackTileBuilder,
    required this.feedbackWidgetSizeNotifier,
  });

  @override
  State<FeedbackWidget<T>> createState() => _FeedbackWidgetState<T>();
}

class _FeedbackWidgetState<T extends Object?> extends State<FeedbackWidget<T>> {
  Size _size = const Size(0, 0);

  @override
  void initState() {
    super.initState();
    _updateSize();
    widget.feedbackWidgetSizeNotifier.addListener(_updateSize);
  }

  @override
  void dispose() {
    widget.feedbackWidgetSizeNotifier.removeListener(_updateSize);
    super.dispose();
  }

  void _updateSize() {
    if (!mounted) return;
    if (widget.feedbackWidgetSizeNotifier.value == Size.zero) return;
    if (widget.feedbackWidgetSizeNotifier.value == _size) return;

    // Update the size only if it has changed.
    setState(() => _size = widget.feedbackWidgetSizeNotifier.value);
  }

  @override
  Widget build(BuildContext context) {
    final feedbackTile = widget.feedbackTileBuilder?.call(widget.event, _size);
    return feedbackTile ?? const SizedBox();
  }
}

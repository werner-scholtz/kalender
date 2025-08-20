import 'package:flutter/material.dart';
import 'package:kalender/kalender.dart';
import 'package:kalender/src/models/calendar_events/draggable_event.dart';
import 'package:kalender/src/models/providers/calendar_provider.dart';
import 'package:kalender/src/platform.dart' show isMobileDevice;

/// The base class for all event tiles.
///
/// Event tiles are used to display events in the calendar.
abstract class EventTile<T extends Object?> extends StatelessWidget {
  /// The event to be displayed in the tile.
  final CalendarEvent<T> event;

  /// The callbacks for the calendar.
  final CalendarCallbacks<T>? callbacks;

  /// The components used to build the tile.
  final TileComponents<T> tileComponents;

  /// The interaction state of the tile.
  final CalendarInteraction interaction;

  /// The date time range for the tile.
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

  /// Check if the tile should notify taps.
  bool get hasOnEventTapped => callbacks?.hasOnEventTapped ?? false;

  /// The function that is called when the event is tapped.
  OnEventTapped<T>? get onEventTapped => callbacks?.onEventTapped;

  /// The function that is called when the event is tapped with detail.
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

class EventResize<T extends Object?> extends StatefulWidget {
  final ResizeDirection direction;
  final CalendarEvent<T> event;
  final TileComponents<T> tileComponents;

  const EventResize({
    super.key,
    required this.event,
    required this.tileComponents,
    required this.direction,
  });

  @override
  State<EventResize<T>> createState() => _EventResizeState<T>();
}

class _EventResizeState<T extends Object?> extends State<EventResize<T>> with EventModification<T> {
  CalendarController<T>? _controller;

  @override
  CalendarEvent<T> get event => widget.event;

  @override
  TileComponents<T> get tileComponents => widget.tileComponents;

  bool _showHandle = isMobileDevice ? false : true;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (isMobileDevice) {
        _controller = context.calendarController<T>();
        _controller?.selectedEvent.addListener(listener);
      }
    });
  }

  @override
  void dispose() {
    _controller?.selectedEvent.removeListener(listener);
    super.dispose();
  }

  void listener() {
    final selectedEventId = _controller?.selectedEventId;
    if (selectedEventId != event.id) {
      setState(() => _showHandle = true);
    } else {
      setState(() => _showHandle = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_showHandle) {
      final resizeHandle = widget.direction == ResizeDirection.left || widget.direction == ResizeDirection.right
          ? horizontalResizeHandle
          : verticalResizeHandle;

      return Draggable<Resize<T>>(
        data: resizeEvent(widget.direction),
        feedback: const SizedBox(),
        dragAnchorStrategy: pointerDragAnchorStrategy,
        onDragStarted: () => selectEvent(context),
        child: resizeHandle ?? Container(color: Colors.transparent),
      );
    } else {
      return const SizedBox();
    }
  }
}

/// The [Reschedule] widget allows the user to reschedule an event by dragging it.
class EventReschedule<T extends Object?> extends StatelessWidget with EventModification<T> {
  final Widget tile;
  final VoidCallback? dismissOverlay;

  @override
  final CalendarEvent<T> event;
  @override
  final TileComponents<T> tileComponents;

  const EventReschedule({
    super.key,
    required this.event,
    required this.tileComponents,
    required this.tile,
    this.dismissOverlay,
  });

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
            onDragStarted: () {
              dismissOverlay?.call();
              selectEvent(context);
            },
            maxSimultaneousDrags: 1,
            child: isDragging && tileWhenDragging != null ? tileWhenDragging : tile,
          )
        : Draggable<Reschedule<T>>(
            data: rescheduleEvent,
            feedback: feedback,
            childWhenDragging: tileWhenDragging,
            dragAnchorStrategy: dragAnchorStrategy ?? childDragAnchorStrategy,
            onDragStarted: () {
              dismissOverlay?.call();
              selectEvent(context);
            },
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

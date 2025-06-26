import 'package:flutter/material.dart';
import 'package:kalender/kalender.dart';
import 'package:kalender/src/models/calendar_events/draggable_event.dart';
import 'package:kalender/src/platform.dart';
import 'package:kalender/src/widgets/event_tiles/event_tile.dart';

/// This widget renders the tile widget and resize handles in a stack.
///
/// The tile widget is rendered below the resize handles.
class DayEventTile<T extends Object?> extends EventTile<T> {
  /// A key used to identify the tile.
  static ValueKey<String> getKey(int eventId) => ValueKey('DayEventTile-$eventId');

  /// A key used to identify the top resize handle.
  static const topResizeDraggable = ValueKey('TopResizeDraggable');

  /// A key used to identify the bottom resize handle.
  static const bottomResizeDraggable = ValueKey('BottomResizeDraggable');

  /// A key used to identify the reschedule draggable.
  static const rescheduleDraggable = ValueKey('RescheduleDraggable');

  const DayEventTile({
    required super.key,
    required super.controller,
    required super.eventsController,
    required super.callbacks,
    required super.tileComponents,
    required super.event,
    required super.dateTimeRange,
    required super.interaction,
  });

  @override
  Widget build(BuildContext context) {
    late final feedback = ValueListenableBuilder(
      valueListenable: feedbackWidgetSize,
      builder: (context, value, child) {
        final feedbackTile = feedbackTileBuilder?.call(event, value);
        return feedbackTile ?? const SizedBox();
      },
    );

    final tile = tileBuilder.call(event, localDateTimeRange);
    final tileWhenDragging = tileWhenDraggingBuilder?.call(event);
    final isDragging = controller.selectedEventId == event.id && controller.internalFocus;
    late final draggable = isMobileDevice
        ? LongPressDraggable<Reschedule<T>>(
            key: rescheduleDraggable,
            data: rescheduleEvent,
            feedback: feedback,
            childWhenDragging: tileWhenDragging,
            dragAnchorStrategy: dragAnchorStrategy ?? childDragAnchorStrategy,
            onDragStarted: selectEvent,
            maxSimultaneousDrags: 1,
            child: isDragging && tileWhenDragging != null ? tileWhenDragging : tile,
          )
        : Draggable<Reschedule<T>>(
            key: rescheduleDraggable,
            data: rescheduleEvent,
            feedback: feedback,
            childWhenDragging: tileWhenDragging,
            dragAnchorStrategy: dragAnchorStrategy ?? childDragAnchorStrategy,
            onDragStarted: selectEvent,
            child: isDragging && tileWhenDragging != null ? tileWhenDragging : tile,
          );

    final tileWidget = GestureDetector(
      onTap: onEventTapped != null
          ? () {
              // Find the global position and size of the tile.
              final renderObject = context.findRenderObject()! as RenderBox;
              onEventTapped!.call(event, renderObject);
              onEventTappedWithDetail?.call(event, renderObject, DayDetail(dateTimeRange.start));
            }
          : null,
      child: canReschedule ? draggable : tile,
    );

    final handles = Handles(
      selectedEvent: selectedEvent,
      tileComponents: tileComponents,
      controller: controller,
      event: event,
      dateTimeRange: dateTimeRange,
      interaction: interaction,
      resizeEvent: resizeEvent,
      selectEvent: selectEvent,
    );

    return Stack(
      fit: StackFit.expand,
      children: [
        tileWidget,
        Positioned.fill(child: handles),
      ],
    );

    // return ValueListenableBuilder(
    //   valueListenable: interaction,
    //   builder: (context, interaction, child) {
    //     // late final topResizeDetector = ValueListenableBuilder(
    //     //   valueListenable: selectedEvent,
    //     //   builder: (context, value, child) {
    //     //     if (!isMobileDevice) {
    //     //       if (controller.internalFocus) return const SizedBox();
    //     //     } else {
    //     //       if (value != event) return const SizedBox();
    //     //     }

    //     //     return Draggable<Resize<T>>(
    //     //       key: topResizeDraggable,
    //     //       data: resizeEvent(ResizeDirection.top),
    //     //       feedback: const SizedBox(),
    //     //       dragAnchorStrategy: pointerDragAnchorStrategy,
    //     //       onDragStarted: selectEvent,
    //     //       child: verticalResizeHandle ?? Container(color: Colors.transparent),
    //     //     );
    //     //   },
    //     // );

    //     // late final bottomResizeDetector = ValueListenableBuilder(
    //     //   valueListenable: selectedEvent,
    //     //   builder: (context, value, child) {
    //     //     if (!isMobileDevice) {
    //     //       if (controller.internalFocus) return const SizedBox();
    //     //     } else {
    //     //       if (value != event) return const SizedBox();
    //     //     }

    //     //     return Draggable<Resize<T>>(
    //     //       key: bottomResizeDraggable,
    //     //       data: resizeEvent(ResizeDirection.bottom),
    //     //       feedback: const SizedBox(),
    //     //       dragAnchorStrategy: pointerDragAnchorStrategy,
    //     //       onDragStarted: selectEvent,
    //     //       child: verticalResizeHandle ?? Container(color: Colors.transparent),
    //     //     );
    //     //   },
    //     // );

    //     // final resizeHandles = tileComponents.verticalHandlePositioner?.call(
    //     //       topResizeDetector,
    //     //       bottomResizeDetector,
    //     //       showStart,
    //     //       showEnd,
    //     //     ) ??
    //     //     VerticalTileResizeHandlePositioner(
    //     //       startResizeDetector: topResizeDetector,
    //     //       endResizeDetector: bottomResizeDetector,
    //     //       showStart: showStart,
    //     //       showEnd: showEnd,
    //     //     );
    //   },
    // );
  }
}

class Handles<T extends Object?> extends StatefulWidget {
  final ValueNotifier<CalendarEvent<T>?> selectedEvent;
  final TileComponents<T> tileComponents;
  final CalendarController<T> controller;
  final CalendarEvent<T> event;
  final DateTimeRange dateTimeRange;
  final ValueNotifier<CalendarInteraction> interaction;
  final Resize<T> Function(ResizeDirection direction) resizeEvent;
  final void Function() selectEvent;

  const Handles({
    super.key,
    required this.selectedEvent,
    required this.tileComponents,
    required this.controller,
    required this.event,
    required this.dateTimeRange,
    required this.interaction,
    required this.resizeEvent,
    required this.selectEvent,
  });

  @override
  State<Handles<T>> createState() => _HandlesState<T>();
}

class _HandlesState<T extends Object?> extends State<Handles<T>> {
  /// A key used to identify the bottom resize handle.
  static const bottomResizeDraggable = ValueKey('BottomResizeDraggable');

  /// A key used to identify the top resize handle.
  static const topResizeDraggable = ValueKey('TopResizeDraggable');

  TileComponents<T> get tileComponents => widget.tileComponents;
  Widget? get verticalResizeHandle => tileComponents.verticalResizeHandle;
  Widget? get horizontalResizeHandle => tileComponents.horizontalResizeHandle;
  bool get continuesBefore => widget.event.startAsUtc.isBefore(widget.dateTimeRange.start);
  bool get continuesAfter => widget.event.endAsUtc.isAfter(widget.dateTimeRange.end);
  bool get showStart => widget.interaction.value.allowResizing && widget.event.canModify && !continuesBefore;
  bool get showEnd => widget.interaction.value.allowResizing && widget.event.canModify && !continuesAfter;
  bool get canReschedule => widget.interaction.value.allowRescheduling && widget.event.canModify;

  CalendarEvent? _event;

  @override
  void initState() {
    widget.selectedEvent.addListener(update);
    super.initState();
  }

  @override
  void dispose() {
    widget.selectedEvent.removeListener(update);
    super.dispose();
  }

  void update() {
    if (widget.selectedEvent.value != _event) {
      setState(() => _event = widget.selectedEvent.value);
    }
  }

  bool _shouldShow = false;

  @override
  Widget build(BuildContext context) {
    late final top = Draggable<Resize<T>>(
      key: topResizeDraggable,
      data: widget.resizeEvent(ResizeDirection.top),
      feedback: const SizedBox(),
      dragAnchorStrategy: pointerDragAnchorStrategy,
      onDragStarted: widget.selectEvent,
      child: verticalResizeHandle ?? Container(color: Colors.transparent),
    );

    late final bottom = Draggable<Resize<T>>(
      key: bottomResizeDraggable,
      data: widget.resizeEvent(ResizeDirection.bottom),
      feedback: const SizedBox(),
      dragAnchorStrategy: pointerDragAnchorStrategy,
      onDragStarted: widget.selectEvent,
      child: verticalResizeHandle ?? Container(color: Colors.transparent),
    );

    late final handles = widget.tileComponents.verticalHandlePositioner?.call(
          top,
          bottom,
          showStart,
          showEnd,
        ) ??
        VerticalTileResizeHandlePositioner(
          startResizeDetector: top,
          endResizeDetector: bottom,
          showStart: showStart,
          showEnd: showEnd,
        );

    if (!isMobileDevice) {
      return ValueListenableBuilder(
        valueListenable: widget.interaction,
        builder: (context, value, child) {
          return MouseRegion(
            onEnter: (event) => setState(() => _shouldShow = true),
            onExit: (event) => setState(() => _shouldShow = false),
            hitTestBehavior: HitTestBehavior.translucent,
            child: (widget.controller.selectedEvent.value == null && _shouldShow) ? handles : const SizedBox.shrink(),
          );
        },
      );
    } else {
      return ValueListenableBuilder(
        valueListenable: widget.controller.selectedEvent,
        builder: (context, value, child) {
          if (value != widget.event) return const SizedBox();
          return handles;
        },
      );
    }
  }
}

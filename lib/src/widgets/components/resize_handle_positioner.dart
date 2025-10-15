import 'dart:math';

import 'package:flutter/material.dart';
import 'package:kalender/kalender.dart';
import 'package:kalender/src/models/calendar_events/draggable_event.dart';
import 'package:kalender/src/models/providers/calendar_provider.dart';
import 'package:kalender/src/platform.dart';
import 'package:kalender/src/widgets/event_tiles/event_tile.dart';

/// An base class for widgets that position resize handles.
abstract class ResizeHandles<T extends Object?> extends StatelessWidget {
  /// The event associated with the resize handles.
  final CalendarEvent<T> event;

  /// The global interaction settings for the calendar.
  final CalendarInteraction interaction;

  /// The tile components used to build the resize handles.
  final TileComponents<T> tileComponents;

  /// The DateTimeRange that the current view is displaying.
  final DateTimeRange dateTimeRange;

  /// The axis on which the resize handles are positioned.
  final Axis axis;

  /// The length of the tile on the axis.
  final double verticalLength;

  const ResizeHandles({
    super.key,
    required this.event,
    required this.axis,
    required this.interaction,
    required this.tileComponents,
    required this.dateTimeRange,
    required this.verticalLength,
  });

  bool get isMobile => isMobileDevice;
  bool get isDesktop => !isMobileDevice;

  bool get isVertical => axis == Axis.vertical;

  /// Whether the event continues before the current date range.
  bool get continuesBefore => event.startAsUtc.isBefore(dateTimeRange.start);

  /// Whether the event continues after the current date range.
  bool get continuesAfter => event.endAsUtc.isAfter(dateTimeRange.end);

  /// Whether to show the start resize handle.
  bool get showStart => interaction.allowResizing && event.interaction.allowStartResize && !continuesBefore;

  /// Whether to show the end resize handle.
  bool get showEnd => interaction.allowResizing && event.interaction.allowEndResize && !continuesAfter;

  /// The interaction settings for this event.
  EventInteraction get eventInteraction => event.interaction;

  /// The resize handle to use.
  Widget get resizeHandle =>
      (axis == Axis.vertical ? tileComponents.verticalResizeHandle : tileComponents.horizontalResizeHandle) ??
      const SizedBox();

  /// A key used to identify the top resize handle.
  static Key startResizeDraggableKey(int eventId, Axis axis) =>
      Key('DayEventTile-${axis == Axis.vertical ? "Top" : "Left"}ResizeDraggable-$eventId');

  /// A key used to identify the bottom resize handle.
  static Key endResizeDraggableKey(int eventId, Axis axis) =>
      Key('DayEventTile-${axis == Axis.vertical ? "Bottom" : "Right"}ResizeDraggable-$eventId');

  /// The start resize detector.
  ///
  /// The direction is determined by the axis.
  Widget get startResizeDetector => EventResize<T>(
        key: startResizeDraggableKey(event.id, axis),
        event: event,
        tileComponents: tileComponents,
        direction: axis == Axis.vertical ? ResizeDirection.top : ResizeDirection.left,
      );

  /// The end resize detector.
  ///
  /// The direction is determined by the axis.
  Widget get endResizeDetector => EventResize<T>(
        key: endResizeDraggableKey(event.id, axis),
        event: event,
        tileComponents: tileComponents,
        direction: axis == Axis.vertical ? ResizeDirection.bottom : ResizeDirection.right,
      );
}

/// The base class for the ResizeDetectorPositioner.
class DefaultResizeHandles<T extends Object?> extends ResizeHandles<T> {
  const DefaultResizeHandles({
    required super.event,
    required super.axis,
    required super.interaction,
    required super.tileComponents,
    required super.dateTimeRange,
    required super.verticalLength,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    if (!showStart && !showEnd) {
      // If neither handle should be shown, return an empty widget.
      return const SizedBox();
    }

    if (isMobile && axis == Axis.horizontal) {
      // On mobile, we do not show horizontal resize handles.
      return const SizedBox();
    }

    // Determine the length of the handles based on the axis, length and device type.
    final handleLength = switch (axis) {
      Axis.vertical => switch (isMobile) {
          true => 12.0,
          false => min(verticalLength * 0.25, 12).toDouble(),
        },
      Axis.horizontal => 12.0,
    };

    // Determine whether to hide the start resize handle.
    final hideStart = (handleLength * 2) > (verticalLength / 2);

    return Stack(
      fit: StackFit.expand,
      children: [
        if (!hideStart && showStart)
          isVertical
              ? Positioned(
                  top: 0,
                  left: 0,
                  right: isMobileDevice ? null : 0,
                  width: isMobileDevice ? handleLength : null,
                  height: handleLength,
                  child: startResizeDetector,
                )
              : Positioned(
                  left: 0,
                  top: 0,
                  bottom: 0,
                  width: handleLength,
                  child: startResizeDetector,
                ),
        if (showEnd)
          isVertical
              ? Positioned(
                  bottom: 0,
                  left: isMobileDevice ? null : 0,
                  right: 0,
                  width: isMobileDevice ? handleLength : null,
                  height: handleLength,
                  child: endResizeDetector,
                )
              : Positioned(
                  right: 0,
                  top: 0,
                  bottom: 0,
                  width: handleLength,
                  child: endResizeDetector,
                ),
      ],
    );
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
  @override
  CalendarEvent<T> get event => widget.event;

  @override
  TileComponents<T> get tileComponents => widget.tileComponents;

  CalendarController<T>? _controller;
  bool _showHandle = isMobileDevice ? false : true;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _controller = context.calendarController<T>();
      if (isMobileDevice) _controller?.selectedEvent.addListener(listener);
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
    if (!_showHandle) return const SizedBox();

    final resizeHandle = widget.direction == ResizeDirection.left || widget.direction == ResizeDirection.right
        ? horizontalResizeHandle
        : verticalResizeHandle;

    // TODO: add a gesture detector here that can call onTapped/onLongPressed too.
    return Draggable<Resize<T>>(
      data: resizeEvent(widget.direction),
      feedback: const SizedBox(),
      dragAnchorStrategy: pointerDragAnchorStrategy,
      onDragStarted: () => selectEvent(context),
      child: resizeHandle ?? Container(color: Colors.transparent),
    );
  }
}

/// TODO: Depricate.
/// The base class for the ResizeDetectorPositioner.
abstract class ResizeHandlePositionerWidget extends StatelessWidget {
  /// The top/left resize detector.
  final Widget startResizeDetector;

  /// The bottom/right resize detector.
  final Widget endResizeDetector;

  /// Should the start resize detector be show.
  final bool showStart;

  /// Should the end resize detector be show.
  final bool showEnd;

  const ResizeHandlePositionerWidget({
    required this.startResizeDetector,
    required this.endResizeDetector,
    required this.showStart,
    required this.showEnd,
    super.key,
  });
}

// // TODO: REDO THIS SO WE DO NOT HAVE TO USE A LAYOUT BUILDER :D.
// /// A widget that positions the resize handles for a day event tile.
// class VerticalTileResizeHandlePositioner extends ResizeHandlePositionerWidget {
//   const VerticalTileResizeHandlePositioner({
//     super.key,
//     required super.startResizeDetector,
//     required super.endResizeDetector,
//     required super.showStart,
//     required super.showEnd,
//   });

//   static VerticalTileResizeHandlePositioner verticalTileResizeHandlePositionerBuilder(
//     Widget startResizeDetector,
//     Widget endResizeDetector,
//     bool showStart,
//     bool showEnd,
//   ) {
//     return VerticalTileResizeHandlePositioner(
//       startResizeDetector: startResizeDetector,
//       endResizeDetector: endResizeDetector,
//       showStart: showStart,
//       showEnd: showEnd,
//     );
//   }

//   @override
//   Widget build(BuildContext context) {
//     return LayoutBuilder(
//       builder: (context, constraints) {
//         late final showTop = constraints.maxHeight > (isMobileDevice ? kMinInteractiveDimension : 24);

//         double resizeHeight;
//         if (isMobileDevice) {
//           resizeHeight = 12.0;
//         } else {
//           resizeHeight = min(12, constraints.maxHeight / 4);
//         }

//         return Stack(
//           children: [
//             if (showTop && showStart)
//               Positioned(
//                 top: 0,
//                 left: 0,
//                 right: isMobileDevice ? null : 0,
//                 width: isMobileDevice ? resizeHeight : null,
//                 height: resizeHeight,
//                 child: startResizeDetector,
//               ),
//             if (showEnd)
//               Positioned(
//                 bottom: 0,
//                 left: isMobileDevice ? null : 0,
//                 right: 0,
//                 width: isMobileDevice ? resizeHeight : null,
//                 height: resizeHeight,
//                 child: endResizeDetector,
//               ),
//           ],
//         );
//       },
//     );
//   }
// }

// /// A widget that positions the resize handles for a day event tile.
// class HorizontalTileResizeHandlePositioner extends ResizeHandlePositionerWidget {
//   const HorizontalTileResizeHandlePositioner({
//     super.key,
//     required super.startResizeDetector,
//     required super.endResizeDetector,
//     required super.showStart,
//     required super.showEnd,
//   });

//   static HorizontalTileResizeHandlePositioner horizontalTileResizeHandlePositionerBuilder(
//     Widget startResizeDetector,
//     Widget endResizeDetector,
//     bool showStart,
//     bool showEnd,
//   ) {
//     return HorizontalTileResizeHandlePositioner(
//       startResizeDetector: startResizeDetector,
//       endResizeDetector: endResizeDetector,
//       showStart: showStart,
//       showEnd: showEnd,
//     );
//   }

//   @override
//   Widget build(BuildContext context) {
//     return LayoutBuilder(
//       builder: (context, constraints) {
//         late final resizeWidth = min(constraints.maxWidth * 0.25, 24.0);

//         return Stack(
//           children: [
//             if (showStart && !isMobileDevice)
//               Positioned(
//                 top: 0,
//                 bottom: 0,
//                 left: 0,
//                 width: resizeWidth,
//                 child: startResizeDetector,
//               ),
//             if (showEnd && !isMobileDevice)
//               Positioned(
//                 top: 0,
//                 bottom: 0,
//                 right: 0,
//                 width: resizeWidth,
//                 child: endResizeDetector,
//               ),
//           ],
//         );
//       },
//     );
//   }
// }

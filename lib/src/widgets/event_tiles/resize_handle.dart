import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:kalender/src/enumerations.dart';
import 'package:kalender/src/models/calendar_events/calendar_event.dart';
import 'package:kalender/src/models/calendar_events/draggable_event.dart';
import 'package:kalender/src/models/calendar_interaction.dart';
import 'package:kalender/src/models/components/tile_components.dart';
import 'package:kalender/src/models/controllers/calendar_controller.dart';
import 'package:kalender/src/models/providers/calendar_provider.dart';
import 'package:kalender/src/platform.dart';
import 'package:kalender/src/widgets/components/resize_handles.dart';

/// A widget that positions the resize handles for an event tile.
class ResizeHandleWidget<T extends Object?> extends StatefulWidget {
  /// The event associated with the resize handles.
  final CalendarEvent<T> event;

  /// The global interaction settings for the calendar.
  final CalendarInteraction interaction;

  /// The tile components used to build the resize handles.
  final TileComponents<T> tileComponents;

  /// The DateTimeRange that the current view is displaying.
  final DateTimeRange dateTimeRange;

  /// The axis along which the resize handles are positioned.
  final Axis axis;

  /// Creates an instance of [ResizeHandleWidget].
  const ResizeHandleWidget({
    super.key,
    required this.event,
    required this.interaction,
    required this.tileComponents,
    required this.dateTimeRange,
    this.axis = Axis.vertical,
  });

  @override
  State<ResizeHandleWidget<T>> createState() => _ResizeHandleWidgetState<T>();
}

/// The state for the ResizeHandleWidget.
///
/// This state listens to the calendar controller to show or hide the resize handles
/// based on user interaction.
class _ResizeHandleWidgetState<T extends Object?> extends State<ResizeHandleWidget<T>> {
  /// The calendar controller.
  late CalendarController<T> _controller;

  /// Whether to show the resize handles.
  bool _showHandles = false;

  /// The size of the event tile.
  Size _size = Size.zero;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _controller = context.calendarController<T>();
      _controller.selectedEvent.addListener(listener);
      setState(() => _size = context.size ?? Size.zero);
    });
  }

  @override
  void didUpdateWidget(covariant ResizeHandleWidget<T> oldWidget) {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      setState(() => _size = context.size ?? Size.zero);
    });
    super.didUpdateWidget(oldWidget);
  }

  @override
  void dispose() {
    _controller.selectedEvent.removeListener(listener);
    super.dispose();
  }

  /// The listener for the calendar controller's selected event.
  ///
  /// This listener updates the visibility of the resize handles based on whether the current event
  /// is selected and the device type.
  void listener() {
    if (isMobileDevice) {
      final selectedEvent = _controller.selectedEvent.value;
      if (selectedEvent != null && selectedEvent.id == widget.event.id) {
        setState(() => _showHandles = true);
      } else {
        setState(() => _showHandles = false);
      }
    } else if (_showHandles == true && _controller.internalFocus) {
      setState(() => _showHandles = false);
    }
  }

  /// [PointerEnterEvent] handler to show/hide resize handles on non-mobile devices.
  void _onEnter(PointerEnterEvent event) {
    if (isMobileDevice) return;
    if (_controller.internalFocus == true) return;
    if (_showHandles == false) setState(() => _showHandles = true);
  }

  /// [PointerExitEvent] handler to show/hide resize handles on non-mobile devices.
  void _onExit(PointerExitEvent event) {
    if (isMobileDevice) return;
    if (_showHandles == true) setState(() => _showHandles = false);
  }

  /// [PointerHoverEvent] handler to show/hide resize handles on non-mobile devices.
  void _onHover(PointerHoverEvent event) {
    if (_controller.internalFocus == true) return;
    if (_showHandles == false) setState(() => _showHandles = true);
  }

  @override
  Widget build(BuildContext context) {
    final visibility = Visibility(
      visible: _showHandles && _size != Size.zero,
      maintainState: false,
      child: ResizeHandles.builder(
        widget.event,
        widget.interaction,
        widget.tileComponents,
        widget.dateTimeRange,
        _size,
        widget.axis,
        context.location,
      ),
    );

    if (isMobileDevice) {
      return visibility;
    } else {
      return MouseRegion(
        onEnter: _onEnter,
        onExit: _onExit,
        onHover: _onHover,
        opaque: false,
        child: visibility,
      );
    }
  }
}

/// A widget that detects resize gestures for an event.
class ResizeHandle<T extends Object?> extends StatelessWidget {
  /// The direction of the resize.
  final ResizeDirection direction;

  /// The event associated with the resize handle.
  final CalendarEvent<T> event;

  /// The tile components used to build the resize handle.
  final TileComponents<T> tileComponents;

  /// Creates an instance of [ResizeHandle].
  const ResizeHandle({
    super.key,
    required this.event,
    required this.tileComponents,
    required this.direction,
  });

  /// The resize event data.
  Resize<T> get data => Resize<T>(event: event, direction: direction);

  @override
  Widget build(BuildContext context) {
    final resizeHandle = direction == ResizeDirection.left || direction == ResizeDirection.right
        ? tileComponents.horizontalResizeHandle
        : tileComponents.verticalResizeHandle;

    return Draggable<Resize<T>>(
      data: data,
      feedback: const SizedBox(),
      dragAnchorStrategy: pointerDragAnchorStrategy,
      onDragStarted: () {
        context.calendarController<T>().selectEvent(event, internal: true);
        context.callbacks<T>()?.onEventChange?.call(event);
      },
      child: resizeHandle ?? Container(color: Colors.transparent),
    );
  }
}

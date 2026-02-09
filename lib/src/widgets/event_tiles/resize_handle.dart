import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:kalender/src/enumerations.dart';
import 'package:kalender/src/models/calendar_events/calendar_event.dart';
import 'package:kalender/src/models/calendar_events/draggable_event.dart';
import 'package:kalender/src/models/components/tile_components.dart';
import 'package:kalender/src/models/controllers/calendar_controller.dart';
import 'package:kalender/src/models/providers/calendar_provider.dart';
import 'package:kalender/src/platform.dart';
import 'package:kalender/src/widgets/components/resize_handles.dart';

/// A widget that positions the resize handles for an event tile.
class ResizeHandleWidget extends StatefulWidget {
  /// The event associated with the resize handles.
  final CalendarEvent event;

  /// The tile components used to build the resize handles.
  final TileComponents tileComponents;

  /// The DateTimeRange that the current view is displaying.
  final DateTimeRange dateTimeRange;

  /// The axis along which the resize handles are positioned.
  final Axis axis;

  /// Creates an instance of [ResizeHandleWidget].
  const ResizeHandleWidget({
    super.key,
    required this.event,
    required this.tileComponents,
    required this.dateTimeRange,
    this.axis = Axis.vertical,
  });

  @override
  State<ResizeHandleWidget> createState() => _ResizeHandleWidgetState();
}

/// The state for the ResizeHandleWidget.
///
/// This state listens to the calendar controller to show or hide the resize handles
/// based on user interaction.
class _ResizeHandleWidgetState extends State<ResizeHandleWidget> {
  /// The calendar controller (nullable to handle dispose before initialization).
  CalendarController? _controller;

  /// Whether to show the resize handles.
  bool _showHandles = false;

  /// The size of the event tile.
  Size _size = Size.zero;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;
      _controller = context.calendarController();
      _controller?.selectedEvent.addListener(listener);
      setState(() => _size = context.size ?? Size.zero);
    });
  }

  @override
  void didUpdateWidget(covariant ResizeHandleWidget oldWidget) {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) setState(() => _size = context.size ?? Size.zero);
    });
    super.didUpdateWidget(oldWidget);
  }

  @override
  void dispose() {
    _controller?.selectedEvent.removeListener(listener);
    super.dispose();
  }

  /// The listener for the calendar controller's selected event.
  ///
  /// This listener updates the visibility of the resize handles based on whether the current event
  /// is selected and the device type.
  void listener() {
    final controller = _controller;
    if (controller == null) return;

    if (isMobileDevice) {
      final selectedEvent = controller.selectedEvent.value;
      if (selectedEvent != null && selectedEvent.id == widget.event.id) {
        if (mounted) setState(() => _showHandles = true);
      } else {
        if (mounted) setState(() => _showHandles = false);
      }
    } else if (_showHandles == true && controller.internalFocus) {
      if (mounted) setState(() => _showHandles = false);
    }
  }

  /// [PointerEnterEvent] handler to show/hide resize handles on non-mobile devices.
  void _onEnter(PointerEnterEvent event) {
    if (isMobileDevice) return;
    if (_controller?.internalFocus == true) return;
    if (_showHandles == false && mounted) setState(() => _showHandles = true);
  }

  /// [PointerExitEvent] handler to show/hide resize handles on non-mobile devices.
  void _onExit(PointerExitEvent event) {
    if (isMobileDevice) return;
    if (_showHandles == true && mounted) setState(() => _showHandles = false);
  }

  /// [PointerHoverEvent] handler to show/hide resize handles on non-mobile devices.
  void _onHover(PointerHoverEvent event) {
    if (_controller?.internalFocus == true) return;
    if (_showHandles == false && mounted) setState(() => _showHandles = true);
  }

  @override
  Widget build(BuildContext context) {
    final visibility = Visibility(
      visible: _showHandles && _size != Size.zero,
      maintainState: false,
      child: ResizeHandles.builder(
        widget.event,
        context.interaction,
        widget.tileComponents,
        widget.dateTimeRange,
        _size,
        widget.axis,
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
class ResizeHandle extends StatelessWidget {
  /// The direction of the resize.
  final ResizeDirection direction;

  /// The event associated with the resize handle.
  final CalendarEvent event;

  /// The tile components used to build the resize handle.
  final TileComponents tileComponents;

  /// Creates an instance of [ResizeHandle].
  const ResizeHandle({
    super.key,
    required this.event,
    required this.tileComponents,
    required this.direction,
  });

  /// The resize event data.
  Resize get data => Resize(event: event, direction: direction);

  @override
  Widget build(BuildContext context) {
    final resizeHandle = direction == ResizeDirection.left || direction == ResizeDirection.right
        ? tileComponents.horizontalResizeHandle
        : tileComponents.verticalResizeHandle;

    return Draggable<Resize>(
      data: data,
      feedback: const SizedBox(),
      dragAnchorStrategy: pointerDragAnchorStrategy,
      onDragStarted: () {
        context.calendarController().selectEvent(event, internal: true);
        context.callbacks()?.onEventChange?.call(event);
      },
      child: resizeHandle ?? Container(color: Colors.transparent),
    );
  }
}

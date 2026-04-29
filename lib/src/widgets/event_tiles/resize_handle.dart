import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:kalender/src/enumerations.dart';
import 'package:kalender/src/models/calendar_events/calendar_event.dart';
import 'package:kalender/src/models/calendar_events/draggable_event.dart';
import 'package:kalender/src/models/calendar_interaction.dart';
import 'package:kalender/src/models/components/tile_components.dart';
import 'package:kalender/src/models/controllers/calendar_controller.dart';
import 'package:kalender/src/models/providers/calendar_provider.dart';
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

  /// Whether the resize handles are shown due to a hover event (precise input).
  bool _showFromHover = false;

  /// Whether the resize handles are shown due to event selection (imprecise input).
  bool _showFromSelection = false;

  /// Whether the pointer event should be treated as precise input.
  bool _isPrecisePointer(PointerEvent event) {
    return switch (event.kind) {
      PointerDeviceKind.mouse || PointerDeviceKind.stylus || PointerDeviceKind.invertedStylus => true,
      _ => false,
    };
  }

  /// Whether to show the resize handles (derived from hover or selection).
  bool get _showHandles => _showFromHover || _showFromSelection;

  /// The size of the event tile.
  Size _size = Size.zero;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;
      _controller = context.calendarController;
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
  /// is selected or if an internal drag operation is in progress.
  void listener() {
    final controller = _controller;
    if (controller == null) return;

    if (controller.internalFocus) {
      // Suppress handles during internal drag/resize operations.
      if ((_showFromHover || _showFromSelection) && mounted) {
        setState(() {
          _showFromHover = false;
          _showFromSelection = false;
        });
      }
      return;
    }

    final selectedEvent = controller.selectedEvent.value;
    final isSelected = selectedEvent != null && selectedEvent.id == widget.event.id;
    if (isSelected != _showFromSelection && mounted) {
      setState(() => _showFromSelection = isSelected);
    }
  }

  /// [PointerEnterEvent] handler to show resize handles on hover (precise input).
  void _onEnter(PointerEnterEvent event) {
    if (_controller?.internalFocus == true) return;
    if (!_isPrecisePointer(event)) return;
    if (!_showFromHover && mounted) setState(() => _showFromHover = true);
  }

  /// [PointerExitEvent] handler to hide resize handles when the pointer leaves.
  void _onExit(PointerExitEvent event) {
    if (_showFromHover && mounted) setState(() => _showFromHover = false);
  }

  /// [PointerHoverEvent] handler to show resize handles on hover (precise input).
  void _onHover(PointerHoverEvent event) {
    if (_controller?.internalFocus == true) return;
    if (!_isPrecisePointer(event)) return;
    if (!_showFromHover && mounted) setState(() => _showFromHover = true);
  }

  /// Resolves whether the current input is imprecise.
  ///
  /// If the [InputMode] is [InputMode.auto], the input is considered imprecise
  /// when the handles were shown via selection (not hover).
  /// Otherwise, the explicit [InputMode] setting is used.
  bool _resolveIsImprecise(CalendarInteraction interaction) {
    return switch (interaction.inputMode) {
      InputMode.precise => false,
      InputMode.imprecise => true,
      InputMode.auto => !_showFromHover,
    };
  }

  @override
  Widget build(BuildContext context) {
    final interaction = context.interaction;
    final isImprecise = _resolveIsImprecise(interaction);

    final visibility = Visibility(
      visible: _showHandles && _size != Size.zero,
      maintainState: false,
      child: ResizeHandles.builder(
        widget.event,
        interaction,
        widget.tileComponents,
        widget.dateTimeRange,
        _size,
        widget.axis,
        isImprecise,
      ),
    );

    return MouseRegion(
      onEnter: _onEnter,
      onExit: _onExit,
      onHover: _onHover,
      opaque: false,
      child: visibility,
    );
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

  /// The length of the resize handle.
  final double length;

  /// Creates an instance of [ResizeHandle].
  const ResizeHandle({
    super.key,
    required this.event,
    required this.tileComponents,
    required this.direction,
    required this.length,
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
      feedback: Container(
        color: Colors.transparent,
        width: length,
        height: 10,
      ),
      dragAnchorStrategy: tileComponents.dragAnchorStrategy ?? childDragAnchorStrategy,
      onDragStarted: () {
        context.calendarController.selectEvent(event, internal: true);
        context.callbacks?.onEventChange?.call(event);
      },
      child: resizeHandle ?? Container(color: Colors.transparent),
    );
  }
}

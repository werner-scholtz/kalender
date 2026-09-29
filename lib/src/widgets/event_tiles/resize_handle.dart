// This file is part of kalender.
//
// SPDX-FileCopyrightText: 2023 Klarälvdalens Datakonsult AB, a KDAB Group company <info@kdab.com>
//
// SPDX-License-Identifier: MIT

import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:kalender/src/enumerations.dart';
import 'package:kalender/src/models/components/tile_components.dart';
import 'package:kalender/src/models/controllers/kalender_controller.dart';
import 'package:kalender/src/models/floating_date_time_range.dart';
import 'package:kalender/src/models/kalender_events/draggable_event.dart';
import 'package:kalender/src/models/kalender_events/kalender_event.dart';
import 'package:kalender/src/models/kalender_interaction.dart';
import 'package:kalender/src/models/providers/kalender_provider.dart';
import 'package:kalender/src/widgets/components/resize_handles.dart';

/// A widget that positions the resize handles for an event tile.
class ResizeHandleWidget extends StatefulWidget {
  /// The event associated with the resize handles.
  final KalenderEvent event;

  /// The FloatingDateTimeRange that the current view is displaying.
  final FloatingDateTimeRange floatingRange;

  /// The axis along which the resize handles are positioned.
  final Axis axis;

  const ResizeHandleWidget({super.key, required this.event, required this.floatingRange, this.axis = Axis.vertical});

  @override
  State<ResizeHandleWidget> createState() => _ResizeHandleWidgetState();
}

class _ResizeHandleWidgetState extends State<ResizeHandleWidget> {
  KalenderController? _controller;

  /// Whether the resize handles are shown due to a hover event (precise input).
  bool _showFromHover = false;

  /// Whether the pointer event should be treated as precise input.
  bool _isPrecisePointer(PointerEvent event) {
    return switch (event.kind) {
      PointerDeviceKind.mouse || PointerDeviceKind.stylus || PointerDeviceKind.invertedStylus => true,
      _ => false,
    };
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _controller = context.kalenderController;
  }

  /// Shows the resize handles on enter and hover from a precise pointer.
  void _show(PointerEvent event) {
    if (_controller?.internalFocus == true) return;
    if (!_isPrecisePointer(event)) return;
    if (!_showFromHover && mounted) setState(() => _showFromHover = true);
  }

  /// [PointerExitEvent] handler to hide resize handles when the pointer leaves.
  void _onExit(PointerExitEvent event) {
    if (_showFromHover && mounted) setState(() => _showFromHover = false);
  }

  /// Resolves whether the current input is imprecise.
  ///
  /// If the [InputMode] is [InputMode.auto], the input is considered imprecise when the handles were shown via
  /// selection (not hover). Otherwise, the explicit [InputMode] setting is used.
  bool _resolveIsImprecise(KalenderInteraction interaction) {
    return switch (interaction.inputMode) {
      InputMode.precise => false,
      InputMode.imprecise => true,
      InputMode.auto => !_showFromHover,
    };
  }

  @override
  Widget build(BuildContext context) {
    final selection = SelectionModel.of(context, widget.event.id);
    final showFromHover = _showFromHover && !SelectionModel.anyMoving(context);
    final showHandles = showFromHover || (selection.selected && !selection.moving);

    return MouseRegion(
      onEnter: _show,
      onExit: _onExit,
      onHover: _show,
      opaque: false,
      child: showHandles ? LayoutBuilder(builder: _buildHandles) : const SizedBox.shrink(),
    );
  }

  Widget _buildHandles(BuildContext context, BoxConstraints constraints) {
    final size = constraints.biggest;
    if (size.isEmpty) return const SizedBox.shrink();

    final interaction = context.interaction;
    return context.tileComponents.buildResizeHandles(
      context,
      ResizeHandleDetails(
        event: widget.event,
        interaction: interaction,
        range: widget.floatingRange,
        size: size,
        axis: widget.axis,
        isImprecise: _resolveIsImprecise(interaction),
        location: context.location,
      ),
    );
  }
}

/// The draggable that detects a resize gesture, wrapping the handle widget from [TileComponents.verticalResizeHandle]
/// or [TileComponents.horizontalResizeHandle].
///
/// {@category Interaction}
class ResizeDetector extends StatelessWidget {
  /// The direction of the resize.
  final ResizeDirection direction;

  /// The event associated with the resize handle.
  final KalenderEvent event;

  const ResizeDetector({super.key, required this.event, required this.direction});

  /// A key used to identify the start resize handle.
  static Key startResizeDraggableKey(String eventId) => Key('ResizeDetector-Start-$eventId');

  /// A key used to identify the end resize handle.
  static Key endResizeDraggableKey(String eventId) => Key('ResizeDetector-End-$eventId');

  /// The resize event data.
  Resize get data => Resize(event: event, direction: direction);

  @override
  Widget build(BuildContext context) {
    final isVertical = direction.vertical;
    final tileComponents = context.tileComponents;
    final resizeHandle = isVertical ? tileComponents.verticalResizeHandle : tileComponents.horizontalResizeHandle;

    // Anchor a vertical resize to the pointer so the target day follows the cursor itself. With childDragAnchorStrategy
    // the drag reports the handle's top-left, which for a full-width vertical handle is the column's left edge, so the
    // day flipped to the previous column on the smallest sideways move. A caller-provided resizeDragAnchorStrategy
    // still wins.
    final anchorStrategy =
        tileComponents.resizeDragAnchorStrategy ?? (isVertical ? pointerDragAnchorStrategy : childDragAnchorStrategy);

    return Draggable<Resize>(
      data: data,
      feedback: const SizedBox(),
      dragAnchorStrategy: anchorStrategy,
      onDragStarted: () {
        context.kalenderController.selectEvent(event, internal: true);
        context.callbacks?.onEventChange?.call(event);
      },
      child: resizeHandle ?? Container(color: Colors.transparent),
    );
  }
}

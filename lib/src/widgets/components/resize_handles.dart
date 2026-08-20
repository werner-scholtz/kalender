import 'package:flutter/material.dart';

import 'package:kalender/src/enumerations.dart';
import 'package:kalender/src/layout_delegates/event_layout_delegate.dart';
import 'package:kalender/src/models/calendar_interaction.dart';
import 'package:kalender/src/models/components/tile_components.dart';
import 'package:kalender/src/models/providers/calendar_provider.dart';
import 'package:kalender/src/widgets/event_tiles/resize_handle.dart';

/// The builder that positions the resize handles of an event tile.
///
/// [details] carries the event, the tile geometry and the helpers that decide
/// which handles to show and build them.
typedef ResizeHandlePositioner = Widget Function(
  BuildContext context,
  ResizeHandleDetails details,
);

/// What a [ResizeHandlePositioner] needs to lay out the resize handles of one event tile.
class ResizeHandleDetails {
  /// The event associated with the resize handles.
  final CalendarEvent event;

  /// The global interaction settings for the calendar.
  final CalendarInteraction interaction;

  /// The DateTimeRange that the current view is displaying.
  final DateTimeRange dateTimeRange;

  /// The size of the event tile.
  final Size size;

  /// The axis along which the resize handles are positioned.
  final Axis axis;

  /// Whether the current input is imprecise (e.g. touch/finger).
  ///
  /// When `true`, resize handles are positioned at corners for easier targeting.
  /// When `false`, resize handles span the full width/height of the event tile.
  final bool isImprecise;

  const ResizeHandleDetails({
    required this.event,
    required this.interaction,
    required this.dateTimeRange,
    required this.size,
    required this.axis,
    required this.isImprecise,
  });

  /// Whether the axis is vertical.
  bool get isVertical => axis == Axis.vertical;

  /// The interaction settings for this event.
  EventInteraction get eventInteraction => event.interaction;

  /// Whether the event continues before the current date range.
  bool continuesBefore({Location? location}) => event.internalStart(location: location).isBefore(dateTimeRange.start);

  /// Whether the event continues after the current date range.
  bool continuesAfter({Location? location}) => event.internalEnd(location: location).isAfter(dateTimeRange.end);

  /// Whether to show the start resize handle, based on interaction settings and event continuation.
  bool showStart({Location? location}) =>
      interaction.allowResizing && event.interaction.allowStartResize && !continuesBefore(location: location);

  /// Whether to show the end resize handle, based on interaction settings and event continuation.
  bool showEnd({Location? location}) =>
      interaction.allowResizing && event.interaction.allowEndResize && !continuesAfter(location: location);

  /// The resize handle to use, resolved from the [TileComponents] of [context].
  ///
  /// Resolves the handle for [axis] unless another one is given.
  Widget resizeHandle(BuildContext context, {Axis? axis}) {
    final components = context.tileComponents;
    final effective = axis ?? this.axis;
    return (effective == Axis.vertical ? components.verticalResizeHandle : components.horizontalResizeHandle) ??
        const SizedBox();
  }

  /// The start resize detector.
  ///
  /// The direction is determined by [axis].
  ResizeDetector get startResizeDetector => ResizeDetector(
        key: ResizeDetector.startResizeDraggableKey(event.id),
        event: event,
        direction: isVertical ? ResizeDirection.top : ResizeDirection.left,
      );

  /// The end resize detector.
  ///
  /// The direction is determined by [axis].
  ResizeDetector get endResizeDetector => ResizeDetector(
        key: ResizeDetector.endResizeDraggableKey(event.id),
        event: event,
        direction: isVertical ? ResizeDirection.bottom : ResizeDirection.right,
      );
}

/// The default layout for the resize handles of an event tile.
class DefaultResizeHandles extends StatelessWidget {
  /// The event tile the handles are positioned on.
  final ResizeHandleDetails details;

  const DefaultResizeHandles({required this.details, super.key});

  @override
  Widget build(BuildContext context) {
    final location = context.location;
    if (!details.showStart(location: location) && !details.showEnd(location: location)) {
      // If neither handle should be shown, return an empty widget.
      return const SizedBox();
    }

    final isImprecise = details.isImprecise;
    final isVertical = details.isVertical;

    if (isImprecise && !isVertical && !details.interaction.allowHorizontalImpreciseResize) {
      // Horizontal resize handles are not supported by default for imprecise input.
      // This is because they will be super small and hard to interact with.
      return const SizedBox();
    }

    final length = isVertical ? details.size.height : details.size.width;

    // The length of the resize handle.
    // TODO: Make this configurable in the future.
    final handleLength = isImprecise ? 24.0 : 16.0;

    // Determine whether to hide the start resize handle.
    final hideStart = (handleLength * 2) > (length / 2);

    return Stack(
      fit: StackFit.expand,
      children: [
        if (!hideStart && details.showStart(location: location))
          isVertical
              ? Positioned(
                  top: 0,
                  left: 0,
                  right: isImprecise ? null : 0,
                  width: isImprecise ? handleLength : null,
                  height: handleLength,
                  child: details.startResizeDetector,
                )
              : Positioned(
                  left: 0,
                  top: 0,
                  bottom: 0,
                  width: handleLength,
                  child: details.startResizeDetector,
                ),
        if (details.showEnd(location: location))
          isVertical
              ? Positioned(
                  bottom: 0,
                  left: isImprecise ? null : 0,
                  right: 0,
                  width: isImprecise ? handleLength : null,
                  height: handleLength,
                  child: details.endResizeDetector,
                )
              : Positioned(
                  right: 0,
                  top: 0,
                  bottom: 0,
                  width: handleLength,
                  child: details.endResizeDetector,
                ),
      ],
    );
  }
}

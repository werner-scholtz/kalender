import 'package:flutter/material.dart';

import 'package:kalender/src/enumerations.dart';
import 'package:kalender/src/layout_delegates/event_layout_delegate.dart';
import 'package:kalender/src/models/calendar_interaction.dart';
import 'package:kalender/src/models/components/tile_components.dart';
import 'package:kalender/src/models/providers/calendar_provider.dart';
import 'package:kalender/src/platform.dart';
import 'package:kalender/src/widgets/event_tiles/resize_handle.dart';
import 'package:timezone/timezone.dart';

/// The builder that positions the ResizeHandles.
///
/// [event] is the event associated with the resize handles.
/// [interaction] is the global interaction settings for the calendar.
/// [tileComponents] are the tile components used to build the resize handles.
/// [dateTimeRange] is the DateTimeRange that the current view is displaying.
/// [size] is the size of the event tile.
/// [axis] is the axis along which the resize handles are positioned.
typedef ResizeHandlePositioner<T extends Object?> = ResizeHandles<T> Function(
  CalendarEvent<T> event,
  CalendarInteraction interaction,
  TileComponents<T> tileComponents,
  DateTimeRange dateTimeRange,
  Size size,
  Axis axis,
);

/// The base class for the ResizeDetectorPositioner.
abstract class ResizeHandles<T extends Object?> extends StatelessWidget {
  /// The event associated with the resize handles.
  final CalendarEvent<T> event;

  /// The global interaction settings for the calendar.
  final CalendarInteraction interaction;

  /// The tile components used to build the resize handles.
  final TileComponents<T> tileComponents;

  /// The DateTimeRange that the current view is displaying.
  final DateTimeRange dateTimeRange;

  /// The size of the event tile.
  final Size size;

  /// The axis along which the resize handles are positioned.
  final Axis axis;

  const ResizeHandles({
    required this.event,
    required this.interaction,
    required this.tileComponents,
    required this.dateTimeRange,
    required this.size,
    required this.axis,
    super.key,
  });

  /// Builds the ResizeHandles using the provided [tileComponents] or the default implementation.
  static ResizeHandles<T> builder<T>(
    CalendarEvent<T> event,
    CalendarInteraction interaction,
    TileComponents<T> tileComponents,
    DateTimeRange dateTimeRange,
    Size size,
    Axis axis,
  ) {
    return tileComponents.resizeHandlePositioner?.call(
          event,
          interaction,
          tileComponents,
          dateTimeRange,
          size,
          axis,
        ) ??
        DefaultResizeHandles<T>(
          event: event,
          interaction: interaction,
          tileComponents: tileComponents,
          dateTimeRange: dateTimeRange,
          size: size,
          axis: axis,
        );
  }

  /// Whether the device is a mobile device.
  bool get isMobile => isMobileDevice;

  /// Whether the axis is vertical.
  bool get isVertical => axis == Axis.vertical;

  /// Whether the event continues before the current date range.
  bool continuesBefore([Location? location]) => event.internalStart(location).isBefore(dateTimeRange.start);

  /// Whether the event continues after the current date range.
  bool continuesAfter([Location? location]) => event.internalEnd(location).isAfter(dateTimeRange.end);

  /// Whether to show the start resize handle, based on interaction settings and event continuation.
  bool showStart([Location? location]) =>
      interaction.allowResizing && event.interaction.allowStartResize && !continuesBefore(location);

  /// Whether to show the end resize handle, based on interaction settings and event continuation.
  bool showEnd([Location? location]) =>
      interaction.allowResizing && event.interaction.allowEndResize && !continuesAfter(location);

  /// The interaction settings for this event.
  EventInteraction get eventInteraction => event.interaction;

  /// The resize handle to use.
  Widget resizeHandle(Axis axis) =>
      (axis == Axis.vertical ? tileComponents.verticalResizeHandle : tileComponents.horizontalResizeHandle) ??
      const SizedBox();

  /// A key used to identify the top resize handle.
  static Key startResizeDraggableKey(int eventId) => Key('DayEventTile-StartResizeDraggable-$eventId');

  /// A key used to identify the bottom resize handle.
  static Key endResizeDraggableKey(int eventId) => Key('DayEventTile-EndResizeDraggable-$eventId');

  /// The start resize detector.
  ///
  /// The direction is determined by the axis.
  Widget get startResizeDetector => ResizeHandle<T>(
        key: startResizeDraggableKey(event.id),
        event: event,
        tileComponents: tileComponents,
        direction: axis == Axis.vertical ? ResizeDirection.top : ResizeDirection.left,
      );

  /// The end resize detector.
  ///
  /// The direction is determined by the axis.
  Widget get endResizeDetector => ResizeHandle<T>(
        key: endResizeDraggableKey(event.id),
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
    required super.size,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final location = context.location;
    if (!showStart(location) && !showEnd(location)) {
      // If neither handle should be shown, return an empty widget.
      return const SizedBox();
    }

    if (isMobile && axis == Axis.horizontal) {
      // Horizontal resize handles are not supported by default on mobile devices.
      // This is because they will be super small and hard to interact with.
      return const SizedBox();
    }

    final length = isVertical ? size.height : size.width;

    // The length of the resize handle.
    // TODO: Make this configurable in the future.
    const handleLength = 16.0;

    // Determine whether to hide the start resize handle.
    final hideStart = (handleLength * 2) > (length / 2);

    return Stack(
      fit: StackFit.expand,
      children: [
        if (!hideStart && showStart(location))
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
        if (showEnd(location))
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

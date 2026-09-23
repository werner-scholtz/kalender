// This file is part of kalender.
//
// SPDX-FileCopyrightText: 2023 Klarälvdalens Datakonsult AB, a KDAB Group company <info@kdab.com>
//
// SPDX-License-Identifier: MIT

import 'dart:ui' show lerpDouble;

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:kalender/src/enumerations.dart';
import 'package:kalender/src/layout_delegates/event_layout_delegate.dart';
import 'package:kalender/src/models/components/tile_components.dart';
import 'package:kalender/src/models/kalender_interaction.dart';
import 'package:kalender/src/models/providers/kalender_provider.dart';
import 'package:kalender/src/theme/kalender_theme.dart';
import 'package:kalender/src/widgets/event_tiles/resize_handle.dart';
import 'package:kalender/src/widgets/event_tiles/tile_interaction.dart';

/// The builder that positions the resize handles of an event tile.
///
/// [details] carries the event, the tile geometry and the helpers that decide
/// which handles to show and build them.
///
/// {@category Interaction}
typedef ResizeHandlePositioner = Widget Function(BuildContext context, ResizeHandleDetails details);

/// What a [ResizeHandlePositioner] needs to lay out the resize handles of one event tile.
///
/// {@category Interaction}
class ResizeHandleDetails {
  /// The event associated with the resize handles.
  final KalenderEvent event;

  /// The global interaction settings for the calendar.
  final KalenderInteraction interaction;

  /// The FloatingDateTimeRange that the current view is displaying.
  final FloatingDateTimeRange range;

  /// The size of the event tile.
  final Size size;

  /// The axis along which the resize handles are positioned.
  final Axis axis;

  /// Whether the current input is imprecise (e.g. touch/finger).
  ///
  /// When `true`, resize handles are positioned at corners for easier targeting.
  /// When `false`, resize handles span the full width/height of the event tile.
  final bool isImprecise;

  /// The location of the calendar, or null for the device timezone.
  ///
  /// [continuesBefore], [continuesAfter], [showStart] and [showEnd] compare the event in it.
  final Location? location;

  const ResizeHandleDetails({
    required this.event,
    required this.interaction,
    required this.range,
    required this.size,
    required this.axis,
    required this.isImprecise,
    this.location,
  });

  /// Whether the axis is vertical.
  bool get isVertical => axis == Axis.vertical;

  /// The interaction settings for this event.
  EventInteraction get eventInteraction => event.interaction;

  /// Whether the event continues before the current date range.
  bool get continuesBefore => event.floatingStart(location: location).isBefore(range.start);

  /// Whether the event continues after the current date range.
  bool get continuesAfter => event.floatingEnd(location: location).isAfter(range.end);

  /// Whether to show the start resize handle, based on interaction settings and event continuation.
  bool get showStart => event.canResizeStart(interaction, range, location: location);

  /// Whether to show the end resize handle, based on interaction settings and event continuation.
  bool get showEnd => event.canResizeEnd(interaction, range, location: location);

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

/// The style of the resize handles laid out by [DefaultResizeHandles].
///
/// The handle widgets themselves come from [TileComponents.verticalResizeHandle]
/// and [TileComponents.horizontalResizeHandle]. This sizes the area each one is
/// given.
///
/// {@category Appearance}
class ResizeHandleStyle with Diagnosticable {
  const ResizeHandleStyle({this.length, this.impreciseLength});

  /// The length of a resize handle for precise input, such as a mouse.
  final double? length;

  /// The length of a resize handle for imprecise input, such as a finger.
  final double? impreciseLength;

  /// Creates a copy of this style with the given fields replaced with the new values.
  ResizeHandleStyle copyWith({double? length, double? impreciseLength}) {
    return ResizeHandleStyle(length: length ?? this.length, impreciseLength: impreciseLength ?? this.impreciseLength);
  }

  /// Returns a copy of this style where the non-null fields of [other] replace the matching fields.
  ResizeHandleStyle merge(ResizeHandleStyle? other) {
    if (other == null) return this;
    return ResizeHandleStyle(length: other.length ?? length, impreciseLength: other.impreciseLength ?? impreciseLength);
  }

  /// Linearly interpolates between [a] and [b].
  static ResizeHandleStyle? lerp(ResizeHandleStyle? a, ResizeHandleStyle? b, double t) {
    if (identical(a, b)) return a;
    return ResizeHandleStyle(
      length: lerpDouble(a?.length, b?.length, t),
      impreciseLength: lerpDouble(a?.impreciseLength, b?.impreciseLength, t),
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is ResizeHandleStyle && other.length == length && other.impreciseLength == impreciseLength;
  }

  @override
  int get hashCode => Object.hash(length, impreciseLength);

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties.add(DoubleProperty('length', length, defaultValue: null));
    properties.add(DoubleProperty('impreciseLength', impreciseLength, defaultValue: null));
  }
}

/// The default layout for the resize handles of an event tile.
///
/// {@category Interaction}
class DefaultResizeHandles extends StatelessWidget {
  /// The event tile the handles are positioned on.
  final ResizeHandleDetails details;

  const DefaultResizeHandles({required this.details, super.key});

  @override
  Widget build(BuildContext context) {
    final showStart = details.showStart;
    final showEnd = details.showEnd;
    if (!showStart && !showEnd) return const SizedBox();

    final isImprecise = details.isImprecise;
    final isVertical = details.isVertical;

    if (isImprecise && !isVertical && !details.interaction.allowHorizontalImpreciseResize) {
      // Horizontal handles are too small for imprecise input.
      return const SizedBox();
    }

    final length = isVertical ? details.size.height : details.size.width;

    final style = KalenderTheme.of(context).resizeHandleStyle ?? const ResizeHandleStyle();
    final handleLength = isImprecise ? (style.impreciseLength ?? 24.0) : (style.length ?? 16.0);

    final hideStart = (handleLength * 2) > (length / 2);

    return Stack(
      fit: StackFit.expand,
      children: [
        if (!hideStart && showStart)
          isVertical
              ? Positioned(
                  top: 0,
                  left: 0,
                  right: isImprecise ? null : 0,
                  width: isImprecise ? handleLength : null,
                  height: handleLength,
                  child: details.startResizeDetector,
                )
              : Positioned(left: 0, top: 0, bottom: 0, width: handleLength, child: details.startResizeDetector),
        if (showEnd)
          isVertical
              ? Positioned(
                  bottom: 0,
                  left: isImprecise ? null : 0,
                  right: 0,
                  width: isImprecise ? handleLength : null,
                  height: handleLength,
                  child: details.endResizeDetector,
                )
              : Positioned(right: 0, top: 0, bottom: 0, width: handleLength, child: details.endResizeDetector),
      ],
    );
  }
}

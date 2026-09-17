// This file is part of kalender.
//
// SPDX-FileCopyrightText: 2023 Klarälvdalens Datakonsult AB, a KDAB Group company <info@kdab.com>
//
// SPDX-License-Identifier: MIT

import 'package:collection/collection.dart';
import 'package:flutter/widgets.dart';
import 'package:kalender/kalender.dart';
import 'package:kalender/src/widgets/internal_components/day_overlay.dart';

/// A function that returns a [MultiDayOverlayPortal].
///
/// [date] is the date for which the widget is created.
/// [events] are all the events that can be displayed for the given [date]. (They are not necessarily all displayed.)
/// [numberOfHiddenRows] is the number of hidden rows.
/// [tileHeight] is the height of the tile.
/// [getMultiDayEventLayoutRenderBox] is the function that returns the [RenderBox] MultiDayEventLayoutWidget.
/// [overlayBuilders] is the builders for the overlay event tile.
///
/// Resolve the style with [KalenderTheme].
///
/// {@category Appearance}
typedef MultiDayOverlayPortalBuilder =
    Widget Function(
      BuildContext context, {
      required DateTime date,
      required List<KalenderEvent> events,
      required int numberOfHiddenRows,
      required double tileHeight,
      required RenderBoxCallback getMultiDayEventLayoutRenderBox,
      required MultiDayOverlayEventTileBuilder overlayTileBuilder,
      required OverlayBuilders? overlayBuilders,
    });

/// A widget that manages the overlay portal for a single day.
///
/// Inside a calendar the overlay opens and closes through [KalenderController.openDayOverlay].
///
/// {@category Appearance}
class MultiDayOverlayPortal extends StatefulWidget {
  /// The date for which the widget is created.
  final FloatingDateTime date;

  /// All the events that should be displayed for the given [date].
  final List<KalenderEvent> events;

  /// The number of hidden rows.
  final int numberOfHiddenRows;

  /// The height of the tile.
  final double tileHeight;

  /// The function that returns the [RenderBox] MultiDayEventLayoutWidget.
  final RenderBoxCallback getMultiDayEventLayoutRenderBox;

  /// The builder for the overlay event tile.
  final MultiDayOverlayEventTileBuilder overlayTileBuilder;

  /// The builders for the overlay.
  final OverlayBuilders? overlayBuilders;

  const MultiDayOverlayPortal({
    required this.date,
    required this.events,
    required this.numberOfHiddenRows,
    required this.tileHeight,
    required this.getMultiDayEventLayoutRenderBox,
    required this.overlayTileBuilder,
    required this.overlayBuilders,
    super.key,
  });

  @override
  State<MultiDayOverlayPortal> createState() => _MultiDayOverlayPortalState();

  /// Returns a [Key] for the overlay portal based on the date.
  static Key getKey(DateTime date) {
    assert(date.isUtc, 'Date must be in UTC');
    return Key('multi_day_overlay_portal_${date.millisecondsSinceEpoch}');
  }
}

class _MultiDayOverlayPortalState extends State<MultiDayOverlayPortal> with DayOverlayState<MultiDayOverlayPortal> {
  @override
  FloatingDateTime get overlayDate => widget.date;

  @override
  bool get followsKalenderController => !CustomOverlayPortalScope.isIn(context);

  /// The function that returns the [RenderBox] for the overlay portal.
  RenderBox getOverlayPortalRenderBox() => context.findRenderObject() as RenderBox;

  @override
  void didUpdateWidget(covariant MultiDayOverlayPortal oldWidget) {
    super.didUpdateWidget(oldWidget);

    final didUpdate =
        oldWidget.date != widget.date ||
        !oldWidget.events.equals(widget.events) ||
        oldWidget.tileHeight != widget.tileHeight ||
        oldWidget.getMultiDayEventLayoutRenderBox != widget.getMultiDayEventLayoutRenderBox ||
        oldWidget.overlayTileBuilder != widget.overlayTileBuilder;

    if (didUpdate) setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return OverlayPortal(
      controller: portalController,
      overlayChildBuilder: (overlayContext) => buildDayOverlay(
        overlayContext,
        date: widget.date,
        events: widget.events,
        tileHeight: widget.tileHeight,
        portalController: portalController,
        overlayTileBuilder: widget.overlayTileBuilder,
        getMultiDayEventLayoutRenderBox: widget.getMultiDayEventLayoutRenderBox,
        getOverlayPortalRenderBox: getOverlayPortalRenderBox,
        overlayBuilders: widget.overlayBuilders,
      ),
      child:
          widget.overlayBuilders?.multiDayPortalOverlayButtonBuilder?.call(
            context,
            portalController,
            widget.numberOfHiddenRows,
          ) ??
          MultiDayPortalOverlayButton(
            key: MultiDayPortalOverlayButton.getKey(widget.date),
            portalController: portalController,
            numberOfHiddenRows: widget.numberOfHiddenRows,
            stringBuilder: widget.overlayBuilders?.multiDayPortalOverlayButtonStringBuilder,
          ),
    );
  }
}

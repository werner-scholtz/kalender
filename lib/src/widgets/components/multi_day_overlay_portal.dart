import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:kalender/kalender.dart';

/// A function that returns a [MultiDayOverlayPortal].
///
/// [date] is the date for which the widget is created.
/// [events] are all the events that can be displayed for the given [date]. (They are not necessarily all displayed.)
/// [numberOfHiddenRows] is the number of hidden rows.
/// [tileHeight] is the height of the tile.
/// [getMultiDayEventLayoutRenderBox] is the function that returns the [RenderBox] MultiDayEventLayoutWidget.
/// [overlayBuilders] is the builders for the overlay event tile.
/// [overlayStyles] is the styles for the overlay event tile.
typedef MultiDayOverlayPortalBuilder<T extends Object?> = Widget Function({
  required DateTime date,
  required List<CalendarEvent> events,
  required int numberOfHiddenRows,
  required double tileHeight,
  required RenderBoxCallback getMultiDayEventLayoutRenderBox,
  required MultiDayOverlayEventTileBuilder<T> overlayTileBuilder,
  required OverlayBuilders<T>? overlayBuilders,
  required OverlayStyles? overlayStyles,
});

/// A widget that manages the overlay portal for a single day.
class MultiDayOverlayPortal<T extends Object?> extends StatefulWidget {
  /// The date for which the widget is created.
  final InternalDateTime date;

  /// All the events that should be displayed for the given [date].
  final List<CalendarEvent> events;

  /// The number of hidden rows.
  final int numberOfHiddenRows;

  /// The height of the tile.
  final double tileHeight;

  /// The function that returns the [RenderBox] MultiDayEventLayoutWidget.
  final RenderBoxCallback getMultiDayEventLayoutRenderBox;

  /// The builder for the overlay event tile.
  final MultiDayOverlayEventTileBuilder<T> overlayTileBuilder;

  /// The builders for the overlay.
  final OverlayBuilders<T>? overlayBuilders;

  /// The styles for the overlay widgets.
  final OverlayStyles? overlayStyles;

  const MultiDayOverlayPortal({
    required this.date,
    required this.events,
    required this.numberOfHiddenRows,
    required this.tileHeight,
    required this.getMultiDayEventLayoutRenderBox,
    required this.overlayTileBuilder,
    required this.overlayBuilders,
    required this.overlayStyles,
    super.key,
  });

  @override
  State<MultiDayOverlayPortal<T>> createState() => _MultiDayOverlayPortalState<T>();

  /// Returns a [Key] for the overlay portal based on the date.
  static Key getKey(DateTime date) {
    assert(date.isUtc, 'Date must be in UTC');
    return Key('multi_day_overlay_portal_${date.millisecondsSinceEpoch}');
  }
}

class _MultiDayOverlayPortalState<T extends Object?> extends State<MultiDayOverlayPortal<T>> {
  /// The controller for the overlay portal.
  final _portalController = OverlayPortalController();

  /// The function that returns the [RenderBox] for the overlay portal.
  RenderBox getOverlayPortalRenderBox() => context.findRenderObject() as RenderBox;

  @override
  void didUpdateWidget(covariant MultiDayOverlayPortal<T> oldWidget) {
    super.didUpdateWidget(oldWidget);

    final didUpdate = oldWidget.date != widget.date ||
        !oldWidget.events.equals(widget.events) ||
        oldWidget.tileHeight != widget.tileHeight ||
        oldWidget.getMultiDayEventLayoutRenderBox != widget.getMultiDayEventLayoutRenderBox ||
        oldWidget.overlayTileBuilder != widget.overlayTileBuilder;

    if (didUpdate) setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return OverlayPortal(
      controller: _portalController,
      overlayChildBuilder: (overlayContext) {
        return widget.overlayBuilders?.multiDayOverlayBuilder?.call(
              date: widget.date,
              events: widget.events,
              tileHeight: widget.tileHeight,
              portalController: _portalController,
              overlayTileBuilder: widget.overlayTileBuilder,
              getMultiDayEventLayoutRenderBox: widget.getMultiDayEventLayoutRenderBox,
              getOverlayPortalRenderBox: getOverlayPortalRenderBox,
              style: widget.overlayStyles?.multiDayOverlayStyle,
            ) ??
            MultiDayOverlay<T>(
              key: MultiDayOverlay.getKey(widget.date),
              date: widget.date,
              events: widget.events,
              tileHeight: widget.tileHeight,
              portalController: _portalController,
              overlayTileBuilder: widget.overlayTileBuilder,
              getMultiDayEventLayoutRenderBox: widget.getMultiDayEventLayoutRenderBox,
              getOverlayPortalRenderBox: getOverlayPortalRenderBox,
              style: widget.overlayStyles?.multiDayOverlayStyle,
            );
      },
      child: widget.overlayBuilders?.multiDayPortalOverlayButtonBuilder?.call(
            _portalController,
            widget.numberOfHiddenRows,
            widget.overlayStyles?.multiDayPortalOverlayButtonStyle,
          ) ??
          MultiDayPortalOverlayButton(
            key: MultiDayPortalOverlayButton.getKey(widget.date),
            portalController: _portalController,
            numberOfHiddenRows: widget.numberOfHiddenRows,
            style: widget.overlayStyles?.multiDayPortalOverlayButtonStyle,
          ),
    );
  }
}

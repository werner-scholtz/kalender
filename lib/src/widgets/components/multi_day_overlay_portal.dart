import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:kalender/kalender.dart';

/// A function that returns a [MultiDayOverlayPortal].
///
/// TODO: docs
typedef MultiDayOverlayPortalBuilder<T extends Object?> = Widget Function({
  required DateTime date,
  required List<CalendarEvent<T>> events,
  required int numberOfHiddenEvents,
  required double tileHeight,
  required RenderBoxCallback getMultiDayEventLayoutRenderBox,
  required OverlayBuilders<T>? overlayBuilders,
  required OverlayStyles? overlayStyles,
});

class MultiDayOverlayPortal<T extends Object?> extends StatefulWidget {
  /// The date for which the widget is created.
  final DateTime date;

  /// All the events that should be displayed for the given [date].
  final List<CalendarEvent<T>> events;

  /// The number of hidden events.
  final int numberOfHiddenEvents;

  /// The height of the tile.
  final double tileHeight;

  /// The function that returns the [RenderBox] MultiDayEventLayoutWidget.
  final RenderBoxCallback getMultiDayEventLayoutRenderBox;

  /// The builder for the overlay event tile.
  final MultiDayOverlayEventTileBuilder<T> overlayTileBuilder;

  final OverlayBuilders<T>? overlayBuilders;
  final OverlayStyles? overlayStyles;

  const MultiDayOverlayPortal({
    required this.date,
    required this.events,
    required this.numberOfHiddenEvents,
    required this.tileHeight,
    required this.getMultiDayEventLayoutRenderBox,
    required this.overlayTileBuilder,
    required this.overlayBuilders,
    required this.overlayStyles,
    super.key,
  });

  @override
  State<MultiDayOverlayPortal<T>> createState() => _MultiDayOverlayPortalState<T>();
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
            widget.numberOfHiddenEvents,
            widget.overlayStyles?.multiDayPortalOverlayButtonStyle,
          ) ??
          MultiDayPortalOverlayButton(
            portalController: _portalController,
            numberOfHiddenEvents: widget.numberOfHiddenEvents,
            style: widget.overlayStyles?.multiDayPortalOverlayButtonStyle,
          ),
    );
  }
}

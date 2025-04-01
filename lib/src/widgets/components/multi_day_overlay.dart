import 'package:flutter/material.dart';
import 'package:kalender/kalender.dart';
import 'package:kalender/src/widgets/event_tiles/multi_day_overlay_event_tile.dart';

/// A function that returns a [MultiDayOverlayEventTile] for the multi-day overlay.
///
/// The [event] is the event that is being displayed.
/// The [dateTimeRange] is the range for which the event is displayed.
/// The [dismissOverlay] is a function that is called when the overlay needs to be dismissed.
typedef MultiDayOverlayEventTileBuilder<T> = MultiDayOverlayEventTile<T> Function(
  CalendarEvent<T> event,
  DateTimeRange dateTimeRange,
  VoidCallback dismissOverlay,
);

/// A function that returns a [RenderBox] for the multi-day event layout.
typedef RenderBoxCallback = RenderBox Function();


/// A function that returns a [MultiDayOverlay] widget.
/// 
/// The [date] is the date for which the widget is created.
/// The [events] are all the events that should be displayed for the given [date].
/// The [tileHeight] is the height of the tile.
/// The [portalController] is the controller for the overlay portal.
/// The [getMultiDayEventLayoutRenderBox] is the function that returns the [RenderBox] for the [MultiDayEventLayoutWidget].
/// The [getOverlayPortalRenderBox] is the function that returns the [RenderBox] for the [MultiDayOverlay].
/// The [overlayTileBuilder] is the builder for the overlay event tile.
/// The [style] is the style for the overlay.
typedef MultiDayOverlayBuilder<T extends Object?> = Widget Function({
  required DateTime date,
  required List<CalendarEvent<T>> events,
  required double tileHeight,
  required OverlayPortalController portalController,
  required RenderBoxCallback getMultiDayEventLayoutRenderBox,
  required RenderBoxCallback getOverlayPortalRenderBox,
  required MultiDayOverlayEventTileBuilder<T> overlayTileBuilder,
  required MultiDayOverlayStyle? style,
});

class MultiDayOverlayStyle {
  /// TODO: Add styling options.
}

class MultiDayOverlay<T extends Object?> extends StatelessWidget {
  /// The date for which the widget is created.
  final DateTime date;

  /// All the events that should be displayed for the given [date].
  final List<CalendarEvent<T>> events;

  /// The height of the tile.
  final double tileHeight;

  /// The portal controller that controls the overlay for this widget.
  final OverlayPortalController portalController;

  /// The function that returns the [RenderBox] MultiDayEventLayoutWidget.
  final RenderBoxCallback getMultiDayEventLayoutRenderBox;

  /// The function that returns the [RenderBox] for the overlay portal.
  final RenderBoxCallback getOverlayPortalRenderBox;

  /// The builder for the overlay event tile.
  final MultiDayOverlayEventTileBuilder<T> overlayTileBuilder;

  /// The style for the overlay.
  final MultiDayOverlayStyle? style;

  const MultiDayOverlay({
    super.key,
    required this.date,
    required this.events,
    required this.tileHeight,
    required this.portalController,
    required this.overlayTileBuilder,
    required this.getMultiDayEventLayoutRenderBox,
    required this.getOverlayPortalRenderBox,
    required this.style,
  });

  /// Calculates the top and left position of the overlay.
  (double top, double left) calculatePosition(
    RenderBox portalRenderBox,
    double headerHeight,
    double width,
  ) {
    final multiDayEventsLayoutRenderBox = getMultiDayEventLayoutRenderBox();

    // Get the size of the multi day events layout.
    final multiDayEventsLayoutSize = multiDayEventsLayoutRenderBox.size;

    // Get the position of the portal widget.
    final portalWidth = portalRenderBox.size.width;
    final portalPosition = portalRenderBox.localToGlobal(Offset.zero);

    // Calculate the left and top position of the overlay.
    final top = portalPosition.dy - multiDayEventsLayoutSize.height - headerHeight;
    final left = portalPosition.dx - (width / 2) + portalWidth / 2;

    return (top, left);
  }

  static const defaultHeaderHeight = 80.0;
  static const defaultWidth = 300.0;

  @override
  Widget build(BuildContext context) {
    const width = defaultWidth;
    const headerHeight = defaultHeaderHeight;
    final (top, left) = calculatePosition(getOverlayPortalRenderBox.call(), 80.0, 300.0);

    return Stack(
      fit: StackFit.expand,
      children: [
        Positioned.fill(child: GestureDetector(behavior: HitTestBehavior.opaque, onTap: portalController.hide)),
        Positioned(
          top: top,
          left: left,
          width: width,
          child: Card(
            child: Column(
              spacing: 8,
              children: [
                SizedBox(
                  height: headerHeight,
                  width: width,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(vertical: 8),
                    child: Stack(
                      children: [
                        Align(
                          alignment: Alignment.topCenter,
                          child: Text(date.dayNameEnglish),
                        ),
                        Align(
                          alignment: Alignment.bottomCenter,
                          child: IconButton.filledTonal(
                            onPressed: () {},
                            icon: Text(date.day.toString()),
                          ),
                        ),
                        Align(
                          alignment:
                              Directionality.of(context) == TextDirection.ltr ? Alignment.topRight : Alignment.topLeft,
                          child: IconButton.filledTonal(
                            onPressed: portalController.hide,
                            icon: const Icon(Icons.close),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(4.0),
                  child: ListBody(
                    children: [
                      for (final event in events)
                        Padding(
                          padding: const EdgeInsets.symmetric(vertical: 2.0),
                          child: SizedBox(
                            height: tileHeight,
                            child: overlayTileBuilder(event, date.dayRange, portalController.hide),
                          ),
                        ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

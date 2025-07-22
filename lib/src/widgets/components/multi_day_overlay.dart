import 'package:flutter/material.dart';
import 'package:kalender/kalender.dart';
import 'package:kalender/src/models/providers/calendar_provider.dart';
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
  /// The function that returns the name of the day.
  final String Function(DateTime date)? dayNameBuilder;

  /// The [TextStyle] used for the name of the day.
  final TextStyle? dayNameTextStyle;

  /// The [TextStyle] used for the date.
  final TextStyle? dateTextStyle;

  /// The [Icon] used for the close button.
  final Icon? closeIcon;

  /// The padding for the header.
  final EdgeInsets? headerPadding;

  /// The padding around the events.
  final EdgeInsets? eventsPadding;

  /// The padding around each event.
  final EdgeInsets? eventPadding;

  const MultiDayOverlayStyle({
    this.dayNameBuilder,
    this.dayNameTextStyle,
    this.dateTextStyle,
    this.closeIcon,
    this.headerPadding,
    this.eventsPadding,
    this.eventPadding,
  });
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
    final (top, left) = calculatePosition(getOverlayPortalRenderBox.call(), headerHeight, width);
    final textDirection = Directionality.of(context);

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
                    padding: style?.headerPadding ?? const EdgeInsets.symmetric(vertical: 8),
                    child: Stack(
                      children: [
                        Align(
                          alignment: Alignment.topCenter,
                          child: Text(
                            style?.dayNameBuilder?.call(date) ?? date.dayNameLocalized(context.locale),
                            style: style?.dayNameTextStyle,
                          ),
                        ),
                        Align(
                          alignment: Alignment.bottomCenter,
                          child: IconButton.filledTonal(
                            onPressed: () {},
                            icon: Text(date.day.toString(), style: style?.dateTextStyle),
                          ),
                        ),
                        Align(
                          alignment: textDirection == TextDirection.ltr ? Alignment.topRight : Alignment.topLeft,
                          child: IconButton.filledTonal(
                            onPressed: portalController.hide,
                            icon: style?.closeIcon ?? const Icon(Icons.close),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                Padding(
                  padding: style?.eventsPadding ?? const EdgeInsets.all(4.0),
                  child: ListBody(
                    children: [
                      for (final event in events)
                        Padding(
                          padding: style?.eventsPadding ?? const EdgeInsets.symmetric(vertical: 2.0),
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

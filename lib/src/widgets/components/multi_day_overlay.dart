import 'package:flutter/material.dart';
import 'package:kalender/kalender.dart';
import 'package:kalender/src/models/providers/calendar_provider.dart';
import 'package:kalender/src/widgets/event_tiles/tiles/multi_day_overlay_tile.dart';

/// A function that returns a [MultiDayOverlayEventTile] for the multi-day overlay.
///
/// The [event] is the event that is being displayed.
/// The [dateTimeRange] is the range for which the event is displayed.
/// The [dismissOverlay] is a function that is called when the overlay needs to be dismissed.
typedef MultiDayOverlayEventTileBuilder<T> = MultiDayOverlayEventTile<T> Function(
  CalendarEvent<T> event,
  InternalDateTimeRange internalRange,
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
  final InternalDateTime date;

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

  /// Returns a [Key] for the overlay based on the date.
  static Key getKey(DateTime date) {
    assert(date.isUtc, 'Date must be in UTC');
    return Key('multi_day_overlay_${date.millisecondsSinceEpoch}');
  }

  /// Returns a [Key] for the overlay card based on the date.
  static Key getOverlayCardKey(DateTime date) {
    assert(date.isUtc, 'Date must be in UTC');
    return Key('multi_day_overlay_card_${date.millisecondsSinceEpoch}');
  }

  /// Returns a [Key] for the close button based on the date.
  static Key getCloseButtonKey(DateTime date) {
    assert(date.isUtc, 'Date must be in UTC');
    return Key('multi_day_overlay_close_button_${date.millisecondsSinceEpoch}');
  }

  /// Calculates the top and left position of the overlay.
  (double top, double left, double right) _calculatePosition(
    BoxConstraints constraints,
    double headerHeight,
  ) {
    final portalRenderBox = getOverlayPortalRenderBox();

    final multiDayEventsLayoutRenderBox = getMultiDayEventLayoutRenderBox();
    final multiDayEventsLayoutSize = multiDayEventsLayoutRenderBox.size;

    // Get the position of the portal widget.
    final portalWidth = portalRenderBox.size.width;
    final portalPosition = portalRenderBox.localToGlobal(Offset.zero);

    // Calculate the left and top position of the overlay.
    // Ensure the overlay does not go off the top of the screen.
    var top = portalPosition.dy - multiDayEventsLayoutSize.height - headerHeight;
    if (top < 0) top = 0;

    // Calculate the left position of the overlay.
    // Ensure the overlay does not go off the left side of the screen.
    final maxWidth = _determineWidth(constraints);
    var left = portalPosition.dx - (maxWidth / 2) + portalWidth / 2;
    if (left < 0) left = 0;

    // Ensure the overlay does not go off the right side of the screen.
    var width = maxWidth;
    final right = left + width;
    if (right > constraints.maxWidth) {
      if (left > constraints.maxWidth - maxWidth) {
        // If there is space on the left side, adjust the left position.
        left = constraints.maxWidth - maxWidth;
      } else {
        // Otherwise, adjust the width to fit within the constraints.
        width = constraints.maxWidth - left;
      }
    }

    return (top, left, width);
  }

  /// Determines the width of the overlay based on the constraints.
  double _determineWidth(BoxConstraints constraints) {
    if (constraints.maxWidth < 300) {
      return constraints.maxWidth;
    } else {
      return defaultWidth;
    }
  }

  static const defaultWidth = 300.0;

  /// Determines the height of the header based on the constraints.
  double _determineHeaderHeight(BoxConstraints constraints) {
    if (constraints.maxHeight < 80) {
      return constraints.maxHeight;
    } else {
      return defaultHeaderHeight;
    }
  }

  static const defaultHeaderHeight = 80.0;

  @override
  Widget build(BuildContext context) {
    final textDirection = Directionality.of(context);

    return LayoutBuilder(
      builder: (context, constraints) {
        final headerHeight = _determineHeaderHeight(constraints);
        final (top, left, width) = _calculatePosition(constraints, headerHeight);
        return Stack(
          fit: StackFit.expand,
          children: [
            Positioned.fill(child: GestureDetector(behavior: HitTestBehavior.opaque, onTap: portalController.hide)),
            Positioned(
              top: top,
              left: left,
              width: width,
              child: Card(
                key: getOverlayCardKey(date),
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
                                key: MultiDayOverlay.getCloseButtonKey(date),
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
                                child: overlayTileBuilder(event, InternalDateTimeRange.fromDateTimeRange(date.dayRange), portalController.hide),
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
      },
    );
  }
}

import 'dart:math' as math;
import 'dart:ui' show lerpDouble;

import 'package:flutter/material.dart';
import 'package:kalender/kalender.dart';
import 'package:kalender/src/models/providers/calendar_provider.dart';
import 'package:kalender/src/widgets/event_tiles/tiles/multi_day_overlay_tile.dart';
import 'package:kalender/src/widgets/internal_components/day_number.dart';
import 'package:kalender/src/widgets/internal_components/pass_through_pointer.dart';

/// A function that returns a [MultiDayEventOverlayTile] for the multi-day overlay.
///
/// The [event] is the event that is being displayed.
/// The [dateTimeRange] is the range for which the event is displayed.
/// The [dismissOverlay] is a function that is called when the overlay needs to be dismissed.
typedef MultiDayOverlayEventTileBuilder = MultiDayEventOverlayTile Function(
  CalendarEvent event,
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
typedef MultiDayOverlayBuilder = Widget Function({
  required DateTime date,
  required List<CalendarEvent> events,
  required double tileHeight,
  required OverlayPortalController portalController,
  required RenderBoxCallback getMultiDayEventLayoutRenderBox,
  required RenderBoxCallback getOverlayPortalRenderBox,
  required MultiDayOverlayEventTileBuilder overlayTileBuilder,
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

  /// The theme applied to the [Card] the overlay is drawn on.
  ///
  /// Falls back to the ambient [CardTheme] when null.
  final CardThemeData? cardTheme;

  /// The [ButtonStyle] used for the close button.
  ///
  /// This is merged over the defaults of the filled tonal icon button, so a
  /// value only has to set the fields it wants to change.
  final ButtonStyle? closeButtonStyle;

  /// The color drawn behind the card, covering the rest of the calendar.
  ///
  /// Transparent when null.
  final Color? barrierColor;

  /// The width of the card.
  ///
  /// Defaults to [MultiDayOverlay.defaultWidth]. The card is never wider than
  /// the space available to it.
  final double? width;

  /// The height of the header above the event list.
  ///
  /// Defaults to [MultiDayOverlay.defaultHeaderHeight]. The header is never
  /// taller than the space available to it.
  final double? headerHeight;

  const MultiDayOverlayStyle({
    this.dayNameBuilder,
    this.dayNameTextStyle,
    this.dateTextStyle,
    this.closeIcon,
    this.headerPadding,
    this.eventsPadding,
    this.eventPadding,
    this.cardTheme,
    this.closeButtonStyle,
    this.barrierColor,
    this.width,
    this.headerHeight,
  });

  /// Creates a copy of this style with the given fields replaced with the new values.
  MultiDayOverlayStyle copyWith({
    String Function(DateTime date)? dayNameBuilder,
    TextStyle? dayNameTextStyle,
    TextStyle? dateTextStyle,
    Icon? closeIcon,
    EdgeInsets? headerPadding,
    EdgeInsets? eventsPadding,
    EdgeInsets? eventPadding,
    CardThemeData? cardTheme,
    ButtonStyle? closeButtonStyle,
    Color? barrierColor,
    double? width,
    double? headerHeight,
  }) {
    return MultiDayOverlayStyle(
      dayNameBuilder: dayNameBuilder ?? this.dayNameBuilder,
      dayNameTextStyle: dayNameTextStyle ?? this.dayNameTextStyle,
      dateTextStyle: dateTextStyle ?? this.dateTextStyle,
      closeIcon: closeIcon ?? this.closeIcon,
      headerPadding: headerPadding ?? this.headerPadding,
      eventsPadding: eventsPadding ?? this.eventsPadding,
      eventPadding: eventPadding ?? this.eventPadding,
      cardTheme: cardTheme ?? this.cardTheme,
      closeButtonStyle: closeButtonStyle ?? this.closeButtonStyle,
      barrierColor: barrierColor ?? this.barrierColor,
      width: width ?? this.width,
      headerHeight: headerHeight ?? this.headerHeight,
    );
  }

  /// Returns a copy of this style where the non-null fields of [other] replace the matching fields.
  MultiDayOverlayStyle merge(MultiDayOverlayStyle? other) {
    if (other == null) return this;
    return MultiDayOverlayStyle(
      dayNameBuilder: other.dayNameBuilder ?? dayNameBuilder,
      dayNameTextStyle: other.dayNameTextStyle ?? dayNameTextStyle,
      dateTextStyle: other.dateTextStyle ?? dateTextStyle,
      closeIcon: other.closeIcon ?? closeIcon,
      headerPadding: other.headerPadding ?? headerPadding,
      eventsPadding: other.eventsPadding ?? eventsPadding,
      eventPadding: other.eventPadding ?? eventPadding,
      cardTheme: other.cardTheme ?? cardTheme,
      closeButtonStyle: other.closeButtonStyle ?? closeButtonStyle,
      barrierColor: other.barrierColor ?? barrierColor,
      width: other.width ?? width,
      headerHeight: other.headerHeight ?? headerHeight,
    );
  }

  /// Linearly interpolates between [a] and [b]. Fields that cannot be interpolated switch at the midpoint.
  static MultiDayOverlayStyle? lerp(MultiDayOverlayStyle? a, MultiDayOverlayStyle? b, double t) {
    if (identical(a, b)) return a;
    return MultiDayOverlayStyle(
      dayNameBuilder: t < 0.5 ? a?.dayNameBuilder : b?.dayNameBuilder,
      dayNameTextStyle: TextStyle.lerp(a?.dayNameTextStyle, b?.dayNameTextStyle, t),
      dateTextStyle: TextStyle.lerp(a?.dateTextStyle, b?.dateTextStyle, t),
      closeIcon: t < 0.5 ? a?.closeIcon : b?.closeIcon,
      headerPadding: EdgeInsets.lerp(a?.headerPadding, b?.headerPadding, t),
      eventsPadding: EdgeInsets.lerp(a?.eventsPadding, b?.eventsPadding, t),
      eventPadding: EdgeInsets.lerp(a?.eventPadding, b?.eventPadding, t),
      // CardThemeData.lerp never returns null, so keep null when neither side
      // sets a theme rather than inventing an empty one.
      cardTheme:
          a?.cardTheme == null && b?.cardTheme == null ? null : CardThemeData.lerp(a?.cardTheme, b?.cardTheme, t),
      closeButtonStyle: ButtonStyle.lerp(a?.closeButtonStyle, b?.closeButtonStyle, t),
      barrierColor: Color.lerp(a?.barrierColor, b?.barrierColor, t),
      width: lerpDouble(a?.width, b?.width, t),
      headerHeight: lerpDouble(a?.headerHeight, b?.headerHeight, t),
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is MultiDayOverlayStyle &&
        other.dayNameBuilder == dayNameBuilder &&
        other.dayNameTextStyle == dayNameTextStyle &&
        other.dateTextStyle == dateTextStyle &&
        other.closeIcon == closeIcon &&
        other.headerPadding == headerPadding &&
        other.eventsPadding == eventsPadding &&
        other.eventPadding == eventPadding &&
        other.cardTheme == cardTheme &&
        other.closeButtonStyle == closeButtonStyle &&
        other.barrierColor == barrierColor &&
        other.width == width &&
        other.headerHeight == headerHeight;
  }

  @override
  int get hashCode => Object.hash(
        dayNameBuilder,
        dayNameTextStyle,
        dateTextStyle,
        closeIcon,
        headerPadding,
        eventsPadding,
        eventPadding,
        cardTheme,
        closeButtonStyle,
        barrierColor,
        width,
        headerHeight,
      );
}

/// Positions the overlay card, keeping all four of its edges inside the overlay.
///
/// The card has to be measured before it can be placed, since it is always
/// taller than the day cell it is anchored to. A [SingleChildLayoutDelegate]
/// receives the measured size in [getPositionForChild], so the card is placed
/// and clamped in a single pass.
class _MultiDayOverlayLayoutDelegate extends SingleChildLayoutDelegate {
  const _MultiDayOverlayLayoutDelegate({
    required this.anchorTop,
    required this.anchorCenterX,
    required this.width,
  });

  /// Where the top of the card should sit, before clamping.
  final double anchorTop;

  /// The horizontal center of the button the card belongs to.
  final double anchorCenterX;

  /// The width of the card.
  final double width;

  @override
  BoxConstraints getConstraintsForChild(BoxConstraints constraints) {
    // The height is deliberately loose. The card has to measure its own height
    // for the bottom edge to be clamped, and a tight height brings back the
    // overflow this delegate exists to prevent.
    return BoxConstraints(minWidth: width, maxWidth: width, maxHeight: constraints.maxHeight);
  }

  @override
  Offset getPositionForChild(Size size, Size childSize) {
    // Pull the card up before pushing it down, so that a card which fills the
    // overlay is aligned to the top rather than the bottom.
    var top = anchorTop;
    if (top + childSize.height > size.height) top = size.height - childSize.height;
    if (top < 0) top = 0;

    final left =
        (anchorCenterX - childSize.width / 2).clamp(0.0, math.max(0.0, size.width - childSize.width)).toDouble();

    return Offset(left, top);
  }

  @override
  bool shouldRelayout(covariant _MultiDayOverlayLayoutDelegate oldDelegate) {
    return oldDelegate.anchorTop != anchorTop ||
        oldDelegate.anchorCenterX != anchorCenterX ||
        oldDelegate.width != width;
  }
}

class MultiDayOverlay extends StatelessWidget {
  /// The date for which the widget is created.
  final InternalDateTime date;

  /// All the events that should be displayed for the given [date].
  final List<CalendarEvent> events;

  /// The height of the tile.
  final double tileHeight;

  /// The portal controller that controls the overlay for this widget.
  final OverlayPortalController portalController;

  /// The function that returns the [RenderBox] MultiDayEventLayoutWidget.
  final RenderBoxCallback getMultiDayEventLayoutRenderBox;

  /// The function that returns the [RenderBox] for the overlay portal.
  final RenderBoxCallback getOverlayPortalRenderBox;

  /// The builder for the overlay event tile.
  final MultiDayOverlayEventTileBuilder overlayTileBuilder;

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

  /// Returns a [Key] for the barrier behind the card, based on the date.
  static Key getBarrierKey(DateTime date) {
    assert(date.isUtc, 'Date must be in UTC');
    return Key('multi_day_overlay_barrier_${date.millisecondsSinceEpoch}');
  }

  /// Returns a [Key] for the card's header, based on the date.
  static Key getHeaderKey(DateTime date) {
    assert(date.isUtc, 'Date must be in UTC');
    return Key('multi_day_overlay_header_${date.millisecondsSinceEpoch}');
  }

  /// Key applied to the [IconButton] when the date is today.
  static const todayKey = ValueKey('MultiDayOverlay.today');

  /// Calculates where the overlay card would ideally sit, and how wide it is.
  ///
  /// The anchor lines the card's event list up with the day cell's event area,
  /// putting the header above it. The card is taller than the cell it is
  /// anchored to, because it lists every event for the day including the hidden
  /// ones, so [_MultiDayOverlayLayoutDelegate] clamps the anchor to the
  /// viewport once the card has been measured.
  (double anchorTop, double anchorCenterX, double width) _calculateAnchor(
    BoxConstraints constraints,
    MultiDayOverlayStyle style,
    double headerHeight,
  ) {
    final portalRenderBox = getOverlayPortalRenderBox();
    final multiDayEventsLayoutSize = getMultiDayEventLayoutRenderBox().size;

    // Get the position of the portal widget.
    final portalWidth = portalRenderBox.size.width;
    final portalPosition = portalRenderBox.localToGlobal(Offset.zero);

    final anchorTop = portalPosition.dy - multiDayEventsLayoutSize.height - headerHeight;
    final anchorCenterX = portalPosition.dx + portalWidth / 2;

    return (anchorTop, anchorCenterX, _determineWidth(constraints, style));
  }

  /// Determines the width of the overlay, never wider than the space available.
  double _determineWidth(BoxConstraints constraints, MultiDayOverlayStyle style) {
    return math.min(style.width ?? defaultWidth, constraints.maxWidth);
  }

  static const defaultWidth = 300.0;

  /// Determines the height of the header, never taller than the space available.
  ///
  /// The header does not get the whole overlay: [cardMargin] and the gap between
  /// the header and the event list come out of it first. Clamping against the
  /// full height instead lets the column overflow by up to that much.
  double _determineHeaderHeight(BoxConstraints constraints, MultiDayOverlayStyle style, EdgeInsetsGeometry cardMargin) {
    final available = constraints.maxHeight - cardMargin.vertical - _columnSpacing;
    return math.min(style.headerHeight ?? defaultHeaderHeight, math.max(0.0, available));
  }

  static const defaultHeaderHeight = 80.0;

  /// The gap between the header and the event list.
  static const _columnSpacing = 8.0;

  /// The margin a [Card] uses when neither the style nor the theme sets one.
  ///
  /// Mirrors the Material default, which [Card] applies inside its own size.
  static const _defaultCardMargin = EdgeInsets.all(4.0);

  @override
  Widget build(BuildContext context) {
    final textDirection = Directionality.of(context);
    final style = (KalenderTheme.of(context).multiDayOverlayStyle ?? const MultiDayOverlayStyle()).merge(this.style);

    final cardTheme = style.cardTheme ?? CardTheme.of(context);
    final cardMargin = cardTheme.margin ?? _defaultCardMargin;

    return LayoutBuilder(
      builder: (context, constraints) {
        final headerHeight = _determineHeaderHeight(constraints, style, cardMargin);
        final (anchorTop, anchorCenterX, width) = _calculateAnchor(constraints, style, headerHeight);
        return Stack(
          fit: StackFit.expand,
          children: [
            Positioned.fill(
              child: GestureDetector(
                behavior: HitTestBehavior.opaque,
                onTap: portalController.hide,
                child: ColoredBox(
                  key: getBarrierKey(date),
                  color: style.barrierColor ?? Colors.transparent,
                ),
              ),
            ),
            CustomSingleChildLayout(
              delegate: _MultiDayOverlayLayoutDelegate(
                anchorTop: anchorTop,
                anchorCenterX: anchorCenterX,
                width: width,
              ),
              child: CardTheme(
                data: cardTheme,
                child: Card(
                  key: getOverlayCardKey(date),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    spacing: _columnSpacing,
                    children: [
                      SizedBox(
                        key: getHeaderKey(date),
                        height: headerHeight,
                        child: Padding(
                          padding: style.headerPadding ?? const EdgeInsets.symmetric(vertical: 8),
                          child: Stack(
                            children: [
                              Align(
                                alignment: Alignment.topCenter,
                                child: Text(
                                  style.dayNameBuilder?.call(date) ?? date.dayNameLocalized(context.locale),
                                  style: style.dayNameTextStyle,
                                ),
                              ),
                              Align(
                                alignment: Alignment.bottomCenter,
                                child: DayNumber(
                                  number: Text(date.day.toString(), style: style.dateTextStyle),
                                  isToday: context.isToday(date),
                                  todayKey: todayKey,
                                ),
                              ),
                              Align(
                                alignment: textDirection == TextDirection.ltr ? Alignment.topRight : Alignment.topLeft,
                                child: IconButton.filledTonal(
                                  onPressed: portalController.hide,
                                  style: style.closeButtonStyle,
                                  icon: style.closeIcon ?? const Icon(Icons.close),
                                  key: MultiDayOverlay.getCloseButtonKey(date),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      // Flexible and the scroll view belong together: without
                      // Flexible the column child keeps an unbounded height and
                      // never scrolls, and without the scroll view the bounded
                      // height reaches ListBody, which requires an unbounded one.
                      Flexible(
                        child: SingleChildScrollView(
                          primary: false,
                          child: Padding(
                            padding: style.eventsPadding ?? const EdgeInsets.all(4.0),
                            child: Stack(
                              children: [
                                ListBody(
                                  children: [
                                    for (final event in events)
                                      Padding(
                                        padding: style.eventPadding ?? const EdgeInsets.symmetric(vertical: 2.0),
                                        child: SizedBox(
                                          height: tileHeight,
                                          child: overlayTileBuilder(
                                            event,
                                            InternalDateTimeRange.fromDateTimeRange(date.dayRange),
                                            portalController.hide,
                                          ),
                                        ),
                                      ),
                                  ],
                                ),
                                ValueListenableBuilder<CalendarEvent?>(
                                  valueListenable: context.calendarController.selectedEvent,
                                  builder: (context, selectedEvent, child) {
                                    if (selectedEvent == null) return const SizedBox();
                                    if (!events.any((e) => e.id == selectedEvent.id)) return const SizedBox();

                                    final eventIndex = events.indexWhere((e) => e.id == selectedEvent.id);
                                    if (eventIndex == -1) return const SizedBox();

                                    final eventPadding =
                                        style.eventPadding ?? const EdgeInsets.symmetric(vertical: 2.0);
                                    final verticalPadding = eventPadding.vertical;

                                    return Positioned(
                                      top: eventIndex * (tileHeight + verticalPadding),
                                      left: 0,
                                      right: 0,
                                      height: tileHeight + verticalPadding,
                                      child: PassThroughPointer(
                                        child: Padding(
                                          padding: eventPadding,
                                          child: context.tileComponents.dropTargetTile?.call(selectedEvent) ??
                                              const SizedBox(),
                                        ),
                                      ),
                                    );
                                  },
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        );
      },
    );
  }
}

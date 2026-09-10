import 'dart:async';
import 'dart:ui' show lerpDouble;

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:kalender/kalender.dart';

/// The time indicator builder.
///
/// The [timeOfDayRange] is the range of time that the time indicator will be displayed for.
/// The [heightPerMinute] is the height of each minute.
/// The [location] is the calendar's time zone.
///
/// Resolve the style with [KalenderTheme].
typedef TimeIndicatorBuilder = Widget Function(
  BuildContext context,
  KalenderTimeRange timeOfDayRange,
  double heightPerMinute,
  Location? location,
);

/// The style of the [TimeIndicator] widget.
class TimeIndicatorStyle with Diagnosticable {
  /// The [Color] of the time indicator.
  final Color? lineColor;

  /// The thickness of the time indicator.
  final double? thickness;

  /// The [Color] of the circle.
  /// * If not provided, the [lineColor] will be used.
  final Color? circleColor;

  /// The size of the circle.
  final Size? circleSize;

  const TimeIndicatorStyle({
    this.lineColor,
    this.thickness,
    this.circleColor,
    this.circleSize,
  });

  /// Creates a copy of this style with the given fields replaced with the new values.
  TimeIndicatorStyle copyWith({
    Color? lineColor,
    double? thickness,
    Color? circleColor,
    Size? circleSize,
  }) {
    return TimeIndicatorStyle(
      lineColor: lineColor ?? this.lineColor,
      thickness: thickness ?? this.thickness,
      circleColor: circleColor ?? this.circleColor,
      circleSize: circleSize ?? this.circleSize,
    );
  }

  /// Returns a copy of this style where the non-null fields of [other] replace the matching fields.
  TimeIndicatorStyle merge(TimeIndicatorStyle? other) {
    if (other == null) return this;
    return TimeIndicatorStyle(
      lineColor: other.lineColor ?? lineColor,
      thickness: other.thickness ?? thickness,
      circleColor: other.circleColor ?? circleColor,
      circleSize: other.circleSize ?? circleSize,
    );
  }

  /// Linearly interpolates between [a] and [b].
  static TimeIndicatorStyle? lerp(TimeIndicatorStyle? a, TimeIndicatorStyle? b, double t) {
    if (identical(a, b)) return a;
    return TimeIndicatorStyle(
      lineColor: Color.lerp(a?.lineColor, b?.lineColor, t),
      thickness: lerpDouble(a?.thickness, b?.thickness, t),
      circleColor: Color.lerp(a?.circleColor, b?.circleColor, t),
      circleSize: Size.lerp(a?.circleSize, b?.circleSize, t),
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is TimeIndicatorStyle &&
        other.lineColor == lineColor &&
        other.thickness == thickness &&
        other.circleColor == circleColor &&
        other.circleSize == circleSize;
  }

  @override
  int get hashCode => Object.hash(lineColor, thickness, circleColor, circleSize);

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties.add(ColorProperty('lineColor', lineColor, defaultValue: null));
    properties.add(DoubleProperty('thickness', thickness, defaultValue: null));
    properties.add(ColorProperty('circleColor', circleColor, defaultValue: null));
    properties.add(DiagnosticsProperty<Size>('circleSize', circleSize, defaultValue: null));
  }
}

/// A widget that displays the current time as a line and a circle.
class TimeIndicator extends StatefulWidget {
  /// The [KalenderTimeRange] that will be used to display the hour lines.
  final KalenderTimeRange timeOfDayRange;

  /// The height per minute.
  final double heightPerMinute;

  /// The style of the time indicator.
  final TimeIndicatorStyle? style;

  /// The location to use for the time indicator.
  final Location? location;

  /// An optional callback that returns the current [DateTime] for the time indicator.
  ///
  /// When provided, the wall-clock components of the returned [DateTime] are used
  /// directly, bypassing the [location]-based time resolution.
  final NowCallback? nowCallback;

  /// Creates a new [TimeIndicator] widget.
  const TimeIndicator({
    super.key,
    required this.timeOfDayRange,
    required this.heightPerMinute,
    required this.location,
    this.nowCallback,
    this.style,
  });

  @override
  State<TimeIndicator> createState() => _TimeIndicatorState();
}

class _TimeIndicatorState extends State<TimeIndicator> {
  /// The timer that updates the time indicator every 10 seconds.
  late final Timer _timer;

  /// The offset to center the circle on the first pixel of the pageview.
  static const _circleCenterOffset = 1.0;

  @override
  void initState() {
    super.initState();
    _startTimer();
  }

  @override
  void didUpdateWidget(covariant TimeIndicator oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.timeOfDayRange != oldWidget.timeOfDayRange ||
        oldWidget.location != widget.location ||
        oldWidget.nowCallback != widget.nowCallback) {
      setState(() {});
    }
  }

  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }

  void _startTimer() => _timer = Timer.periodic(const Duration(seconds: 10), (_) => setState(() {}));

  @override
  Widget build(BuildContext context) {
    final now = widget.nowCallback != null
        ? InternalDateTime.fromDateTime(widget.nowCallback!())
        : InternalDateTime.fromExternal(DateTime.timestamp(), location: widget.location);
    final startTime = widget.timeOfDayRange.start.toInternalDateTime(now);
    final endTime = widget.timeOfDayRange.end.toInternalDateTime(now);
    final showIndicator = now.isAfter(startTime) && now.isBefore(endTime);
    if (!showIndicator) return const SizedBox.shrink();
    final top = now.difference(startTime).inMinutes * widget.heightPerMinute;

    final style = (KalenderTheme.of(context).timeIndicatorStyle ?? const TimeIndicatorStyle()).merge(widget.style);
    // Never null: KalenderThemeData.defaults always sets it, which a test pins.
    final lineColor = style.lineColor!;
    final thickness = style.thickness ?? 1;

    final circleWidth = style.circleSize?.width ?? 10;
    final circleHeight = style.circleSize?.height ?? 10;

    // This ignore pointer is needed so that users can interact with the event tiles and other components that are behind the time indicator.
    return IgnorePointer(
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          PositionedDirectional(
            top: top,
            start: 0,
            end: 0,
            child: Container(
              height: thickness,
              color: lineColor,
            ),
          ),
          PositionedDirectional(
            top: top - circleHeight / 2,
            // This needs to be offset slightly so the center of the circle aligns with the first pixel of the pageview.
            start: -(circleWidth / 2) + _circleCenterOffset,
            width: circleWidth,
            height: circleHeight,
            child: DecoratedBox(
              decoration: BoxDecoration(
                color: style.circleColor ?? lineColor,
                shape: BoxShape.circle,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

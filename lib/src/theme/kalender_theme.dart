import 'package:flutter/material.dart';
import 'package:kalender/kalender.dart';

/// The calendar's visual theme, following the same layering as Flutter's own component themes.
///
/// Styling is resolved in three layers, most specific first:
/// 1. A style passed directly to a widget or through the component style containers.
/// 2. A [KalenderThemeData] registered as a [ThemeExtension] on the app's [ThemeData].
/// 3. Material 3 defaults derived from the ambient [Theme], see [KalenderThemeData.defaults].
///
/// To theme every calendar in the app:
///
/// ```dart
/// MaterialApp(
///   theme: ThemeData(
///     extensions: [
///       KalenderThemeData(
///         timeIndicatorStyle: TimeIndicatorStyle(lineColor: Colors.pink),
///       ),
///     ],
///   ),
/// )
/// ```
class KalenderThemeData extends ThemeExtension<KalenderThemeData> {
  /// The style of the [DayHeader].
  final DayHeaderStyle? dayHeaderStyle;

  /// The style of the [TimeLine].
  final TimelineStyle? timelineStyle;

  /// The style of the [HourLines].
  final HourLinesStyle? hourLinesStyle;

  /// The style of the [DaySeparator].
  final DaySeparatorStyle? daySeparatorStyle;

  /// The style of the [TimeIndicator].
  final TimeIndicatorStyle? timeIndicatorStyle;

  /// The style of the [WeekNumber].
  final WeekNumberStyle? weekNumberStyle;

  /// The style of the [MonthGrid].
  final MonthGridStyle? monthGridStyle;

  /// The style of the [MonthDayHeader].
  final MonthDayHeaderStyle? monthDayHeaderStyle;

  /// The style of the [WeekDayHeader].
  final WeekDayHeaderStyle? weekDayHeaderStyle;

  /// The style of the [ScheduleDate].
  final ScheduleDateStyle? scheduleDateStyle;

  /// The style of the [ScheduleTileHighlight].
  final ScheduleTileHighlightStyle? scheduleTileHighlightStyle;

  /// The style of the [MultiDayOverlay].
  final MultiDayOverlayStyle? multiDayOverlayStyle;

  /// The style of the [MultiDayPortalOverlayButton].
  final MultiDayPortalOverlayButtonStyle? multiDayPortalOverlayButtonStyle;

  /// Creates a new [KalenderThemeData].
  const KalenderThemeData({
    this.dayHeaderStyle,
    this.timelineStyle,
    this.hourLinesStyle,
    this.daySeparatorStyle,
    this.timeIndicatorStyle,
    this.weekNumberStyle,
    this.monthGridStyle,
    this.monthDayHeaderStyle,
    this.weekDayHeaderStyle,
    this.scheduleDateStyle,
    this.scheduleTileHighlightStyle,
    this.multiDayOverlayStyle,
    this.multiDayPortalOverlayButtonStyle,
  });

  /// The Material 3 defaults, derived from the [Theme] of the given [context].
  ///
  /// This is the single place where the calendar's default visuals are defined.
  /// Fields that depend on runtime state stay null:
  /// - string builders, which use the ambient locale inside the widgets.
  /// - [TimeIndicatorStyle.circleColor], which falls back to the line color.
  /// - text styles that intentionally inherit from [DefaultTextStyle].
  static KalenderThemeData defaults(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final textTheme = theme.textTheme;

    final tooltipDecoration = BoxDecoration(
      color: colorScheme.surfaceContainerHighest,
      borderRadius: BorderRadius.circular(8),
    );

    return KalenderThemeData(
      dayHeaderStyle: DayHeaderStyle(
        textStyle: textTheme.bodySmall,
        numberTextStyle: textTheme.bodyMedium,
        mainAxisAlignment: MainAxisAlignment.start,
      ),
      timelineStyle: TimelineStyle(
        textStyle: textTheme.labelMedium,
        textDirection: TextDirection.ltr,
        textPadding: const EdgeInsets.symmetric(horizontal: 8, vertical: 36),
        startDecoration: tooltipDecoration,
        endDecoration: tooltipDecoration,
      ),
      hourLinesStyle: HourLinesStyle(
        color: colorScheme.surfaceContainerHighest,
        thickness: 1,
        indent: 0,
        endIndent: 0,
      ),
      daySeparatorStyle: DaySeparatorStyle(
        color: colorScheme.surfaceContainerHighest,
        width: 1,
        topIndent: 0,
        bottomIndent: 0,
      ),
      timeIndicatorStyle: TimeIndicatorStyle(
        lineColor: colorScheme.error,
        thickness: 1,
        circleSize: const Size(10, 10),
      ),
      weekNumberStyle: WeekNumberStyle(
        textStyle: textTheme.bodyMedium,
        visualDensity: VisualDensity.compact,
        tooltip: 'Week Number',
        padding: const EdgeInsets.symmetric(horizontal: 4),
        alignment: Alignment.center,
      ),
      monthGridStyle: MonthGridStyle(
        color: colorScheme.surfaceContainerHighest,
        thickness: 0,
      ),
      monthDayHeaderStyle: MonthDayHeaderStyle(
        numberTextStyle: textTheme.bodyMedium,
        // Keeps the today highlight clear of the gridline above it and the
        // event tiles below it.
        margin: const EdgeInsets.symmetric(vertical: 2),
      ),
      weekDayHeaderStyle: WeekDayHeaderStyle(
        textStyle: textTheme.bodySmall,
        padding: const EdgeInsets.symmetric(vertical: 2),
      ),
      scheduleDateStyle: ScheduleDateStyle(
        textStyle: textTheme.bodySmall,
        numberTextStyle: textTheme.bodyMedium,
      ),
      scheduleTileHighlightStyle: ScheduleTileHighlightStyle(
        decoration: BoxDecoration(color: colorScheme.primary.withAlpha(50)),
      ),
      multiDayOverlayStyle: MultiDayOverlayStyle(
        closeIcon: const Icon(Icons.close),
        dateTextStyle: textTheme.bodyMedium,
        headerPadding: const EdgeInsets.symmetric(vertical: 8),
        eventsPadding: const EdgeInsets.all(4),
        eventPadding: const EdgeInsets.symmetric(vertical: 2),
      ),
      multiDayPortalOverlayButtonStyle: MultiDayPortalOverlayButtonStyle(
        textStyle: textTheme.bodyMedium,
        textPadding: const EdgeInsets.symmetric(horizontal: 4),
        textOverflow: TextOverflow.ellipsis,
      ),
    );
  }

  @override
  KalenderThemeData copyWith({
    DayHeaderStyle? dayHeaderStyle,
    TimelineStyle? timelineStyle,
    HourLinesStyle? hourLinesStyle,
    DaySeparatorStyle? daySeparatorStyle,
    TimeIndicatorStyle? timeIndicatorStyle,
    WeekNumberStyle? weekNumberStyle,
    MonthGridStyle? monthGridStyle,
    MonthDayHeaderStyle? monthDayHeaderStyle,
    WeekDayHeaderStyle? weekDayHeaderStyle,
    ScheduleDateStyle? scheduleDateStyle,
    ScheduleTileHighlightStyle? scheduleTileHighlightStyle,
    MultiDayOverlayStyle? multiDayOverlayStyle,
    MultiDayPortalOverlayButtonStyle? multiDayPortalOverlayButtonStyle,
  }) {
    return KalenderThemeData(
      dayHeaderStyle: dayHeaderStyle ?? this.dayHeaderStyle,
      timelineStyle: timelineStyle ?? this.timelineStyle,
      hourLinesStyle: hourLinesStyle ?? this.hourLinesStyle,
      daySeparatorStyle: daySeparatorStyle ?? this.daySeparatorStyle,
      timeIndicatorStyle: timeIndicatorStyle ?? this.timeIndicatorStyle,
      weekNumberStyle: weekNumberStyle ?? this.weekNumberStyle,
      monthGridStyle: monthGridStyle ?? this.monthGridStyle,
      monthDayHeaderStyle: monthDayHeaderStyle ?? this.monthDayHeaderStyle,
      weekDayHeaderStyle: weekDayHeaderStyle ?? this.weekDayHeaderStyle,
      scheduleDateStyle: scheduleDateStyle ?? this.scheduleDateStyle,
      scheduleTileHighlightStyle: scheduleTileHighlightStyle ?? this.scheduleTileHighlightStyle,
      multiDayOverlayStyle: multiDayOverlayStyle ?? this.multiDayOverlayStyle,
      multiDayPortalOverlayButtonStyle: multiDayPortalOverlayButtonStyle ?? this.multiDayPortalOverlayButtonStyle,
    );
  }

  /// Returns a copy of this theme where each style is overlaid with the matching style of [other].
  ///
  /// Field-level merge: a style present in both keeps its fields where [other]'s are null.
  KalenderThemeData merge(KalenderThemeData? other) {
    if (other == null) return this;
    return KalenderThemeData(
      dayHeaderStyle: dayHeaderStyle?.merge(other.dayHeaderStyle) ?? other.dayHeaderStyle,
      timelineStyle: timelineStyle?.merge(other.timelineStyle) ?? other.timelineStyle,
      hourLinesStyle: hourLinesStyle?.merge(other.hourLinesStyle) ?? other.hourLinesStyle,
      daySeparatorStyle: daySeparatorStyle?.merge(other.daySeparatorStyle) ?? other.daySeparatorStyle,
      timeIndicatorStyle: timeIndicatorStyle?.merge(other.timeIndicatorStyle) ?? other.timeIndicatorStyle,
      weekNumberStyle: weekNumberStyle?.merge(other.weekNumberStyle) ?? other.weekNumberStyle,
      monthGridStyle: monthGridStyle?.merge(other.monthGridStyle) ?? other.monthGridStyle,
      monthDayHeaderStyle: monthDayHeaderStyle?.merge(other.monthDayHeaderStyle) ?? other.monthDayHeaderStyle,
      weekDayHeaderStyle: weekDayHeaderStyle?.merge(other.weekDayHeaderStyle) ?? other.weekDayHeaderStyle,
      scheduleDateStyle: scheduleDateStyle?.merge(other.scheduleDateStyle) ?? other.scheduleDateStyle,
      scheduleTileHighlightStyle:
          scheduleTileHighlightStyle?.merge(other.scheduleTileHighlightStyle) ?? other.scheduleTileHighlightStyle,
      multiDayOverlayStyle: multiDayOverlayStyle?.merge(other.multiDayOverlayStyle) ?? other.multiDayOverlayStyle,
      multiDayPortalOverlayButtonStyle:
          multiDayPortalOverlayButtonStyle?.merge(other.multiDayPortalOverlayButtonStyle) ??
              other.multiDayPortalOverlayButtonStyle,
    );
  }

  @override
  KalenderThemeData lerp(KalenderThemeData? other, double t) {
    if (other == null) return this;
    return KalenderThemeData(
      dayHeaderStyle: DayHeaderStyle.lerp(dayHeaderStyle, other.dayHeaderStyle, t),
      timelineStyle: TimelineStyle.lerp(timelineStyle, other.timelineStyle, t),
      hourLinesStyle: HourLinesStyle.lerp(hourLinesStyle, other.hourLinesStyle, t),
      daySeparatorStyle: DaySeparatorStyle.lerp(daySeparatorStyle, other.daySeparatorStyle, t),
      timeIndicatorStyle: TimeIndicatorStyle.lerp(timeIndicatorStyle, other.timeIndicatorStyle, t),
      weekNumberStyle: WeekNumberStyle.lerp(weekNumberStyle, other.weekNumberStyle, t),
      monthGridStyle: MonthGridStyle.lerp(monthGridStyle, other.monthGridStyle, t),
      monthDayHeaderStyle: MonthDayHeaderStyle.lerp(monthDayHeaderStyle, other.monthDayHeaderStyle, t),
      weekDayHeaderStyle: WeekDayHeaderStyle.lerp(weekDayHeaderStyle, other.weekDayHeaderStyle, t),
      scheduleDateStyle: ScheduleDateStyle.lerp(scheduleDateStyle, other.scheduleDateStyle, t),
      scheduleTileHighlightStyle:
          ScheduleTileHighlightStyle.lerp(scheduleTileHighlightStyle, other.scheduleTileHighlightStyle, t),
      multiDayOverlayStyle: MultiDayOverlayStyle.lerp(multiDayOverlayStyle, other.multiDayOverlayStyle, t),
      multiDayPortalOverlayButtonStyle: MultiDayPortalOverlayButtonStyle.lerp(
        multiDayPortalOverlayButtonStyle,
        other.multiDayPortalOverlayButtonStyle,
        t,
      ),
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is KalenderThemeData &&
        other.dayHeaderStyle == dayHeaderStyle &&
        other.timelineStyle == timelineStyle &&
        other.hourLinesStyle == hourLinesStyle &&
        other.daySeparatorStyle == daySeparatorStyle &&
        other.timeIndicatorStyle == timeIndicatorStyle &&
        other.weekNumberStyle == weekNumberStyle &&
        other.monthGridStyle == monthGridStyle &&
        other.monthDayHeaderStyle == monthDayHeaderStyle &&
        other.weekDayHeaderStyle == weekDayHeaderStyle &&
        other.scheduleDateStyle == scheduleDateStyle &&
        other.scheduleTileHighlightStyle == scheduleTileHighlightStyle &&
        other.multiDayOverlayStyle == multiDayOverlayStyle &&
        other.multiDayPortalOverlayButtonStyle == multiDayPortalOverlayButtonStyle;
  }

  @override
  int get hashCode => Object.hash(
        dayHeaderStyle,
        timelineStyle,
        hourLinesStyle,
        daySeparatorStyle,
        timeIndicatorStyle,
        weekNumberStyle,
        monthGridStyle,
        monthDayHeaderStyle,
        weekDayHeaderStyle,
        scheduleDateStyle,
        scheduleTileHighlightStyle,
        multiDayOverlayStyle,
        multiDayPortalOverlayButtonStyle,
      );
}

/// Resolves the effective [KalenderThemeData] for a [BuildContext].
abstract final class KalenderTheme {
  /// The effective theme: the Material 3 defaults overlaid with the app's
  /// [KalenderThemeData] extension, if one is registered on [ThemeData.extensions].
  ///
  /// A style passed directly to a widget still takes precedence over the
  /// value returned here.
  static KalenderThemeData of(BuildContext context) {
    final extension = Theme.of(context).extension<KalenderThemeData>();
    return KalenderThemeData.defaults(context).merge(extension);
  }
}

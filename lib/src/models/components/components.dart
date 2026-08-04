import 'package:flutter/material.dart';
import 'package:kalender/src/models/components/month_components.dart';
import 'package:kalender/src/models/components/month_styles.dart';
import 'package:kalender/src/models/components/multi_day_components.dart';
import 'package:kalender/src/models/components/multi_day_styles.dart';
import 'package:kalender/src/models/components/schedule_components.dart';
import 'package:kalender/src/models/components/schedule_styles.dart';
import 'package:kalender/src/models/components/string_builders.dart';
import 'package:kalender/src/widgets/components/multi_day_overlay.dart';
import 'package:kalender/src/widgets/components/multi_day_overlay_portal.dart';
import 'package:kalender/src/widgets/components/multi_day_overlay_portal_button.dart';

/// A styling class used by the [CalendarView].
///
/// Change the style the default widgets with [multiDayComponentStyles] and [monthComponentStyles].
/// Provide your own widgets with [multiDayComponents] and [monthComponents].
class CalendarComponents {
  /// Components used to override the default month components
  final MonthComponents monthComponents;

  /// Styles used by the month view.
  final MonthComponentStyles monthComponentStyles;

  /// Components used to override the default multi day components.
  final MultiDayComponents multiDayComponents;

  /// Styles used by the multi day view.
  final MultiDayComponentStyles multiDayComponentStyles;

  /// Components used to override the default schedule components.
  final ScheduleComponents scheduleComponents;

  /// Styles used by the schedule view.
  final ScheduleComponentStyles scheduleComponentStyles;

  /// Default override for the overlay widgets.
  ///
  /// If a more specific builder is provided in [multiDayComponents] or [monthComponents], that will be used instead.
  final OverlayBuilders? overlayBuilders;

  /// Default styles for the overlay widgets.
  ///
  /// If another style is provided in [multiDayComponentStyles] or [monthComponentStyles], that will be used instead.
  final OverlayStyles? overlayStyles;

  const CalendarComponents({
    this.monthComponents = const MonthComponents(),
    this.monthComponentStyles = const MonthComponentStyles(),
    this.multiDayComponents = const MultiDayComponents(),
    this.multiDayComponentStyles = const MultiDayComponentStyles(),
    this.scheduleComponents = const ScheduleComponents(),
    this.scheduleComponentStyles = const ScheduleComponentStyles(),
    this.overlayBuilders,
    this.overlayStyles,
  });

  /// Creates a copy of this with the given fields replaced.
  CalendarComponents copyWith({
    MonthComponents? monthComponents,
    MonthComponentStyles? monthComponentStyles,
    MultiDayComponents? multiDayComponents,
    MultiDayComponentStyles? multiDayComponentStyles,
    ScheduleComponents? scheduleComponents,
    ScheduleComponentStyles? scheduleComponentStyles,
    OverlayBuilders? overlayBuilders,
    OverlayStyles? overlayStyles,
  }) {
    return CalendarComponents(
      monthComponents: monthComponents ?? this.monthComponents,
      monthComponentStyles: monthComponentStyles ?? this.monthComponentStyles,
      multiDayComponents: multiDayComponents ?? this.multiDayComponents,
      multiDayComponentStyles: multiDayComponentStyles ?? this.multiDayComponentStyles,
      scheduleComponents: scheduleComponents ?? this.scheduleComponents,
      scheduleComponentStyles: scheduleComponentStyles ?? this.scheduleComponentStyles,
      overlayBuilders: overlayBuilders ?? this.overlayBuilders,
      overlayStyles: overlayStyles ?? this.overlayStyles,
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is CalendarComponents &&
        other.monthComponents == monthComponents &&
        other.monthComponentStyles == monthComponentStyles &&
        other.multiDayComponents == multiDayComponents &&
        other.multiDayComponentStyles == multiDayComponentStyles &&
        other.scheduleComponents == scheduleComponents &&
        other.scheduleComponentStyles == scheduleComponentStyles &&
        other.overlayBuilders == overlayBuilders &&
        other.overlayStyles == overlayStyles;
  }

  @override
  int get hashCode => Object.hash(
        monthComponents,
        monthComponentStyles,
        multiDayComponents,
        multiDayComponentStyles,
        scheduleComponents,
        scheduleComponentStyles,
        overlayBuilders,
        overlayStyles,
      );
}

/// Builders used to create the overlayPortal, overlay and overlay button widgets.
class OverlayBuilders {
  /// The builder for the multi day overlay.
  final MultiDayOverlayBuilder? multiDayOverlayBuilder;

  /// The builder for the multi day overlay portal.
  final MultiDayOverlayPortalBuilder? multiDayOverlayPortalBuilder;

  /// The builder for the multi day overlay portal button.
  final MultiDayPortalOverlayButtonBuilder? multiDayPortalOverlayButtonBuilder;

  /// Builds the label of the multi day overlay portal button.
  ///
  /// Defaults to a plus sign followed by the number of hidden events, with the
  /// number formatted for the calendar's locale.
  final HiddenEventCountStringBuilder? multiDayPortalOverlayButtonStringBuilder;

  const OverlayBuilders({
    this.multiDayOverlayBuilder,
    this.multiDayOverlayPortalBuilder,
    this.multiDayPortalOverlayButtonBuilder,
    this.multiDayPortalOverlayButtonStringBuilder,
  });

  /// Creates a copy of this with the given fields replaced.
  OverlayBuilders copyWith({
    MultiDayOverlayBuilder? multiDayOverlayBuilder,
    MultiDayOverlayPortalBuilder? multiDayOverlayPortalBuilder,
    MultiDayPortalOverlayButtonBuilder? multiDayPortalOverlayButtonBuilder,
    HiddenEventCountStringBuilder? multiDayPortalOverlayButtonStringBuilder,
  }) {
    return OverlayBuilders(
      multiDayOverlayBuilder: multiDayOverlayBuilder ?? this.multiDayOverlayBuilder,
      multiDayOverlayPortalBuilder: multiDayOverlayPortalBuilder ?? this.multiDayOverlayPortalBuilder,
      multiDayPortalOverlayButtonBuilder: multiDayPortalOverlayButtonBuilder ?? this.multiDayPortalOverlayButtonBuilder,
      multiDayPortalOverlayButtonStringBuilder:
          multiDayPortalOverlayButtonStringBuilder ?? this.multiDayPortalOverlayButtonStringBuilder,
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is OverlayBuilders &&
        other.multiDayOverlayBuilder == multiDayOverlayBuilder &&
        other.multiDayOverlayPortalBuilder == multiDayOverlayPortalBuilder &&
        other.multiDayPortalOverlayButtonBuilder == multiDayPortalOverlayButtonBuilder &&
        other.multiDayPortalOverlayButtonStringBuilder == multiDayPortalOverlayButtonStringBuilder;
  }

  @override
  int get hashCode => Object.hash(
        multiDayOverlayBuilder,
        multiDayOverlayPortalBuilder,
        multiDayPortalOverlayButtonBuilder,
        multiDayPortalOverlayButtonStringBuilder,
      );
}

/// Styles used by the overlay widgets.
class OverlayStyles {
  /// The style for the multi day overlay.
  final MultiDayOverlayStyle? multiDayOverlayStyle;

  /// The style for the multi day overlay portal button.
  final MultiDayPortalOverlayButtonStyle? multiDayPortalOverlayButtonStyle;

  const OverlayStyles({
    this.multiDayOverlayStyle,
    this.multiDayPortalOverlayButtonStyle,
  });

  /// Creates a copy of this with the given fields replaced.
  OverlayStyles copyWith({
    MultiDayOverlayStyle? multiDayOverlayStyle,
    MultiDayPortalOverlayButtonStyle? multiDayPortalOverlayButtonStyle,
  }) {
    return OverlayStyles(
      multiDayOverlayStyle: multiDayOverlayStyle ?? this.multiDayOverlayStyle,
      multiDayPortalOverlayButtonStyle: multiDayPortalOverlayButtonStyle ?? this.multiDayPortalOverlayButtonStyle,
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is OverlayStyles &&
        other.multiDayOverlayStyle == multiDayOverlayStyle &&
        other.multiDayPortalOverlayButtonStyle == multiDayPortalOverlayButtonStyle;
  }

  @override
  int get hashCode => Object.hash(multiDayOverlayStyle, multiDayPortalOverlayButtonStyle);
}

/// The trigger widget builder, should be constrained in width.
///
/// The [pageWidth] is the width of the page.
typedef HorizontalTriggerWidgetBuilder = Widget Function(double pageWidth);

/// The trigger widget builder, should be constrained in height.
///
/// The [viewPortHeight] is the height of the page.
typedef VerticalTriggerWidgetBuilder = Widget Function(double viewPortHeight);

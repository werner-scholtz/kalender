import 'package:flutter/material.dart';
import 'package:kalender/src/kalender_view.dart';
import 'package:kalender/src/models/components/month_components.dart';
import 'package:kalender/src/models/components/multi_day_components.dart';
import 'package:kalender/src/models/components/schedule_components.dart';
import 'package:kalender/src/models/components/string_builders.dart';
import 'package:kalender/src/theme/kalender_theme.dart';
import 'package:kalender/src/widgets/components/multi_day_overlay.dart';
import 'package:kalender/src/widgets/components/multi_day_overlay_portal.dart';
import 'package:kalender/src/widgets/components/multi_day_overlay_portal_button.dart';

/// A class holding the widget builders used by the [KalenderView].
///
/// Provide your own widgets with [multiDayComponents], [monthComponents] and
/// [scheduleComponents]. Styling goes through [KalenderThemeData] for the whole
/// app, or a [KalenderTheme] to scope one calendar.
class CalendarComponents {
  /// Components used to override the default month components
  final MonthComponents monthComponents;

  /// Components used to override the default multi day components.
  final MultiDayComponents multiDayComponents;

  /// Components used to override the default schedule components.
  final ScheduleComponents scheduleComponents;

  /// Default override for the overlay widgets.
  ///
  /// If a more specific builder is provided in [multiDayComponents] or [monthComponents], that will be used instead.
  final OverlayBuilders? overlayBuilders;

  const CalendarComponents({
    this.monthComponents = const MonthComponents(),
    this.multiDayComponents = const MultiDayComponents(),
    this.scheduleComponents = const ScheduleComponents(),
    this.overlayBuilders,
  });

  /// Creates a copy of this with the given fields replaced.
  CalendarComponents copyWith({
    MonthComponents? monthComponents,
    MultiDayComponents? multiDayComponents,
    ScheduleComponents? scheduleComponents,
    OverlayBuilders? overlayBuilders,
  }) {
    return CalendarComponents(
      monthComponents: monthComponents ?? this.monthComponents,
      multiDayComponents: multiDayComponents ?? this.multiDayComponents,
      scheduleComponents: scheduleComponents ?? this.scheduleComponents,
      overlayBuilders: overlayBuilders ?? this.overlayBuilders,
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is CalendarComponents &&
        other.monthComponents == monthComponents &&
        other.multiDayComponents == multiDayComponents &&
        other.scheduleComponents == scheduleComponents &&
        other.overlayBuilders == overlayBuilders;
  }

  @override
  int get hashCode => Object.hash(
        monthComponents,
        multiDayComponents,
        scheduleComponents,
        overlayBuilders,
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

/// The trigger widget builder, should be constrained in width.
///
/// The [pageWidth] is the width of the page.
typedef HorizontalTriggerWidgetBuilder = Widget Function(BuildContext context, double pageWidth);

/// The trigger widget builder, should be constrained in height.
///
/// The [viewPortHeight] is the height of the page.
typedef VerticalTriggerWidgetBuilder = Widget Function(BuildContext context, double viewPortHeight);

import 'package:flutter/material.dart';
import 'package:kalender/src/models/components/month_components.dart';
import 'package:kalender/src/models/components/month_styles.dart';
import 'package:kalender/src/models/components/multi_day_components.dart';
import 'package:kalender/src/models/components/multi_day_styles.dart';
import 'package:kalender/src/models/components/schedule_components.dart';
import 'package:kalender/src/models/components/schedule_styles.dart';
import 'package:kalender/src/widgets/components/multi_day_overlay.dart';
import 'package:kalender/src/widgets/components/multi_day_overlay_portal.dart';
import 'package:kalender/src/widgets/components/multi_day_overlay_portal_button.dart';

/// A styling class used by the [CalendarView].
///
/// Change the style the default widgets with [multiDayComponentStyles] and [monthComponentStyles].
/// Provide your own widgets with [multiDayComponents] and [monthComponents].
class CalendarComponents<T extends Object?> {
  /// Components used to override the default month components
  final MonthComponents<T>? monthComponents;

  /// Styles used by the month view.
  final MonthComponentStyles? monthComponentStyles;

  /// Components used to override the default multi day components.
  final MultiDayComponents<T>? multiDayComponents;

  /// Styles used by the multi day view.
  final MultiDayComponentStyles? multiDayComponentStyles;

  /// Components used to override the default schedule components.
  final ScheduleComponents<T>? scheduleComponents;

  /// Styles used by the schedule view.
  final ScheduleComponentStyles? scheduleComponentStyles;

  CalendarComponents({
    this.monthComponents,
    this.monthComponentStyles,
    this.multiDayComponents,
    this.multiDayComponentStyles,
    this.scheduleComponents,
    this.scheduleComponentStyles,
  });
}

/// Builders used to create the overlayPortal, overlay and overlay button widgets.
class OverlayBuilders<T extends Object?> {
  /// The builder for the multi day overlay.
  final MultiDayOverlayBuilder<T>? multiDayOverlayBuilder;

  /// The builder for the multi day overlay portal.
  final MultiDayOverlayPortalBuilder<T>? multiDayOverlayPortalBuilder;

  /// The builder for the multi day overlay portal button.
  final MultiDayPortalOverlayButtonBuilder? multiDayPortalOverlayButtonBuilder;

  OverlayBuilders({
    this.multiDayOverlayBuilder,
    this.multiDayOverlayPortalBuilder,
    this.multiDayPortalOverlayButtonBuilder,
  });
}

/// Styles used by the overlay widgets.
class OverlayStyles {
  /// The style for the multi day overlay.
  final MultiDayOverlayStyle? multiDayOverlayStyle;

  /// The style for the multi day overlay portal button.
  final MultiDayPortalOverlayButtonStyle? multiDayPortalOverlayButtonStyle;

  OverlayStyles({
    this.multiDayOverlayStyle,
    this.multiDayPortalOverlayButtonStyle,
  });
}

/// The trigger widget builder, should be constrained in width.
///
/// The [pageWidth] is the width of the page.
typedef HorizontalTriggerWidgetBuilder = Widget Function(double pageWidth);

/// The trigger widget builder, should be constrained in height.
///
/// The [viewPortHeight] is the height of the page.
typedef VerticalTriggerWidgetBuilder = Widget Function(double viewPortHeight);

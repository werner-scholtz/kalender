// This file is part of kalender.
//
// SPDX-FileCopyrightText: 2023 Klarälvdalens Datakonsult AB, a KDAB Group company <info@kdab.com>
//
// SPDX-License-Identifier: MIT

import 'package:kalender/kalender.dart';

/// How the horizontal date is chosen when switching to a view.
///
/// {@category Views}
enum DateTransition {
  /// Carry the current focus forward from the view being switched away from
  /// (e.g. the visible week's start becomes the new day). This is the default.
  carryFocus,

  /// Restore the date this view last displayed (matched by configuration `name`),
  /// falling back to [carryFocus] when the view has no recorded history yet.
  restorePerView,
}

/// How the vertical scroll position (time-of-day) is chosen when switching to a
/// multi-day view.
///
/// {@category Views}
enum ScrollTransition {
  /// Keep the time-of-day the user was last looking at in a multi-day view
  /// (survives a round-trip through a view without scroll, e.g. Month). Default.
  preserve,

  /// Reset to the view's configured `initialTimeOfDay`.
  reset,

  /// Restore the time-of-day this view last displayed (matched by configuration
  /// `name`), falling back to [preserve].
  restorePerView,
}

/// How the zoom (`heightPerMinute`) is chosen when switching to a multi-day view.
///
/// {@category Views}
enum ZoomTransition {
  /// Keep the last multi-day zoom level. Default.
  preserve,

  /// Reset to the view's configured `initialHeightPerMinute`.
  reset,

  /// Restore the zoom this view last used (matched by configuration `name`),
  /// falling back to [preserve].
  restorePerView,
}

/// Resolves the initial date for the incoming view. Overrides [DateTransition].
///
/// {@category Views}
typedef DateResolver = FloatingDateTime Function(ViewTransitionContext transition);

/// Resolves the initial time-of-day for the incoming multi-day view. Overrides
/// [ScrollTransition]. Return `null` to use the view's `initialTimeOfDay`.
///
/// {@category Views}
typedef ScrollResolver = KalenderTime? Function(ViewTransitionContext transition);

/// Resolves the initial zoom (`heightPerMinute`) for the incoming multi-day view.
/// Overrides [ZoomTransition]. Return `null` to use `initialHeightPerMinute`.
///
/// {@category Views}
typedef ZoomResolver = double? Function(ViewTransitionContext transition);

/// A snapshot of what a view was displaying, captured when it is switched away
/// from. Used to restore per-view state on a later switch.
///
/// {@category Views}
class ViewSnapshot {
  const ViewSnapshot({required this.date, this.timeOfDay, this.heightPerMinute});

  /// The representative date the view was showing.
  final FloatingDateTime date;

  /// The time-of-day at the top of the viewport, or `null` for views without a
  /// vertical scroll (month/schedule).
  final KalenderTime? timeOfDay;

  /// The zoom level, or `null` for non-multi-day views.
  final double? heightPerMinute;
}

/// The inputs available when resolving how a view switch or a location change should transfer state.
///
/// {@category Views}
class ViewTransitionContext {
  const ViewTransitionContext({
    required this.oldViewController,
    required this.newViewConfiguration,
    required this.byView,
    required this.lastMultiDay,
    this.locationChanged = false,
  });

  /// The controller of the view being switched away from.
  final ViewController oldViewController;

  /// The configuration of the view being switched to.
  final ViewConfiguration newViewConfiguration;

  /// The last snapshot of each view, keyed by its configuration `name`.
  final Map<String, ViewSnapshot> byView;

  /// The most recent multi-day snapshot, kept even across an intermediate view
  /// without scroll (e.g. Week → Month → Week).
  final ViewSnapshot? lastMultiDay;

  /// Whether the calendar's location changed. A location change runs the resolvers even when the view
  /// configuration stays the same.
  final bool locationChanged;
}

/// The "carry the current focus forward" date used by [DateTransition.carryFocus].
///
/// Routes to [kDefaultToMonthly] / [kDefaultToWeekly] / [kDefaultToDaily] /
/// [kDefaultToSchedule] based on the view being switched *to*. Exposed so a
/// custom [DateResolver] can build on the default behaviour, e.g.
/// `dateResolver: (transition) => nextBusinessDay(kCarryFocusDate(transition))`.
///
/// {@category Views}
FloatingDateTime kCarryFocusDate(ViewTransitionContext transition) {
  final old = transition.oldViewController;
  return switch (transition.newViewConfiguration) {
    MonthViewConfiguration _ => kDefaultToMonthly(old),
    ScheduleViewConfiguration _ => kDefaultToSchedule(old),
    final MultiDayViewConfiguration config => switch (config.type) {
      MultiDayViewType.custom when config.numberOfDays == 1 => kDefaultToDaily(old),
      MultiDayViewType.freeScroll when config.numberOfDays == 1 => kDefaultToDaily(old),
      MultiDayViewType.singleDay => kDefaultToDaily(old),
      _ => kDefaultToWeekly(old),
    },
    _ => kDefaultToDaily(old),
  };
}

/// Carry-focus date when switching **to** a month view, derived from [old].
///
/// {@category Views}
FloatingDateTime kDefaultToMonthly(ViewController old) {
  final oldRange = old.floatingVisibleRange.value!;
  return switch (old.viewConfiguration) {
    MonthViewConfiguration _ => FloatingDateTime.fromDateTime(oldRange.dominantMonthDate),
    MultiDayViewConfiguration _ => oldRange.start,
    ScheduleViewConfiguration _ => oldRange.start,
    _ => FloatingDateTime.fromDateTime(oldRange.dominantMonthDate),
  };
}

/// Carry-focus date when switching **to** a weekly (multi-day) view, derived from [old].
///
/// {@category Views}
FloatingDateTime kDefaultToWeekly(ViewController old) => _focusDate(old);

/// Carry-focus date when switching **to** a daily view, derived from [old].
///
/// {@category Views}
FloatingDateTime kDefaultToDaily(ViewController old) => _focusDate(old);

/// Carry-focus date when switching **to** a schedule view, derived from [old].
///
/// {@category Views}
FloatingDateTime kDefaultToSchedule(ViewController old) => _focusDate(old);

/// The first day of the month with the most visible days for a month view, else the start of the visible range.
FloatingDateTime _focusDate(ViewController old) {
  final oldRange = old.floatingVisibleRange.value!;
  if (old.viewConfiguration is MonthViewConfiguration) return FloatingDateTime.fromDateTime(oldRange.dominantMonthDate);
  return oldRange.start;
}

import 'package:flutter/material.dart';
import 'package:kalender/kalender.dart';

/// How the horizontal date is chosen when switching to a view.
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
typedef DateResolver = InternalDateTime Function(ViewTransitionContext context);

/// Resolves the initial time-of-day for the incoming multi-day view. Overrides
/// [ScrollTransition]. Return `null` to use the view's `initialTimeOfDay`.
typedef ScrollResolver = TimeOfDay? Function(ViewTransitionContext context);

/// Resolves the initial zoom (`heightPerMinute`) for the incoming multi-day view.
/// Overrides [ZoomTransition]. Return `null` to use `initialHeightPerMinute`.
typedef ZoomResolver = double? Function(ViewTransitionContext context);

/// A snapshot of what a view was displaying, captured when it is switched away
/// from. Used to restore per-view state on a later switch.
class ViewSnapshot {
  const ViewSnapshot({required this.date, this.timeOfDay, this.heightPerMinute});

  /// The representative date the view was showing.
  final InternalDateTime date;

  /// The time-of-day at the top of the viewport, or `null` for views without a
  /// vertical scroll (month/schedule).
  final TimeOfDay? timeOfDay;

  /// The zoom level, or `null` for non-multi-day views.
  final double? heightPerMinute;
}

/// The inputs available when resolving how a view switch should transfer state.
class ViewTransitionContext {
  const ViewTransitionContext({
    required this.oldViewController,
    required this.newViewConfiguration,
    required this.byView,
    required this.lastMultiDay,
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
}

/// The "carry the current focus forward" date used by [DateTransition.carryFocus].
///
/// Routes to [kDefaultToMonthly] / [kDefaultToWeekly] / [kDefaultToDaily] /
/// [kDefaultToSchedule] based on the view being switched *to*. Exposed so a
/// custom [DateResolver] can build on the default behaviour, e.g.
/// `dateResolver: (ctx) => nextBusinessDay(kCarryFocusDate(ctx))`.
InternalDateTime kCarryFocusDate(ViewTransitionContext context) {
  final old = context.oldViewController;
  return switch (context.newViewConfiguration) {
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
InternalDateTime kDefaultToMonthly(ViewController old) {
  final oldRange = old.visibleDateTimeRange.value!;
  return switch (old.viewConfiguration) {
    MonthViewConfiguration _ => InternalDateTime.fromDateTime(oldRange.dominantMonthDate),
    MultiDayViewConfiguration _ => oldRange.start,
    ScheduleViewConfiguration _ => oldRange.start,
    _ => InternalDateTime.fromDateTime(oldRange.dominantMonthDate),
  };
}

/// Carry-focus date when switching **to** a weekly (multi-day) view.
InternalDateTime kDefaultToWeekly(ViewController old) => old.visibleDateTimeRange.value!.start;

/// Carry-focus date when switching **to** a daily view, derived from [old].
InternalDateTime kDefaultToDaily(ViewController old) {
  final oldRange = old.visibleDateTimeRange.value!;
  return switch (old.viewConfiguration) {
    MonthViewConfiguration _ => InternalDateTime.fromDateTime(oldRange.dominantMonthDate),
    MultiDayViewConfiguration _ => oldRange.start,
    ScheduleViewConfiguration _ => oldRange.start,
    _ => oldRange.start,
  };
}

/// Carry-focus date when switching **to** a schedule view.
InternalDateTime kDefaultToSchedule(ViewController old) => old.visibleDateTimeRange.value!.start;

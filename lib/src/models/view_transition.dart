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

/// Resolves the time of day the incoming multi-day view opens on. A null result falls back to [ScrollTransition].
///
/// {@category Views}
typedef ScrollResolver = KalenderTime? Function(ViewTransitionContext transition);

/// Resolves the zoom (`heightPerMinute`) the incoming multi-day view opens on. A null result falls back to
/// [ZoomTransition].
///
/// {@category Views}
typedef ZoomResolver = double? Function(ViewTransitionContext transition);

/// What a view shows, as returned by [ViewController.snapshot].
///
/// A view controller also opens on one. There a null [timeOfDay] or [heightPerMinute] means the configuration's
/// `initialTimeOfDay` or `initialHeightPerMinute`.
///
/// {@category Views}
class ViewSnapshot {
  const ViewSnapshot({required this.date, this.timeOfDay, this.heightPerMinute});

  /// The date the view focuses on.
  final FloatingDateTime date;

  /// The time of day at the top of the viewport. Null for a view without vertical scroll.
  final KalenderTime? timeOfDay;

  /// The zoom. Null for a view without vertical scroll.
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
    this.location,
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

  /// The location the new view controller is created in.
  final Location? location;
}

/// The date the previous view focused on, from its [ViewController.snapshot]. Used by [DateTransition.carryFocus].
///
/// A custom [DateResolver] can build on it: `dateResolver: (t) => nextBusinessDay(kCarryFocusDate(t))`.
///
/// {@category Views}
FloatingDateTime kCarryFocusDate(ViewTransitionContext transition) => transition.oldViewController.snapshot().date;

/// The date [old] focused on.
///
/// {@category Views}
@Deprecated('Use old.snapshot().date. Will be removed in 0.34.0.')
FloatingDateTime kDefaultToMonthly(ViewController old) => old.snapshot().date;

/// The date [old] focused on.
///
/// {@category Views}
@Deprecated('Use old.snapshot().date. Will be removed in 0.34.0.')
FloatingDateTime kDefaultToWeekly(ViewController old) => old.snapshot().date;

/// The date [old] focused on.
///
/// {@category Views}
@Deprecated('Use old.snapshot().date. Will be removed in 0.34.0.')
FloatingDateTime kDefaultToDaily(ViewController old) => old.snapshot().date;

/// The date [old] focused on.
///
/// {@category Views}
@Deprecated('Use old.snapshot().date. Will be removed in 0.34.0.')
FloatingDateTime kDefaultToSchedule(ViewController old) => old.snapshot().date;

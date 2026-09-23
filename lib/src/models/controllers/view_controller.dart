// This file is part of kalender.
//
// SPDX-FileCopyrightText: 2023 Klarälvdalens Datakonsult AB, a KDAB Group company <info@kdab.com>
//
// SPDX-License-Identifier: MIT

import 'dart:async';

import 'package:flutter/widgets.dart';
import 'package:kalender/kalender.dart';
import 'package:kalender/src/models/mixins/kalender_navigation_functions.dart';

export 'view_controllers/month_view_controller.dart';
export 'view_controllers/multi_day_view_controller.dart';
export 'view_controllers/schedule_view_controller.dart';

/// A controller for calendar views.
///
/// {@category Controllers and callbacks}
abstract class ViewController with KalenderNavigationFunctions {
  /// The location of the current view.
  final Location? location;

  /// The range currently visible.
  ///
  /// This is the unzoned counterpart of [KalenderController.visibleDateTimeRange],
  /// which carries the same range as a [KalenderDateTimeRange] for an app to read.
  /// Call [FloatingDateTimeRange.forLocation] to cross between them.
  final ValueNotifier<FloatingDateTimeRange?> floatingVisibleRange;

  ViewController({this.location, required this.floatingVisibleRange});

  /// The view configuration that will be used by the controller.
  ViewConfiguration get viewConfiguration;

  /// The [KalenderEvent]s that are currently visible.
  ValueNotifier<Set<KalenderEvent>> get visibleEvents;

  /// The cache used by the event layout delegate.
  final EventLayoutDelegateCache cache = EventLayoutDelegateCache();

  /// The cache used for the multi-day event layout.
  final MultiDayLayoutFrameCache multiDayCache = MultiDayLayoutFrameCache();

  /// What this view shows, for the view created on the next switch.
  ///
  /// The base returns the start of [floatingVisibleRange].
  ViewSnapshot snapshot() => ViewSnapshot(date: floatingVisibleRange.value!.start);

  @override
  FutureOr<void> jumpToDate(DateTime date);

  void dispose();
}

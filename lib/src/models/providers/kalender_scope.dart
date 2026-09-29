// This file is part of kalender.
//
// SPDX-FileCopyrightText: 2023 Klarälvdalens Datakonsult AB, a KDAB Group company <info@kdab.com>
//
// SPDX-License-Identifier: MIT

import 'package:flutter/widgets.dart';
import 'package:kalender/kalender.dart';
import 'package:kalender/src/models/providers/kalender_provider.dart';

/// Reads the state of the [KalenderView] a widget is built inside.
///
/// Each accessor depends on one value, so a widget reading the locale does not rebuild when the location changes. Every
/// accessor returns the nearest value. [interactionOf], [callbacksOf] and [tileComponentsOf] can differ between the
/// header and the body.
///
/// The `of` form throws where there is no [KalenderView] above the context. The `maybeOf` form returns null there
/// instead.
///
/// {@category Controllers and callbacks}
abstract final class KalenderScope {
  /// The [EventsController] driving the calendar.
  static EventsController eventsControllerOf(BuildContext context) => EventsControllerProvider.of(context);

  /// The [EventsController] driving the calendar, or null outside a [KalenderView].
  static EventsController? maybeEventsControllerOf(BuildContext context) {
    return context.dependOnInheritedWidgetOfExactType<EventsControllerProvider>()?.eventsController;
  }

  /// The [KalenderController] driving the calendar.
  static KalenderController kalenderControllerOf(BuildContext context) => KalenderControllerProvider.of(context);

  /// The [KalenderController] driving the calendar, or null outside a [KalenderView].
  static KalenderController? maybeKalenderControllerOf(BuildContext context) {
    return context.dependOnInheritedWidgetOfExactType<KalenderControllerProvider>()?.notifier;
  }

  /// The [ViewController] the surrounding [KalenderView] shows.
  ///
  /// [KalenderController.viewController] is the active view's. It differs while two views share one controller, such as
  /// during a route transition.
  static ViewController viewControllerOf(BuildContext context) => ViewControllerProvider.of(context);

  /// The [ViewController] the surrounding [KalenderView] shows, or null outside a [KalenderView].
  static ViewController? maybeViewControllerOf(BuildContext context) => ViewControllerProvider.maybeOf(context);

  /// The locale the calendar formats its own dates and times with.
  ///
  /// This is `KalenderView.locale`, which is not necessarily the app's locale.
  static Locale? localeOf(BuildContext context) => LocaleProvider.of(context);

  /// The IANA location the calendar displays its events in, or null when it has none.
  static Location? locationOf(BuildContext context) => LocationProvider.of(context);

  /// The components the calendar builds with.
  static KalenderComponents componentsOf(BuildContext context) => Components.of(context);

  /// The callbacks the calendar reports to, or null when it has none.
  static KalenderCallbacks? callbacksOf(BuildContext context) => Callbacks.of(context);

  /// What the calendar allows at this point in the tree. See [KalenderView.interaction].
  static KalenderInteraction interactionOf(BuildContext context) => Interaction.of(context);

  /// How a dragged event snaps. Only available inside a [MultiDayBody].
  static KalenderSnapping snappingOf(BuildContext context) => Snapping.of(context);

  /// The tile components in use at this point in the tree.
  static TileComponents tileComponentsOf(BuildContext context) => TileComponentProvider.of(context);

  /// The height one minute occupies. Only available inside a [MultiDayBody].
  static double heightPerMinuteOf(BuildContext context) => HeightPerMinute.of(context);

  /// The rule deciding whether an event spans multiple days.
  static MultiDayRule multiDayRuleOf(BuildContext context) => context.multiDayRule;
}

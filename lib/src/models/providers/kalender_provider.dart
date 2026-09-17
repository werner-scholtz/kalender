// This file is part of kalender.
//
// SPDX-FileCopyrightText: 2023 Klarälvdalens Datakonsult AB, a KDAB Group company <info@kdab.com>
//
// SPDX-License-Identifier: MIT

import 'package:flutter/widgets.dart';
import 'package:kalender/kalender.dart';

/// The [Components] widget provides the [KalenderComponents] to the widget tree.
class Components extends InheritedWidget {
  /// The [KalenderComponents] that will be used by the Calendar.
  final KalenderComponents components;

  const Components({super.key, required this.components, required super.child});

  static KalenderComponents of(BuildContext context) {
    final result = context.dependOnInheritedWidgetOfExactType<Components>();
    assert(result != null, 'No ComponentsProvider found.');
    return result!.components;
  }

  @override
  bool updateShouldNotify(covariant Components oldWidget) {
    return components != oldWidget.components;
  }
}

class EventsControllerProvider extends InheritedWidget {
  /// The [EventsController] that will be used by the Calendar.
  final EventsController eventsController;

  const EventsControllerProvider({super.key, required this.eventsController, required super.child});

  @override
  bool updateShouldNotify(covariant EventsControllerProvider oldWidget) {
    return eventsController != oldWidget.eventsController;
  }

  static EventsController of(BuildContext context) {
    final result = context.dependOnInheritedWidgetOfExactType<EventsControllerProvider>();
    assert(result != null, 'No EventControllerProvider found.');
    return result!.eventsController;
  }
}

/// The [KalenderControllerProvider] is used to provide the [KalenderController] to the [KalenderView]'s descendants.
class KalenderControllerProvider extends InheritedNotifier<KalenderController> {
  const KalenderControllerProvider({super.key, required super.notifier, required super.child});

  static KalenderController of(BuildContext context) {
    final result = context.dependOnInheritedWidgetOfExactType<KalenderControllerProvider>();
    assert(result != null, 'No KalenderControllerProvider  found.');
    return result!.notifier!;
  }
}

/// The [LocaleProvider] is used to provide the locale for internationalization.
/// It does not have a type parameter so it can be used globally without type constraints.
class LocaleProvider extends InheritedWidget {
  /// The locale used for internationalization.
  final Locale? locale;

  const LocaleProvider({super.key, required this.locale, required super.child});

  static Locale? of(BuildContext context) {
    final result = context.dependOnInheritedWidgetOfExactType<LocaleProvider>();
    assert(result != null, 'No LocaleProvider found.');
    return result!.locale;
  }

  @override
  bool updateShouldNotify(covariant LocaleProvider oldWidget) {
    return locale != oldWidget.locale;
  }
}

/// The [LocationProvider] is used to provide the [Location] for the calendar.
class LocationProvider extends InheritedNotifier<ValueNotifier<Location?>> {
  const LocationProvider({super.key, required super.notifier, required super.child});

  static Location? of(BuildContext context) {
    final result = context.dependOnInheritedWidgetOfExactType<LocationProvider>();
    assert(result != null, 'No LocationProvider found.');
    return result!.notifier!.value;
  }

  static ValueNotifier<Location?> ofNotifier(BuildContext context) {
    final result = context.dependOnInheritedWidgetOfExactType<LocationProvider>();
    assert(result != null, 'No LocationProvider found.');
    return result!.notifier!;
  }
}

/// The [Callbacks] widget provides the [KalenderCallbacks] to the widget tree.
class Callbacks extends InheritedWidget {
  /// The [KalenderCallbacks] that will be used by the Calendar.
  final KalenderCallbacks? callbacks;

  const Callbacks({super.key, required this.callbacks, required super.child});

  @override
  bool updateShouldNotify(covariant Callbacks oldWidget) {
    return callbacks != oldWidget.callbacks;
  }

  static KalenderCallbacks? of(BuildContext context) {
    final result = context.dependOnInheritedWidgetOfExactType<Callbacks>();
    assert(result != null, 'No CallbackProvider  found.');
    return result!.callbacks;
  }

  /// Gets the [Callbacks] from the context, or null when there is none.
  static KalenderCallbacks? maybeOf(BuildContext context) {
    return context.dependOnInheritedWidgetOfExactType<Callbacks>()?.callbacks;
  }
}

/// The [TileComponentProvider] provides the [TileComponents] to the widget tree.
class TileComponentProvider extends InheritedWidget {
  /// The tile components used by the Calendar.
  final TileComponents tileComponents;

  const TileComponentProvider({super.key, required this.tileComponents, required super.child});

  @override
  bool updateShouldNotify(covariant TileComponentProvider oldWidget) {
    return tileComponents != oldWidget.tileComponents;
  }

  static TileComponents of(BuildContext context) {
    final result = context.dependOnInheritedWidgetOfExactType<TileComponentProvider>();
    assert(result != null, 'No TileComponentProvider found.');
    return result!.tileComponents;
  }
}

/// The [Interaction] widget provides the [KalenderInteraction] to the widget tree.
class Interaction extends InheritedNotifier<ValueNotifier<KalenderInteraction>> {
  const Interaction({super.key, required super.notifier, required super.child});

  static KalenderInteraction of(BuildContext context) {
    final result = context.dependOnInheritedWidgetOfExactType<Interaction>();
    assert(result != null, 'No KalenderInteractionProvider found.');
    return result!.notifier!.value;
  }
}

/// The [Snapping] widget provides the [KalenderSnapping] to the widget tree.
class Snapping extends InheritedNotifier<ValueNotifier<KalenderSnapping>> {
  const Snapping({super.key, required super.notifier, required super.child});

  static KalenderSnapping of(BuildContext context) {
    final result = context.dependOnInheritedWidgetOfExactType<Snapping>();
    assert(result != null, 'No KalenderSnappingProvider found.');
    return result!.notifier!.value;
  }

  static ValueNotifier<KalenderSnapping> valueNotifier(BuildContext context) {
    final result = context.dependOnInheritedWidgetOfExactType<Snapping>();
    assert(result != null, 'No KalenderSnappingProvider found.');
    return result!.notifier!;
  }
}

/// The [HeightPerMinute] provides the height per minute to the widget tree.
class HeightPerMinute extends InheritedNotifier<ValueNotifier<double>> {
  const HeightPerMinute({super.key, required super.notifier, required super.child});

  static double of(BuildContext context) {
    final result = context.dependOnInheritedWidgetOfExactType<HeightPerMinute>();
    assert(result != null, 'No HeightPerMinuteProvider found.');
    return result!.notifier!.value;
  }
}

/// Extension methods for [BuildContext] to retrieve various calendar-related providers.
extension ProviderContext on BuildContext {
  /// Retrieve the [EventsController].
  EventsController get eventsController => EventsControllerProvider.of(this);

  /// Retrieve the [KalenderController].
  KalenderController get kalenderController => KalenderControllerProvider.of(this);

  /// Retrieve the [KalenderComponents].
  KalenderComponents get components => Components.of(this);

  /// Retrieve the [KalenderCallbacks] from the [Callbacks].
  KalenderCallbacks? get callbacks => Callbacks.of(this);

  /// Retrieve the [TileComponents] from the [TileComponentProvider].
  TileComponents get tileComponents => TileComponentProvider.of(this);

  /// Retrieve the feedback widget size notifier from the [EventsController].
  ValueNotifier<Size> get feedbackWidgetSizeNotifier => eventsController.feedbackWidgetSize;

  /// Retrieve the locale.
  Locale? get locale => LocaleProvider.of(this);

  /// Retrieve the [KalenderInteraction].
  KalenderInteraction get interaction => Interaction.of(this);

  /// Retrieve the [KalenderSnapping].
  KalenderSnapping get snapping => Snapping.of(this);

  /// Retrieve the [ValueNotifier] containing the [KalenderSnapping].
  ValueNotifier<KalenderSnapping> get snappingNotifier => Snapping.valueNotifier(this);

  /// Retrieve the height per minute.
  double get heightPerMinute => HeightPerMinute.of(this);

  /// The rule deciding which events belong in the multi-day header.
  ///
  /// Comes from the current view's [ViewConfiguration.multiDayRule], falling
  /// back to [kDefaultMultiDayRule] before a view is attached.
  MultiDayRule get multiDayRule =>
      kalenderController.viewController?.viewConfiguration.multiDayRule ?? kDefaultMultiDayRule;

  /// Retrieve the [Location] of the calendar.
  Location? get location => LocationProvider.of(this);
  ValueNotifier<Location?> get locationNotifier => LocationProvider.ofNotifier(this);
  bool get hasLocation => location != null;

  /// Whether [date] is today, honouring the view's `nowCallback` when set and
  /// otherwise the calendar's [location].
  bool isToday(FloatingDateTime date) {
    final now = kalenderController.viewController?.viewConfiguration.nowCallback?.call();
    return now != null ? date.isToday(now: now) : date.isToday(location: location);
  }
}

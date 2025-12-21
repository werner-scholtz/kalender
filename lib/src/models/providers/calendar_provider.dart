import 'package:flutter/material.dart';
import 'package:kalender/kalender.dart';

/// The [Components] widget provides the [CalendarComponents] to the widget tree.
class Components extends InheritedWidget {
  /// The [CalendarComponents] that will be used by the Calendar.
  final CalendarComponents components;

  /// Creates a [Components] with the specified components.
  const Components({super.key, required this.components, required super.child});

  /// Gets the [Components] from the context.
  static CalendarComponents of(BuildContext context) {
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

  /// Gets the [EventsControllerProvider] from the context.
  static EventsController of(BuildContext context) {
    final result = context.dependOnInheritedWidgetOfExactType<EventsControllerProvider>();
    assert(result != null, 'No EventControllerProvider found.');
    return result!.eventsController;
  }
}

/// The [CalendarControllerProvider] is used to provide the [CalendarController] to the [CalendarView]'s descendants.
class CalendarControllerProvider extends InheritedNotifier<CalendarController> {
  const CalendarControllerProvider({super.key, required super.notifier, required super.child});

  /// Gets the [CalendarControllerProvider] from the context.
  static CalendarController of(BuildContext context) {
    final result = context.dependOnInheritedWidgetOfExactType<CalendarControllerProvider>();
    assert(result != null, 'No CalendarControllerProvider  found.');
    return result!.notifier!;
  }
}

/// The [LocaleProvider] is used to provide the locale for internationalization.
/// It does not have a type parameter so it can be used globally without type constraints.
class LocaleProvider extends InheritedWidget {
  /// The locale used for internationalization.
  final dynamic locale;

  /// Creates a [LocaleProvider] with the specified locale.
  const LocaleProvider({super.key, required this.locale, required super.child});

  /// Gets the [LocaleProvider] of type [T] from the context.
  static dynamic of(BuildContext context) {
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
///
/// TODO: Check that the calendar updates correctly when the location changes.
class LocationProvider extends InheritedNotifier<ValueNotifier<Location?>> {
  /// Creates a [LocationProvider] with the specified location.
  const LocationProvider({super.key, required super.notifier, required super.child});

  /// Gets the [LocationProvider] from the context.
  static Location? of(BuildContext context) {
    final result = context.dependOnInheritedWidgetOfExactType<LocationProvider>();
    assert(result != null, 'No LocationProvider found.');
    return result!.notifier!.value;
  }

  /// Gets the [ValueNotifier<Location?>] from the context.
  static ValueNotifier<Location?> ofNotifier(BuildContext context) {
    final result = context.dependOnInheritedWidgetOfExactType<LocationProvider>();
    assert(result != null, 'No LocationProvider found.');
    return result!.notifier!;
  }
}

/// The [Callbacks] widget provides the [CalendarCallbacks] to the widget tree.
class Callbacks extends InheritedWidget {
  /// The [CalendarCallbacks] that will be used by the Calendar.
  final CalendarCallbacks? callbacks;

  /// Creates a [Callbacks] with the specified callbacks.
  const Callbacks({super.key, required this.callbacks, required super.child});

  @override
  bool updateShouldNotify(covariant Callbacks oldWidget) {
    return callbacks != oldWidget.callbacks;
  }

  /// Gets the [Callbacks] from the context.
  static CalendarCallbacks? of(BuildContext context) {
    final result = context.dependOnInheritedWidgetOfExactType<Callbacks>();
    assert(result != null, 'No CallbackProvider  found.');
    return result!.callbacks;
  }
}

/// The [TileComponentProvider] provides the [TileComponents] to the widget tree.
class TileComponentProvider extends InheritedWidget {
  /// The tile components used by the Calendar.
  final TileComponents tileComponents;

  /// Creates a [TileComponentProvider] with the specified tile components.
  const TileComponentProvider({super.key, required this.tileComponents, required super.child});

  @override
  bool updateShouldNotify(covariant TileComponentProvider oldWidget) {
    return tileComponents != oldWidget.tileComponents;
  }

  /// Gets the [TileComponentProvider] from the context.
  static TileComponents of(BuildContext context) {
    final result = context.dependOnInheritedWidgetOfExactType<TileComponentProvider>();
    assert(result != null, 'No TileComponentProvider found.');
    return result!.tileComponents;
  }
}

/// The [Interaction] widget provides the [CalendarInteraction] to the widget tree.
class Interaction extends InheritedNotifier<ValueNotifier<CalendarInteraction>> {
  const Interaction({super.key, required super.notifier, required super.child});

  /// Gets the [Interaction] from the context.
  static CalendarInteraction of(BuildContext context) {
    final result = context.dependOnInheritedWidgetOfExactType<Interaction>();
    assert(result != null, 'No CalendarInteractionProvider found.');
    return result!.notifier!.value;
  }
}

/// The [Snapping] widget provides the [CalendarSnapping] to the widget tree.
class Snapping extends InheritedNotifier<ValueNotifier<CalendarSnapping>> {
  const Snapping({super.key, required super.notifier, required super.child});

  /// Gets the [Snapping] from the context.
  static CalendarSnapping of(BuildContext context) {
    final result = context.dependOnInheritedWidgetOfExactType<Snapping>();
    assert(result != null, 'No CalendarSnappingProvider found.');
    return result!.notifier!.value;
  }

  static ValueNotifier<CalendarSnapping> valueNotifier(BuildContext context) {
    final result = context.dependOnInheritedWidgetOfExactType<Snapping>();
    assert(result != null, 'No CalendarSnappingProvider found.');
    return result!.notifier!;
  }
}

/// The [HeightPerMinute] provides the height per minute to the widget tree.
class HeightPerMinute extends InheritedNotifier<ValueNotifier<double>> {
  const HeightPerMinute({super.key, required super.notifier, required super.child});

  /// Gets the [HeightPerMinute] of type [T] from the context.
  static double of(BuildContext context) {
    final result = context.dependOnInheritedWidgetOfExactType<HeightPerMinute>();
    assert(result != null, 'No HeightPerMinuteProvider found.');
    return result!.notifier!.value;
  }
}

/// Extension methods for [BuildContext] to retrieve various calendar-related providers.
extension ProviderContext on BuildContext {
  /// Retrieve the [EventsController].
  EventsController eventsController() => EventsControllerProvider.of(this);

  /// Retrieve the [CalendarController].
  CalendarController calendarController() => CalendarControllerProvider.of(this);

  /// Retrieve the [CalendarComponents].
  CalendarComponents components() => Components.of(this);

  /// Retrieve the [CalendarCallbacks] from the [Callbacks].
  CalendarCallbacks? callbacks() => Callbacks.of(this);

  /// Retrieve the [TileComponents] from the [TileComponentProvider].
  TileComponents tileComponents() => TileComponentProvider.of(this);

  /// Retrieve the feedback widget size notifier from the [EventsController].
  ValueNotifier<Size> feedbackWidgetSizeNotifier() => eventsController().feedbackWidgetSize;

  /// Retrieve the locale.
  dynamic get locale => LocaleProvider.of(this);

  /// Retrieve the [CalendarInteraction].
  CalendarInteraction get interaction => Interaction.of(this);

  /// Retrieve the [CalendarSnapping].
  CalendarSnapping get snapping => Snapping.of(this);

  /// Retrieve the [ValueNotifier] containing the [CalendarSnapping].
  ValueNotifier<CalendarSnapping> get snappingNotifier => Snapping.valueNotifier(this);

  /// Retrieve the height per minute.
  double get heightPerMinute => HeightPerMinute.of(this);

  /// Retrieve the [Location] of the calendar.
  Location? get location => LocationProvider.of(this);
  ValueNotifier<Location?> get locationNotifier => LocationProvider.ofNotifier(this);
  bool get hasLocation => location != null;
}

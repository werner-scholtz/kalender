import 'package:flutter/material.dart';
import 'package:kalender/kalender.dart';

/// The [CalendarProvider] is used to provide the [CalendarCallbacks] and [CalendarComponents] to the [CalendarView]'s descendants.
class CalendarProvider<T extends Object?> extends InheritedWidget {
  /// The [CalendarCallbacks] that will be used by the Calendar.
  final CalendarCallbacks<T>? callbacks;

  /// Components used by the CalendarView.
  final CalendarComponents<T>? components;

  const CalendarProvider({required this.callbacks, required this.components, required super.child, super.key});

  /// Finds the [CalendarProvider] of type [T] in the widget tree, or null if not found.
  static CalendarProvider<T>? maybeOf<T>(BuildContext context) {
    return context.dependOnInheritedWidgetOfExactType<CalendarProvider<T>>();
  }

  /// Finds the [CalendarProvider] of type [T] in the widget tree, or throws an assertion error if not found.
  static CalendarProvider<T> of<T>(BuildContext context) {
    final result = maybeOf<T>(context);
    assert(result != null, 'No CalendarProvider of <$T> found.');
    return result!;
  }

  @override
  bool updateShouldNotify(covariant CalendarProvider<T> oldWidget) {
    return callbacks != oldWidget.callbacks || components != oldWidget.components;
  }
}

class EventsControllerProvider<T> extends InheritedWidget {
  /// The [EventsController] that will be used by the Calendar.
  final EventsController<T> eventsController;

  const EventsControllerProvider({super.key, required this.eventsController, required super.child});

  @override
  bool updateShouldNotify(covariant EventsControllerProvider<T> oldWidget) {
    return eventsController != oldWidget.eventsController;
  }

  /// Gets the [EventsControllerProvider] of type [T] from the context.
  static EventsController<T> of<T>(BuildContext context) {
    final result = context.dependOnInheritedWidgetOfExactType<EventsControllerProvider<T>>();
    assert(result != null, 'No EventControllerProvider of <$T> found.');
    return result!.eventsController;
  }
}

/// The [CalendarControllerProvider] is used to provide the [CalendarController] to the [CalendarView]'s descendants.
class CalendarControllerProvider<T extends Object?> extends InheritedNotifier<CalendarController<T>> {
  const CalendarControllerProvider({super.key, required super.notifier, required super.child});

  /// Gets the [CalendarControllerProvider] of type [T] from the context.
  static CalendarController<T> of<T>(BuildContext context) {
    final result = context.dependOnInheritedWidgetOfExactType<CalendarControllerProvider<T>>();
    assert(result != null, 'No CalendarControllerProvider of <$T> found.');
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

/// The [Callbacks] widget provides the [CalendarCallbacks] to the widget tree.
class Callbacks<T extends Object?> extends InheritedWidget {
  /// The [CalendarCallbacks] that will be used by the Calendar.
  final CalendarCallbacks<T>? callbacks;

  /// Creates a [Callbacks] with the specified callbacks.
  const Callbacks({super.key, required this.callbacks, required super.child});

  @override
  bool updateShouldNotify(covariant Callbacks<T> oldWidget) {
    return callbacks != oldWidget.callbacks;
  }

  /// Gets the [Callbacks] of type [T] from the context.
  static CalendarCallbacks<T>? of<T>(BuildContext context) {
    final result = context.dependOnInheritedWidgetOfExactType<Callbacks<T>>();
    assert(result != null, 'No CallbackProvider of <$T> found.');
    return result!.callbacks;
  }
}

/// The [TileComponentProvider] provides the [TileComponents] to the widget tree.
class TileComponentProvider<T extends Object?> extends InheritedWidget {
  /// The tile components used by the Calendar.
  final TileComponents<T> tileComponents;

  /// Creates a [TileComponentProvider] with the specified tile components.
  const TileComponentProvider({super.key, required this.tileComponents, required super.child});

  @override
  bool updateShouldNotify(covariant TileComponentProvider<T> oldWidget) {
    return tileComponents != oldWidget.tileComponents;
  }

  /// Gets the [TileComponentProvider] of type [T] from the context.
  static TileComponents<T> of<T>(BuildContext context) {
    final result = context.dependOnInheritedWidgetOfExactType<TileComponentProvider<T>>();
    assert(result != null, 'No TileComponentProvider of <$T> found.');
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

/// The [HeightPerMinuteProvider] provides the height per minute to the widget tree.
class HeightPerMinuteProvider extends InheritedNotifier<ValueNotifier<double>> {
  const HeightPerMinuteProvider({super.key, required super.notifier, required super.child});

  /// Gets the [HeightPerMinuteProvider] of type [T] from the context.
  static double of(BuildContext context) {
    final result = context.dependOnInheritedWidgetOfExactType<HeightPerMinuteProvider>();
    assert(result != null, 'No HeightPerMinuteProvider found.');
    return result!.notifier!.value;
  }
}

/// Extension methods for [BuildContext] to retrieve various calendar-related providers.
extension ProviderContext on BuildContext {
  /// Returns the [CalendarProvider] of type [T] from the context.
  CalendarProvider<T> provider<T extends Object?>() => CalendarProvider.of<T>(this);

  /// Retrieve the [EventsController] from the [CalendarProvider].
  EventsController<T> eventsController<T extends Object?>() => EventsControllerProvider.of<T>(this);

  /// Retrieve the [CalendarController] from the [CalendarProvider].
  CalendarController<T> calendarController<T extends Object?>() => CalendarControllerProvider.of<T>(this);

  /// Retrieve the [CalendarComponents] from the [CalendarProvider].
  CalendarComponents<T>? components<T extends Object?>() => provider<T>().components;

  /// Retrieve the [CalendarCallbacks] from the [Callbacks].
  CalendarCallbacks<T>? callbacks<T extends Object?>() => Callbacks.of<T>(this);

  /// Retrieve the [TileComponents] from the [TileComponentProvider].
  TileComponents<T> tileComponents<T extends Object?>() => TileComponentProvider.of<T>(this);

  /// Retrieve the feedback widget size notifier from the [EventsController].
  ValueNotifier<Size> feedbackWidgetSizeNotifier<T extends Object?>() => eventsController<T>().feedbackWidgetSize;

  /// Retrieve the locale.
  dynamic get locale => LocaleProvider.of(this);

  /// Retrieve the [CalendarInteraction].
  CalendarInteraction get interaction => Interaction.of(this);

  /// Retrieve the [CalendarSnapping].
  CalendarSnapping get snapping => Snapping.of(this);

  /// Retrieve the [ValueNotifier] containing the [CalendarSnapping].
  ValueNotifier<CalendarSnapping> get snappingNotifier => Snapping.valueNotifier(this);

  /// Retrieve the height per minute.
  double get heightPerMinute => HeightPerMinuteProvider.of(this);
}

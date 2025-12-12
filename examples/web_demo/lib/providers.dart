import 'package:flutter/material.dart';
import 'package:kalender/kalender.dart';
import 'package:web_demo/models/calendar_configuration.dart';
import 'package:web_demo/models/event.dart';

class ControllerProvider extends InheritedWidget {
  final controller = CalendarController<Event>();
  ControllerProvider({required super.child, super.key});

  /// Gets the [ControllerProvider] from the context.
  static CalendarController<Event> of(BuildContext context) {
    final result = context.dependOnInheritedWidgetOfExactType<ControllerProvider>();
    assert(result != null, 'No ControllerProvider found.');
    return result!.controller;
  }

  @override
  bool updateShouldNotify(covariant ControllerProvider oldWidget) {
    return controller != oldWidget.controller;
  }
}

class ConfigurationProvider extends InheritedNotifier<CalendarConfiguration> {
  ConfigurationProvider({required super.child, super.key}) : super(notifier: CalendarConfiguration());

  /// Gets the [ConfigurationProvider] from the context.
  static CalendarConfiguration of(BuildContext context) {
    final result = context.dependOnInheritedWidgetOfExactType<ConfigurationProvider>();
    assert(result != null, 'No ConfigurationProvider found.');
    return result!.notifier!;
  }
}

class LocationProvider extends InheritedNotifier<ValueNotifier<Location?>> {
  LocationProvider({required super.child, super.key}) : super(notifier: ValueNotifier<Location?>(null));

  /// Gets the [LocationProvider] from the context.
  static ValueNotifier<Location?> of(BuildContext context) {
    final result = context.dependOnInheritedWidgetOfExactType<LocationProvider>();
    assert(result != null, 'No LocationProvider found.');
    return result!.notifier!;
  }
}

extension CalendarContextUtils on BuildContext {
  /// Gets the current [Location] from the [LocationProvider].
  ValueNotifier<Location?> get location => LocationProvider.of(this);

  /// Gets the current [CalendarConfiguration] from the [ConfigurationProvider].
  CalendarConfiguration get configuration => ConfigurationProvider.of(this);

  /// Gets the current [CalendarController] from the [ControllerProvider].
  CalendarController<Event> get controller => ControllerProvider.of(this);
}

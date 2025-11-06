import 'package:flutter/material.dart';
import 'package:timezone/timezone.dart';
import 'package:web_demo/models/calendar_configuration.dart';

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
}

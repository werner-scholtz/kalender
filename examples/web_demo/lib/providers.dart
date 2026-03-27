import 'package:flutter/material.dart';
import 'package:kalender/kalender.dart';
import 'package:web_demo/models/calendar_configuration.dart';

class ControllerProvider extends InheritedWidget {
  final CalendarController controller;
  ControllerProvider({required super.child, super.key}) : controller = CalendarController();

  static CalendarController of(BuildContext context) {
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

  static CalendarConfiguration of(BuildContext context) {
    final result = context.dependOnInheritedWidgetOfExactType<ConfigurationProvider>();
    assert(result != null, 'No ConfigurationProvider found.');
    return result!.notifier!;
  }
}

class LocationProvider extends InheritedNotifier<ValueNotifier<Location?>> {
  LocationProvider({required super.child, super.key}) : super(notifier: ValueNotifier<Location?>(null));

  static ValueNotifier<Location?> of(BuildContext context) {
    final result = context.dependOnInheritedWidgetOfExactType<LocationProvider>();
    assert(result != null, 'No LocationProvider found.');
    return result!.notifier!;
  }
}

class ThemeModeProvider extends InheritedNotifier<ValueNotifier<ThemeMode>> {
  const ThemeModeProvider({required ValueNotifier<ThemeMode> notifier, required super.child, super.key})
      : super(notifier: notifier);

  static ValueNotifier<ThemeMode> of(BuildContext context) {
    final result = context.dependOnInheritedWidgetOfExactType<ThemeModeProvider>();
    assert(result != null, 'No ThemeModeProvider found.');
    return result!.notifier!;
  }
}

class TextDirectionProvider extends InheritedNotifier<ValueNotifier<TextDirection>> {
  const TextDirectionProvider({required ValueNotifier<TextDirection> notifier, required super.child, super.key})
      : super(notifier: notifier);

  static ValueNotifier<TextDirection> of(BuildContext context) {
    final result = context.dependOnInheritedWidgetOfExactType<TextDirectionProvider>();
    assert(result != null, 'No TextDirectionProvider found.');
    return result!.notifier!;
  }
}

class LocaleNotifierProvider extends InheritedNotifier<ValueNotifier<Locale>> {
  const LocaleNotifierProvider({required ValueNotifier<Locale> notifier, required super.child, super.key})
      : super(notifier: notifier);

  static ValueNotifier<Locale> of(BuildContext context) {
    final result = context.dependOnInheritedWidgetOfExactType<LocaleNotifierProvider>();
    assert(result != null, 'No LocaleNotifierProvider found.');
    return result!.notifier!;
  }
}

class EventsControllerProvider extends InheritedWidget {
  final EventsController eventsController;
  const EventsControllerProvider({required this.eventsController, required super.child, super.key});

  static EventsController of(BuildContext context) {
    final result = context.dependOnInheritedWidgetOfExactType<EventsControllerProvider>();
    assert(result != null, 'No EventsControllerProvider found.');
    return result!.eventsController;
  }

  @override
  bool updateShouldNotify(covariant EventsControllerProvider oldWidget) {
    return eventsController != oldWidget.eventsController;
  }
}

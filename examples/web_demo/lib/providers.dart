import 'package:flutter/material.dart';
import 'package:kalender/kalender.dart';
import 'package:web_demo/models/demo_configuration.dart';

// ---------------------------------------------------------------------------
// App-level settings (theme, text direction, locale)
// ---------------------------------------------------------------------------

class AppSettings {
  final ValueNotifier<ThemeMode> themeMode;
  final ValueNotifier<TextDirection> textDirection;
  final ValueNotifier<Locale> locale;

  AppSettings({
    required this.themeMode,
    required this.textDirection,
    required this.locale,
  });
}

class AppSettingsProvider extends InheritedWidget {
  final AppSettings settings;
  const AppSettingsProvider({required this.settings, required super.child, super.key});

  static AppSettings of(BuildContext context) {
    final result = context.dependOnInheritedWidgetOfExactType<AppSettingsProvider>();
    assert(result != null, 'No AppSettingsProvider found.');
    return result!.settings;
  }

  @override
  bool updateShouldNotify(covariant AppSettingsProvider oldWidget) => settings != oldWidget.settings;
}

// ---------------------------------------------------------------------------
// Events controller
// ---------------------------------------------------------------------------

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

// ---------------------------------------------------------------------------
// Calendar-scoped state (controller, configuration, location)
// ---------------------------------------------------------------------------

class DemoScope extends InheritedWidget {
  final KalenderController controller;
  final DemoConfiguration configuration;
  final ValueNotifier<Location?> location;

  DemoScope({
    required super.child,
    super.key,
  })  : controller = KalenderController(),
        configuration = DemoConfiguration(),
        location = ValueNotifier<Location?>(null);

  static DemoScope _of(BuildContext context) {
    final result = context.dependOnInheritedWidgetOfExactType<DemoScope>();
    assert(result != null, 'No DemoScope found.');
    return result!;
  }

  static KalenderController controllerOf(BuildContext context) => _of(context).controller;
  static DemoConfiguration configurationOf(BuildContext context) => _of(context).configuration;
  static ValueNotifier<Location?> locationOf(BuildContext context) => _of(context).location;

  @override
  bool updateShouldNotify(covariant DemoScope oldWidget) {
    return controller != oldWidget.controller ||
        configuration != oldWidget.configuration ||
        location != oldWidget.location;
  }
}

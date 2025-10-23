import 'package:flutter/material.dart';
import 'package:kalender/kalender.dart';
import 'package:timezone/timezone.dart';
import 'package:web_demo/l10n/app_localizations.dart';
import 'package:web_demo/models/event.dart';

extension BuildContextExtension on BuildContext {
  AppLocalizations get l10n => AppLocalizations.of(this)!;
  String get localeTag => Localizations.localeOf(this).toLanguageTag();
  EventsController<Event> get eventsController => EventsProvider.of(this).eventsController;
  AppSettings get appSettings => AppSettings.of(this);
  ValueNotifier<Location?> get location => appSettings.location;
  ValueNotifier<ThemeMode> get themeMode => appSettings.themeMode;
  ValueNotifier<TextDirection> get textDirection => appSettings.textDirection;
  ValueNotifier<Locale> get locale => appSettings.locale;
}

class AppSettings extends InheritedWidget {
  final ValueNotifier<Location?> location;
  final ValueNotifier<ThemeMode> themeMode;
  final ValueNotifier<TextDirection> textDirection;
  final ValueNotifier<Locale> locale;

  const AppSettings({
    super.key,
    required this.location,
    required this.themeMode,
    required this.textDirection,
    required this.locale,
    required super.child,
  });

  static AppSettings of(BuildContext context) {
    final result = context.dependOnInheritedWidgetOfExactType<AppSettings>();
    assert(result != null, 'No AppSettings found in context');
    return result!;
  }

  @override
  bool updateShouldNotify(covariant AppSettings oldWidget) {
    return oldWidget.themeMode != themeMode ||
        oldWidget.textDirection != textDirection ||
        oldWidget.locale != locale ||
        oldWidget.location != location;
  }
}

/// The [EventsProvider] is used to provide the [EventsController] to the widget tree.
class EventsProvider extends InheritedWidget {
  /// The events controller for the app.
  final DefaultEventsController<Event> eventsController;

  /// Creates an [EventsProvider].
  const EventsProvider({super.key, required this.eventsController, required super.child});

  /// Returns the [EventsProvider] from the [BuildContext].
  static EventsProvider of(BuildContext context) {
    return context.dependOnInheritedWidgetOfExactType<EventsProvider>()!;
  }

  @override
  bool updateShouldNotify(covariant EventsProvider oldWidget) {
    return oldWidget.eventsController != eventsController;
  }
}

import 'dart:math' show Random;

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:kalender/kalender.dart';
import 'package:web_demo/l10n/app_localizations.dart';
import 'package:web_demo/locales.dart';
import 'package:web_demo/models/event.dart';
import 'package:web_demo/pages/multi_calendar.dart';
import 'package:web_demo/pages/single_calendar.dart';
import 'package:web_demo/providers.dart';
import 'package:web_demo/widgets/event_overlay_portal.dart';
import 'package:web_demo/widgets/locale_dropdown.dart';
import 'package:web_demo/widgets/text_direction_button.dart';
import 'package:web_demo/widgets/theme_button.dart';
import 'package:web_demo/widgets/view_type_picker.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'timezone/stub.dart'
    if (dart.library.html) 'timezone/browser.dart'
    if (dart.library.io) 'timezone/standalone.dart';

void main() async {
  await initializeDateFormatting();
  await initializeTimeZonePackage();
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});
  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  /// The theme mode of the app.
  final ValueNotifier<ThemeMode> _themeMode = ValueNotifier(ThemeMode.dark);
  final ValueNotifier<TextDirection> _textDirection = ValueNotifier(TextDirection.ltr);
  final ValueNotifier<Locale> _locale = ValueNotifier(const Locale('en', 'US'));
  final ValueNotifier<Location?> _location = ValueNotifier(null);

  final _eventsController = DefaultEventsController<Event>(
    locations: supportedLocations.map((e) => getLocation(e)).toList(),
  );
  DefaultEventsController<Event> get eventsController => _eventsController;

  @override
  void initState() {
    super.initState();
    _eventsController.addEvents(_generateEvents());
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _locale.addListener(() => setState(() {}));
      _themeMode.addListener(() => setState(() {}));
      _textDirection.addListener(() => setState(() {}));
    });
  }

  Locale _resolveLocale(Locale? locale, Iterable<Locale> supportedLocales) {
    if (locale == null) return const Locale('en', 'US');
    for (var supportedLocale in supportedLocales) {
      if (supportedLocale.languageCode == locale.languageCode) {
        return supportedLocale;
      }
    }
    return const Locale('en', 'US');
  }

  @override
  Widget build(BuildContext context) {
    final isMobile = defaultTargetPlatform == TargetPlatform.iOS || defaultTargetPlatform == TargetPlatform.android;
    return AppSettings(
      location: _location,
      themeMode: _themeMode,
      textDirection: _textDirection,
      locale: _locale,
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Web Demo',
        themeMode: _themeMode.value,
        theme: ThemeData(
          useMaterial3: true,
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue),
        ),
        darkTheme: ThemeData(
          useMaterial3: true,
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue, brightness: Brightness.dark),
        ),
        locale: _locale.value,
        supportedLocales: supportedLocales,
        localizationsDelegates: const [
          AppLocalizations.delegate,
          GlobalMaterialLocalizations.delegate,
          GlobalWidgetsLocalizations.delegate,
          GlobalCupertinoLocalizations.delegate,
        ],
        localeResolutionCallback: (locale, supportedLocales) => _resolveLocale(locale, supportedLocales),
        localeListResolutionCallback: (locales, supportedLocales) {
          return _resolveLocale(locales?.isNotEmpty == true ? locales!.first : null, supportedLocales);
        },
        home: EventsProvider(
          eventsController: _eventsController,
          child: Directionality(
            textDirection: _textDirection.value,
            child: isMobile ? const MobileHomePage() : const DesktopHomePage(),
          ),
        ),
      ),
    );
  }

  /// Generate a list of events for the demo.
  List<CalendarEvent<Event>> _generateEvents() {
    final now = DateTime.now();
    const numOfEvents = 1000;
    return List.generate(numOfEvents, (index) {
      final start = now.add(Duration(days: index - (numOfEvents ~/ 2)));
      final end = start.add(Duration(hours: Random().nextInt(3) + 1));
      return CalendarEvent(
        data: Event(
          title: 'Event $index',
          color: Colors.blue,
        ),
        dateTimeRange: DateTimeRange(start: start, end: end),
      );
    });
  }
}

class MobileHomePage extends StatelessWidget {
  const MobileHomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(context.l10n.appTitle),
        actionsPadding: const EdgeInsets.symmetric(horizontal: 8),
        actions: const [
          ThemeButton(),
          SizedBox(width: 4),
          TextDirectionButton(),
          SizedBox(width: 4),
        ],
      ),
      body: const EventOverlayPortal(child: SingleCalendarView()),
    );
  }
}

class DesktopHomePage extends StatefulWidget {
  const DesktopHomePage({super.key});
  @override
  State<DesktopHomePage> createState() => _DesktopHomePageState();
}

class _DesktopHomePageState extends State<DesktopHomePage> {
  /// The type of the calendar view.
  ViewType _type = ViewType.single;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(context.l10n.appTitle),
        actionsPadding: const EdgeInsets.symmetric(horizontal: 8),
        actions: [
          const ThemeButton(),
          const SizedBox(width: 4),
          const TextDirectionButton(),
          const SizedBox(width: 4),
          const LocaleDropdown(),
          const SizedBox(width: 4),
          ViewTypePicker(type: _type, onChanged: (value) => setState(() => _type = value)),
        ],
      ),
      body: EventOverlayPortal(
        child: _type == ViewType.single ? const SingleCalendarView() : const MultiCalendarView(),
      ),
    );
  }
}

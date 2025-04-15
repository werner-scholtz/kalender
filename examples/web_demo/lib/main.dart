import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:kalender/kalender.dart';
import 'package:web_demo/models/event.dart';
import 'package:web_demo/pages/multi_calendar.dart';
import 'package:web_demo/pages/single_calendar.dart';
import 'package:web_demo/utils.dart';
import 'package:web_demo/widgets/event_overlay_portal.dart';
import 'package:web_demo/widgets/text_direction_button.dart';
import 'package:web_demo/widgets/theme_button.dart';
import 'package:web_demo/widgets/view_type_picker.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});
  static MyAppState? of(BuildContext context) => context.findAncestorStateOfType<MyAppState>();

  /// Returns the [EventsController] of the app.
  static EventsController<Event> eventsController(BuildContext context) {
    final state = context.findAncestorStateOfType<MyAppState>();
    if (state == null) throw Exception('MyAppState not found in context');
    return state.eventsController;
  }

  @override
  State<MyApp> createState() => MyAppState();
}

class MyAppState extends State<MyApp> {
  /// The theme mode of the app.
  ThemeMode _themeMode = ThemeMode.dark;
  ThemeMode get themeMode => _themeMode;

  /// Toggles the theme mode of the app.
  void toggleTheme() {
    return setState(() => _themeMode = _themeMode == ThemeMode.dark ? ThemeMode.light : ThemeMode.dark);
  }

  /// The text direction of the app.
  TextDirection _textDirection = TextDirection.ltr;
  TextDirection get textDirection => _textDirection;

  /// Toggles the text direction of the app.
  void toggleTextDirection() {
    return setState(() => _textDirection = _textDirection == TextDirection.ltr ? TextDirection.rtl : TextDirection.ltr);
  }

  final _eventsController = DefaultEventsController<Event>();
  DefaultEventsController<Event> get eventsController => _eventsController;

  @override
  Widget build(BuildContext context) {
    final isMobile = defaultTargetPlatform == TargetPlatform.iOS || defaultTargetPlatform == TargetPlatform.android;
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Web Demo',
      themeMode: _themeMode,
      theme: ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue),
      ),
      darkTheme: ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue, brightness: Brightness.dark),
      ),
      home: Directionality(
        textDirection: _textDirection,
        child: isMobile ? const MobileHomePage() : const DesktopHomePage(),
      ),
    );
  }
}

class MobileHomePage extends StatelessWidget {
  const MobileHomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(body: SafeArea(child: EventOverlayPortal(child: SingleCalendarView())));
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
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) => _insertEvents);
  }

  void _insertEvents() => MyApp.eventsController(context).addEvents(generateEvents(context));

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: const Text("Kalender Web Demo"),
        actionsPadding: const EdgeInsets.symmetric(horizontal: 8),
        actions: [
          const ThemeButton(),
          const SizedBox(width: 4),
          const TextDirectionButton(),
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

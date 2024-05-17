import 'dart:math';

import 'package:flutter/material.dart';
import 'package:kalender/kalender.dart';
import 'package:web_demo/models/event.dart';
import 'package:web_demo/theme.g.dart';
import 'package:web_demo/widgets/calendar_widget.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  static MyAppState? of(BuildContext context) {
    return context.findAncestorStateOfType<MyAppState>();
  }

  @override
  State<MyApp> createState() => MyAppState();
}

class MyAppState extends State<MyApp> {
  ThemeMode themeMode = ThemeMode.dark;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Web Demo',
      themeMode: themeMode,
      theme: ThemeData(useMaterial3: true, colorScheme: lightColorScheme),
      darkTheme: ThemeData(useMaterial3: true, colorScheme: darkColorScheme),
      home: const MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }

  void toggleTheme() {
    setState(() {
      themeMode =
          themeMode == ThemeMode.dark ? ThemeMode.light : ThemeMode.dark;
    });
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final controller = CalendarController();
  final controller1 = CalendarController();
  final eventsController = EventsController();

  late ViewConfiguration _viewConfiguration = _viewConfigurations[1];
  late ViewConfiguration _viewConfiguration1 = _viewConfigurations[1];
  final _viewConfigurations = [
    MultiDayViewConfiguration.singleDay(),
    MultiDayViewConfiguration.week(),
    MultiDayViewConfiguration.workWeek(),
    MultiDayViewConfiguration.custom(numberOfDays: 3),
    MultiDayViewConfiguration.custom(
      name: '2 Weeks',
      numberOfDays: 14,
    ),
  ];

  OverlayEntry? _overlayEntry;

  @override
  void initState() {
    super.initState();
    final now = DateTime.now();

    final events = List.generate(14, (index) {
      final start = now.add(Duration(days: index - 7));
      final end = start.add(Duration(hours: Random().nextInt(3) + 1));

      return CalendarEvent(
        data: Event(
          title: 'Event $index',
          color: Colors.blue,
        ),
        dateTimeRange: DateTimeRange(start: start, end: end),
      );
    });

    eventsController.addEvents(events);
  }

  @override
  Widget build(BuildContext context) {
    final callbacks = CalendarCallbacks(
      onEventTapped: _createOverlay,
    );

    final calendar = CalendarWidget(
      controller: controller,
      eventsController: eventsController,
      viewConfiguration: _viewConfiguration,
      viewConfigurations: _viewConfigurations,
      onSelected: (value) => setState(() => _viewConfiguration = value),
      callbacks: callbacks,
    );

    final calendar1 = CalendarWidget(
      controller: controller1,
      eventsController: eventsController,
      viewConfiguration: _viewConfiguration1,
      viewConfigurations: _viewConfigurations,
      onSelected: (value) => setState(() => _viewConfiguration1 = value),
      callbacks: callbacks,
    );

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(widget.title),
        actions: [
          IconButton.filledTonal(
            onPressed: () => MyApp.of(context)!.toggleTheme(),
            icon: Icon(
              MyApp.of(context)!.themeMode == ThemeMode.dark
                  ? Icons.brightness_2_rounded
                  : Icons.brightness_7_rounded,
            ),
          )
        ],
      ),
      body: Row(
        children: [
          Flexible(flex: 3, child: calendar),
          Flexible(flex: 3, child: calendar1),
        ],
      ),
    );
  }

  void _removeOverlay() {
    if (_overlayEntry != null) {
      _overlayEntry?.remove();
      _overlayEntry = null;
    }
  }

  void _createOverlay(CalendarEvent event, RenderBox renderBox) {
    _removeOverlay();

    var position = renderBox.localToGlobal(Offset.zero);
    const height = 300.0;
    const width = 250.0;

    final size = context.size!;

    if (position.dy + height > size.height) {
      position =
          position.translate(0, size.height - (position.dy + height) - 25);
    }

    if (position.dx + width + renderBox.size.width > size.width) {
      position = position.translate(-width - 16, 0);
    } else {
      position = position.translate(renderBox.size.width, 0);
    }

    final overlayEntry = OverlayEntry(
      builder: (context) {
        return Stack(
          fit: StackFit.expand,
          children: [
            Positioned.fill(
              child: GestureDetector(
                onTap: _removeOverlay,
              ),
            ),
            Positioned(
              top: position.dy,
              left: position.dx,
              child: Card(
                elevation: 5,
                margin: const EdgeInsets.all(8),
                child: SizedBox(
                  width: width,
                  height: height,
                  child: Padding(
                    padding: const EdgeInsets.all(8),
                    child: Column(
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            IconButton.filledTonal(
                              onPressed: () => _removeOverlay(),
                              icon: const Icon(Icons.close),
                            )
                          ],
                        )
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ],
        );
      },
    );

    _overlayEntry = overlayEntry;
    Overlay.of(context).insert(overlayEntry);
  }
}

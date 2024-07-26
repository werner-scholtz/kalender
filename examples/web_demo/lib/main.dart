import 'package:flutter/material.dart';
import 'package:kalender/kalender.dart';
import 'package:web_demo/enumerations.dart';
import 'package:web_demo/models/event.dart';
import 'package:web_demo/pages/multi_calendar.dart';
import 'package:web_demo/pages/single_calendar.dart';
import 'package:web_demo/utils.dart';
import 'package:web_demo/widgets/event_overlay.dart';

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
      theme: ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(
          seedColor: Colors.blue,
        ),
      ),
      darkTheme: ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(
          seedColor: Colors.blue,
          brightness: Brightness.dark,
        ),
      ),
      home: const MyHomePage(title: 'Kalender Demo'),
    );
  }

  void toggleTheme() {
    setState(() {
      themeMode = themeMode == ThemeMode.dark ? ThemeMode.light : ThemeMode.dark;
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
  final eventsController = EventsController<Event>();

  final _viewConfigurations = [
    MultiDayViewConfiguration.singleDay(),
    MultiDayViewConfiguration.week(),
    MultiDayViewConfiguration.workWeek(),
    MultiDayViewConfiguration.custom(numberOfDays: 3),
    MonthViewConfiguration.singleMonth(),
  ];

  late final _calendarCallbacks = CalendarCallbacks<Event>(
    onEventTapped: (event, renderBox) => _createOverlay(event, renderBox),
    onEventCreate: (event) => event.copyWith(data: Event(title: 'new')),
    onEventCreated: (event) => eventsController.addEvent(event),
  );

  ViewType _type = ViewType.single;
  OverlayEntry? _overlayEntry;

  @override
  void initState() {
    super.initState();
    eventsController.addEvents(generateEvents());
  }

  @override
  Widget build(BuildContext context) {
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
          ),
          DropdownMenu<ViewType>(
            initialSelection: _type,
            dropdownMenuEntries: [
              ...ViewType.values.map((e) => DropdownMenuEntry(value: e, label: e.label)),
            ],
            onSelected: (value) {
              if (value == null) return;
              setState(() => _type = value);
            },
          ),
        ],
      ),
      body: _type == ViewType.single
          ? SingleCalendarView(
              eventsController: eventsController,
              callbacks: _calendarCallbacks,
              viewConfigurations: _viewConfigurations,
            )
          : MultiCalendarView(
              eventsController: eventsController,
              callbacks: _calendarCallbacks,
              viewConfigurations: _viewConfigurations,
            ),
    );
  }

  void _removeOverlay() {
    if (_overlayEntry != null) {
      _overlayEntry?.remove();
      _overlayEntry = null;
    }
  }

  void _createOverlay(CalendarEvent<Event> event, RenderBox renderBox) {
    _removeOverlay();

    var position = renderBox.localToGlobal(Offset.zero);
    const height = 300.0;
    const width = 250.0;

    final size = context.size!;

    if (position.dy + height > size.height) {
      position = position.translate(0, size.height - (position.dy + height) - 25);
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
                behavior: HitTestBehavior.opaque,
                onTap: _removeOverlay,
              ),
            ),
            Positioned(
              top: position.dy,
              left: position.dx,
              child: EventOverlayCard(
                event: event,
                position: position,
                height: height,
                width: width,
                onDismiss: _removeOverlay,
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

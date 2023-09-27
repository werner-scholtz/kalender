import 'package:web_demo/models/event.dart';
import 'package:web_demo/functions/generate_calendar_events.dart';
import 'package:web_demo/widgets/calendar/calendar_header.dart';
import 'package:web_demo/widgets/calendar/calendar_widget.dart';
import 'package:web_demo/theme/theme.dart';
import 'package:flutter/material.dart';
import 'package:kalender/kalender.dart';
import 'package:web_demo/widgets/customize/calendar_customize.dart';
import 'package:web_demo/widgets/customize/view_customize.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  static MyAppState? of(BuildContext context) =>
      context.findAncestorStateOfType<MyAppState>();

  @override
  State<MyApp> createState() => MyAppState();
}

class MyAppState extends State<MyApp> {
  ThemeMode themeMode = ThemeMode.dark;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Kalender Example',
      themeMode: themeMode,
      theme: ThemeData(
        useMaterial3: true,
        colorScheme: lightColorScheme,
      ),
      darkTheme: ThemeData(
        useMaterial3: true,
        colorScheme: darkColorScheme,
      ),
      home: const MyHomePage(),
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
  const MyHomePage({
    super.key,
  });

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final CalendarEventsController<Event> eventsController =
      CalendarEventsController<Event>();

  final CalendarController<Event> calendarController =
      CalendarController<Event>();

  late CalendarComponents calendarComponents;
  late CalendarStyle calendarStyle;
  late CalendarLayoutDelegates<Event> calendarLayoutDelegates;

  int currentConfiguration = 0;
  List<ViewConfiguration> viewConfigurations = [
    const CustomMultiDayConfiguration(
      name: 'Day',
      numberOfDays: 1,
    ),
    const CustomMultiDayConfiguration(
      name: 'Custom',
      numberOfDays: 2,
    ),
    const WeekConfiguration(),
    const WorkWeekConfiguration(),
    const MonthConfiguration(),
    const ScheduleConfiguration(),
  ];

  @override
  void initState() {
    super.initState();
    eventsController.addEvents(generateCalendarEvents());
    calendarComponents = CalendarComponents(
      calendarHeaderBuilder: _calendarHeaderBuilder,
    );
    calendarStyle = const CalendarStyle();
    calendarLayoutDelegates = CalendarLayoutDelegates();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: LayoutBuilder(
        builder: (context, constraints) {
          final calendarWidget = CalendarWidget(
            eventsController: eventsController,
            calendarController: calendarController,
            calendarComponents: calendarComponents,
            calendarStyle: calendarStyle,
            currentConfiguration: viewConfigurations[currentConfiguration],
            calendarLayoutDelegates: calendarLayoutDelegates,
            onDateTapped: () {
              setState(() {
                currentConfiguration = 0;
              });
            },
          );

          if (constraints.maxWidth < 500) {
            return calendarWidget;
          } else {
            return Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Flexible(
                  flex: 3,
                  child: calendarWidget,
                ),
                Flexible(
                  flex: 1,
                  child: SingleChildScrollView(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        CalendarCustomize(
                          currentConfiguration:
                              viewConfigurations[currentConfiguration],
                          style: calendarStyle,
                          layoutDelegates: calendarLayoutDelegates,
                          onStyleChange: (newStyle) {
                            setState(() {
                              calendarStyle = newStyle;
                            });
                          },
                          onCalendarLayoutChange: (newLayout) {
                            setState(() {
                              calendarLayoutDelegates = newLayout;
                            });
                          },
                        ),
                        ViewConfigurationCustomize(
                          currentConfiguration:
                              viewConfigurations[currentConfiguration],
                          onViewConfigChanged: (newConfig) {
                            setState(() {
                              viewConfigurations[currentConfiguration] =
                                  newConfig;
                            });
                          },
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            );
          }
        },
      ),
    );
  }

  Widget _calendarHeaderBuilder(DateTimeRange visibleDateTimeRange) {
    return CalendarHeader(
      calendarController: calendarController,
      viewConfigurations: viewConfigurations,
      currentConfiguration: currentConfiguration,
      onViewConfigurationChanged: (viewConfiguration) {
        setState(() {
          currentConfiguration = viewConfiguration;
        });
      },
      visibleDateTimeRange: visibleDateTimeRange,
    );
  }
}

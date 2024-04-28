import 'package:flutter/material.dart';
import 'package:kalender/custom_kalendar.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const MyHomePage(title: 'Flutter Demo Home Page'),
    );
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
  final eventsController = CalendarEventsController();
  ViewConfiguration viewConfiguration = WeekConfiguration();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(widget.title),
      ),
      body: Calendar(
        calendarController: controller,
        eventsController: eventsController,
        viewConfiguration: viewConfiguration,
        headerBuilder: (context) {
          return Material(
            color: Theme.of(context).colorScheme.surface,
            surfaceTintColor: Theme.of(context).colorScheme.surfaceTint,
            elevation: 2,
            child: const Column(
              children: [],
            ),
          );
        },
        bodyBuilder: (context) {
          final internals = CalendarInternals.of(context);
          return Center(
            child: Text(internals.viewConfiguration.name),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(onPressed: _changeViewConfig),
    );
  }

  void _changeViewConfig() {
    setState(() {
      if (viewConfiguration is WeekConfiguration) {
        viewConfiguration = DayConfiguration();
      } else {
        viewConfiguration = WeekConfiguration();
      }
    });
  }
}

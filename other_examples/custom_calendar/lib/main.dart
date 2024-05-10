import 'package:flutter/material.dart';
import 'package:kalender/kalender.dart';

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
  final eventsController = EventsController();

  final test = ValueNotifier<bool>(false);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // body: Calendar(
      //   calendarController: controller,
      //   eventsController: eventsController,
      //   viewConfiguration: DayConfiguration(),
      //   header: (context) {
      //     return ValueListenableBuilder(
      //       valueListenable: test,
      //       builder: (context, value, child) {
      //         return Material(
      //           color: Theme.of(context).colorScheme.surface,
      //           surfaceTintColor: Theme.of(context).colorScheme.surfaceTint,
      //           elevation: 2,
      //           child: Column(
      //             children: [
      //               if (value)
      //                 FilledButton(
      //                   onPressed: () {},
      //                   child: Text('data'),
      //                 ),
      //               FilledButton(
      //                 onPressed: () {},
      //                 child: Text('data'),
      //               ),
      //             ],
      //           ),
      //         );
      //       },
      //     );
      //   },
      //   body: (context) {
      //     // return _MultiDayBody();
      //     return Container();
      //   },
      // ),
      floatingActionButton: FloatingActionButton(onPressed: _changeViewConfig),
    );
  }

  void _changeViewConfig() {
    test.value = !test.value;
    // setState(() {
    //   if (viewConfiguration is WeekConfiguration) {
    //     viewConfiguration = DayConfiguration();
    //   } else {
    //     viewConfiguration = WeekConfiguration();
    //   }
    // });
  }
}

import 'package:flutter/material.dart';
import 'package:kalender/kalender.dart';
import 'package:web_demo/main.dart';
import 'package:web_demo/models/event.dart';
import 'package:web_demo/widgets/calendar_widget.dart';

class MultiCalendarView extends StatefulWidget {
  const MultiCalendarView({super.key});

  @override
  State<MultiCalendarView> createState() => _MultiCalendarViewState();
}

class _MultiCalendarViewState extends State<MultiCalendarView> {
  final _controller = CalendarController<Event>();
  final _controller1 = CalendarController<Event>();

  late ViewConfiguration _viewConfiguration = _viewConfigurations.first;
  late ViewConfiguration _viewConfiguration1 = _viewConfigurations.first;
  final _viewConfigurations = [
    MultiDayViewConfiguration.singleDay(),
    MultiDayViewConfiguration.week(),
    MultiDayViewConfiguration.workWeek(),
    MultiDayViewConfiguration.custom(numberOfDays: 3),
    MonthViewConfiguration.singleMonth(),
    MultiDayViewConfiguration.freeScroll(numberOfDays: 3, name: "FreeScroll (WIP)"),
  ];

  bool showHeader = true;

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Flexible(
          flex: 3,
          child: CalendarWidget(
            controller: _controller,
            eventsController: MyApp.eventsController(context),
            viewConfiguration: _viewConfiguration,
            viewConfigurations: _viewConfigurations,
            onSelected: (value) => setState(() => _viewConfiguration = value),
            bodyConfiguration: MultiDayBodyConfiguration(),
            headerConfiguration: MultiDayHeaderConfiguration(),
            showHeader: showHeader,
          ),
        ),
        Flexible(
          flex: 3,
          child: CalendarWidget(
            controller: _controller1,
            eventsController: MyApp.eventsController(context),
            viewConfiguration: _viewConfiguration1,
            viewConfigurations: _viewConfigurations,
            onSelected: (value) => setState(() => _viewConfiguration1 = value),
            bodyConfiguration: MultiDayBodyConfiguration(),
            headerConfiguration: MultiDayHeaderConfiguration(),
            showHeader: showHeader,
          ),
        ),
      ],
    );
  }
}

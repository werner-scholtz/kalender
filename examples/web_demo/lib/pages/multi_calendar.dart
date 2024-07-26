import 'package:flutter/material.dart';
import 'package:kalender/kalender.dart';
import 'package:web_demo/models/event.dart';
import 'package:web_demo/widgets/calendar_widget.dart';

class MultiCalendarView extends StatefulWidget {
  final EventsController<Event> eventsController;
  final CalendarCallbacks<Event> callbacks;
  final List<ViewConfiguration> viewConfigurations;
  const MultiCalendarView({
    super.key,
    required this.eventsController,
    required this.callbacks,
    required this.viewConfigurations,
  });

  @override
  State<MultiCalendarView> createState() => _MultiCalendarViewState();
}

class _MultiCalendarViewState extends State<MultiCalendarView> {
  final _controller = CalendarController<Event>();
  final _controller1 = CalendarController<Event>();

  late ViewConfiguration _viewConfiguration = widget.viewConfigurations.first;
  late ViewConfiguration _viewConfiguration1 = widget.viewConfigurations.first;

  bool showHeader = true;

  @override
  Widget build(BuildContext context) {
    final calendar = CalendarWidget(
      controller: _controller,
      eventsController: widget.eventsController,
      viewConfiguration: _viewConfiguration,
      viewConfigurations: widget.viewConfigurations,
      onSelected: (value) => setState(() => _viewConfiguration = value),
      callbacks: widget.callbacks,
      bodyConfiguration: MultiDayBodyConfiguration(),
      headerConfiguration: MultiDayHeaderConfiguration(),
      showHeader: showHeader,
    );

    final calendar1 = CalendarWidget(
      controller: _controller1,
      eventsController: widget.eventsController,
      viewConfiguration: _viewConfiguration1,
      viewConfigurations: widget.viewConfigurations,
      onSelected: (value) => setState(() => _viewConfiguration1 = value),
      callbacks: widget.callbacks,
      bodyConfiguration: MultiDayBodyConfiguration(),
      headerConfiguration: MultiDayHeaderConfiguration(),
      showHeader: showHeader,
    );

    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Flexible(flex: 3, child: calendar),
        Flexible(flex: 3, child: calendar1),
      ],
    );
  }
}

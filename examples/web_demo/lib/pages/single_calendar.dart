import 'package:flutter/material.dart';
import 'package:kalender/kalender.dart';
import 'package:web_demo/main.dart';
import 'package:web_demo/models/event.dart';
import 'package:web_demo/widgets/calendar_customize.dart';
import 'package:web_demo/widgets/calendar_widget.dart';

class SingleCalendarView extends StatefulWidget {
  const SingleCalendarView({super.key});

  @override
  State<SingleCalendarView> createState() => _SingleCalendarViewState();
}

class _SingleCalendarViewState extends State<SingleCalendarView> {
  final _controller = CalendarController<Event>();

  late ViewConfiguration _viewConfiguration = _viewConfigurations[1];
  final _viewConfigurations = [
    MultiDayViewConfiguration.singleDay(),
    MultiDayViewConfiguration.week(),
    MultiDayViewConfiguration.workWeek(),
    MultiDayViewConfiguration.custom(numberOfDays: 3),
    MonthViewConfiguration.singleMonth(),
    MultiDayViewConfiguration.freeScroll(numberOfDays: 3, name: "FreeScroll (WIP)"),
  ];

  MultiDayBodyConfiguration _bodyConfiguration = MultiDayBodyConfiguration();
  MultiDayHeaderConfiguration<Event> _headerConfiguration = MultiDayHeaderConfiguration();

  final ValueNotifier<CalendarInteraction> _interactionHeader = ValueNotifier(CalendarInteraction());
  final ValueNotifier<CalendarInteraction> _interactionBody = ValueNotifier(CalendarInteraction());
  final ValueNotifier<CalendarSnapping> _snapping = ValueNotifier(const CalendarSnapping());

  bool showHeader = true;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final calendar = CalendarWidget(
          controller: _controller,
          eventsController: MyApp.eventsController(context),
          viewConfiguration: _viewConfiguration,
          viewConfigurations: _viewConfigurations,
          onSelected: (value) => setState(() => _viewConfiguration = value),
          bodyConfiguration: _bodyConfiguration,
          headerConfiguration: _headerConfiguration,
          showHeader: showHeader,
          interactionHeader: _interactionHeader,
          interactionBody: _interactionBody,
          snapping: _snapping,
        );

        final canShowCustomize = constraints.maxWidth > 800;
        late final customize = CalendarCustomize(
          viewConfiguration: _viewConfiguration,
          onChanged: (value) => setState(() => _viewConfiguration = value),
          bodyConfiguration: _bodyConfiguration,
          onBodyChanged: (value) => setState(() => _bodyConfiguration = value),
          headerConfiguration: _headerConfiguration,
          onHeaderChanged: (value) => setState(() => _headerConfiguration = value),
          showHeader: showHeader,
          onShowHeaderChanged: (value) => setState(() => showHeader = value),
          interaction: _interactionBody,
          interactionHeader: _interactionHeader,
          snapping: _snapping,
        );

        return Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Flexible(flex: 3, child: calendar),
            if (canShowCustomize) Flexible(flex: 1, child: customize),
          ],
        );
      },
    );
  }
}

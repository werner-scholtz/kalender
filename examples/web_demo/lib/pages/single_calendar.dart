import 'package:flutter/material.dart';
import 'package:kalender/kalender.dart';
import 'package:web_demo/models/event.dart';
import 'package:web_demo/widgets/calendar_customize.dart';
import 'package:web_demo/widgets/calendar_widget.dart';

class SingleCalendarView extends StatefulWidget {
  final EventsController<Event> eventsController;
  final CalendarCallbacks<Event> callbacks;
  final List<ViewConfiguration> viewConfigurations;

  const SingleCalendarView({
    super.key,
    required this.eventsController,
    required this.callbacks,
    required this.viewConfigurations,
  });

  @override
  State<SingleCalendarView> createState() => _SingleCalendarViewState();
}

class _SingleCalendarViewState extends State<SingleCalendarView> {
  final _controller = CalendarController<Event>();

  late ViewConfiguration _viewConfiguration = widget.viewConfigurations[1];
  MultiDayBodyConfiguration _bodyConfiguration = MultiDayBodyConfiguration();
  MultiDayHeaderConfiguration _headerConfiguration = MultiDayHeaderConfiguration();

  final ValueNotifier<CalendarInteraction> _interactionHeader = ValueNotifier(CalendarInteraction());
  final ValueNotifier<CalendarInteraction> _interactionBody = ValueNotifier(CalendarInteraction());
  final ValueNotifier<CalendarSnapping> _snapping = ValueNotifier(const CalendarSnapping());

  bool showHeader = true;

  @override
  Widget build(BuildContext context) {
    final customize = CalendarCustomize(
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

    final calendar = CalendarWidget(
      controller: _controller,
      eventsController: widget.eventsController,
      viewConfiguration: _viewConfiguration,
      viewConfigurations: widget.viewConfigurations,
      onSelected: (value) => setState(() => _viewConfiguration = value),
      callbacks: widget.callbacks,
      bodyConfiguration: _bodyConfiguration,
      headerConfiguration: _headerConfiguration,
      showHeader: showHeader,
      interactionHeader: _interactionHeader,
      interactionBody: _interactionBody,
      snapping: _snapping,
    );

    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Flexible(flex: 3, child: calendar),
        Flexible(flex: 1, child: customize),
      ],
    );
  }
}

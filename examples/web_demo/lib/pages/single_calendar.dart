import 'package:flutter/material.dart';
import 'package:kalender/kalender.dart';
import 'package:web_demo/widgets/calendar_customize.dart';
import 'package:web_demo/widgets/calendar_widget.dart';

class SingleCalendarView extends StatefulWidget {
  final EventsController eventsController;
  final CalendarCallbacks callbacks;
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
  final _controller = CalendarController();

  late ViewConfiguration _viewConfiguration = widget.viewConfigurations[1];
  MultiDayBodyConfiguration _bodyConfiguration = MultiDayBodyConfiguration();
  MultiDayHeaderConfiguration _headerConfiguration = MultiDayHeaderConfiguration();

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

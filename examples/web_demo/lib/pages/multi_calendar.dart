import 'package:flutter/material.dart';
import 'package:kalender/kalender.dart';

class MultiCalendarView extends StatefulWidget {
  final EventsController eventsController;
  const MultiCalendarView({super.key, required this.eventsController});

  @override
  State<MultiCalendarView> createState() => _MultiCalendarViewState();
}

class _MultiCalendarViewState extends State<MultiCalendarView> {
  @override
  Widget build(BuildContext context) {
    return Container();
  }
}

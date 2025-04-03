import 'package:flutter/material.dart';
import 'package:web_demo/pages/single_calendar.dart';

class MultiCalendarView extends StatefulWidget {
  const MultiCalendarView({super.key});

  @override
  State<MultiCalendarView> createState() => _MultiCalendarViewState();
}

class _MultiCalendarViewState extends State<MultiCalendarView> {
  @override
  Widget build(BuildContext context) {
    return const Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Flexible(flex: 3, child: SingleCalendarView()),
        Flexible(flex: 3, child: SingleCalendarView()),
      ],
    );
  }
}

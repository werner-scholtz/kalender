import 'package:flutter/material.dart';
import 'package:web_demo/providers.dart';
import 'package:web_demo/widgets/calendar_widget.dart';

class SingleCalendarView extends StatelessWidget {
  const SingleCalendarView({super.key});

  @override
  Widget build(BuildContext context) {
    return ConfigurationProvider(child: LocationProvider(child: const CalendarWidget()));
  }
}

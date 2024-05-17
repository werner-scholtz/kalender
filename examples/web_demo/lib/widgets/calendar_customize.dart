import 'package:flutter/material.dart';
import 'package:kalender/kalender.dart';

class CalendarCustomize extends StatefulWidget {
  final ViewConfiguration viewConfiguration;
  final void Function(ViewConfiguration value) onChanged;
  const CalendarCustomize({
    super.key,
    required this.viewConfiguration,
    required this.onChanged,
  });

  @override
  State<CalendarCustomize> createState() => _CalendarCustomizeState();
}

class _CalendarCustomizeState extends State<CalendarCustomize> {
  @override
  Widget build(BuildContext context) {
    return Card(
      child: Column(
        children: [],
      ),
    );
  }
}

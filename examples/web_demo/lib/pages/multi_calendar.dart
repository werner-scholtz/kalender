import 'package:flutter/material.dart';
import 'package:web_demo/widgets/calendar_widget.dart';

class MultiCalendarView extends StatelessWidget {
  const MultiCalendarView({super.key});

  @override
  Widget build(BuildContext context) {
    return const Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Flexible(flex: 3, child: Calendar()),
        Flexible(flex: 3, child: Calendar()),
      ],
    );
  }
}

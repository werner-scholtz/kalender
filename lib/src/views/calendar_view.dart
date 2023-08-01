import 'package:flutter/material.dart';

class CalendarView<T extends Object?> extends StatefulWidget {
  const CalendarView.singleDay({
    super.key,
  });

  const CalendarView.multiDay({
    super.key,
  });

  const CalendarView.month({
    super.key,
  });

  const CalendarView.schedule({
    super.key,
  });

  @override
  State<CalendarView<T>> createState() => _CalendarViewState<T>();
}

class _CalendarViewState<T extends Object?> extends State<CalendarView<T>> {
  @override
  Widget build(BuildContext context) {
    return Container();
  }
}

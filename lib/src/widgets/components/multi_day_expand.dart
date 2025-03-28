import 'package:flutter/material.dart';
import 'package:kalender/kalender.dart';

/// The builder for the multi day expand widget.
///
/// The [date] is the date that the expand widget will be displayed for.
/// The [onExpand] is the callback should be called when the expand widget is interacted with.
typedef MultiDayExpandBuilder = Widget Function(
  DateTime date,
  OnMultiDayExpand? onExpand,
);

class MultiDayExpand extends StatelessWidget {
  final DateTime date;
  final OnMultiDayExpand? onExpand;

  const MultiDayExpand({
    required this.date,
    required this.onExpand,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        final renderBox = context.findRenderObject() as RenderBox;
        onExpand?.call(date, renderBox);
      },
      child: const Text('...'),
    );
  }
}

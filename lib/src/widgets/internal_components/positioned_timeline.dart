import 'dart:async';

import 'package:flutter/material.dart';
import 'package:kalender/kalender_extensions.dart';
import 'package:kalender/src/extensions/internal.dart';

/// The positioned timeline widget is used to display the timeline in the [MultiDayBody].
///
/// This returns a [PositionedDirectional] or [SizedBox] widget that respects Directionality.
class PositionedTimeIndicator extends StatefulWidget {
  /// The list of visible dates in the view.
  final List<DateTime> visibleDates;

  /// The width of each day in the view.
  final double dayWidth;

  /// The child widget [TimeIndicator].
  final Widget child;

  /// The date override for testing purposes.
  final DateTime? nowOverride;

  const PositionedTimeIndicator({
    super.key,
    required this.visibleDates,
    required this.dayWidth,
    required this.child,
    this.nowOverride,
  });

  @override
  State<PositionedTimeIndicator> createState() => _PositionedTimeIndicatorState();
}

class _PositionedTimeIndicatorState extends State<PositionedTimeIndicator> {
  int? _index;
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    _update();
  }

  @override
  void didUpdateWidget(covariant PositionedTimeIndicator oldWidget) {
    super.didUpdateWidget(oldWidget);
    setState(_update);
  }

  void _update() {
    final newIndex = widget.nowOverride != null
        ? widget.visibleDates.indexWhere((date) => date.isSameDay(widget.nowOverride!.asUtc))
        // Compare with the current date as UTC.
        : widget.visibleDates.indexWhere((date) => date.isSameDay(DateTime.now().asUtc));

    if (_index == newIndex) {
      return;
    } else if (newIndex == -1) {
      _index = null;
      _timer?.cancel();
    } else {
      _index = newIndex;
      _timer?.cancel();

      final now = widget.nowOverride ?? DateTime.now();
      final nextDay = DateTime(now.year, now.month, now.day + 1);
      final duration = nextDay.difference(now);
      _timer = Timer(duration, () => setState(_update));
    }
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final index = _index;
    if (index == null) return const SizedBox.shrink();
    return PositionedDirectional(
      top: 0,
      bottom: 0,
      start: widget.dayWidth * index,
      width: widget.dayWidth,
      child: widget.child,
    );
  }
}

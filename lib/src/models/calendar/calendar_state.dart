import 'package:flutter/material.dart';

class CalendarState {
  const CalendarState({
    required this.scrollController,
    required this.visibleDateRange,
    required this.heightPerMinute,
    required this.dateTimeRange,
    required this.pageController,
    required this.itemCount,
  });

  final ScrollController scrollController;
  final ValueNotifier<DateTimeRange> visibleDateRange;
  final ValueNotifier<double> heightPerMinute;
  final DateTimeRange dateTimeRange;
  final PageController pageController;
  final int itemCount;
}

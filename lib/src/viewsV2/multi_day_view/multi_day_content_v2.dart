import 'package:flutter/material.dart';
import 'package:kalender/kalender.dart';
import 'package:kalender/src/constants.dart';
import 'package:kalender/src/providers/calendar_scope.dart';
import 'package:kalender/src/viewsV2/multi_day_view/multi_day_page_content.dart';

class MultiDayContentV2<T> extends StatelessWidget {
  const MultiDayContentV2({
    super.key,
    required this.controller,
    required this.viewConfiguration,
  });

  final CalendarController<T> controller;
  final MultiDayViewConfiguration viewConfiguration;

  @override
  Widget build(BuildContext context) {
    final scope = CalendarScope.of<T>(context);

    return ValueListenableBuilder<double>(
      valueListenable: scope.state.heightPerMinute!,
      builder: (context, heightPerMinute, child) {
        final hourHeight = heightPerMinute * minutesAnHour;
        final pageHeight = hourHeight * hoursADay;

        return ValueListenableBuilder<ScrollPhysics>(
          valueListenable: scope.state.scrollPhysics,
          builder: (context, value, child) {
            return SingleChildScrollView(
              physics: value,
              child: SizedBox(
                height: pageHeight,
                child: Stack(
                  fit: StackFit.expand,
                  clipBehavior: Clip.none,
                  children: [
                    Positioned.fill(
                      left: viewConfiguration.hourLineLeftOffset,
                      child: scope.components.hourLineBuilder(
                        hourHeight,
                      ),
                    ),
                    Positioned(
                      width: viewConfiguration.timelineWidth,
                      child: scope.components.timelineBuilder(
                        hourHeight,
                      ),
                    ),
                    Positioned.fill(
                      left: viewConfiguration.timelineWidth,
                      child: PageView.builder(
                        key: Key(viewConfiguration.hashCode.toString()),
                        controller: scope.state.pageController,
                        itemCount: scope.state.numberOfPages,
                        clipBehavior: Clip.none,
                        onPageChanged: (index) {
                          final newVisibleDateTimeRange = viewConfiguration
                              .calculateVisibleDateRangeForIndex(
                            index: index,
                            calendarStart:
                                scope.state.adjustedDateTimeRange.start,
                          );
                          // Update the visible date range.
                          scope.state.visibleDateTimeRange =
                              newVisibleDateTimeRange;

                          // Update the selected date.
                          controller.selectedDate =
                              newVisibleDateTimeRange.start;

                          // Call the onPageChanged function.
                          scope.functions.onPageChanged?.call(
                            newVisibleDateTimeRange,
                          );
                        },
                        itemBuilder: (context, index) {
                          final visibleDateRange = viewConfiguration
                              .calculateVisibleDateRangeForIndex(
                            index: index,
                            calendarStart:
                                scope.state.adjustedDateTimeRange.start,
                          );

                          return MultiDayPageContent<T>(
                            viewConfiguration: viewConfiguration,
                            visibleDateRange: visibleDateRange,
                          );
                        },
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }
}

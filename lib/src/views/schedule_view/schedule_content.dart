import 'package:flutter/material.dart';

import 'package:kalender/src/providers/calendar_scope.dart';
import 'package:kalender/src/components/general/schedule_date_tile/schedule_date_tile.dart';
import 'package:kalender/src/extensions.dart';
import 'package:kalender/src/models/calendar/calendar_controller.dart';
import 'package:kalender/src/models/calendar/calendar_view_state.dart';
import 'package:kalender/src/models/schedule_group.dart';
import 'package:kalender/src/models/view_configurations/schedule_configurations/schedule_view_configuration.dart';
import 'package:scrollable_positioned_list/scrollable_positioned_list.dart';

class ScheduleContent<T> extends StatefulWidget {
  const ScheduleContent({
    super.key,
    required this.controller,
    required this.viewConfiguration,
    required this.viewState,
  });

  final CalendarController<T> controller;
  final ScheduleViewConfiguration viewConfiguration;
  final ScheduleViewState<T> viewState;

  @override
  State<ScheduleContent<T>> createState() => _ScheduleContentState<T>();
}

class _ScheduleContentState<T> extends State<ScheduleContent<T>> {
  late CalendarScope<T> scope = CalendarScope.of<T>(context);

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback(
      (timeStamp) => _jumpToStartDate(),
    );

    widget.viewState.itemPositionsListener.itemPositions
        .addListener(_updateVisibleDateRange);
  }

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<List<ScheduleGroup<T>>>(
      valueListenable: widget.viewState.scheduleGroupsNotifier,
      builder: (context, value, child) {
        return ScrollConfiguration(
          behavior: ScrollConfiguration.of(context).copyWith(scrollbars: false),
          child: ScrollablePositionedList.builder(
            itemCount: value.length,
            itemBuilder: (context, index) {
              final scheduleGroup = value[index];

              return Column(
                children: [
                  if (scheduleGroup.isFirstOfMonth)
                    Row(
                      children: [
                        Expanded(
                          child: scope.components.scheduleMonthHeaderBuilder(
                            scheduleGroup.date,
                          ),
                        ),
                      ],
                    ),
                  ScheduleDateTile<T>(
                    scheduleGroup: scheduleGroup,
                  ),
                ],
              );
            },
            itemScrollController: widget.viewState.itemScrollController,
            itemPositionsListener: widget.viewState.itemPositionsListener,
          ),
        );
      },
    );
  }

  void _jumpToStartDate() {
    if (widget.viewState.scheduleGroups.isEmpty) return;

    final date = DateTime.now();

    var index = widget.viewState.scheduleGroups.indexWhere(
      (group) => group.date.isSameDay(date),
    );

    if (index == -1) {
      index = widget.viewState.scheduleGroups.indexWhere(
        (group) => group.date.startOfWeek == date.startOfWeek,
      );
    }

    if (index == -1) {
      index = widget.viewState.scheduleGroups.indexWhere(
        (group) => group.date.startOfMonth == date.startOfMonth,
      );
    }

    if (index == -1) {
      index = widget.viewState.scheduleGroups.length ~/ 2;
    }

    widget.viewState.itemScrollController.jumpTo(index: index);
  }

  void _updateVisibleDateRange() {
    if (widget.viewState.itemPositionsListener.itemPositions.value.isEmpty) {
      return;
    }

    final startIndex =
        widget.viewState.itemPositionsListener.itemPositions.value.reduce(
      (value, item) => value.index < item.index ? value : item,
    );

    final endIndex =
        widget.viewState.itemPositionsListener.itemPositions.value.reduce(
      (value, item) => value.index > item.index ? value : item,
    );

    final startTime = widget.viewState.scheduleGroups[startIndex.index].date;
    final endTime = widget.viewState.scheduleGroups[endIndex.index].date;

    final visibleDateRange = DateTimeRange(
      start: startTime.startOfDay,
      end: endTime.endOfDay,
    );

    if (widget.viewState.visibleDateTimeRangeNotifier.value !=
        visibleDateRange) {
      // Update the visible date range.
      widget.viewState.visibleDateTimeRange = visibleDateRange;

      // Update the selected date.
      widget.controller.selectedDate = visibleDateRange.start;
    }
  }
}

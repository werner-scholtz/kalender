import 'package:flutter/material.dart';
import 'package:kalender/kalender.dart';
import 'package:web_demo/models/event.dart';
import 'package:web_demo/widgets/customize/theme_tile.dart';

class CalendarCustomize extends StatefulWidget {
  const CalendarCustomize({
    super.key,
    required this.currentConfiguration,
    required this.onStyleChange,
    required this.layoutDelegates,
    required this.style,
    required this.onCalendarLayoutChange,
  });

  final ViewConfiguration currentConfiguration;
  final CalendarStyle style;
  final CalendarLayoutDelegates layoutDelegates;
  final Function(CalendarStyle newStyle) onStyleChange;
  final Function(CalendarLayoutDelegates<Event> newLayout)
      onCalendarLayoutChange;

  @override
  State<CalendarCustomize> createState() => _CalendarCustomizeState();
}

class _CalendarCustomizeState extends State<CalendarCustomize> {
  final Color highlightColor = Colors.red;

  bool customLayoutController = false;

  bool highlightCalendarHeader = false;
  bool highlightDaySeparator = false;
  bool highlightHourLine = false;
  bool highlightDayHeader = false;

  bool highlightTimeIndicator = false;
  bool highlightTimeline = false;
  bool highlightWeekNumber = false;
  bool highlightMonthGrid = false;
  bool highlightMonthCellHeaders = false;
  bool highlightMonthHeader = false;

  bool scheduleMonthHeader = false;
  bool scheduleTilePaddingVertical = false;
  bool scheduleTilePaddingHorizontal = false;

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        children: [
          const ThemeTile(),
          if (widget.currentConfiguration is MultiDayViewConfiguration)
            CheckboxListTile.adaptive(
              title: const Text('Custom Layout Controller'),
              value: customLayoutController,
              onChanged: (value) {
                if (value == null) return;
                customLayoutController = value;

                if (value) {
                  widget.onCalendarLayoutChange(
                    CalendarLayoutDelegates<Event>(
                      dayTileLayoutController: ({
                        required events,
                        required heightPerMinute,
                        required startOfGroup,
                      }) =>
                          EventGroupBasicLayoutDelegate(
                        events: events,
                        startOfGroup: startOfGroup,
                        heightPerMinute: heightPerMinute,
                      ),
                    ),
                  );
                } else {
                  widget.onCalendarLayoutChange(
                    CalendarLayoutDelegates<Event>(),
                  );
                }
              },
            ),
          ExpansionTile(
            title: const Text('Highlight Components'),
            initiallyExpanded: true,
            children: [
              CheckboxListTile.adaptive(
                title: const Text('Calendar Header'),
                value: highlightCalendarHeader,
                onChanged: (value) {
                  if (value == null) return;
                  highlightCalendarHeader = value;
                  widget.onStyleChange(
                    widget.style.copyWith(
                      calendarHeaderBackgroundStyle:
                          CalendarHeaderBackgroundStyle(
                        headerElevation: 5,
                        headerBackgroundColor:
                            value ? highlightColor.withAlpha(100) : null,
                      ),
                    ),
                  );
                },
              ),
              if (widget.currentConfiguration is MultiDayViewConfiguration)
                ...multiDayConfig(
                    widget.currentConfiguration as MultiDayViewConfiguration),
              if (widget.currentConfiguration is MonthViewConfiguration)
                ...monthConfig(
                    widget.currentConfiguration as MonthConfiguration),
              if (widget.currentConfiguration is ScheduleConfiguration)
                ...scheduleConfig(
                    widget.currentConfiguration as ScheduleConfiguration)
            ],
          ),
        ],
      ),
    );
  }

  List<Widget> scheduleConfig(ScheduleConfiguration config) {
    return [
      CheckboxListTile.adaptive(
        title: const Text('Day Header'),
        value: highlightDayHeader,
        onChanged: (value) {
          if (value == null) return;
          highlightDayHeader = value;
          widget.onStyleChange(
            widget.style.copyWith(
              dayHeaderStyle: DayHeaderStyle(
                backgroundColor: value ? highlightColor.withAlpha(100) : null,
                borderRadius: BorderRadius.circular(16),
              ),
            ),
          );
        },
      ),
      CheckboxListTile.adaptive(
        title: const Text('Schedule Month Header'),
        value: scheduleMonthHeader,
        onChanged: (value) {
          if (value == null) return;
          scheduleMonthHeader = value;
          widget.onStyleChange(
            widget.style.copyWith(
              scheduleMonthHeaderStyle: value
                  ? const ScheduleMonthHeaderStyle(
                      monthColors: {
                        1: Colors.red,
                        2: Colors.red,
                        3: Colors.red,
                        4: Colors.red,
                        5: Colors.red,
                        6: Colors.red,
                        7: Colors.red,
                        8: Colors.red,
                        9: Colors.red,
                        10: Colors.red,
                        11: Colors.red,
                        12: Colors.red,
                      },
                    )
                  : const ScheduleMonthHeaderStyle(),
            ),
          );
        },
      ),
      CheckboxListTile.adaptive(
        title: const Text('Day Header'),
        value: highlightDayHeader,
        onChanged: (value) {
          if (value == null) return;
          highlightDayHeader = value;
          widget.onStyleChange(
            widget.style.copyWith(
              dayHeaderStyle: DayHeaderStyle(
                backgroundColor: value ? highlightColor.withAlpha(100) : null,
                borderRadius: BorderRadius.circular(16),
              ),
            ),
          );
        },
      ),
      CheckboxListTile.adaptive(
        title: const Text('ScheduleDateTile margin'),
        value: scheduleTilePaddingVertical,
        onChanged: (value) {
          if (value == null) return;
          scheduleTilePaddingVertical = value;
          widget.onStyleChange(
            widget.style.copyWith(
              scheduleDateTileStyle: ScheduleDateTileStyle(
                margin: value
                    ? const EdgeInsets.symmetric(vertical: 16)
                    : const EdgeInsets.symmetric(vertical: 4),
                tilePadding: widget.style.scheduleDateTileStyle?.tilePadding,
              ),
            ),
          );
        },
      ),
      CheckboxListTile.adaptive(
        title: const Text('Schedule Tile Padding'),
        value: scheduleTilePaddingHorizontal,
        onChanged: (value) {
          if (value == null) return;
          scheduleTilePaddingHorizontal = value;
          widget.onStyleChange(
            widget.style.copyWith(
              scheduleDateTileStyle: ScheduleDateTileStyle(
                tilePadding: value
                    ? const EdgeInsets.symmetric(horizontal: 8, vertical: 4)
                    : const EdgeInsets.symmetric(horizontal: 8),
                margin: widget.style.scheduleDateTileStyle?.margin,
              ),
            ),
          );
        },
      ),
    ];
  }

  List<Widget> multiDayConfig(MultiDayViewConfiguration config) {
    return [
      CheckboxListTile.adaptive(
        title: const Text('Day Separator'),
        value: highlightDaySeparator,
        onChanged: (value) {
          if (value == null) return;
          highlightDaySeparator = value;
          widget.onStyleChange(
            widget.style.copyWith(
              daySeparatorStyle: DaySeparatorStyle(
                color: value ? highlightColor : null,
              ),
            ),
          );
        },
      ),
      CheckboxListTile.adaptive(
        title: const Text('Hour Lines'),
        value: highlightHourLine,
        onChanged: (value) {
          if (value == null) return;
          highlightHourLine = value;
          widget.onStyleChange(
            widget.style.copyWith(
              hourLineStyle: HourLineStyle(
                color: value ? highlightColor : null,
              ),
            ),
          );
        },
      ),
      CheckboxListTile.adaptive(
        title: const Text('Day Header'),
        value: highlightDayHeader,
        onChanged: (value) {
          if (value == null) return;
          highlightDayHeader = value;
          widget.onStyleChange(
            widget.style.copyWith(
              dayHeaderStyle: DayHeaderStyle(
                backgroundColor: value ? highlightColor.withAlpha(100) : null,
                borderRadius: BorderRadius.circular(16),
              ),
            ),
          );
        },
      ),
      CheckboxListTile.adaptive(
        title: const Text('Time Indicator'),
        value: highlightTimeIndicator,
        onChanged: (value) {
          if (value == null) return;
          highlightTimeIndicator = value;
          widget.onStyleChange(
            widget.style.copyWith(
              timeIndicatorStyle: TimeIndicatorStyle(
                color: value ? Colors.greenAccent : null,
              ),
            ),
          );
        },
      ),
      CheckboxListTile.adaptive(
        title: const Text('Timeline'),
        value: highlightTimeline,
        onChanged: (value) {
          if (value == null) return;
          highlightTimeline = value;
          widget.onStyleChange(
            widget.style.copyWith(
                timelineStyle: TimelineStyle(
              textStyle: highlightTimeline
                  ? TextStyle(
                      color: highlightColor,
                    )
                  : null,
            )),
          );
        },
      ),
      CheckboxListTile.adaptive(
        title: const Text('Week Number'),
        value: highlightWeekNumber,
        onChanged: (value) {
          if (value == null) return;
          highlightWeekNumber = value;
          widget.onStyleChange(widget.style.copyWith(
            weekNumberStyle: WeekNumberStyle(
              visualDensity: value ? VisualDensity.comfortable : null,
              textStyle: TextStyle(
                color: value ? highlightColor : null,
              ),
            ),
          ));
        },
      ),
    ];
  }

  List<Widget> monthConfig(MonthConfiguration config) {
    return [
      CheckboxListTile.adaptive(
        title: const Text('Month Header'),
        value: highlightMonthHeader,
        onChanged: (value) {
          if (value == null) return;
          highlightMonthHeader = value;
          widget.onStyleChange(
            widget.style.copyWith(
              monthHeaderStyle: MonthHeaderStyle(
                textStyle: TextStyle(
                  color: value ? highlightColor : null,
                ),
              ),
            ),
          );
        },
      ),
      CheckboxListTile.adaptive(
        title: const Text('Month Cell Header'),
        value: highlightMonthCellHeaders,
        onChanged: (value) {
          if (value == null) return;
          highlightMonthCellHeaders = value;
          widget.onStyleChange(
            widget.style.copyWith(
              monthCellHeaderStyle: MonthCellHeaderStyle(
                backgroundColor: value ? highlightColor.withAlpha(100) : null,
                borderRadius: BorderRadius.circular(16),
              ),
            ),
          );
        },
      ),
      CheckboxListTile.adaptive(
        title: const Text('Month Grid'),
        value: highlightMonthGrid,
        onChanged: (value) {
          if (value == null) return;
          highlightMonthGrid = value;
          widget.onStyleChange(
            widget.style.copyWith(
              monthGridStyle: MonthGridStyle(
                color: value ? highlightColor : null,
              ),
            ),
          );
        },
      ),
    ];
  }
}

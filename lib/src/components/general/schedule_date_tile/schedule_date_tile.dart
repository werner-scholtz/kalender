import 'package:flutter/material.dart';
import 'package:kalender/src/models/schedule_group.dart';
import 'package:kalender/src/providers/calendar_scope.dart';
import 'package:kalender/src/providers/calendar_style.dart';

class ScheduleDateTile<T> extends StatelessWidget {
  const ScheduleDateTile({
    super.key,
    required this.scheduleGroup,
  });

  final ScheduleGroup<T> scheduleGroup;

  @override
  Widget build(BuildContext context) {
    final style = CalendarStyleProvider.of(context).style.scheduleDateTileStyle;
    final scope = CalendarScope.of<T>(context);
    return Padding(
      padding: style?.margin ?? const EdgeInsets.all(0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: style?.datePadding ?? const EdgeInsets.all(0),
            child: scope.components.dayHeaderBuilder(
              scheduleGroup.date,
              (date) => scope.functions.onDateTapped?.call(date),
            ),
          ),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                ...scheduleGroup.events.map(
                  (event) => Padding(
                    padding: style?.tilePadding ?? const EdgeInsets.all(0),
                    child: MouseRegion(
                      hitTestBehavior: HitTestBehavior.deferToChild,
                      cursor: SystemMouseCursors.click,
                      child: GestureDetector(
                        behavior: HitTestBehavior.deferToChild,
                        onTap: () {
                          scope.functions.onEventTapped?.call(event);
                        },
                        child: scope.tileComponents.scheduleTileBuilder!(
                          event,
                          scheduleGroup.date,
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

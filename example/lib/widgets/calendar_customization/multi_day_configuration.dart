import 'package:example/widgets/calendar_customization/list_tiles.dart';
import 'package:flutter/material.dart';
import 'package:kalender/kalender.dart';

class MultiDayConfiguarionEditor extends StatelessWidget {
  const MultiDayConfiguarionEditor({
    super.key,
    required this.config,
    required this.onConfigChanged,
  });

  final MultiDayConfiguration config;
  final void Function(MultiDayConfiguration newConfig) onConfigChanged;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        NumberOfDays(
          value: config.numberOfDays,
          onChanged: (value) {
            onConfigChanged(
              config.copyWith(
                numberOfDays: value,
              ),
            );
          },
        ),
        TimelineWidth(
          value: config.timelineWidth,
          onChanged: (value) {
            onConfigChanged(
              config.copyWith(
                timelineWidth: value,
              ),
            );
          },
        ),
        HourlineTimelineOverlap(
          value: config.hourLineTimelineOverlap,
          onChanged: (value) {
            onConfigChanged(
              config.copyWith(
                hourLineTimelineOverlap: value,
              ),
            );
          },
        ),
        MultidayTileHeight(
          value: config.multiDayTileHeight,
          onChanged: (value) {
            onConfigChanged(
              config.copyWith(
                multiDayTileHeight: value,
              ),
            );
          },
        ),
        SlotSizeTile(
          value: config.newEventDuration,
          onChanged: (value) {
            onConfigChanged(
              config.copyWith(
                slotSize: value,
              ),
            );
          },
        ),
        CheckboxListTile.adaptive(
          title: const Text('paintWeekNumber'),
          value: config.paintWeekNumber,
          onChanged: (bool? value) {
            if (value == null) return;
            onConfigChanged(
              config.copyWith(
                paintWeekNumber: value,
              ),
            );
          },
        ),
        CheckboxListTile.adaptive(
          title: const Text('eventSnapping'),
          value: config.eventSnapping,
          onChanged: (bool? value) {
            if (value == null) return;
            onConfigChanged(
              config.copyWith(
                eventSnapping: value,
              ),
            );
          },
        ),
        CheckboxListTile.adaptive(
          title: const Text('timeIndicatorSnapping'),
          value: config.timeIndicatorSnapping,
          onChanged: (bool? value) {
            if (value == null) return;
            onConfigChanged(
              config.copyWith(
                timeIndicatorSnapping: value,
              ),
            );
          },
        ),
        CheckboxListTile.adaptive(
          title: const Text('createNewEvents'),
          value: config.createNewEvents,
          onChanged: (bool? value) {
            if (value == null) return;
            onConfigChanged(
              config.copyWith(
                createNewEvents: value,
              ),
            );
          },
        ),
        VerticalStepDuration(
          verticalStepDuration: config.verticalStepDuration,
          onChanged: (value) {
            onConfigChanged(
              config.copyWith(
                verticalStepDuration: value,
              ),
            );
          },
        ),
        VerticalSnapRange(
          verticalSnapRange: config.verticalSnapRange,
          onChanged: (value) {
            onConfigChanged(
              config.copyWith(
                verticalSnapRange: value,
              ),
            );
          },
        ),
      ],
    );
  }
}

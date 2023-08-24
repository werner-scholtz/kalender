import 'package:example/widgets/calendar_customization/list_tiles.dart';
import 'package:flutter/material.dart';
import 'package:kalender/kalender.dart';

class DayConfiguarionEditor extends StatelessWidget {
  const DayConfiguarionEditor({
    super.key,
    required this.config,
    required this.onConfigChanged,
  });

  final DayConfiguration config;
  final void Function(DayConfiguration newConfig) onConfigChanged;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
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
          value: config.hourlineTimelineOverlap,
          onChanged: (value) {
            onConfigChanged(
              config.copyWith(
                hourlineTimelineOverlap: value,
              ),
            );
          },
        ),
        MultidayTileHeight(
          value: config.multidayTileHeight,
          onChanged: (value) {
            onConfigChanged(
              config.copyWith(
                multidayTileHeight: value,
              ),
            );
          },
        ),
        SlotSizeTile(
          value: config.slotSize,
          onChanged: (value) {
            onConfigChanged(
              config.copyWith(
                slotSize: value,
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

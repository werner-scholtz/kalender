import 'package:flutter/material.dart';
import 'package:kalender/kalender.dart';
import 'package:web_demo/widgets/customize/list_tiles.dart';

class ViewConfigurationCustomize extends StatelessWidget {
  const ViewConfigurationCustomize({
    super.key,
    required this.currentConfiguration,
    required this.onViewConfigChanged,
  });

  final ViewConfiguration currentConfiguration;
  final Function(ViewConfiguration newConfig) onViewConfigChanged;

  @override
  Widget build(BuildContext context) {
    return ExpansionTile(
      title: const Text('View Configuration'),
      initiallyExpanded: true,
      children: [
        ...(currentConfiguration is MultiDayViewConfiguration)
            ? multiDayConfig(currentConfiguration as MultiDayViewConfiguration)
            : monthConfig(currentConfiguration as MonthConfiguration)
      ],
    );
  }

  List<Widget> multiDayConfig(MultiDayViewConfiguration config) {
    return [
      MultiDayTileHeight(
        value: config.multiDayTileHeight,
        onChanged: (value) {
          onViewConfigChanged(
            config.copyWith(
              multiDayTileHeight: value,
            ),
          );
        },
      ),
      HourLineTimelineOverlap(
        value: config.hourLineTimelineOverlap,
        onChanged: (value) {
          onViewConfigChanged(
            config.copyWith(
              hourLineTimelineOverlap: value,
            ),
          );
        },
      ),
      TimelineWidth(
        value: config.timelineWidth,
        onChanged: (value) {
          onViewConfigChanged(
            config.copyWith(
              timelineWidth: value,
            ),
          );
        },
      ),
      if (config is CustomMultiDayConfiguration)
        NumberOfDays(
          value: config.numberOfDays,
          onChanged: (value) {
            onViewConfigChanged(
              config.copyWith(
                numberOfDays: value,
              ),
            );
          },
        ),
      if (config is WeekConfiguration)
        FirstDayOfWeek(
          value: config.firstDayOfWeek,
          onChanged: (value) {
            onViewConfigChanged(
              config.copyWith(
                firstDayOfWeek: value,
              ),
            );
          },
        ),
      VerticalStepDuration(
        verticalStepDuration: config.verticalStepDuration,
        onChanged: (value) {
          onViewConfigChanged(
            config.copyWith(
              verticalStepDuration: value,
            ),
          );
        },
      ),
      VerticalSnapRange(
        verticalSnapRange: config.verticalSnapRange,
        onChanged: (value) {
          onViewConfigChanged(
            config.copyWith(
              verticalSnapRange: value,
            ),
          );
        },
      ),
    ];
  }

  List<Widget> monthConfig(MonthConfiguration config) {
    return [
      MultiDayTileHeight(
        value: config.multiDayTileHeight,
        onChanged: (value) {
          onViewConfigChanged(
            config.copyWith(
              multiDayTileHeight: value,
            ),
          );
        },
      ),
      FirstDayOfWeek(
        value: config.firstDayOfWeek,
        onChanged: (value) {
          onViewConfigChanged(
            config.copyWith(
              firstDayOfWeek: value,
            ),
          );
        },
      ),
    ];
  }
}

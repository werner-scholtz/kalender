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
    return ListenableBuilder(
      listenable: currentConfiguration,
      builder: (context, child) {
        return ExpansionTile(
          title: const Text('View Configuration'),
          initiallyExpanded: true,
          children: [
            if (currentConfiguration is MultiDayViewConfiguration)
              ...multiDayConfig(
                  currentConfiguration as MultiDayViewConfiguration),
            if (currentConfiguration is MonthConfiguration)
              ...monthConfig(currentConfiguration as MonthConfiguration)
          ],
        );
      },
    );
  }

  List<Widget> multiDayConfig(MultiDayViewConfiguration config) {
    return [
      MultiDayTileHeight(
        value: config.multiDayTileHeight,
        onChanged: (value) {
          config.multiDayTileHeight = value;
        },
      ),
      HourLineTimelineOverlap(
        value: config.daySeparatorLeftOffset,
        onChanged: (value) {
          config.daySeparatorLeftOffset = value;
        },
      ),
      TimelineWidth(
        value: config.timelineWidth,
        onChanged: (value) {
          config.timelineWidth = value;
        },
      ),
      if (config is CustomMultiDayConfiguration)
        NumberOfDays(
          value: config.numberOfDays,
          onChanged: (value) {
            config.numberOfDays = value;
          },
        ),
      if (config is WeekConfiguration)
        FirstDayOfWeek(
          value: config.firstDayOfWeek,
          onChanged: (value) {
            config.firstDayOfWeek = value;
          },
        ),
      VerticalStepDuration(
        verticalStepDuration: config.verticalStepDuration,
        onChanged: (value) {
          config.verticalStepDuration = value;
        },
      ),
      VerticalSnapRange(
        verticalSnapRange: config.verticalSnapRange,
        onChanged: (value) {
          config.verticalSnapRange = value;
        },
      ),
    ];
  }

  List<Widget> monthConfig(MonthConfiguration config) {
    return [
      MultiDayTileHeight(
        value: config.multiDayTileHeight,
        onChanged: (value) {
          config.multiDayTileHeight = value;
        },
      ),
      FirstDayOfWeek(
        value: config.firstDayOfWeek,
        onChanged: (value) {
          config.firstDayOfWeek = value;
        },
      ),
    ];
  }
}

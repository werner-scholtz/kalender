import 'package:flutter/material.dart';
import 'package:kalender/src/models/view_configurations/view_configuration.dart';
import 'package:kalender/src/views/single_day_view/single_day_content.dart';
import 'package:kalender/src/views/single_day_view/single_day_header.dart';

class SingleDayView<T extends Object?> extends StatelessWidget {
  const SingleDayView({
    super.key,
    required this.viewConfiguration,
  });

  final SingleDayViewConfiguration viewConfiguration;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (BuildContext context, BoxConstraints constraints) {
        // Calculate the width of the day.
        double dayWidth = constraints.maxWidth - viewConfiguration.timelineWidth;

        return Column(
          children: <Widget>[
            SingleDayHeader<T>(
              dayWidth: dayWidth,
              viewConfiguration: viewConfiguration,
            ),
            SingleDayContent<T>(
              dayWidth: dayWidth,
              viewConfiguration: viewConfiguration,
            ),
          ],
        );
      },
    );
  }
}

import 'package:flutter/material.dart';
import 'package:kalender/src/models/view_configurations/multi_day_configurations/multi_day_view_configuration.dart';
import 'package:kalender/src/views/multi_day_view/multi_day_content.dart';
import 'package:kalender/src/views/multi_day_view/multi_day_header.dart';

class MultiDayView<T extends Object?> extends StatelessWidget {
  const MultiDayView({
    super.key,
    required this.viewConfiguration,
  });

  final MultiDayViewConfiguration viewConfiguration;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (BuildContext context, BoxConstraints constraints) {
        // Calculate the width of the page.
        double pageWidth = constraints.maxWidth - viewConfiguration.timelineWidth;

        // Calculate the width of the day.
        double dayWidth = viewConfiguration.calculateDayWidth(pageWidth);

        return Column(
          children: <Widget>[
            MultiDayHeader<T>(
              viewConfiguration: viewConfiguration,
              dayWidth: dayWidth,
              pageWidth: pageWidth,
            ),
            MultiDayContent<T>(
              viewConfiguration: viewConfiguration,
              dayWidth: dayWidth,
              pageWidth: pageWidth,
            ),
          ],
        );
      },
    );
  }
}

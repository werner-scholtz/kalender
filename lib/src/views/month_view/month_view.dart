import 'package:flutter/material.dart';
import 'package:kalender/kalender.dart';
import 'package:kalender/src/views/month_view/month_content.dart';
import 'package:kalender/src/views/month_view/month_header.dart';

class MonthView<T extends Object?> extends StatelessWidget {
  const MonthView({
    super.key,
    required this.viewConfiguration,
  });

  final MonthViewConfiguration viewConfiguration;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (BuildContext context, BoxConstraints constraints) {
        double pageWidth = constraints.maxWidth;

        double cellWidth = viewConfiguration.calculateDayWidth(pageWidth);

        return Column(
          children: [
            MonthViewHeader<T>(
              cellWidth: cellWidth,
              viewConfiguration: viewConfiguration,
            ),
            MonthContent<T>(
              cellWidth: cellWidth,
              viewConfiguration: viewConfiguration,
            ),
          ],
        );
      },
    );
  }
}

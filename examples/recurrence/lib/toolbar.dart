import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:kalender/kalender.dart';

class CalendarToolBar extends StatelessWidget {
  final CalendarController calendarController;
  const CalendarToolBar({required this.calendarController, super.key});

  @override
  Widget build(BuildContext context) {
    final isDesktop = kIsWeb ||
        (Theme.of(context).platform != TargetPlatform.android && Theme.of(context).platform != TargetPlatform.iOS);

    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Row(
        spacing: 4,
        children: [
          ValueListenableBuilder(
            valueListenable: calendarController.internalDateTimeRange,
            builder: (context, value, child) {
              if (value == null) return const SizedBox.shrink();
              final localRange = value.forLocation();

              final String month;
              final int year;

              if (calendarController.viewController?.viewConfiguration is MonthViewConfiguration) {
                final dominantMonthDate = InternalDateTimeRange.fromDateTimeRange(localRange).dominantMonthDate;
                year = dominantMonthDate.year;
                month = dominantMonthDate.monthNameLocalized();
              } else {
                year = localRange.start.year;
                month = localRange.start.monthNameLocalized();
              }

              return FilledButton.tonal(
                onPressed: () => calendarController.animateToDate(DateTime.now()),
                style: FilledButton.styleFrom(
                  minimumSize: const Size(150, kMinInteractiveDimension),
                ),
                child: Text('$month $year'),
              );
            },
          ),
          if (isDesktop)
            IconButton.filledTonal(
              onPressed: () => calendarController.animateToPreviousPage(),
              icon: const Icon(Icons.chevron_left),
            ),
          if (isDesktop)
            IconButton.filledTonal(
              onPressed: () => calendarController.animateToNextPage(),
              icon: const Icon(Icons.chevron_right),
            ),
          IconButton.filledTonal(
            onPressed: () => calendarController.animateToDate(DateTime.now()),
            icon: const Icon(Icons.today),
          ),
        ],
      ),
    );
  }
}

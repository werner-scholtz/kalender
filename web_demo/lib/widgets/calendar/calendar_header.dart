import 'package:flutter/material.dart';
import 'package:kalender/kalender.dart';

class CalendarHeader extends StatelessWidget {
  const CalendarHeader({
    super.key,
    required this.calendarController,
    required this.viewConfigurations,
    required this.currentConfiguration,
    required this.onViewConfigurationChanged,
    required this.visibleDateTimeRange,
  });

  final CalendarController calendarController;
  final List<ViewConfiguration> viewConfigurations;
  final DateTimeRange visibleDateTimeRange;
  final int currentConfiguration;
  final void Function(int index) onViewConfigurationChanged;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (BuildContext context, BoxConstraints constraints) {
        final months =
            constraints.maxWidth < 600 ? monthsMobile : monthsDesktop;
        final buttonWidth = constraints.maxWidth < 600 ? 120.0 : 250.0;
        final viewWidth = constraints.maxWidth < 600 ? 80.0 : 150.0;

        return Padding(
          padding: const EdgeInsets.all(8.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              FilledButton.tonal(
                style: ButtonStyle(
                  minimumSize: MaterialStateProperty.all<Size>(
                    Size(buttonWidth, 48),
                  ),
                ),
                onPressed: () async {
                  DateTime? selectedDate = await showDatePicker(
                    context: context,
                    initialDate: visibleDateTimeRange.start,
                    firstDate: DateTime(1970),
                    lastDate: DateTime(2040),
                  );
                  if (selectedDate == null) return;

                  calendarController.animateToDate(
                    selectedDate,
                  );
                },
                child: Text(
                  '${calendarController.visibleMonth!.year} - ${months[calendarController.visibleMonth!.month - 1]}',
                  style: Theme.of(context).textTheme.titleLarge,
                ),
              ),
              if (viewConfigurations[currentConfiguration]
                  is! ScheduleViewConfiguration)
                Padding(
                  padding: const EdgeInsets.only(left: 4),
                  child: IconButton.filledTonal(
                    onPressed: () {
                      calendarController.animateToPreviousPage();
                    },
                    icon: const Icon(Icons.chevron_left),
                    tooltip: 'Previous Page',
                  ),
                ),
              if (viewConfigurations[currentConfiguration]
                  is! ScheduleViewConfiguration)
                Padding(
                  padding: const EdgeInsets.only(left: 4),
                  child: IconButton.filledTonal(
                    onPressed: () {
                      calendarController.animateToNextPage();
                    },
                    icon: const Icon(Icons.chevron_right),
                    tooltip: 'Next Page',
                  ),
                ),
              Padding(
                padding: const EdgeInsets.only(left: 4),
                child: IconButton.filledTonal(
                  onPressed: () {
                    calendarController.animateToDate(
                      DateTime.now(),
                      duration: const Duration(milliseconds: 800),
                    );
                  },
                  icon: const Icon(Icons.today),
                  tooltip: 'Today',
                ),
              ),
              Expanded(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 4),
                      child: DropdownMenu<int>(
                        width: viewWidth,
                        initialSelection: currentConfiguration,
                        dropdownMenuEntries: [
                          for (var i = 0; i < viewConfigurations.length; i++)
                            DropdownMenuEntry<int>(
                              value: i,
                              label: viewConfigurations[i].name,
                            ),
                        ],
                        enableSearch: false,
                        onSelected: (int? value) {
                          if (value == null) return;
                          onViewConfigurationChanged(value);
                        },
                        inputDecorationTheme: const InputDecorationTheme(
                          contentPadding: EdgeInsets.symmetric(horizontal: 8),
                          border: OutlineInputBorder(gapPadding: 16),
                          constraints:
                              BoxConstraints(maxHeight: 42, minHeight: 38),
                        ),
                      ),
                    ),
                  ],
                ),
              )
            ],
          ),
        );
      },
    );
  }
}

const Map<int, String> monthsDesktop = {
  0: 'January',
  1: 'February',
  2: 'March',
  3: 'April',
  4: 'Mei',
  5: 'June',
  6: 'July',
  7: 'August',
  8: 'September',
  9: 'October',
  10: 'November',
  11: 'December',
};

const Map<int, String> monthsMobile = {
  0: 'Jan',
  1: 'Feb',
  2: 'Mar',
  3: 'Apr',
  4: 'Mei',
  5: 'Jun',
  6: 'Jul',
  7: 'Aug',
  8: 'Sep',
  9: 'Oct',
  10: 'Nov',
  11: 'Dec',
};

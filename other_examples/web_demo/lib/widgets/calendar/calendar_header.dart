import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
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
        final buttonWidth = constraints.maxWidth < 600 ? 120.0 : 250.0;
        final viewWidth = constraints.maxWidth < 600 ? 80.0 : 150.0;
        final padding = constraints.maxWidth < 600 ? 0.0 : 4.0;
        final buttonHeight = constraints.maxWidth < 600 ? 40.0 : 48.0;

        final dateFormat = constraints.maxWidth < 600
            ? DateFormat('yyyy - MMM')
            : DateFormat('yyyy - MMMM');

        final dateButton = FilledButton.tonal(
          style: ButtonStyle(
            minimumSize: MaterialStateProperty.all<Size>(
              Size(buttonWidth, buttonHeight),
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
            dateFormat.format(calendarController.visibleMonth!),
            style: Theme.of(context).textTheme.titleLarge,
          ),
        );

        return Padding(
          padding: const EdgeInsets.all(8.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              dateButton,
              if (viewConfigurations[currentConfiguration]
                  is! ScheduleViewConfiguration)
                Padding(
                  padding: EdgeInsets.only(left: padding),
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
                  padding: EdgeInsets.only(left: padding),
                  child: IconButton.filledTonal(
                    onPressed: () {
                      calendarController.animateToNextPage();
                    },
                    icon: const Icon(Icons.chevron_right),
                    tooltip: 'Next Page',
                  ),
                ),
              Padding(
                padding: EdgeInsets.only(left: padding),
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
                      padding: EdgeInsets.symmetric(horizontal: padding),
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

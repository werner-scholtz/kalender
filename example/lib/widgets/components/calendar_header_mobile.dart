import 'package:flutter/material.dart';
import 'package:kalender/kalender.dart';

class CalendarHeaderMobile extends StatelessWidget {
  const CalendarHeaderMobile({
    super.key,
    required this.calendarController,
    required this.viewConfigurations,
    required this.currentConfiguration,
    required this.onViewConfigurationChanged,
    required this.dateTimeRange,
  });

  final CalendarController calendarController;
  final List<ViewConfiguration> viewConfigurations;
  final ViewConfiguration currentConfiguration;
  final DateTimeRange dateTimeRange;
  final void Function(ViewConfiguration) onViewConfigurationChanged;

  @override
  Widget build(BuildContext context) {
    DateTime monthYear = calendarController.visibleMonth!;
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 8),
          child: Text(
            '${monthYear.year} - ${months[monthYear.month - 1]}',
            style: Theme.of(context).textTheme.titleLarge,
          ),
        ),
        IconButton.filledTonal(
          onPressed: () async {
            DateTime? selectedDate = await showDatePicker(
              context: context,
              initialDate: dateTimeRange.start,
              firstDate: DateTime(1970),
              lastDate: DateTime(2040),
            );
            if (selectedDate == null) return;

            calendarController.animateToDate(
              selectedDate,
              duration: const Duration(microseconds: 300),
              curve: Curves.ease,
            );
          },
          icon: const Icon(Icons.calendar_month),
          tooltip: 'Date Picker',
        ),
        Expanded(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 1),
                child: IconButton.filledTonal(
                  onPressed: () {
                    calendarController.animateToPreviousPage();
                  },
                  icon: const Icon(Icons.chevron_left),
                  tooltip: 'Previous Page',
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 1),
                child: IconButton.filledTonal(
                  onPressed: () {
                    calendarController.animateToNextPage();
                  },
                  icon: const Icon(Icons.chevron_right),
                  tooltip: 'Next Page',
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 1),
                child: DropdownMenu<ViewConfiguration>(
                  width: 120,
                  initialSelection: currentConfiguration,
                  dropdownMenuEntries: viewConfigurations
                      .map(
                        (e) => DropdownMenuEntry<ViewConfiguration>(
                          value: e,
                          label: e.name,
                        ),
                      )
                      .toList(),
                  enableSearch: false,
                  onSelected: (ViewConfiguration? value) {
                    if (value == null) return;
                    onViewConfigurationChanged(value);
                  },
                  inputDecorationTheme: const InputDecorationTheme(
                    contentPadding: EdgeInsets.symmetric(horizontal: 8),
                    border: OutlineInputBorder(gapPadding: 16),
                    constraints: BoxConstraints(maxHeight: 42, minHeight: 38),
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

const Map<int, String> months = {
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
  11: 'Des',
};

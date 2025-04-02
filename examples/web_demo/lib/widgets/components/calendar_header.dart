import 'dart:math';

import 'package:flutter/material.dart';
import 'package:kalender/kalender.dart';
import 'package:web_demo/models/event.dart';

class NavigationHeader extends StatelessWidget {
  final CalendarController<Event> controller;
  final List<ViewConfiguration> viewConfigurations;
  final ViewConfiguration viewConfiguration;
  final void Function(ViewConfiguration value) onSelected;
  const NavigationHeader({
    super.key,
    required this.controller,
    required this.viewConfigurations,
    required this.viewConfiguration,
    required this.onSelected,
  });

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (BuildContext context, BoxConstraints constraints) {
        final dateButton = HeaderDateButton(controller: controller);
        final todayButton = IconButton.filledTonal(
          icon: const Icon(Icons.today),
          onPressed: () => controller.animateToDate(DateTime.now()),
        );

        final showNavigationButtons = constraints.maxWidth > 500;
        late final previousButton = IconButton.filledTonal(
          icon: const Icon(Icons.chevron_left),
          onPressed: () => controller.animateToPreviousPage(),
        );

        late final nextButton = IconButton.filledTonal(
          icon: const Icon(Icons.chevron_right),
          onPressed: () => controller.animateToNextPage(),
        );

        final width = min(200.0, constraints.maxWidth - 200.0);
        final view = DropdownMenu(
          dropdownMenuEntries: viewConfigurations.map((e) => DropdownMenuEntry(value: e, label: e.name)).toList(),
          width: width,
          inputDecorationTheme: InputDecorationTheme(
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(kMinInteractiveDimension)),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(kMinInteractiveDimension),
              borderSide: BorderSide(width: 2, color: Theme.of(context).colorScheme.outline),
            ),
          ),
          initialSelection: viewConfiguration,
          onSelected: (value) {
            if (value == null) return;
            onSelected(value);
          },
        );

        return Row(
          spacing: 4.0,
          children: [
            dateButton,
            if (showNavigationButtons) ...[
              previousButton,
              nextButton,
            ],
            todayButton,
            const Spacer(),
            view,
          ],
        );
      },
    );
  }
}

class HeaderDateButton extends StatelessWidget {
  final CalendarController<Event> controller;
  const HeaderDateButton({super.key, required this.controller});

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder(
      valueListenable: controller.visibleDateTimeRange,
      builder: (context, value, child) {
        final String month;
        final int year;

        if (controller.viewController is MonthViewController) {
          // Since the visible DateTimeRange returned by the month view does not always start at the beginning of the month,
          // we need to check the second week of the visibleDateTimeRange to determine the month and year.
          final secondWeek = value.start.addDays(7);
          year = secondWeek.year;
          month = secondWeek.monthNameEnglish;
        } else {
          year = value.start.year;
          month = value.start.monthNameEnglish;
        }

        return FilledButton.tonal(
          onPressed: () async {
            final displayRange = controller.viewController?.viewConfiguration.displayRange;
            if (displayRange == null) return;
            final selectedDate = await showDatePicker(
              context: context,
              firstDate: displayRange.start,
              lastDate: displayRange.end,
            );
            if (selectedDate != null) controller.animateToDate(selectedDate);
          },
          style: FilledButton.styleFrom(
            minimumSize: const Size(150, kMinInteractiveDimension),
          ),
          child: Text('$month $year'),
        );
      },
    );
  }
}

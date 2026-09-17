// This file is part of kalender.
//
// SPDX-FileCopyrightText: 2023 Klarälvdalens Datakonsult AB, a KDAB Group company <info@kdab.com>
//
// SPDX-License-Identifier: MIT

import 'package:example/main.dart' show Event;
import 'package:example/tiles.dart';
import 'package:flutter/material.dart';
import 'package:kalender/kalender.dart';

/// Date selection through [KalenderController]. Run with `flutter run -t lib/selection_demo.dart`.
void main() => runApp(const SelectionDemoApp());

class SelectionDemoApp extends StatelessWidget {
  const SelectionDemoApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Kalender Selection',
      theme: ThemeData(colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue)),
      darkTheme: ThemeData(colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue, brightness: Brightness.dark)),
      home: const SelectionDemo(),
    );
  }
}

enum TapMode { day, range }

enum Look {
  ring('Ring', 'The package default. Today keeps its fill, a selected day gets a ring.'),
  fill('Fill', 'A selected day is filled. On today the selected fill replaces the today fill.'),
  fillTodayRing('Tonal fill, today ring', 'A selected day has a light fill and today is a ring. On today both show.');

  const Look(this.label, this.description);

  final String label;
  final String description;

  DayNumberStyle style(ColorScheme scheme) {
    final ring = BorderSide(color: scheme.primary, width: 2);
    return switch (this) {
      Look.ring => const DayNumberStyle(),
      Look.fill => DayNumberStyle(
          selectedBackgroundColor: scheme.primary,
          selectedForegroundColor: scheme.onPrimary,
          selectedBorder: BorderSide.none,
        ),
      Look.fillTodayRing => DayNumberStyle(
          todayBackgroundColor: Colors.transparent,
          todayForegroundColor: scheme.primary,
          todayBorder: ring,
          selectedBackgroundColor: scheme.primaryContainer,
          selectedForegroundColor: scheme.onPrimaryContainer,
          selectedBorder: BorderSide.none,
        ),
    };
  }
}

class SelectionDemo extends StatefulWidget {
  const SelectionDemo({super.key});

  @override
  State<SelectionDemo> createState() => _SelectionDemoState();
}

class _SelectionDemoState extends State<SelectionDemo> {
  final eventsController = DefaultEventsController();
  final kalenderController = KalenderController();

  final now = DateTime.now();
  late final today = DateTime(now.year, now.month, now.day);
  late final displayRange = KalenderDateTimeRange(start: DateTime(now.year - 1), end: DateTime(now.year + 2));
  static const initialTimeOfDay = KalenderTime(hour: 7, minute: 0);

  late final viewConfigurations = <ViewConfiguration>[
    MonthViewConfiguration.singleMonth(
      displayRange: displayRange,
      initialDateTime: now,
      nowCallback: () => now,
      showWeekNumbers: true,
    ),
    MultiDayViewConfiguration.week(
      displayRange: displayRange,
      firstDayOfWeek: 1,
      initialTimeOfDay: initialTimeOfDay,
      initialDateTime: now,
      nowCallback: () => now,
    ),
    MultiDayViewConfiguration.singleDay(
      displayRange: displayRange,
      initialTimeOfDay: initialTimeOfDay,
      initialDateTime: now,
      nowCallback: () => now,
    ),
    ScheduleViewConfiguration.continuous(displayRange: displayRange, initialDateTime: now, nowCallback: () => now),
  ];
  late ViewConfiguration viewConfiguration = viewConfigurations.first;

  var tapMode = TapMode.day;
  var navigate = false;
  var labelOpensOverlay = false;
  var look = Look.ring;
  DateTime? rangeAnchor;
  String lastCall = '';

  @override
  void initState() {
    super.initState();
    eventsController.addEvents([
      Event(
        start: today.add(const Duration(hours: 9)),
        end: today.add(const Duration(hours: 10)),
        title: 'Standup',
        color: Colors.blue,
      ),
      Event(
        start: today.add(const Duration(days: 2, hours: 13)),
        end: today.add(const Duration(days: 2, hours: 15)),
        title: 'Workshop',
        color: Colors.orange,
      ),
      Event(
        start: today.add(const Duration(days: 5)),
        end: today.add(const Duration(days: 7)),
        title: 'Conference',
        color: Colors.purple,
      ),
      Event(
        start: today.subtract(const Duration(days: 4, hours: -11)),
        end: today.subtract(const Duration(days: 4, hours: -12)),
        title: 'Lunch',
        color: Colors.green,
      ),
      Event(
        start: today.add(const Duration(days: 45, hours: 10)),
        end: today.add(const Duration(days: 45, hours: 11)),
        title: 'Review',
        color: Colors.teal,
      ),
    ]);
  }

  @override
  void dispose() {
    kalenderController.dispose();
    eventsController.dispose();
    super.dispose();
  }

  String _date(DateTime date) => '${date.year}-${date.month}-${date.day}';

  void selectDate(DateTime date) {
    kalenderController.selectDate(date, navigate: navigate);
    setState(() => lastCall = 'controller.selectDate(${_date(date)}, navigate: $navigate)');
  }

  void selectRange(KalenderDateTimeRange range) {
    kalenderController.selectRange(range, navigate: navigate);
    setState(
      () => lastCall = 'controller.selectRange(${_date(range.start)} to ${_date(range.end)}, navigate: $navigate)',
    );
  }

  void showDayOverlay(DateTime date) {
    kalenderController.showDayOverlay(date, navigate: navigate);
    setState(() => lastCall = 'controller.showDayOverlay(${_date(date)}, navigate: $navigate)');
  }

  void onTapped(DateTime date) {
    switch (tapMode) {
      case TapMode.day:
        selectDate(date);
      case TapMode.range:
        final anchor = rangeAnchor;
        if (anchor == null) {
          selectDate(date);
          rangeAnchor = date;
        } else {
          final (first, last) = anchor.isAfter(date) ? (date, anchor) : (anchor, date);
          selectRange(KalenderDateTimeRange(start: first, end: DateTime(last.year, last.month, last.day + 1)));
          rangeAnchor = null;
        }
    }
  }

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return Scaffold(
      body: Row(
        children: [
          Expanded(
            child: KalenderTheme(
              data: KalenderThemeData(dayNumberStyle: look.style(scheme)),
              child: KalenderView(
                eventsController: eventsController,
                kalenderController: kalenderController,
                viewConfiguration: viewConfiguration,
                callbacks: KalenderCallbacks(
                  onTapped: onTapped,
                  dateLabel: GestureCallbacks(
                    onTap: (detail) => labelOpensOverlay ? showDayOverlay(detail.date) : onTapped(detail.date),
                  ),
                  weekNumber: GestureCallbacks(onTap: (detail) => selectRange(detail.dateTimeRange)),
                  onEventChanged: (event, updatedEvent) =>
                      eventsController.updateEvent(event: event, updatedEvent: updatedEvent),
                ),
                header: Material(
                  color: scheme.surface,
                  elevation: 2,
                  child: Column(
                    children: [
                      _toolbar(),
                      const KalenderHeader(multiDayTileComponents: tileComponents),
                    ],
                  ),
                ),
                body: KalenderBody(
                  multiDayTileComponents: tileComponents,
                  monthTileComponents: tileComponents,
                  scheduleTileComponents: scheduleTileComponents,
                  scheduleBodyConfiguration: ScheduleBodyConfiguration(emptyDay: EmptyDayBehavior.show),
                ),
              ),
            ),
          ),
          const VerticalDivider(width: 1),
          SizedBox(width: 360, child: _panel(context)),
        ],
      ),
    );
  }

  Widget _toolbar() {
    return Padding(
      padding: const EdgeInsets.all(8),
      child: Row(
        spacing: 4,
        children: [
          ValueListenableBuilder(
            valueListenable: kalenderController.visibleDateTimeRange,
            builder: (context, range, _) {
              if (range == null) return const SizedBox.shrink();
              final date = FloatingDateTimeRange.fromDateTimeRange(range).dominantMonthDate;
              return Text('${date.monthNameLocalized()} ${date.year}', style: Theme.of(context).textTheme.titleMedium);
            },
          ),
          const Spacer(),
          IconButton(
            onPressed: () => kalenderController.animateToPreviousPage(),
            icon: const Icon(Icons.chevron_left),
          ),
          IconButton(onPressed: () => kalenderController.animateToNextPage(), icon: const Icon(Icons.chevron_right)),
          DropdownMenu(
            dropdownMenuEntries: [for (final c in viewConfigurations) DropdownMenuEntry(value: c, label: c.name)],
            initialSelection: viewConfiguration,
            onSelected: (value) {
              if (value != null) setState(() => viewConfiguration = value);
            },
          ),
        ],
      ),
    );
  }

  Widget _panel(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    Widget heading(String text) => Padding(
          padding: const EdgeInsets.only(top: 16, bottom: 8),
          child: Text(text, style: textTheme.titleSmall),
        );

    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        Text('Selection', style: textTheme.titleLarge),
        const SizedBox(height: 4),
        Text(
            'The app selects through KalenderController. Tap a day, a day number or a week number, or use the buttons.',
            style: textTheme.bodySmall),
        heading('controller.selectedRange'),
        ListenableBuilder(
          listenable: kalenderController.selectedRange,
          builder: (context, _) {
            final range = kalenderController.selectedRange.value;
            if (range == null) return const Text('null');
            final days = range.dates();
            final first = days.first;
            final last = days.last;
            return Text('${_date(first)} to ${_date(last)}, ${days.length} ${days.length == 1 ? 'day' : 'days'}');
          },
        ),
        if (lastCall.isNotEmpty) ...[
          const SizedBox(height: 8),
          Text(lastCall, style: textTheme.bodySmall?.copyWith(fontFamily: 'monospace')),
        ],
        heading('Tapping a day'),
        SegmentedButton<TapMode>(
          segments: const [
            ButtonSegment(value: TapMode.day, label: Text('One day')),
            ButtonSegment(value: TapMode.range, label: Text('Range')),
          ],
          selected: {tapMode},
          onSelectionChanged: (value) => setState(() {
            tapMode = value.single;
            rangeAnchor = null;
          }),
        ),
        if (tapMode == TapMode.range)
          Padding(
            padding: const EdgeInsets.only(top: 8),
            child: Text(
              rangeAnchor == null ? 'Tap the first day.' : 'Tap the last day.',
              style: textTheme.bodySmall,
            ),
          ),
        heading('Select from code'),
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: [
            OutlinedButton(onPressed: () => selectDate(today), child: const Text('Today')),
            OutlinedButton(
              onPressed: () => selectDate(today.add(const Duration(days: 2))),
              child: const Text('In 2 days'),
            ),
            OutlinedButton(
              onPressed: () => selectDate(today.add(const Duration(days: 45))),
              child: const Text('In 45 days'),
            ),
            OutlinedButton(
              onPressed: () => selectRange(
                KalenderDateTimeRange(start: today, end: DateTime(today.year, today.month, today.day + 7)),
              ),
              child: const Text('Next 7 days'),
            ),
            OutlinedButton(
              onPressed: () {
                kalenderController.deselectRange();
                setState(() => lastCall = 'controller.deselectRange()');
              },
              child: const Text('Clear'),
            ),
          ],
        ),
        SwitchListTile(
          contentPadding: EdgeInsets.zero,
          title: const Text('navigate: true'),
          subtitle: const Text('Moves the view when the day is not visible.'),
          value: navigate,
          onChanged: (value) => setState(() => navigate = value),
        ),
        heading('Day overlay'),
        ValueListenableBuilder(
          valueListenable: kalenderController.openDayOverlay,
          builder: (context, day, _) => Text('controller.openDayOverlay: ${day == null ? 'null' : _date(day)}'),
        ),
        SwitchListTile(
          contentPadding: EdgeInsets.zero,
          title: const Text('A date label opens the overlay'),
          value: labelOpensOverlay,
          onChanged: (value) => setState(() => labelOpensOverlay = value),
        ),
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: [
            OutlinedButton(onPressed: () => showDayOverlay(today), child: const Text('Today')),
            OutlinedButton(
              onPressed: () => showDayOverlay(today.add(const Duration(days: 45))),
              child: const Text('In 45 days'),
            ),
          ],
        ),
        heading('Look'),
        RadioGroup<Look>(
          groupValue: look,
          onChanged: (value) {
            if (value != null) setState(() => look = value);
          },
          child: Column(
            children: [
              for (final value in Look.values)
                RadioListTile<Look>(
                  contentPadding: EdgeInsets.zero,
                  value: value,
                  title: Text(value.label),
                  subtitle: Text(value.description),
                ),
            ],
          ),
        ),
        heading('Events in the selection'),
        ListenableBuilder(
          listenable: Listenable.merge([kalenderController.selectedRange, eventsController]),
          builder: (context, _) {
            final range = kalenderController.selectedRange.value;
            if (range == null) return const Text('Nothing selected.');
            final events = eventsController.eventsInRange(range, multiDayRule: kDefaultMultiDayRule).toList();
            if (events.isEmpty) return const Text('No events.');
            return Column(
              children: [
                for (final event in events.cast<Event>())
                  ListTile(
                    contentPadding: EdgeInsets.zero,
                    dense: true,
                    leading: CircleAvatar(radius: 6, backgroundColor: event.color),
                    title: Text(event.title),
                    subtitle: Text('${_date(event.start)} to ${_date(event.end)}'),
                  ),
              ],
            );
          },
        ),
      ],
    );
  }
}

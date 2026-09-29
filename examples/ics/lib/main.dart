// This file is part of kalender.
//
// SPDX-FileCopyrightText: 2023 Klarälvdalens Datakonsult AB, a KDAB Group company <info@kdab.com>
//
// SPDX-License-Identifier: MIT

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:kalender/kalender.dart';

import 'ics_calendar.dart';
import 'ics_event.dart';

void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Kalender ICS Example',
      theme: ThemeData(useMaterial3: true, colorScheme: ColorScheme.fromSeed(seedColor: Colors.indigo)),
      home: const HomePage(),
    );
  }
}

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final eventsController = DefaultEventsController();

  final now = DateTime.now();
  late final displayRange = KalenderDateTimeRange(
    start: DateTime(now.year - 1, now.month, now.day),
    end: DateTime(now.year + 1, now.month, now.day),
  );

  late final viewConfigurations = <ViewConfiguration>[
    MultiDayViewConfiguration.week(displayRange: displayRange, firstDayOfWeek: 1),
    MonthViewConfiguration.singleMonth(displayRange: displayRange),
    ScheduleViewConfiguration.continuous(displayRange: displayRange),
  ];
  late final kalenderController = KalenderController(viewConfiguration: viewConfigurations.first);

  List<IcsSource> _sources = [];

  /// The window the events controller currently holds expanded events for.
  KalenderDateTimeRange? _covered;

  @override
  void initState() {
    super.initState();
    kalenderController.visibleDateTimeRange.addListener(_onVisibleRangeChanged);
    _loadSample();
  }

  @override
  void dispose() {
    kalenderController.visibleDateTimeRange.removeListener(_onVisibleRangeChanged);
    eventsController.dispose();
    kalenderController.dispose();
    super.dispose();
  }

  Future<void> _loadSample() async {
    final text = await rootBundle.loadString('assets/sample.ics');
    _sources = parseIcs(text);
    // Seeds a window around today. The range listener keeps it in sync afterwards.
    _regenerate(_windowAround(KalenderDateTimeRange(start: now, end: now)));
  }

  void _onVisibleRangeChanged() {
    final visible = kalenderController.visibleDateTimeRange.value;
    if (_sources.isEmpty) return;
    final covered = _covered;
    if (covered != null && !visible.start.isBefore(covered.start) && !visible.end.isAfter(covered.end)) {
      return; // still inside the materialized window
    }
    _regenerate(_windowAround(visible));
  }

  KalenderDateTimeRange _windowAround(KalenderDateTimeRange range) => KalenderDateTimeRange(
        start: range.start.subtract(const Duration(days: 60)),
        end: range.end.add(const Duration(days: 60)),
      );

  void _regenerate(KalenderDateTimeRange window) {
    _covered = window;
    eventsController.replaceEvents(expandEvents(_sources, window));
  }

  /// Expands [sources] over the window already covered and keeps them. Throws, keeping the current sources, when
  /// they cannot be expanded.
  void _setSources(List<IcsSource> sources) {
    final window = _covered ?? _windowAround(KalenderDateTimeRange(start: now, end: now));
    final events = expandEvents(sources, window);
    _sources = sources;
    _covered = window;
    eventsController.replaceEvents(events);
  }

  /// An event created in the multi-day header or the month view is all-day.
  KalenderEvent _onEventCreate(KalenderEvent event, TapDetail detail) {
    final uid = '${DateTime.now().microsecondsSinceEpoch}@kalender.example';
    return IcsEvent(
      start: event.start,
      end: event.end,
      uid: uid,
      title: 'New event',
      color: colorFor(uid),
      isAllDay: detail is MultiDayDetail,
    );
  }

  void _onEventCreated(KalenderEvent event) {
    if (event is IcsEvent) _setSources([..._sources, IcsSource.fromEvent(event)]);
  }

  void _onEventChanged(KalenderEvent event, KalenderEvent updatedEvent) {
    if (updatedEvent is! IcsEvent) return;
    _setSources([
      for (final source in _sources)
        source.uid == updatedEvent.uid && source.recurrence == null
            ? source.copyWith(start: updatedEvent.start.toLocal(), end: updatedEvent.end.toLocal())
            : source,
    ]);
  }

  Future<void> _showImport() async {
    final text = await showDialog<String>(context: context, builder: (context) => const ImportDialog());
    if (text == null || !mounted) return;
    try {
      _setSources(importIcs(_sources, text));
    } on Object catch (error) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Could not read the .ics text: $error')));
    }
  }

  Future<void> _showExport() async {
    final text = exportIcs(_sources);
    if (!mounted) return;
    await showDialog<void>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Exported .ics'),
        content: SizedBox(width: 480, child: SingleChildScrollView(child: SelectableText(text))),
        actions: [
          TextButton(
            onPressed: () {
              Clipboard.setData(ClipboardData(text: text));
              Navigator.of(context).pop();
            },
            child: const Text('Copy'),
          ),
          TextButton(onPressed: () => Navigator.of(context).pop(), child: const Text('Close')),
        ],
      ),
    );
  }

  void _onEventTapped(KalenderEvent event) {
    if (event is! IcsEvent) return;
    kalenderController.selectEvent(event);
    final message = event.description == null ? event.title : '${event.title}: ${event.description}';
    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(SnackBar(content: Text(message)));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('ICS example'),
        actions: [
          IconButton(onPressed: _loadSample, icon: const Icon(Icons.refresh), tooltip: 'Reload sample'),
          IconButton(onPressed: _showImport, icon: const Icon(Icons.upload), tooltip: 'Import .ics'),
          IconButton(onPressed: _showExport, icon: const Icon(Icons.download), tooltip: 'Export .ics'),
          const SizedBox(width: 8),
        ],
      ),
      body: KalenderView(
        eventsController: eventsController,
        kalenderController: kalenderController,
        callbacks: KalenderCallbacks(
          onEventTapped: _onEventTapped,
          onEventCreateWithDetail: _onEventCreate,
          onEventCreated: _onEventCreated,
          onEventChanged: _onEventChanged,
        ),
        views: [
          MultiDayViewParts(
            header: _header(MultiDayHeader(tileComponents: _tileComponents())),
            body: MultiDayBody(tileComponents: _tileComponents()),
          ),
          MonthViewParts(
            header: _header(const MonthHeader()),
            body: MonthBody(tileComponents: _tileComponents()),
          ),
          ScheduleViewParts(
            header: _header(),
            body: ScheduleBody(tileComponents: _scheduleTileComponents()),
          ),
        ],
      ),
    );
  }

  /// The view switcher above [child].
  Widget _header([Widget? child]) {
    return Material(
      elevation: 2,
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8),
            child: Row(
              children: [
                DropdownMenu<ViewConfiguration>(
                  initialSelection: kalenderController.viewConfiguration,
                  dropdownMenuEntries: [
                    for (final config in viewConfigurations) DropdownMenuEntry(value: config, label: config.name),
                  ],
                  onSelected: (value) {
                    if (value != null) kalenderController.viewConfiguration = value;
                  },
                ),
              ],
            ),
          ),
          if (child != null) child,
        ],
      ),
    );
  }

  TileComponents _tileComponents() {
    return TileComponents(
      tileBuilder: (context, event, tileRange) {
        final ics = event as IcsEvent;
        return Card(
          margin: EdgeInsets.zero,
          color: ics.color.withAlpha(220),
          child: Padding(
            padding: const EdgeInsets.all(4),
            child: Text(ics.title, style: const TextStyle(color: Colors.white, fontSize: 12)),
          ),
        );
      },
    );
  }

  ScheduleTileComponents _scheduleTileComponents() {
    return ScheduleTileComponents(
      tileBuilder: (context, event, tileRange) {
        final ics = event as IcsEvent;
        return Card(
          margin: const EdgeInsets.symmetric(vertical: 1),
          color: ics.color.withAlpha(220),
          child: Padding(
              padding: const EdgeInsets.all(8), child: Text(ics.title, style: const TextStyle(color: Colors.white))),
        );
      },
    );
  }
}

/// Asks for `.ics` text and returns it, or null when cancelled.
class ImportDialog extends StatefulWidget {
  const ImportDialog({super.key});

  @override
  State<ImportDialog> createState() => _ImportDialogState();
}

class _ImportDialogState extends State<ImportDialog> {
  final _text = TextEditingController();

  @override
  void dispose() {
    _text.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Import .ics'),
      content: SizedBox(
        width: 480,
        child: TextField(
          controller: _text,
          maxLines: 12,
          decoration:
              const InputDecoration(hintText: 'Paste the contents of an .ics file', border: OutlineInputBorder()),
        ),
      ),
      actions: [
        TextButton(onPressed: () => Navigator.of(context).pop(), child: const Text('Cancel')),
        TextButton(onPressed: () => Navigator.of(context).pop(_text.text), child: const Text('Import')),
      ],
    );
  }
}

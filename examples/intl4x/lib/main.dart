// This file is part of kalender.
//
// SPDX-FileCopyrightText: 2023 Klarälvdalens Datakonsult AB, a KDAB Group company <info@kdab.com>
//
// SPDX-License-Identifier: MIT

import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl4x/datetime_format.dart' as intl4x;
import 'package:intl4x/number_format.dart' as intl4x show NumberFormat;
import 'package:kalender/kalender.dart';

/// Renders a calendar whose day and month names and overflow count come from
/// intl4x. See [intl4xComponents] and [intl4xTheme].
void main() => runApp(const IntlFourXApp());

/// The locales offered by the picker.
const _locales = [Locale('en'), Locale('de'), Locale('fr'), Locale('pt', 'BR'), Locale('ja')];

/// Reads the calendar's locale and hands intl4x its own type. `toLanguageTag`
/// gives the `pt-BR` form intl4x parses, where `toString` gives `pt_BR`.
intl4x.Locale _localeOf(BuildContext context) {
  final kalenderLocale = context.kalenderLocale;
  return intl4x.Locale.parse(kalenderLocale?.toLanguageTag() ?? 'en');
}

/// intl4x has no weekday-only formatter. `DateTimeFormat.yearMonthDayWeekday`
/// is the only route to a weekday and it returns the whole date, so the day
/// names come from Flutter's own localizations instead.
String _weekday(BuildContext context, DateTime date) {
  final narrow = MaterialLocalizations.of(context).narrowWeekdays;
  return narrow[date.weekday % DateTime.daysPerWeek];
}

String _month(BuildContext context, DateTime date) {
  // The default length is short, which formats the month as a number.
  return intl4x.DateTimeFormat.month(
    locale: _localeOf(context),
    length: intl4x.DateTimeLength.long,
  ).format(date);
}

/// The builders of [KalenderComponents] that kalender would otherwise answer
/// with intl.
KalenderComponents intl4xComponents() {
  return KalenderComponents(
    overlayBuilders: OverlayBuilders(
      multiDayPortalOverlayButtonStringBuilder: (context, hidden) {
        return '+${intl4x.NumberFormat(locale: _localeOf(context)).format(hidden)}';
      },
    ),
    multiDayComponents: const MultiDayComponents(
      headerComponents: MultiDayHeaderComponents(dayHeaderStringBuilder: _weekday),
    ),
    monthComponents: const MonthComponents(
      headerComponents: MonthHeaderComponents(weekDayHeaderStringBuilder: _weekday),
    ),
    scheduleComponents: ScheduleComponents(
      leadingDateStringBuilder: _weekday,
      monthItemBuilder: (context, monthRange) => ListTile(title: Text(_month(context, monthRange.start))),
    ),
  );
}

/// The day names of the multi-day overlay, which the theme holds.
KalenderThemeData intl4xTheme(BuildContext context) {
  return KalenderThemeData(
    multiDayOverlayStyle: MultiDayOverlayStyle(dayNameBuilder: (date) => _weekday(context, date)),
  );
}

class IntlFourXApp extends StatefulWidget {
  const IntlFourXApp({super.key});

  @override
  State<IntlFourXApp> createState() => _IntlFourXAppState();
}

class _IntlFourXAppState extends State<IntlFourXApp> {
  static final _displayRange = KalenderDateTimeRange(
    start: DateTime.now().subtract(const Duration(days: 180)),
    end: DateTime.now().add(const Duration(days: 180)),
  );
  final _viewConfigurations = [
    MultiDayViewConfiguration.week(displayRange: _displayRange),
    MonthViewConfiguration.singleMonth(displayRange: _displayRange),
    ScheduleViewConfiguration.continuous(displayRange: _displayRange),
  ];
  final _eventsController = DefaultEventsController();
  late final _calendarController = KalenderController(viewConfiguration: _viewConfigurations.first);
  var _locale = _locales.first;

  @override
  void initState() {
    super.initState();
    final today = DateTime.now();
    _eventsController.addEvents([
      KalenderEvent(
        start: DateTime(today.year, today.month, today.day, 9),
        end: DateTime(today.year, today.month, today.day, 11),
      ),
    ]);
  }

  @override
  void dispose() {
    _eventsController.dispose();
    _calendarController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final tiles = TileComponents(
      tileBuilder: (context, event, tileRange) => Card(
        margin: EdgeInsets.zero,
        color: Theme.of(context).colorScheme.primaryContainer,
        child: const SizedBox.expand(),
      ),
    );
    final scheduleTiles = ScheduleTileComponents(
      tileBuilder: (context, event, tileRange) => Card(
        color: Theme.of(context).colorScheme.primaryContainer,
        child: const SizedBox(height: 24),
      ),
    );

    return MaterialApp(
      title: 'kalender with intl4x',
      locale: _locale,
      supportedLocales: _locales,
      localizationsDelegates: GlobalMaterialLocalizations.delegates,
      theme: ThemeData(colorSchemeSeed: Colors.teal, useMaterial3: true),
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Localized by intl4x'),
          actions: [
            ListenableBuilder(
              listenable: _calendarController,
              builder: (context, _) => DropdownButton<ViewConfiguration>(
                value: _calendarController.viewConfiguration,
                onChanged: (value) => _calendarController.viewConfiguration = value!,
                items: [
                  for (final view in _viewConfigurations) DropdownMenuItem(value: view, child: Text(view.name)),
                ],
              ),
            ),
            const SizedBox(width: 16),
            DropdownButton<Locale>(
              value: _locale,
              onChanged: (value) => setState(() => _locale = value!),
              items: [
                for (final locale in _locales) DropdownMenuItem(value: locale, child: Text(locale.toLanguageTag())),
              ],
            ),
            const SizedBox(width: 16),
          ],
        ),
        body: Builder(
          builder: (context) => KalenderTheme(
            data: intl4xTheme(context),
            child: KalenderView(
              eventsController: _eventsController,
              kalenderController: _calendarController,
              locale: _locale,
              components: intl4xComponents(),
              views: [
                MultiDayViewParts(
                  header: MultiDayHeader(tileComponents: tiles),
                  body: MultiDayBody(tileComponents: tiles),
                ),
                MonthViewParts(header: const MonthHeader(), body: MonthBody(tileComponents: tiles)),
                ScheduleViewParts(body: ScheduleBody(tileComponents: scheduleTiles)),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

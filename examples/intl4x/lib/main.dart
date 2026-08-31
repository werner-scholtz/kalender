import 'package:flutter/material.dart';
import 'package:intl4x/datetime_format.dart' as intl4x;
import 'package:intl4x/number_format.dart' as intl4x show NumberFormat;
import 'package:kalender/kalender.dart';

/// Renders a calendar whose every localized string comes from intl4x.
///
/// Kalender formats day names, month names and the overflow count with intl.
/// Each of those has a builder, so supplying all six replaces intl at runtime
/// without the package knowing. See [intl4xComponents].
void main() => runApp(const IntlFourXApp());

/// The locales offered by the picker.
const _locales = [Locale('en'), Locale('de'), Locale('fr'), Locale('pt', 'BR'), Locale('ja')];

/// Reads the calendar's locale and hands intl4x its own type. `toLanguageTag`
/// gives the `pt-BR` form intl4x parses, where `toString` gives `pt_BR`.
intl4x.Locale _localeOf(BuildContext context) {
  final calendarLocale = context.calendarLocale;
  return intl4x.Locale.parse(calendarLocale?.toLanguageTag() ?? 'en');
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

/// Every builder kalender would otherwise answer with intl.
CalendarComponents intl4xComponents() {
  return CalendarComponents(
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

class IntlFourXApp extends StatefulWidget {
  const IntlFourXApp({super.key});

  @override
  State<IntlFourXApp> createState() => _IntlFourXAppState();
}

class _IntlFourXAppState extends State<IntlFourXApp> {
  final _eventsController = DefaultEventsController();
  final _calendarController = CalendarController();
  var _locale = _locales.first;

  @override
  void initState() {
    super.initState();
    final today = DateTime.now();
    _eventsController.addEvents([
      CalendarEvent(
        dateTimeRange: DateTimeRange(
          start: DateTime(today.year, today.month, today.day, 9),
          end: DateTime(today.year, today.month, today.day, 11),
        ),
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

    return MaterialApp(
      title: 'kalender with intl4x',
      locale: _locale,
      supportedLocales: _locales,
      theme: ThemeData(colorSchemeSeed: Colors.teal, useMaterial3: true),
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Localized by intl4x'),
          actions: [
            DropdownButton<Locale>(
              value: _locale,
              onChanged: (value) => setState(() => _locale = value!),
              items: [
                for (final locale in _locales)
                  DropdownMenuItem(value: locale, child: Text(locale.toLanguageTag())),
              ],
            ),
            const SizedBox(width: 16),
          ],
        ),
        body: KalenderView(
          eventsController: _eventsController,
          calendarController: _calendarController,
          locale: _locale,
          components: intl4xComponents(),
          viewConfiguration: MultiDayViewConfiguration.week(
            displayRange: DateTimeRange(
              start: DateTime.now().subtract(const Duration(days: 180)),
              end: DateTime.now().add(const Duration(days: 180)),
            ),
          ),
          header: CalendarHeader(multiDayTileComponents: tiles),
          body: CalendarBody(multiDayTileComponents: tiles),
        ),
      ),
    );
  }
}

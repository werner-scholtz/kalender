# ICS example

Import and export iCalendar (`.ics`) files with `kalender`, including recurring
events.

## What it shows

- **Parse.** A bundled `assets/sample.ics` is parsed with
  [`enough_icalendar`](https://pub.dev/packages/enough_icalendar). Each `VEVENT`
  becomes an `IcsSource` (`lib/ics_calendar.dart`).
- **Expand recurrence lazily.** `enough_icalendar` reads the `RRULE` but does not
  compute the individual occurrences, so the rule is handed to
  [`rrule`](https://pub.dev/packages/rrule), which expands it. Instances are
  produced only for the calendar's visible window, so a "repeat forever" rule stays
  cheap. The window is refreshed as you navigate.
- **Display.** Each occurrence becomes an `IcsEvent` (a `CalendarEvent` subclass
  carrying the title, description, color, and source `uid`).
- **Export.** The master events are serialized back to `.ics` text with
  `enough_icalendar`, recurrence rules included, and shown in a dialog.

## Notes

- The two libraries split the work: `enough_icalendar` parses and generates the
  file, `rrule` expands the rule. Neither expands recurrence on its own.
- Times in the sample are floating (no time zone), handled as local wall-clock.
  Real `.ics` files carry a `TZID`; mapping those correctly means building
  `TZDateTime`s with the `timezone` package before handing them to `kalender`.
- Export writes the master events (with their rules), not the expanded instances,
  so the recurrence survives a round trip.

Run it from this directory:

```sh
flutter run
```

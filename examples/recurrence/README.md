# Recurrence

Recurring events built on top of `kalender`. The package has no recurrence of its
own, so this example shows one way to add it in the app.

## How it works

- A `Recurrence` describes the rule (type, first occurrence, count). This example
  keeps it deliberately small: `none`, `daily`, and `weekly`.
- Each rule is expanded into concrete `RecurringCalendarEvent`s, which are added to
  the events controller. Every generated event shares a `groupId`, so editing or
  deleting one can fan out to the whole group.
- `RecurrenceController` (`lib/recurrence.dart`) holds the groups and keeps the
  events controller in sync when a recurrence is created, edited, or removed.

Because occurrences are generated up front, this suits a small, bounded number of
repeats. For open-ended rules from the iCalendar standard (`RRULE`, "every 2nd
Tuesday", "repeat forever") see the `ics` example, which expands the rule lazily
over the visible range instead.

Run it from this directory:

```sh
flutter run
```

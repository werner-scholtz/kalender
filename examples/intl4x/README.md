# intl4x

Renders the calendar's localized strings with [intl4x](https://pub.dev/packages/intl4x) instead of
intl.

Kalender formats day names, month names and the overflow count with intl, and each of those has a
builder. Supplying all of them replaces intl at runtime without the package knowing. `lib/main.dart`
holds the six in `intl4xComponents`.

`test/intl4x_replaces_intl_test.dart` calls no `initializeDateFormatting`, so the default builders
throw for `de` and the intl4x builders render it.

## What intl4x does not cover

**Weekday names.** There is no weekday-only formatter. `DateTimeFormat.yearMonthDayWeekday` returns
the whole date, `Mon, 1/6/25`, and `DisplayNames` covers languages, regions, scripts and currencies
only. The day headers here use `MaterialLocalizations.narrowWeekdays` instead.

**Month names default to numbers.** `DateTimeFormat.month` defaults to `DateTimeLength.short`, which
formats January as `1`. `DateTimeLength.long` gives `January`.

## Testing

intl4x returns a placeholder instead of formatting when it detects a test, unless the zone opts in:

```dart
runZoned(body, zoneValues: {#test.allowFormatting: true});
```

See `isInTest` in intl4x's `src/test_checker.dart`.

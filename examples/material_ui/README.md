# material_ui example

Runs the calendar inside an app that has migrated to the standalone
[`material_ui`](https://pub.dev/packages/material_ui) package, which replaced
`package:flutter/material.dart` in Flutter 3.47.

The package still imports `package:flutter/material.dart`. Those are two
separate sets of classes with the same names, so an app on `material_ui` hits
three problems. This example shows each one and what to do about it. The first
two are fixed in the package, the third is not.

## 1. The timeline used to throw at runtime

Fixed. `TimeOfDay.format` resolved `MaterialLocalizations`, which a `material_ui`
`MaterialApp` does not install, so the calendar threw:

```
No MaterialLocalizations found.
```

The calendar now formats its hour labels with `intl` against the locale it was
given whenever those localizations are absent, so this needs nothing from you.
An app that does install them keeps the labels it had.

`MaterialUiCompatibilityBridge` is still worth having for the theme, see 3 below,
but the calendar renders without it.

## 2. `DateTimeRange` and `TimeOfDay` do not compile

Fixed. Both are Material classes, so `material_ui` defines its own copies, and
the calendar's API asked for the ones in `package:flutter/material.dart`:

```
The argument type 'TimeOfDay (where TimeOfDay is defined in material_ui-1.1.0/lib/src/time.dart)'
can't be assigned to the parameter type 'TimeOfDay (where TimeOfDay is defined in
flutter/lib/src/material/time.dart)'.
```

The calendar now uses `KalenderDateTimeRange` and `KalenderTime`, so neither value
type names a Material class and nothing here needs a prefix import. Theming is a
separate matter, covered in section 3.

`package:kalender/material.dart` is not the conversion for an app on `material_ui`.
Its extensions are on the types in `package:flutter/material.dart`, which are
different types from `material_ui`'s, and importing it would pull Material back into
this app. Build the kalender value directly from what `material_ui` hands you:

```dart
final picked = await showDateRangePicker(context: context, firstDate: first, lastDate: last);
final range = picked == null ? null : KalenderDateTimeRange(start: picked.start, end: picked.end);

final time = await showTimePicker(context: context, initialTime: initial);
final start = time == null ? null : KalenderTime(hour: time.hour, minute: time.minute);
```

Wrap those in extensions of your own if you cross the boundary often.

## 3. `KalenderThemeData` cannot be a theme extension

`ThemeExtension` is a Material class too, so a `material_ui` `ThemeData` will
not accept one:

```
The element type 'KalenderThemeData' can't be assigned to the list type 'ThemeExtension<dynamic>'
```

The bridge builds a fresh legacy `ThemeData` and does not carry extensions
across, so there is no workaround through it. Use the `KalenderTheme` widget
above the calendar instead. The Material 3 defaults still resolve, because the
bridge maps the color scheme and text theme.

## Running

This example is pinned to Flutter 3.47.2 in `.fvmrc`:

```sh
fvm use
fvm flutter run
```

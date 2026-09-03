# material_ui example

Runs the calendar inside an app that has migrated to the standalone
[`material_ui`](https://pub.dev/packages/material_ui) package, which replaced
`package:flutter/material.dart` in Flutter 3.47.

The package still imports `package:flutter/material.dart`. Those are two
separate sets of classes with the same names, so an app on `material_ui` hits
three problems. This example shows each one and what to do about it. The first
is fixed in the package, the other two are not.

## 1. The timeline used to throw at runtime

Fixed. `KalenderTime.format` resolved `MaterialLocalizations`, which a `material_ui`
`MaterialApp` does not install, so the calendar threw:

```
No MaterialLocalizations found.
```

The calendar now formats its hour labels with `intl` against the locale it was
given whenever those localizations are absent, so this needs nothing from you.
An app that does install them keeps the labels it had.

`MaterialUiCompatibilityBridge` is still worth having for the theme, see 3 below,
but the calendar renders without it.

## 2. `DateTimeRange` and `KalenderTime` do not compile

Both are Material classes, so `material_ui` defines its own copies:

```
The argument type 'KalenderTime (where KalenderTime is defined in material_ui-1.1.0/lib/src/time.dart)'
can't be assigned to the parameter type 'KalenderTime (where KalenderTime is defined in
flutter/lib/src/material/time.dart)'.
```

The bridge does not help here, it only works at runtime. Import
`package:flutter/material.dart` under a prefix and use those types wherever the
calendar's API asks for them.

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

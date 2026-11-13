# material_ui example

Runs the calendar in an app built on the standalone
[`material_ui`](https://pub.dev/packages/material_ui) package, which replaces
`package:flutter/material.dart` from Flutter 3.47 on. kalender is built on
`material_ui` itself, so the two share one set of Material classes and no
`MaterialUiCompatibilityBridge` is needed.

## Theming

The calendar reads the app's `material_ui` `Theme`, and `KalenderThemeData` is a
`material_ui` `ThemeExtension`, so it registers on the app's `ThemeData`:

```dart
MaterialApp(
  theme: ThemeData(
    colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue),
    extensions: const [KalenderThemeData(timeIndicatorStyle: TimeIndicatorStyle(lineColor: Color(0xFFE91E63)))],
  ),
);
```

## Dates and times

`package:kalender/material.dart` converts between the `material_ui`
`DateTimeRange` and `TimeOfDay` and kalender's `KalenderDateTimeRange` and
`KalenderTime`.

## Running

Run it on the Flutter version in the repository's `.fvmrc`:

```sh
fvm use
fvm flutter run
```

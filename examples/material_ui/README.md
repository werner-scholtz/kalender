# material_ui example

Runs the calendar inside an app that has migrated to the standalone
[`material_ui`](https://pub.dev/packages/material_ui) package, which replaced
`package:flutter/material.dart` in Flutter 3.47.

The package still imports `package:flutter/material.dart`. Those are two
separate sets of classes with the same names. The calendar renders without
`MaterialUiCompatibilityBridge`. On `material_ui`, it formats its hour labels
with `intl` and the calendar's locale. Theming needs a workaround.

## Dates and times

The calendar takes `KalenderDateTimeRange` and `KalenderTime`, which are not
Material classes. `package:kalender/material.dart` converts
`package:flutter/material.dart` types only. Build the kalender value directly
from what `material_ui` hands you:

```dart
final picked = await showDateRangePicker(context: context, firstDate: first, lastDate: last);
final range = picked == null ? null : KalenderDateTimeRange(start: picked.start, end: picked.end);

final time = await showTimePicker(context: context, initialTime: initial);
final start = time == null ? null : KalenderTime(hour: time.hour, minute: time.minute);
```

Wrap those in extensions of your own if you cross the boundary often.

## `KalenderThemeData` cannot be a theme extension

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

Run it on the Flutter version in the repository's `.fvmrc`:

```sh
fvm use
fvm flutter run
```

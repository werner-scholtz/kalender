# Migration Guide

## v0.15.x → v0.16.0

### `CalendarEvent` is no longer generic

**Before:**
```dart
CalendarEvent<MyData>(dateTimeRange: range, data: MyData(...))
```

**After** — extend `CalendarEvent` instead:
```dart
class MyEvent extends CalendarEvent {
  final MyData data;

  MyEvent({required super.dateTimeRange, required this.data});

  @override
  MyEvent copyWith({DateTimeRange? dateTimeRange, EventInteraction? interaction, MyData? data}) =>
      MyEvent(
        dateTimeRange: dateTimeRange ?? this.dateTimeRange,
        interaction: interaction ?? this.interaction,
        data: data ?? this.data,
      )..id = id;
}
```

### Event IDs are now `String`

**Before:**
```dart
int id = eventsController.addEvent(event);
CalendarEvent? found = eventsController.byId(42);
```

**After:**
```dart
String id = eventsController.addEvent(event);
CalendarEvent? found = eventsController.byId('some-id');
```

### Renamed symbols

| Old name | New name |
|---|---|
| `MultiDayOverlayEventTile` | `MultiDayEventOverlayTile` |

### Moved imports

`EventsController` and related files moved into the `controllers` folder. Package-relative imports need updating. The top-level `package:kalender/kalender.dart` barrel export is unaffected.

### `DefaultEventsController` direct export

`DefaultEventsController` is now exported directly from `package:kalender/kalender.dart`. No changes needed if you already import from there.

### `DayEventTileUtils` / `MultiDayEventTileUtils` no longer generic

The mixins no longer carry a type parameter. Remove `<T>` from the mixin application and the `event` / `tileRange` field declarations.

**Before:**
```dart
class MyTile extends StatelessWidget with DayEventTileUtils<MyData> {
  @override final CalendarEvent<MyData> event;
  @override final DateTimeRange tileRange;
```

**After:**
```dart
class MyTile extends StatelessWidget with DayEventTileUtils {
  @override final CalendarEvent event;
  @override final InternalDateTimeRange tileRange;
```

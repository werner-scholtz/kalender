# Migration Guide

## v0.16.x → v0.17.0

### Input mode replaces platform-based mobile/desktop split

Resize handle behavior is now driven by **input precision** (`InputMode`) instead of platform detection (`isMobileDevice`). This affects how resize handles are positioned and when they become visible.

**New `InputMode` enum:**

| Value | Meaning |
|-------|---------|
| `auto` (default) | Detect dynamically — hover indicates precise input, selection indicates imprecise |
| `precise` | Mouse, stylus, trackpad — full-width handles, shown on hover |
| `imprecise` | Touch/finger — corner handles, shown on selection |

**`CalendarInteraction` has two new fields:**
```dart
CalendarInteraction(
  inputMode: InputMode.auto,                  // NEW — default is auto
  allowHorizontalImpreciseResize: false,      // NEW — opt-in for horizontal touch resize
)
```

### `ResizeHandlePositioner` typedef has a new `isImprecise` parameter

If you provide a custom `resizeHandlePositioner` in `TileComponents`, update it to accept the new parameter:

**Before:**
```dart
TileComponents(
  resizeHandlePositioner: (event, interaction, components, range, size, axis) {
    return MyCustomResizeHandles(...);
  },
)
```

**After:**
```dart
TileComponents(
  resizeHandlePositioner: (event, interaction, components, range, size, axis, isImprecise) {
    return MyCustomResizeHandles(..., isImprecise: isImprecise);
  },
)
```

### `ResizeHandles` abstract class requires `isImprecise`

If you extend `ResizeHandles`, add `isImprecise` to your constructor:

**Before:**
```dart
class MyResizeHandles extends ResizeHandles {
  const MyResizeHandles({
    required super.event,
    required super.axis,
    required super.interaction,
    required super.tileComponents,
    required super.dateTimeRange,
    required super.size,
  });
}
```

**After:**
```dart
class MyResizeHandles extends ResizeHandles {
  const MyResizeHandles({
    required super.event,
    required super.axis,
    required super.interaction,
    required super.tileComponents,
    required super.dateTimeRange,
    required super.size,
    required super.isImprecise,
  });
}
```

---

## v0.15.x → v0.16.0

### `CalendarEvent` is no longer generic

**Before:**
```dart
CalendarEvent<MyData>(dateTimeRange: range, data: MyData(...))
```

**After** — extend `CalendarEvent` instead:
```dart
class MyEvent extends CalendarEvent {
  final String title;
  final Color? color;

  MyEvent({
    required super.dateTimeRange,
    required this.title,
    this.color,
    super.interaction,
  });

  @override
  MyEvent copyWith({
    DateTimeRange? dateTimeRange,
    EventInteraction? interaction,
    String? title,
    Color? color,
  }) {
    final updated = MyEvent(
      dateTimeRange: dateTimeRange ?? this.dateTimeRange,
      interaction: interaction ?? this.interaction,
      title: title ?? this.title,
      color: color ?? this.color,
    );
    // Always carry the existing ID over to the new instance.
    updated.id = id;
    return updated;
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return super == other &&
        other is MyEvent &&
        other.title == title &&
        other.color == color;
  }

  @override
  int get hashCode => Object.hash(super.hashCode, title, color);
}
```

> [!IMPORTANT]
> You **must** override `==` and `hashCode` to include your custom fields. The base `CalendarEvent` equality only compares `id`, `dateTimeRange`, and `interaction`. Without the override, calls like `eventsController.updateEvent(event: original, updatedEvent: updated)` will not cause tile rebuilds when only custom fields (title, color, etc.) change.

#### `layoutEquals`

`layoutEquals` is used internally to skip expensive layout recalculations. The default implementation compares `id`, `dateTimeRange`, and `interaction` — which is correct for most subclasses. Only override it if a custom property changes the **size or position** of the tile (e.g. a flag that makes a tile render taller). Do **not** override it for content-only changes like color or title.

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

IDs are auto-generated (10-character alphanumeric) when not provided.

### Renamed symbols

| Old name | New name |
|---|---|
| `MultiDayOverlayEventTile` | `MultiDayEventOverlayTile` |

### Extensions moved to `InternalDateTime` / `InternalDateTimeRange`

Most date/time extensions that were previously on `DateTime` and `DateTimeRange` have moved to `InternalDateTime` and `InternalDateTimeRange` for DST-safe arithmetic. `DateTime` retains only the locale-aware formatting extensions (`dayNameLocalized`, `monthNameLocalized`, etc.).

| Previously on `DateTime` | Now on `InternalDateTime` |
|---|---|
| `startOfDay` / `endOfDay` / `dayRange` | `InternalDateTime.startOfDay` / `.endOfDay` / `.dayRange` |
| `startOfMonth` / `endOfMonth` / `monthRange` | `InternalDateTime.startOfMonth` / `.endOfMonth` / `.monthRange` |
| `startOfYear` / `endOfYear` / `yearRange` | `InternalDateTime.startOfYear` / `.endOfYear` / `.yearRange` |
| `startOfWeek()` / `endOfWeek()` / `weekRange()` | `InternalDateTime.startOfWeek()` / `.endOfWeek()` / `.weekRange()` |
| `isSameDay()` | `InternalDateTime.isSameDay()` |

Range operations like `dates()`, `overlaps()`, and `dateTimeRangeOnDate()` are now on `InternalDateTimeRange`.

Use `InternalDateTime.fromExternal(dateTime)` and `InternalDateTimeRange.fromDateTimeRange(range)` to convert from the standard types when needed.

### `DayEventTileUtils` / `MultiDayEventTileUtils` no longer generic

The mixins no longer carry a type parameter. Remove `<T>` from the mixin application and update the `tileRange` field type from `DateTimeRange` to `InternalDateTimeRange`.

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

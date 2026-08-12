# Events

This is part of the [kalender](README.md) documentation.

The event model, and how to attach your own data to it. For where tiles are placed
on screen, see [Layout](layout.md). For what they look like, see
[Appearance](appearance.md).

## Custom Events

Since v0.16.0, `CalendarEvent` is no longer generic. The idiomatic way to attach custom data (title, color, description, etc.) is to **extend** `CalendarEvent` directly.

<!-- snippet: file -->
```dart
class Event extends CalendarEvent {
  final String title;
  final String? description;
  final Color? color;

  Event({
    super.id,
    required super.dateTimeRange,
    required this.title,
    this.description,
    this.color,
    super.interaction,
    super.multiDayRule,
  });

  // Rebuilds the fields this class adds. The calendar calls this on every drag
  // and resize, then restores id, interaction and multiDayRule itself, so none
  // of those are listed here.
  @override
  Event copyWithData({required DateTimeRange dateTimeRange}) {
    return Event(dateTimeRange: dateTimeRange, title: title, description: description, color: color);
  }

  // A copy method of your own. It is not an override, so it takes whatever
  // parameters suit you. carryOver keeps the copy's identity and rule.
  Event copyWith({DateTimeRange? dateTimeRange, String? title, String? description, Color? color}) {
    return carryOver(
      Event(
        dateTimeRange: dateTimeRange ?? this.dateTimeRange,
        title: title ?? this.title,
        description: description ?? this.description,
        color: color ?? this.color,
      ),
    );
  }

  // Override == and hashCode so that the calendar can detect when an event's
  // custom fields have changed and update the tile accordingly.
  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return super == other &&
        other is Event &&
        other.title == title &&
        other.description == description &&
        other.color == color;
  }

  @override
  int get hashCode => Object.hash(super.hashCode, title, description, color);
}
```

> [!NOTE]
> If you don't override `==` and `hashCode`, the calendar cannot detect changes to your custom fields and tiles will not update when those values change (e.g. via `eventsController.updateEvent(...)`). Always override both whenever you add fields to your `CalendarEvent` subclass.

### Updating events

Use `eventsController.updateEvent()` to replace an existing event with an updated copy:

<!-- snippet: statements -->
```dart
final original = eventsController.byId(someId)! as Event;
final updated = original.copyWith(title: 'Updated Title', color: Colors.red);
eventsController.updateEvent(event: original, updatedEvent: updated);
```

Because `==` and `hashCode` include your custom fields, the calendar will detect the change and rebuild the tile.

### `layoutEquals`

Only override `layoutEquals` when a custom property changes the *size or position* of the tile, for example a flag that makes a tile render taller. It is **not** for content-only changes like color or title. The default implementation compares `id`, `dateTimeRange`, `interaction`, and `multiDayRule`, which is sufficient for most cases.

### Accessing custom fields in tile builders

Cast the event to your subclass. A convenience getter keeps the cast to one place:

<!-- snippet: expression -->
```dart
TileComponents(
  tileBuilder: (event, tileRange) {
    final myEvent = event as Event;
    return Container(
      color: myEvent.color ?? Colors.blue,
      child: Text(myEvent.title),
    );
  },
)
```

### Returning your subclass on event creation

Use `onEventCreate` to intercept the bare `CalendarEvent` created by a gesture and return a fully typed instance:

Pass this as `CalendarView.callbacks`:

<!-- snippet: expression -->
```dart
CalendarCallbacks(
  onEventCreate: (event) => Event(
    dateTimeRange: event.dateTimeRange,
    title: 'New Event',
    color: Colors.blue,
  ),
  onEventCreated: (event) => eventsController.addEvent(event),
)
```

---

## Multi-day events

A `MultiDayRule` decides whether an event renders in the multi-day header lane or in the day timeline. The rule is set on the view configuration (see [Shared options](views.md#shared-options)) and defaults to counting events of 24 hours or longer as multi-day.

A single event can override the calendar's rule:

<!-- snippet: expression -->
```dart
CalendarEvent(
  dateTimeRange: range,
  multiDayRule: const MultiDayRule.calendarDays(),
)
```

`CalendarEvent.multiDayRule` is null unless you set it, and null means the calendar's rule applies. You never forward it by hand: `copyWithData` rebuilds only the fields your subclass adds, and `CalendarEvent` reapplies the rule, the id and the interaction config afterwards. Accept `super.multiDayRule` in the constructor so an event can be given one.

`spansMultipleDays` returns whether an event counts as multi-day, applying the same rules the calendar does:

<!-- snippet: expression -->
```dart
event.spansMultipleDays(location: location, defaultRule: viewConfiguration.multiDayRule)
```

The event's own `multiDayRule` takes precedence when set. Otherwise `defaultRule` applies. Pass the calendar's location so that rules measuring calendar days, such as `MultiDayRule.calendarDays`, place midnight in the right timezone.

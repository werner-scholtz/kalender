# Events

This is part of the [kalender](../README.md) documentation.

## Custom Events

Since v0.16.0, `CalendarEvent` is no longer generic. The idiomatic way to attach custom data (title, color, description, etc.) is to **extend** `CalendarEvent` directly.

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
  });

  @override
  Event copyWith({
    DateTimeRange? dateTimeRange,
    EventInteraction? interaction,
    String? title,
    String? description,
    Color? color,
  }) {
    return Event(
      id: id,
      dateTimeRange: dateTimeRange ?? this.dateTimeRange,
      interaction: interaction ?? this.interaction,
      title: title ?? this.title,
      description: description ?? this.description,
      color: color ?? this.color,
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

```dart
tileBuilder: (event, tileRange) {
  final myEvent = event as Event;
  return Container(
    color: myEvent.color ?? Colors.blue,
    child: Text(myEvent.title),
  );
},
```

### Returning your subclass on event creation

Use `onEventCreate` to intercept the bare `CalendarEvent` created by a gesture and return a fully typed instance:

```dart
callbacks: CalendarCallbacks(
  onEventCreate: (event) => Event(
    dateTimeRange: event.dateTimeRange,
    title: 'New Event',
    color: Colors.blue,
  ),
  onEventCreated: (event) => eventsController.addEvent(event),
),
```

---

## Multi-day events

A `MultiDayRule` decides whether an event renders in the multi-day header lane or in the day timeline. The rule is set on the view configuration (see [Views & Interaction](views.md#views)) and defaults to counting events of 24 hours or longer as multi-day.

A single event can override the calendar's rule:

```dart
CalendarEvent(
  dateTimeRange: range,
  multiDayRule: const MultiDayRule.calendarDays(),
)
```

`CalendarEvent.multiDayRule` is null unless you set it, and null means the calendar's rule applies. It is carried through `copyWith` automatically, so a subclass override needs no extra parameter.

To ask the question yourself, use `spansMultipleDays`:

```dart
event.spansMultipleDays(location: location, defaultRule: viewConfiguration.multiDayRule)
```

---

## Event Layout

### Vertical layout (Day / MultiDay body)

The package uses [`CustomMultiChildLayout`](https://api.flutter.dev/flutter/widgets/CustomMultiChildLayout-class.html) with an [`EventLayoutDelegate`](https://github.com/werner-scholtz/kalender/blob/main/lib/src/layout_delegates/event_layout_delegate.dart) to position tiles.

Built-in strategies (pass via `MultiDayBodyConfiguration.eventLayoutStrategy`):

| Strategy                   | Behavior                                   |
| -------------------------- | ------------------------------------------ |
| `overlapLayoutStrategy`    | Tiles stack on top of each other (default) |
| `sideBySideLayoutStrategy` | Tiles placed side by side                  |

To create a custom strategy, subclass `EventLayoutDelegate`. See [`CustomSideBySideLayoutDelegate`](https://github.com/werner-scholtz/kalender/blob/main/examples/advanced_example/lib/layout_strategy.dart) in the advanced example.

Here's a minimal skeleton:

```dart
class MyLayoutDelegate extends EventLayoutDelegate {
  MyLayoutDelegate({
    required super.events,
    required super.heightPerMinute,
    required super.date,
    required super.location,
    required super.timeOfDayRange,
    required super.minimumTileHeight,
    required super.layoutCache,
  });

  @override
  List<CalendarEvent> sortEvents(Iterable<CalendarEvent> events) =>
      events.toList()..sort((a, b) => a.start.compareTo(b.start));

  @override
  List<VerticalLayoutData> sortVerticalLayoutData(
      List<VerticalLayoutData> layoutData) => layoutData;

  @override
  void performLayout(Size size) {
    final verticalLayoutData = calculateVerticalLayoutData(size);
    for (final data in verticalLayoutData) {
      // Events scrolled out of view are culled and have no child to lay out.
      if (!hasChild(data.id)) continue;
      layoutChild(data.id, BoxConstraints.tightFor(
        width: size.width,
        height: data.height,
      ));
      positionChild(data.id, Offset(0, data.top));
    }
  }
}
```

Then create your strategy function:

```dart
EventLayoutDelegate myLayoutStrategy(
  Iterable<CalendarEvent> events,
  InternalDateTime date,
  TimeOfDayRange timeOfDayRange,
  double heightPerMinute,
  double? minimumTileHeight,
  EventLayoutDelegateCache? cache,
  Location? location,
) {
  return MyLayoutDelegate(
    events: events,
    date: date,
    heightPerMinute: heightPerMinute,
    timeOfDayRange: timeOfDayRange,
    minimumTileHeight: minimumTileHeight,
    layoutCache: cache ?? EventLayoutDelegateCache(),
    location: location,
  );
}
```

### Horizontal layout (Month view / MultiDay header)

Events are placed in a grid of rows × columns (rows = concurrent events, columns = days). A **layout frame** (`MultiDayLayoutFrame`) generated by `defaultMultiDayFrameGenerator` determines each event's row and column span.

The default generator sorts events by duration then start date. Supply an `eventComparator` to change the order:

```dart
CalendarBody(
  monthBodyConfiguration: MonthBodyConfiguration(
    generateMultiDayLayoutFrame: ({
      required events,
      required textDirection,
      required visibleDateTimeRange,
      required location,
      cache,
    }) =>
        defaultMultiDayFrameGenerator(
          events: events,
          textDirection: textDirection,
          visibleDateTimeRange: visibleDateTimeRange,
          location: location,
          cache: cache,
          eventComparator: (a, b) => a.end.compareTo(b.end),
        ),
  ),
)
```

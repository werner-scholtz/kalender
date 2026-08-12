# Layout

This is part of the [kalender](README.md) documentation.

Where event tiles are placed and sized. This is advanced material. The built-in
strategies cover most apps, and you only need this to write your own.

For what a tile looks like once placed, see [Appearance](appearance.md).

---

## Vertical layout (Day / MultiDay body)

The package uses [`CustomMultiChildLayout`](https://api.flutter.dev/flutter/widgets/CustomMultiChildLayout-class.html) with an [`EventLayoutDelegate`](https://pub.dev/documentation/kalender/latest/kalender/EventLayoutDelegate-class.html) to position tiles.

Built-in strategies (pass via `MultiDayBodyConfiguration.eventLayoutStrategy`):

| Strategy                   | Behavior                                   |
| -------------------------- | ------------------------------------------ |
| `EventLayoutStrategy.overlap()`    | Tiles stack on top of each other (default) |
| `EventLayoutStrategy.sideBySide()` | Tiles placed side by side                  |

To create a custom strategy, subclass `EventLayoutDelegate`. See [`CustomSideBySideLayoutDelegate`](../examples/advanced_example/lib/layout_strategy.dart) in the advanced example.

Here's a minimal skeleton:

<!-- snippet: file -->
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

<!-- snippet: continues -->
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

## Horizontal layout (Month view / MultiDay header)

Events are placed in a grid of rows × columns (rows = concurrent events, columns = days). A `MultiDayLayoutStrategy` produces a **layout frame** (`MultiDayLayoutFrame`) that determines each event's row and column span.

`MultiDayLayoutStrategy.byDuration()`, the default, sorts events by duration then start date.

Write your own by extending `MultiDayLayoutStrategy`. Call `defaultMultiDayFrameGenerator` to keep the built-in row assignment and change only the order, by supplying an `eventComparator`.

Give the class value equality. This field takes part in the body configuration's
equality, and a strategy that compares unequal on every build clears the layout
frame cache and regenerates every row each time.

<!-- snippet: file -->
```dart
class FrameSortedByEnd extends MultiDayLayoutStrategy {
  const FrameSortedByEnd();

  @override
  MultiDayLayoutFrame generateFrame({
    required InternalDateTimeRange visibleDateTimeRange,
    required List<CalendarEvent> events,
    required TextDirection textDirection,
    required Location? location,
    required MultiDayLayoutFrameCache? cache,
  }) {
    return defaultMultiDayFrameGenerator(
      visibleDateTimeRange: visibleDateTimeRange,
      events: events,
      textDirection: textDirection,
      location: location,
      cache: cache,
      eventComparator: (a, b) => a.end.compareTo(b.end),
    );
  }

  @override
  bool operator ==(Object other) => other is FrameSortedByEnd;

  @override
  int get hashCode => (FrameSortedByEnd).hashCode;
}
```

<!-- snippet: continues -->
```dart
final monthBody = CalendarBody(
  monthBodyConfiguration: MonthBodyConfiguration(
    multiDayLayoutStrategy: const FrameSortedByEnd(),
  ),
);
```

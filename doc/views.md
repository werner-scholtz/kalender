# Views

This is part of the [kalender](README.md) documentation.

The view configuration decides which calendar you get and how it behaves when you
switch away from it. For what the user can do inside a view, see
[Interaction](interaction.md).

## Switching between views

Switch between views by passing a different `ViewConfiguration` to `CalendarView`. What carries over on a switch is controlled per dimension:

- **Date** (all views): `dateTransition`. Use `DateTransition.carryFocus` (default, follows your current date) or `DateTransition.restorePerView` (each view reopens its own last date, matched by `name`).
- **Scroll & zoom** (multi-day views): `scrollTransition` / `zoomTransition`. Use `preserve` (default), `reset`, or `restorePerView`.

For custom logic, provide a `dateResolver` / `scrollResolver` / `zoomResolver`. Each overrides the matching enum. `kCarryFocusDate(transition)` gives you the default carry-focus date to build on.

## Shared options

All configurations accept:
- `displayRange`: the total date range the calendar can navigate within (e.g. Jan 2024 to Dec 2025). Defaults to 1 January two years back through 1 January two years ahead.
- `initialDateTime`: the date to show on first render. Defaults to `DateTime.now()`.
- `multiDayRule`: what counts as a multi-day event and so renders in the multi-day header rather than the day timeline. Defaults to events lasting 24 hours or more (`MultiDayRule.minimumDuration`). `MultiDayRule.calendarDays()` instead counts anything that crosses midnight. A single event can override the rule, see [Multi-day events](events.md#multi-day-events).
- `name`: identifies the view. Each constructor sets one already (`'Day'`, `'Week'`, `'Work Week'`, `'Custom'`, `'Free Scroll'`, `'Month'`, `'Schedule'`). It is what `DateTransition.restorePerView` matches on, so two configurations that should restore separately need different names. It is also a ready-made label for a view switcher, see [Building the surrounding UI](controllers-and-callbacks.md#building-the-surrounding-ui).
- `nowCallback`: overrides how the calendar resolves "now", see [Now Callback](timezones-and-locales.md#now-callback).

<!-- snippet: expression -->
```dart
MultiDayViewConfiguration.week(
  displayRange: DateTimeRange(
    start: DateTime(2024, 1, 1),
    end: DateTime(2025, 12, 31),
  ),
  initialDateTime: DateTime(2024, 6, 15),
)
```

## MultiDay View
Displays one or more days with time on the vertical axis.

| Constructor                                             | Description                                    |
| -------------------------------------------------------- | ---------------------------------------------- |
| `MultiDayViewConfiguration.singleDay()`                  | Single day                                     |
| `MultiDayViewConfiguration.week()`                       | Full 7-day week                                |
| `MultiDayViewConfiguration.workWeek()`                   | Monday to Friday                               |
| `MultiDayViewConfiguration.custom(numberOfDays: n)`      | Custom number of days                          |
| `MultiDayViewConfiguration.freeScroll(numberOfDays: n)`  | Scrolls freely across days, without page snaps |

These views also control which hours exist, where the day opens vertically, and how tall an hour is:

- `timeOfDayRange`: the hours the body lays out. Defaults to `TimeOfDayRange.allDay()`, which is 00:00 to 23:59. Narrowing it makes the page shorter, so there is less to scroll through at the same zoom. Positions are measured from `start`, so an event falling outside the range is drawn outside the page and clipped. Narrow it only when events cannot fall outside it.
- `initialTimeOfDay`: the time at the top of the viewport on first render. Defaults to midnight, so set it to the hour your users actually start at or the calendar opens on empty overnight hours. The offset is measured from `timeOfDayRange.start`, so keep this value inside the range.
- `initialHeightPerMinute`: the starting zoom, in logical pixels per minute. Defaults to `0.7`, giving a 42 pixel hour. Change it later through the controller, see [Zoom](interaction.md#zoom).
- `firstDayOfWeek`: which day a week starts on, as `DateTime.monday` through `DateTime.sunday`. Defaults to `DateTime.monday`. Applies to `week`, `singleDay` and `custom`. `workWeek` and `freeScroll` fix it themselves.

<!-- snippet: expression -->
```dart
MultiDayViewConfiguration.week(
  // Working hours only. The timeline runs 08:00 to 18:00 and nothing else exists.
  timeOfDayRange: TimeOfDayRange(
    start: const TimeOfDay(hour: 8, minute: 0),
    end: const TimeOfDay(hour: 18, minute: 0),
  ),
  initialTimeOfDay: const TimeOfDay(hour: 8, minute: 0),
  initialHeightPerMinute: 0.7,
  firstDayOfWeek: DateTime.sunday,
)
```

## Month View
Shows an entire month at a glance, weeks as rows.

| Constructor                            | Description  |
| -------------------------------------- | ------------ |
| `MonthViewConfiguration.singleMonth()` | Single month |

Month view can be adjusted with `firstDayOfWeek` and `showWeekNumbers`:

<!-- snippet: expression -->
```dart
MonthViewConfiguration.singleMonth(
  initialDateTime: DateTime(2025, 1, 1),
  firstDayOfWeek: DateTime.monday,
  showWeekNumbers: true,
)
```

When `showWeekNumbers` is enabled, the month body adds a leading gutter with one week number per visible row while keeping the day grid at 7 columns.

## Schedule View
Presents events in a chronological scrollable list.

| Constructor                              | Description            |
| ---------------------------------------- | ---------------------- |
| `ScheduleViewConfiguration.continuous()` | Single continuous list |
| `ScheduleViewConfiguration.paginated()`  | Paginated by month     |

---

## Per-view configuration

`CalendarHeader` and `CalendarBody` accept view-specific configuration objects:

| View     | Header config class           | Body config class           |
| -------- | ----------------------------- | --------------------------- |
| MultiDay | `MultiDayHeaderConfiguration` | `MultiDayBodyConfiguration` |
| Month    | None                          | `MonthBodyConfiguration`    |
| Schedule | None                          | `ScheduleBodyConfiguration` |

Both also accept `interaction`. `CalendarBody` additionally accepts `snapping`, which the header has no equivalent of. Both are covered in [Interaction](interaction.md).

Each configuration class has defaults that suit most apps. The references below
spell every option out **at its default value**, so a block copied whole leaves
the calendar exactly as it was. Change only the lines you care about.

<details>
  <summary>MultiDayHeaderConfiguration</summary>

  <!-- snippet: expression -->
  ```dart
  CalendarHeader(
    multiDayHeaderConfiguration: MultiDayHeaderConfiguration(
      showTiles: true,
      allowSingleDayEvents: false,
      tileHeight: 24,
      eventPadding: EdgeInsets.only(left: 0, right: 4, bottom: 2),
      pageTriggerConfiguration: PageTriggerConfiguration(),
      // Null uses defaultMultiDayFrameGenerator, see Layout.
      generateMultiDayLayoutFrame: null,
      // Null means no cap on the rows of events shown per day.
      maximumNumberOfVerticalEvents: null,
    ),
  )
  ```
</details>

<details>
  <summary>MultiDayBodyConfiguration</summary>

  <!-- snippet: expression -->
  ```dart
  CalendarBody(
    multiDayBodyConfiguration: MultiDayBodyConfiguration(
      showMultiDayEvents: false,
      horizontalPadding: EdgeInsets.only(left: 0, right: 4),
      eventLayoutStrategy: overlapLayoutStrategy,
      pageTriggerConfiguration: PageTriggerConfiguration(),
      scrollTriggerConfiguration: ScrollTriggerConfiguration(),
      keepPagesAlive: false,
      // Null lets a tile be as short as its duration. Set a floor, e.g. 24, to
      // keep short events readable.
      minimumTileHeight: null,
      // Null uses the ambient physics. Set your own, e.g. BouncingScrollPhysics().
      scrollPhysics: null,
      pageScrollPhysics: null,
    ),
  )
  ```
</details>

<details>
  <summary>MonthBodyConfiguration</summary>

  <!-- snippet: expression -->
  ```dart
  CalendarBody(
    monthBodyConfiguration: MonthBodyConfiguration(
      tileHeight: 24,
      eventPadding: EdgeInsets.only(left: 0, right: 4, bottom: 2),
      pageTriggerConfiguration: PageTriggerConfiguration(),
      // Null uses defaultMultiDayFrameGenerator, see Layout.
      generateMultiDayLayoutFrame: null,
    ),
  )
  ```
</details>

<details>
  <summary>ScheduleBodyConfiguration</summary>

  <!-- snippet: expression -->
  ```dart
  CalendarBody(
    scheduleBodyConfiguration: ScheduleBodyConfiguration(
      emptyDay: EmptyDayBehavior.showOnlyToday,
      leadingWidth: 56,
      pageTriggerConfiguration: PageTriggerConfiguration(),
      scrollTriggerConfiguration: ScrollTriggerConfiguration(),
      // Null uses the ambient physics. Set your own, e.g. BouncingScrollPhysics().
      scrollPhysics: null,
      pageScrollPhysics: null,
    ),
  )
  ```
</details>

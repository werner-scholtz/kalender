# Views

This is part of the [kalender](README.md) documentation.

The view configuration decides which calendar you get and how it behaves when you
switch away from it. For what the user can do inside a view, see
[Interaction](interaction.md).

## Switching between views

Switch between views by setting a different `ViewConfiguration` on `KalenderController.viewConfiguration`. What carries over on a switch is controlled per dimension:

- **Date** (all views): `dateTransition`. Use `DateTransition.carryFocus` (default, follows your current date) or `DateTransition.restorePerView` (each view reopens its own last date, matched by `name`).
- **Scroll & zoom** (multi-day views): `scrollTransition` / `zoomTransition`. Use `preserve` (default), `reset`, or `restorePerView`.

For custom logic, provide a `dateResolver` / `scrollResolver` / `zoomResolver`. Each overrides the matching enum, and a null from `scrollResolver` or `zoomResolver` falls back to it. `kCarryFocusDate(transition)` gives you the default carry-focus date to build on.

`initialDateTime` is only used when the calendar is first built. To show a fixed date on a switch, return it from a `dateResolver`. The resolvers also run when the location changes, which `transition.locationChanged` reports.

## Shared options

All configurations accept:
- `displayRange`: the total date range the calendar can navigate within (e.g. Jan 2024 to Dec 2025). Defaults to 1 January two years back through 1 January two years ahead.
- `initialDateTime`: the date to show on first render. Defaults to `DateTime.now()`.
- `multiDayRule`: which events go in the multi-day header, see [Multi-day and all-day events](events.md#multi-day-and-all-day-events).
- `name`: what `DateTransition.restorePerView` matches on. Each named constructor sets one.
- `nowCallback`: overrides how the calendar resolves "now", see [Now Callback](timezones-and-locales.md#now-callback).

<!-- snippet: expression -->
```dart
MultiDayViewConfiguration.week(
  displayRange: KalenderDateTimeRange(
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
| `MultiDayViewConfiguration.week()`                       | A week, 7 days by default                      |
| `MultiDayViewConfiguration.workWeek()`                   | Monday to Friday, 5 days by default            |
| `MultiDayViewConfiguration.custom(numberOfDays: n)`      | Custom number of days                          |
| `MultiDayViewConfiguration.freeScroll(numberOfDays: n)`  | Scrolls freely across days, without page snaps |

These views also control which hours exist, where the day opens vertically, and how tall an hour is:

- `timeOfDayRange`: the hours the body lays out. Defaults to `KalenderTimeRange.allDay()`, which is 00:00 to 23:59. Narrowing it makes the page shorter. Events outside it are clipped. Narrow it only when events cannot fall outside it.
- `initialTimeOfDay`: the time at the top of the viewport on first render. Defaults to midnight. The offset is measured from `timeOfDayRange.start`, so keep this value inside the range.
- `initialHeightPerMinute`: the starting zoom, in logical pixels per minute. Defaults to `0.7`, giving a 42 pixel hour. Change it later through the controller, see [Zoom](interaction.md#zoom).
- `firstDayOfWeek`: which day a week starts on, as `DateTime.monday` through `DateTime.sunday`. Defaults to `DateTime.monday`. Applies to `week`, `singleDay` and `custom`. `workWeek` and `freeScroll` fix it themselves.
- `numberOfDays`: how many days a page shows. `week` and `workWeek` take 1 through 7 and drop days off the end of the page without changing the pagination, so `week(numberOfDays: 6)` shows Monday to Saturday and still turns a week at a time. `custom` and `freeScroll` require it and page by it, so they take any number. `singleDay` fixes it at 1.

<!-- snippet: expression -->
```dart
MultiDayViewConfiguration.week(
  // Working hours only. The timeline runs 08:00 to 18:00 and nothing else exists.
  timeOfDayRange: KalenderTimeRange(
    start: const KalenderTime(hour: 8, minute: 0),
    end: const KalenderTime(hour: 18, minute: 0),
  ),
  initialTimeOfDay: const KalenderTime(hour: 8, minute: 0),
  initialHeightPerMinute: 0.7,
  firstDayOfWeek: DateTime.sunday,
)
```

## Month View
Shows a whole month, weeks as rows.

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

`KalenderHeader` and `KalenderBody` accept view-specific configuration objects:

| View     | Header config class           | Body config class           |
| -------- | ----------------------------- | --------------------------- |
| MultiDay | `MultiDayHeaderConfiguration` | `MultiDayBodyConfiguration` |
| Month    | None                          | `MonthBodyConfiguration`    |
| Schedule | None                          | `ScheduleBodyConfiguration` |

Both also accept `interaction`. `KalenderBody` additionally accepts `snapping`, which the header has no equivalent of. Both are covered in [Interaction](interaction.md).

Every option below is shown at its default.

<details>
  <summary>MultiDayHeaderConfiguration</summary>

  <!-- snippet: expression -->
  ```dart
  KalenderHeader(
    multiDayHeaderConfiguration: MultiDayHeaderConfiguration(
      showTiles: true,
      allowSingleDayEvents: false,
      tileHeight: 24,
      eventPadding: EdgeInsets.only(left: 0, right: 4, bottom: 2),
      pageTriggerConfiguration: PageTriggerConfiguration(),
      // See Layout for writing your own.
      multiDayLayoutStrategy: const MultiDayLayoutStrategy.byDuration(),
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
  KalenderBody(
    multiDayBodyConfiguration: MultiDayBodyConfiguration(
      showMultiDayEvents: false,
      horizontalPadding: EdgeInsets.only(left: 0, right: 4),
      eventLayoutStrategy: const EventLayoutStrategy.overlap(),
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
  KalenderBody(
    monthBodyConfiguration: MonthBodyConfiguration(
      tileHeight: 24,
      eventPadding: EdgeInsets.only(left: 0, right: 4, bottom: 2),
      pageTriggerConfiguration: PageTriggerConfiguration(),
      // See Layout for writing your own.
      multiDayLayoutStrategy: const MultiDayLayoutStrategy.byDuration(),
    ),
  )
  ```
</details>

<details>
  <summary>ScheduleBodyConfiguration</summary>

  <!-- snippet: expression -->
  ```dart
  KalenderBody(
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

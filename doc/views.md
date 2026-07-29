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
- `displayRange`: the total date range the calendar can navigate within (e.g. Jan 2024 to Dec 2025). Defaults to two years either side of today.
- `initialDateTime`: the date to show on first render. Defaults to `DateTime.now()`.
- `multiDayRule`: what counts as a multi-day event and so renders in the multi-day header rather than the day timeline. Defaults to events lasting 24 hours or more (`MultiDayRule.minimumDuration`). `MultiDayRule.calendarDays()` instead counts anything that crosses midnight. A single event can override the rule, see [Multi-day events](events.md#multi-day-events).

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

## Month View
Shows an entire month at a glance, weeks as rows.

| Constructor                            | Description  |
| -------------------------------------- | ------------ |
| `MonthViewConfiguration.singleMonth()` | Single month |

Month view can be adjusted with `firstDayOfWeek` and `showWeekNumbers`:

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

Both also accept `interaction` and `snapping`, covered in [Interaction](interaction.md).

Each view has its own configuration class with sensible defaults. Expand the references below for the full set of options.

<details>
  <summary>MultiDayHeaderConfiguration</summary>

  ```dart
  CalendarHeader(
    multiDayHeaderConfiguration: MultiDayHeaderConfiguration(
      showTiles: true,
      allowSingleDayEvents: false,
      tileHeight: 24,
      generateMultiDayLayoutFrame: defaultMultiDayFrameGenerator,
      maximumNumberOfVerticalEvents: null,
      eventPadding: EdgeInsets.only(left: 0, right: 4, bottom: 2),
      pageTriggerConfiguration: PageTriggerConfiguration(),
    ),
  )
  ```
</details>

<details>
  <summary>MultiDayBodyConfiguration</summary>

  ```dart
  CalendarBody(
    multiDayBodyConfiguration: MultiDayBodyConfiguration(
      showMultiDayEvents: true,
      horizontalPadding: EdgeInsets.only(left: 0, right: 4),
      minimumTileHeight: 24.0,
      pageTriggerConfiguration: PageTriggerConfiguration(),
      scrollTriggerConfiguration: ScrollTriggerConfiguration(),
      eventLayoutStrategy: overlapLayoutStrategy,
      scrollPhysics: BouncingScrollPhysics(),
      pageScrollPhysics: BouncingScrollPhysics(),
      keepPagesAlive: false,
    ),
  )
  ```
</details>

<details>
  <summary>MonthBodyConfiguration</summary>

  ```dart
  CalendarBody(
    monthBodyConfiguration: MonthBodyConfiguration(
      tileHeight: 24,
      generateMultiDayLayoutFrame: defaultMultiDayFrameGenerator,
      eventPadding: EdgeInsets.only(left: 0, right: 4, bottom: 2),
      pageTriggerConfiguration: PageTriggerConfiguration(),
    ),
  )
  ```
</details>

<details>
  <summary>ScheduleBodyConfiguration</summary>

  ```dart
  CalendarBody(
    scheduleBodyConfiguration: ScheduleBodyConfiguration(
      emptyDay: EmptyDayBehavior.hide,
      leadingWidth: 56,
      pageTriggerConfiguration: PageTriggerConfiguration(),
      scrollTriggerConfiguration: ScrollTriggerConfiguration(),
      scrollPhysics: BouncingScrollPhysics(),
      pageScrollPhysics: BouncingScrollPhysics(),
    ),
  )
  ```
</details>

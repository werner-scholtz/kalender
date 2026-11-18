# Notes for coding agents

Read this before writing code that uses kalender. Each point links to the guide with the details.

## Check the version first

kalender is before 1.0, and minor releases rename and remove API. Read the version in the app's `pubspec.lock`, and check every class and member against that version's source in the pub cache or its API reference at `https://pub.dev/documentation/kalender/<version>/`. Do not write names from memory.

Names from older versions that no longer exist:

| Old | Now |
| --- | --- |
| `CalendarEvent<T>(data: ...)` | a subclass of `KalenderEvent` |
| `CalendarEvent(dateTimeRange: ...)` | `KalenderEvent(start: ..., end: ...)` |
| `copyWith` on the event | `copyWithData` in the subclass |
| `CalendarView`, `CalendarController`, `CalendarCallbacks`, `CalendarComponents` | `KalenderView`, `KalenderController`, `KalenderCallbacks`, `KalenderComponents` |
| `TimeOfDay`, `DateTimeRange` in the API | `KalenderTime`, `KalenderTimeRange`, `KalenderDateTimeRange` |
| `InternalDateTime`, `InternalDateTimeRange` | `FloatingDateTime`, `FloatingDateTimeRange` |
| `KalenderView(viewConfiguration:, header:, body:)` | `KalenderController(viewConfiguration:)` and `KalenderView(views: [...])` |
| `CalendarHeader`, `CalendarBody`, `KalenderHeader`, `KalenderBody` | `MultiDayHeader`, `MultiDayBody`, `MonthHeader`, `MonthBody` and `ScheduleBody`, in the `ViewParts` of `views` |

To upgrade the package in an app, follow [MIGRATION.md](../MIGRATION.md). Do not upgrade it as a side effect of another task.

## The app stores every change

The calendar never writes to the `EventsController`. A create, drag or resize only calls a callback. Without `onEventChanged`, a moved event goes back to where it was. See [Callbacks](controllers-and-callbacks.md#callbacks).

## Custom data is a subclass

There is no `data` field. Subclass `KalenderEvent` and override `copyWithData`, `==` and `hashCode`. The base class has no `copyWith`. See [Custom Events](events.md#custom-events).

## Event times are UTC

`event.start` and `event.end` are UTC instants. Read the time to show with `event.floatingStart(location: kalenderController.location)`, or with `KalenderScope.locationOf(context)` inside the calendar's widgets. A call that takes a `Location?` and gets none uses the device timezone, not the calendar's. See [Reading an event's time](timezones-and-locales.md#reading-an-events-time).

## Where each option goes

- `KalenderView`: `callbacks`, `interaction`, `components`, `locale` and `views`.
- The header and body widgets inside `views`: `tileComponents`, the per-view `configuration`, and a `callbacks` or `interaction` that overrides the view's. `MonthHeader` takes only `callbacks`. `snapping` goes on `MultiDayBody`.
- The schedule body takes `ScheduleTileComponents`, not `TileComponents`.

See [Headers and bodies](views.md#headers-and-bodies).

## What the app builds

- A toolbar, from the controller's navigation methods. See [Building the surrounding UI](controllers-and-callbacks.md#building-the-surrounding-ui).
- Zoom, by changing `heightPerMinute`. See [Zoom](interaction.md#zoom).
- Selection. The calendar never selects a day by itself. The app calls `selectDate` or `selectRange`, for example from `onTapped`.
- Recurring events. See [Recurring events](events.md#recurring-events).
- Storage, see above.

## Material types

`KalenderTime` and `KalenderDateTimeRange` are not Material's `TimeOfDay` and `DateTimeRange`. Convert the `material_ui` ones with `package:kalender/material.dart`. See [Material types](timezones-and-locales.md#material-types).

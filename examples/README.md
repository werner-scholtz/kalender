# Examples

Runnable apps built on [kalender](../README.md). Each is a standalone Flutter
project that depends on the package by path, so it always builds against the
working tree rather than the published version.

Start with [example](example), which shows the pieces most apps need. The rest
each answer one question.

| Example | Shows |
| --- | --- |
| [example](example) | All view types with a toolbar, sample events, custom tiles, and create, drag and resize. Start here. |
| [advanced_example](advanced_example) | A custom event layout with a lane per person, zoom on desktop and mobile, and creating an event pre-assigned to the lane that was tapped. |
| [recurrence](recurrence) | Recurring events built in the app, since the package has no recurrence of its own. Occurrences are generated up front, which suits a bounded number of repeats. |
| [ics](ics) | Importing and exporting iCalendar files. `enough_icalendar` parses and writes, `rrule` expands the rule, and occurrences are produced only for the visible window so a "repeat forever" rule stays cheap. |
| [riverpod](riverpod) | Sharing the events controller, the calendar controller and the selected view through providers. |
| [web_demo](web_demo) | The source behind the [live demo](https://werner-scholtz.github.io/kalender/). Every option through a runtime configuration panel, theming, locales, text direction, timezones, and a desktop split view over one shared event store. |
| [material_ui](material_ui) | The calendar inside an app that migrated to the standalone `material_ui` package. Shows the three things that break against `package:flutter/material.dart` and the workaround for each. |
| [testing](testing) | A performance harness rather than an app. Drives the calendar through navigation, scrolling, rescheduling and resizing at 10 and 50 events per day and records frame build times. Feeds the [benchmarks dashboard](https://werner-scholtz.github.io/kalender/dev/bench/). |
| [doc_snippets](doc_snippets) | Not an app either. Holds the placeholder identifiers that `tool/analyze_doc_snippets.dart` compiles the documentation snippets against. |

Run any of them from its own directory:

```sh
cd example
flutter run
```

Each has its own README with what it demonstrates and how to run it. The
`analyze_examples.yml` workflow analyzes and tests every one on changes to
`lib/` or `examples/`, which is what catches a breaking change before release,
since the root analyzer excludes this directory.

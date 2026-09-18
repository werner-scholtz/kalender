# Examples

Runnable apps built on [kalender](../README.md). Each is a standalone Flutter
project that depends on the package by path, so it always builds against the
working tree rather than the published version.

Start with [example](example), which shows the pieces most apps need. The rest
each answer one question.

| Example | Shows |
| --- | --- |
| [example](example) | All view types with a toolbar, custom tiles, and create, drag and resize. |
| [advanced_example](advanced_example) | A custom event layout with one lane per person. |
| [recurrence](recurrence) | Recurring events generated in the app. |
| [ics](ics) | Importing and exporting iCalendar files. |
| [riverpod](riverpod) | Sharing the controllers and the selected view through providers. |
| [intl4x](intl4x) | The calendar's localized strings rendered with intl4x instead of intl. |
| [web_demo](web_demo) | The source behind the [live demo](https://werner-scholtz.github.io/kalender/). |
| [material_ui](material_ui) | The calendar in an app built on the standalone `material_ui` package. |
| [testing](testing) | A performance harness that feeds the [benchmarks dashboard](https://werner-scholtz.github.io/kalender/dev/bench/). |
| [doc_snippets](doc_snippets) | Placeholders that `tool/analyze_doc_snippets.dart` compiles the documentation snippets against. |

Run any of them from its own directory:

```sh
cd example
flutter run
```

Each app has its own README. `analyze_examples.yml` analyzes and tests the
examples in CI.

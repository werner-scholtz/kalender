# web_demo – Local Guidelines

This file applies to work under `examples/web_demo/`. It supplements the repository-level `AGENTS.md` at the root; follow both, with this file taking precedence for demo-specific details.

## Overview

`web_demo` is a standalone Flutter app used to showcase the `kalender` package in a browser-targeted demo. It also adapts to touch platforms, so UI and interaction changes should be checked for both desktop and mobile layouts.

- Package name: `web_demo`
- Primary dependency under test: local path dependency on `kalender`
- Generated localization output: `lib/l10n/app_localizations.dart`
- Web deploy workflow: `.github/workflows/web_demo.yml`

## Working Directory

Run commands for this app from `examples/web_demo` unless you intentionally need the repository root.

```bash
flutter pub get
flutter analyze
flutter test
flutter run -d chrome
flutter build web --release --wasm --base-href /kalender/
```

## Architecture

### App bootstrap

- `lib/main.dart` initializes `intl` date formatting and the timezone package before calling `runApp`.
- `MyAppState` owns the app-wide `ThemeMode`, `TextDirection`, `Locale`, and a shared `DefaultEventsController` seeded with demo events.
- Desktop and mobile use different shells: `DesktopHomePage` supports a split view with two calendars, while `MobileHomePage` shows a single calendar.

### State ownership

- `lib/providers.dart` defines lightweight `InheritedWidget` providers for app settings and the shared `EventsController`.
- Each `Calendar` widget creates its own `CalendarScope`, which means each visible calendar instance gets its own `CalendarController`, `DemoConfiguration`, and timezone `Location` notifier.
- In desktop split view, both calendars share the same event store but do not share view/controller state unless you explicitly refactor them to do so.

### Demo configuration

- `lib/models/demo_configuration.dart` is the source of truth for selectable `ViewConfiguration`s, interaction settings, snapping, and visibility toggles.
- Prefer extending `DemoConfiguration` when exposing new demo knobs instead of hard-coding behavior directly inside widgets.
- `viewConfigurationNotifier` drives the active calendar mode; keep new view options aligned with the navigation/configuration UI.

### UI composition

- `lib/widgets/calendar/calendar.dart` is the main composition point for `CalendarView`, `CalendarHeader`, `CalendarBody`, overlay behavior, tile components, and the configuration panel.
- `lib/widgets/toolbar/` contains app-level controls such as theme, locale, text direction, warnings, and view type selection.
- `lib/widgets/configuration/` contains the editors for runtime calendar customization.
- `lib/widgets/calendar/` contains demo-specific calendar chrome and tile rendering; keep package internals in `kalender` and demo presentation concerns here.

### Models and demo data

- `lib/models/event.dart` defines the demo event type by extending `CalendarEvent` with presentation fields like title, description, and color.
- `lib/utils.dart` seeds a large synthetic event list for the demo. Treat it as showcase data, not production logic.

### Timezone and localization

- `lib/timezone/` uses conditional imports for browser, IO, and stub implementations. Preserve that split when changing timezone bootstrapping.
- User-facing strings belong in the ARB files under `lib/l10n/`.
- Keep `lib/locales.dart` synchronized with the available ARB files and supported locales exposed by the app.

## Change Guidance

- Prefer `package:web_demo/...` imports within this app.
- Preserve the current separation between app-wide state (`AppSettingsProvider`, `EventsControllerProvider`) and per-calendar state (`CalendarScope`).
- When changing interaction behavior, verify both pointer-first desktop flows and touch flows. `isTouch` affects toolbar sizing, gestures, and event interactions.
- When changing split-view behavior, remember that the two desktop calendars intentionally render independent configurations over the same underlying events.
- Keep demo-only visual customization in `web_demo`; push reusable widget or API improvements down into the main `kalender` package instead of duplicating logic here.

## Testing Expectations

- Run at least `flutter analyze` in `examples/web_demo` after changes.
- Run `flutter test` when touching startup, localization, toolbar behavior, or widget composition.
- The existing `test/widget.dart` file is boilerplate and does not reflect the current app. If your change affects app behavior, replace or update that test with assertions against real demo UI rather than preserving the counter example.

## Common Pitfalls

- Do not add strings only to `app_en.arb`; update all locale files or leave a deliberate TODO if the change is explicitly partial.
- Do not accidentally couple the two desktop calendars by reusing a single `CalendarScope` unless shared navigation/configuration is the intended product change.
- Do not move demo-specific tile builders or overlays into the package unless the API is meant to become part of `kalender` itself.
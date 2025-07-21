import 'package:flutter/material.dart';
import 'package:kalender/kalender.dart';

/// The [CalendarProvider] is used to provide the [CalendarController], [EventsController], and other components
/// to the [CalendarView]'s descendants.
class CalendarProvider<T extends Object?> extends InheritedWidget {
  /// The [EventsController] that will be used by the Calendar.
  final EventsController<T> eventsController;

  /// The [CalendarController] that will be used by the Calendar.
  final CalendarController<T> calendarController;

  /// The [CalendarCallbacks] that will be used by the Calendar.
  final CalendarCallbacks<T>? callbacks;

  /// Components used by the CalendarView.
  final CalendarComponents<T>? components;

  /// The locale used for internationalization.
  final dynamic locale;

  const CalendarProvider({
    required this.calendarController,
    required this.eventsController,
    required this.callbacks,
    required this.components,
    required super.child,
    this.locale,
    super.key,
  });

  /// The [ViewController] used by the [CalendarController] to controller this view.
  ViewController<T> get viewController {
    final viewController = calendarController.viewController;
    if (viewController == null) throw ErrorHint('Calendar not attached');
    return viewController;
  }

  /// The [ViewConfiguration] used by the [ViewController].
  ViewConfiguration get viewConfiguration => viewController.viewConfiguration;

  /// Finds the [CalendarProvider] of type [T] in the widget tree, or null if not found.
  static CalendarProvider<T>? maybeOf<T>(BuildContext context) {
    return context.dependOnInheritedWidgetOfExactType<CalendarProvider<T>>();
  }

  /// Finds the [CalendarProvider] of type [T] in the widget tree, or throws an assertion error if not found.
  static CalendarProvider<T> of<T>(BuildContext context) {
    final result = maybeOf<T>(context);
    assert(result != null, 'No CalendarProvider of <$T> found.');
    return result!;
  }

  /// Finds the single Provider in the widget tree, regardless of its type parameter.
  /// This is useful when you know there's exactly one Provider but don't know its type.
  /// Throws an assertion error if no Provider is found.
  static CalendarProvider single(BuildContext context) {
    final provider = _findProvider(context);
    assert(provider != null, 'No Provider found in the widget tree.');
    return provider!;
  }

  /// Finds any Provider in the widget tree, regardless of its type parameter.
  /// This is useful when you don't know the exact type T at compile time.
  static CalendarProvider? _findProvider(BuildContext context) {
    // Get all inherited widgets and find the first Provider
    CalendarProvider? provider;
    context.visitAncestorElements((element) {
      if (element.widget is CalendarProvider) {
        provider = element.widget as CalendarProvider;
        return false;
      }
      return true;
    });
    return provider;
  }

  @override
  bool updateShouldNotify(covariant CalendarProvider<T> oldWidget) {
    return locale != oldWidget.locale || callbacks != oldWidget.callbacks || components != oldWidget.components;
  }
}

extension ProviderContext on BuildContext {
  /// Returns the [CalendarProvider] of type [T] from the context.
  CalendarProvider<T> provider<T extends Object?>() => CalendarProvider.of<T>(this);

  /// Retrieve the [EventsController] from the [CalendarProvider].
  EventsController<T> eventsController<T extends Object?>() => provider<T>().eventsController;

  /// Retrieve the [CalendarController] from the [CalendarProvider].
  CalendarController<T> calendarController<T extends Object?>() => provider<T>().calendarController;

  CalendarComponents<T>? components<T extends Object?>() => provider<T>().components;

  /// Retrieve the locale from the [CalendarProvider].
  dynamic locale() => CalendarProvider.single(this).locale;

  /// Retrieve the [HeaderProvider].
  HeaderProvider<T> headerProvider<T extends Object?>() => HeaderProvider.of<T>(this);
  HeaderProvider<T>? maybeHeaderProvider<T extends Object?>() => HeaderProvider.maybeOf<T>(this);

  /// Retrieve the [BodyProvider].
  BodyProvider<T> bodyProvider<T extends Object?>() => BodyProvider.of<T>(this);
  BodyProvider<T>? maybeBodyProvider<T extends Object?>() => BodyProvider.maybeOf<T>(this);

  ValueNotifier<CalendarInteraction> interaction<T extends Object?>() {
    final header = maybeHeaderProvider<T>();
    if (header != null) return header.interaction;

    final body = maybeBodyProvider<T>();
    if (body != null) return body.interaction;

    throw ErrorHint('No CalendarInteraction found in the widget tree.');
  }

  TileComponents<T> tileComponents<T extends Object?>() {
    final header = maybeHeaderProvider<T>();
    if (header != null) return header.tileComponents;

    final body = maybeBodyProvider<T>();
    if (body != null) return body.tileComponents;

    throw ErrorHint('No TileComponents found in the widget tree.');
  }

  /// Retrieve the [CalendarCallbacks] from the [HeaderProvider] or [BodyProvider].
  CalendarCallbacks<T>? callbacks<T extends Object?>() {
    final header = maybeHeaderProvider<T>();
    if (header != null) return header.callbacks;

    final body = maybeBodyProvider<T>();
    if (body != null) return body.callbacks;

    throw ErrorHint('No CalendarCallbacks found in the widget tree.');
  }
}

/// This provider is used to provide the [CalendarCallbacks] and [CalendarComponents]
/// to the [CalendarBody] and [CalendarHeader]
abstract class ComponentProvider<T extends Object?> extends InheritedWidget {
  /// The [CalendarCallbacks] that will be used by the Calendar.
  final CalendarCallbacks<T>? callbacks;

  /// Components used by the CalendarView.
  final TileComponents<T> tileComponents;

  /// The [ValueNotifier] containing the [CalendarInteraction] value.
  final ValueNotifier<CalendarInteraction> interaction;

  const ComponentProvider({
    super.key,
    required super.child,
    required this.callbacks,
    required this.tileComponents,
    required this.interaction,
  });

  @override
  bool updateShouldNotify(covariant ComponentProvider<T> oldWidget) {
    return callbacks != oldWidget.callbacks ||
        tileComponents != oldWidget.tileComponents ||
        interaction != oldWidget.interaction;
  }
}

/// Provider for [CalendarHeader].
class HeaderProvider<T extends Object?> extends ComponentProvider<T> {
  const HeaderProvider({
    super.key,
    required super.child,
    required super.callbacks,
    required super.tileComponents,
    required super.interaction,
  });

  /// Gets the [HeaderProvider] of type [T] from the context.
  static HeaderProvider<T> of<T>(BuildContext context) {
    final result = context.dependOnInheritedWidgetOfExactType<HeaderProvider<T>>();
    assert(result != null, 'No HeaderProvider of <$T> found.');
    return result!;
  }

  /// Gets the [HeaderProvider] of type [T] from the context, or null if not found.
  static HeaderProvider<T>? maybeOf<T>(BuildContext context) {
    return context.dependOnInheritedWidgetOfExactType<HeaderProvider<T>>();
  }
}

/// Provider for [CalendarBody].
class BodyProvider<T extends Object?> extends ComponentProvider<T> {
  /// The [ValueNotifier] containing the [CalendarSnapping] value.
  final ValueNotifier<CalendarSnapping> snapping;

  const BodyProvider({
    super.key,
    required super.child,
    required super.callbacks,
    required super.tileComponents,
    required super.interaction,
    required this.snapping,
  });

  /// Gets the [BodyProvider] of type [T] from the context.
  static BodyProvider<T> of<T>(BuildContext context) {
    final result = context.dependOnInheritedWidgetOfExactType<BodyProvider<T>>();
    assert(result != null, 'No BodyProvider of <$T> found.');
    return result!;
  }

  /// Gets the [BodyProvider] of type [T] from the context, or null if not found.
  static BodyProvider<T>? maybeOf<T>(BuildContext context) {
    return context.dependOnInheritedWidgetOfExactType<BodyProvider<T>>();
  }

  @override
  bool updateShouldNotify(covariant BodyProvider<T> oldWidget) {
    return super.updateShouldNotify(oldWidget) || snapping != oldWidget.snapping;
  }
}

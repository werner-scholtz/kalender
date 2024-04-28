import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:kalender/kalender.dart';

class Calendar<T extends Object?> extends StatefulWidget {
  final CalendarEventsController<T> eventsController;
  final CalendarController<T> calendarController;
  final ViewConfiguration viewConfiguration;

  final Widget Function(BuildContext context)? headerBuilder;
  final Widget Function(BuildContext context)? bodyBuilder;

  // TODO: Add calbacks
  // onPageChanged,
  // onEventTapped,
  // onEventChangeStart,
  // onEventChanged,
  // onCreateEvent,
  // onCreatedEvent,

  const Calendar({
    super.key,
    required this.eventsController,
    required this.calendarController,
    required this.viewConfiguration,
    this.headerBuilder,
    this.bodyBuilder,
  });

  @override
  State<Calendar<T>> createState() => _CalendarState<T>();
}

class _CalendarLayoutDelegate extends MultiChildLayoutDelegate {
  _CalendarLayoutDelegate(this.headerId, this.bodyId);
  final int? headerId;
  final int? bodyId;

  @override
  void performLayout(Size size) {
    Size? headerSize;
    if (headerId != null) {
      final width = size.width;

      final constrains = BoxConstraints(
        minWidth: width,
        maxWidth: width,
        minHeight: 0.0,
      );

      headerSize = layoutChild(
        headerId!,
        constrains,
      );

      positionChild(headerId!, Offset.zero);
    }

    if (bodyId != null) {
      final width = size.width;
      final height = size.height;
      final headerHeight = headerSize?.height ?? 0.0;
      final maxHeight = height - headerHeight;

      final constraints = BoxConstraints(
        minWidth: width,
        maxWidth: width,
        maxHeight: maxHeight,
        minHeight: 0.0,
      );

      layoutChild(
        bodyId!,
        constraints,
      );

      positionChild(bodyId!, Offset(0, headerHeight));
    }
  }

  @override
  bool shouldRelayout(covariant _CalendarLayoutDelegate oldDelegate) {
    return false;
  }
}

class _CalendarState<T> extends State<Calendar<T>> {
  @override
  Widget build(BuildContext context) {
    log(widget.viewConfiguration.name);

    return CalendarInternals<T>(
      eventsController: widget.eventsController,
      calendarController: widget.calendarController,
      viewConfiguration: widget.viewConfiguration,
      child: Builder(
        builder: (context) {
          log('building', name: 'CalendarState');

          final header = widget.headerBuilder?.call(context);
          final headerId = header == null ? null : 0;

          final body = widget.bodyBuilder?.call(context);
          final bodyId = body == null ? null : 1;

          final child = CustomMultiChildLayout(
            delegate: _CalendarLayoutDelegate(headerId, bodyId),
            children: [
              if (bodyId != null)
                LayoutId(
                  id: bodyId,
                  child: body!,
                ),
              if (headerId != null)
                LayoutId(
                  id: headerId,
                  child: header!,
                ),
            ],
          );

          return child;
        },
      ),
    );
  }
}

class CalendarInternals<T extends Object?> extends InheritedWidget {
  final CalendarEventsController eventsController;
  final CalendarController calendarController;
  final ViewConfiguration viewConfiguration;

  const CalendarInternals({
    required this.calendarController,
    required this.eventsController,
    required this.viewConfiguration,
    required super.child,
    super.key,
  });

  static CalendarInternals<T>? maybeOf<T>(BuildContext context) {
    return context.dependOnInheritedWidgetOfExactType<CalendarInternals<T>>();
  }

  static CalendarInternals<T> of<T>(BuildContext context) {
    final result = maybeOf<T>(context);
    assert(result != null, 'No FrogColor found in context');
    return result!;
  }

  @override
  bool updateShouldNotify(covariant CalendarInternals<T> oldWidget) {
    final shouldNotify = calendarController != oldWidget.calendarController ||
        eventsController != oldWidget.eventsController ||
        viewConfiguration != oldWidget.viewConfiguration;

    debugPrint('Should Notify: $shouldNotify');

    return shouldNotify;
  }
}

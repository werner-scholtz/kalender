import 'package:flutter/material.dart';
import 'package:kalender/src/layout_delegates/calendar_layout_delegate.dart';
import 'package:kalender/src/models/controllers/calendar_controller.dart';
import 'package:kalender/src/models/controllers/events_controller.dart';
import 'package:kalender/src/models/controllers/view_controller.dart';
import 'package:kalender/src/models/providers/calendar_provider.dart';
import 'package:kalender/src/models/view_configurations/view_configuration.dart';

class Calendar<T extends Object?> extends StatefulWidget {
  final EventsController<T> eventsController;
  final CalendarController<T> calendarController;
  final ViewConfiguration viewConfiguration;

  final Widget? header;
  final Widget? body;

  const Calendar({
    super.key,
    required this.eventsController,
    required this.calendarController,
    required this.viewConfiguration,
    this.header,
    this.body,
  });

  @override
  State<Calendar<T>> createState() => _CalendarState<T>();
}

class _CalendarState<T> extends State<Calendar<T>> {
  late ViewController _viewController;
  late final EventsController<T> _eventsController;
  late final CalendarController<T> _calendarController;

  @override
  void initState() {
    super.initState();
    _eventsController = widget.eventsController;
    _calendarController = widget.calendarController;

    _viewController = _createViewController();
    _calendarController.attach(_viewController);
  }

  @override
  void didUpdateWidget(covariant Calendar<T> oldWidget) {
    super.didUpdateWidget(oldWidget);

    if (widget.viewConfiguration != oldWidget.viewConfiguration) {
      setState(() {
        _viewController = _createViewController();
        _calendarController.attach(_viewController);
      });
    }
  }

  @override
  void deactivate() {
    super.deactivate();
    widget.calendarController.detach();
  }

  @override
  void activate() {
    super.activate();
    widget.calendarController.attach(_viewController);
  }

  ViewController _createViewController() {
    return ViewController.create(
      focusedDate: widget.calendarController.focusedDate,
      viewConfiguration: widget.viewConfiguration,
    );
  }

  @override
  Widget build(BuildContext context) {
    return CalendarProvider<T>(
      eventsController: _eventsController,
      calendarController: _calendarController,
      child: Builder(
        builder: (context) {
          final body = widget.body;
          final header = widget.header;

          final bodyId = body == null ? null : 1;
          final headerId = header == null ? null : 0;

          return CustomMultiChildLayout(
            delegate: CalendarLayoutDelegate(headerId, bodyId),
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
        },
      ),
    );
  }
}

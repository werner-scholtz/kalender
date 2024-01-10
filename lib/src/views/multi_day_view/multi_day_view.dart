import 'package:flutter/material.dart';
import 'package:kalender/src/models/calendar/calendar_components.dart';
import 'package:kalender/src/models/calendar/calendar_controller.dart';
import 'package:kalender/src/models/calendar/calendar_event_controller.dart';
import 'package:kalender/src/models/calendar/calendar_functions.dart';
import 'package:kalender/src/models/calendar/calendar_layout_delegates.dart';
import 'package:kalender/src/models/calendar/calendar_style.dart';
import 'package:kalender/src/models/calendar/view_state/multi_day_view_state.dart';
import 'package:kalender/src/models/view_configurations/view_configuration_export.dart';
import 'package:kalender/src/providers/calendar_scope.dart';
import 'package:kalender/src/providers/calendar_style.dart';
import 'package:kalender/src/type_definitions.dart';

import 'package:kalender/src/models/calendar/platform_data/web_platform_data.dart'
    if (dart.library.io) 'package:kalender/src/models/calendar/platform_data/io_platform_data.dart';
import 'package:kalender/src/views/multi_day_view/multi_day_content.dart';
import 'package:kalender/src/views/multi_day_view/multi_day_header.dart';

/// A widget that displays a multi day view.
class MultiDayView<T> extends StatefulWidget {
  const MultiDayView({
    super.key,
    required this.controller,
    required this.eventsController,
    required this.multiDayViewConfiguration,
    required this.tileBuilder,
    required this.multiDayTileBuilder,
    this.components,
    this.style,
    this.functions,
    this.layoutDelegates,
    this.eventTileBuilder,
    this.multiDayEventTileBuilder,
  });

  /// The [CalendarController] used to control the view.
  final CalendarController<T> controller;

  /// The [CalendarEventsController] used to control events.
  final CalendarEventsController<T> eventsController;

  /// The [MultiDayViewConfiguration] used to configure the view.
  final MultiDayViewConfiguration multiDayViewConfiguration;

  /// The [CalendarComponents] used to build the components of the view.
  final CalendarComponents? components;

  /// The [CalendarStyle] used to style the default components.
  final CalendarStyle? style;

  /// The [CalendarEventHandlers] used to handle events.
  final CalendarEventHandlers<T>? functions;

  /// The [CalendarLayoutDelegates] used to layout the calendar's tiles.
  final CalendarLayoutDelegates<T>? layoutDelegates;

  /// The [TileBuilder] used to build event tiles.
  final TileBuilder<T> tileBuilder;

  /// The [MultiDayTileBuilder] used to build multi day event tiles.
  final MultiDayTileBuilder<T> multiDayTileBuilder;

  final EventTileBuilder<T>? eventTileBuilder;
  final MultiDayEventTileBuilder<T>? multiDayEventTileBuilder;

  @override
  State<MultiDayView<T>> createState() => _MultiDayViewState<T>();
}

const _headerID = 0;
const _contentID = 1;

class _MultiDayViewLayoutDelegate extends MultiChildLayoutDelegate {
  _MultiDayViewLayoutDelegate();

  @override
  void performLayout(Size size) {
    final headerSize = layoutChild(
      _headerID,
      BoxConstraints.loose(size),
    );

    layoutChild(
      _contentID,
      BoxConstraints.loose(
        Size(
          size.width,
          size.height - headerSize.height,
        ),
      ),
    );

    positionChild(1, Offset(0, headerSize.height));
    positionChild(0, Offset.zero);
  }

  @override
  bool shouldRelayout(covariant MultiChildLayoutDelegate oldDelegate) {
    return false;
  }
}

class _MultiDayViewState<T> extends State<MultiDayView<T>> {
  late MultiDayViewState _viewState;

  @override
  void deactivate() {
    widget.controller.detach();
    super.deactivate();
  }

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: widget.multiDayViewConfiguration,
      builder: (context, child) {
        _viewState = widget.controller.attach(
          widget.multiDayViewConfiguration,
        )! as MultiDayViewState;

        final functions = widget.functions ?? CalendarEventHandlers<T>();

        final layoutDelegates =
            widget.layoutDelegates ?? CalendarLayoutDelegates<T>();

        final child = CustomMultiChildLayout(
          delegate: _MultiDayViewLayoutDelegate(),
          children: [
            // The content is placed first so that it is behind the header.
            LayoutId(
              id: _contentID,
              child: MultiDayContent<T>(
                controller: widget.controller,
                viewConfiguration: widget.multiDayViewConfiguration,
              ),
            ),
            LayoutId(
              id: _headerID,
              child: MultiDayHeader<T>(
                viewConfiguration: widget.multiDayViewConfiguration,
              ),
            ),
          ],
        );

        return CalendarStyleProvider(
          style: widget.style ?? const CalendarStyle(),
          components: widget.components ?? CalendarComponents(),
          child: CalendarScope<T>(
            state: _viewState,
            eventsController: widget.eventsController,
            functions: functions,
            tileComponents: CalendarTileComponents<T>(
              tileBuilder: widget.tileBuilder,
              multiDayTileBuilder: widget.multiDayTileBuilder,
              eventTileBuilder: widget.eventTileBuilder,
              multiDayEventTileBuilder: widget.multiDayEventTileBuilder,
            ),
            platformData: PlatformData(),
            layoutDelegates: layoutDelegates,
            child: child,
          ),
        );
      },
    );
  }
}

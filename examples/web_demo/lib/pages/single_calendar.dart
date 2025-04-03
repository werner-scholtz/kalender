import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:kalender/kalender.dart';
import 'package:web_demo/models/event.dart';
import 'package:web_demo/widgets/calendar_customize.dart';
import 'package:web_demo/widgets/calendar_widget.dart';

class SingleCalendarView extends StatefulWidget {
  const SingleCalendarView({super.key});

  static SingleCalendarViewState? _of(BuildContext context) {
    return context.findAncestorStateOfType<SingleCalendarViewState>();
  }

  static void setViewConfiguration(BuildContext context, ViewConfiguration value) {
    final state = _of(context);
    if (state == null) throw Exception('SingleCalendarViewState not found in context');
    state.setViewConfiguration(value);
  }

  @override
  State<SingleCalendarView> createState() => SingleCalendarViewState();
}

class SingleCalendarViewState extends State<SingleCalendarView> {
  final controller = CalendarController<Event>();

  late ViewConfiguration viewConfiguration = viewConfigurations[1];
  void setViewConfiguration(ViewConfiguration value) {
    if (viewConfiguration == value) return;
    setState(() => viewConfiguration = value);
  }

  final viewConfigurations = [
    MultiDayViewConfiguration.singleDay(),
    MultiDayViewConfiguration.week(),
    MultiDayViewConfiguration.workWeek(),
    MultiDayViewConfiguration.custom(numberOfDays: 3),
    MonthViewConfiguration.singleMonth(),
    MultiDayViewConfiguration.freeScroll(numberOfDays: 3, name: "FreeScroll (WIP)"),
  ];

  MultiDayBodyConfiguration multiDayBodyConfiguration = MultiDayBodyConfiguration();
  MultiDayHeaderConfiguration<Event> multiDayHeaderConfiguration = MultiDayHeaderConfiguration();
  MonthBodyConfiguration<Event> monthBodyConfiguration = MonthBodyConfiguration();

  late final ValueNotifier<CalendarInteraction> interactionHeader = ValueNotifier(CalendarInteraction(
    createEventGesture: isMobile ? CreateEventGesture.longPress : CreateEventGesture.tap,
  ));
  late final ValueNotifier<CalendarInteraction> interactionBody = ValueNotifier(CalendarInteraction(
    createEventGesture: isMobile ? CreateEventGesture.longPress : CreateEventGesture.tap,
  ));
  final ValueNotifier<CalendarSnapping> snapping = ValueNotifier(const CalendarSnapping());

  bool showHeader = true;
  bool get isMobile => defaultTargetPlatform == TargetPlatform.iOS || defaultTargetPlatform == TargetPlatform.android;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final canShowCustomize = constraints.maxWidth > 800;
        return Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Flexible(
              flex: 3,
              child: CalendarWidget(
                controller: controller,
                viewConfiguration: viewConfiguration,
                viewConfigurations: viewConfigurations,
                multiDayBodyConfiguration: multiDayBodyConfiguration,
                multiDayHeaderConfiguration: multiDayHeaderConfiguration,
                monthBodyConfiguration: monthBodyConfiguration,
                interactionHeader: interactionHeader,
                interactionBody: interactionBody,
                snapping: snapping,
                showHeader: showHeader,
              ),
            ),
            if (canShowCustomize)
              Flexible(
                flex: 1,
                child: CalendarCustomize(
                  viewConfiguration: viewConfiguration,
                  onChanged: (value) => setState(() => viewConfiguration = value),
                  bodyConfiguration: multiDayBodyConfiguration,
                  onBodyChanged: (value) => setState(() => multiDayBodyConfiguration = value),
                  headerConfiguration: multiDayHeaderConfiguration,
                  onHeaderChanged: (value) => setState(() => multiDayHeaderConfiguration = value),
                  showHeader: showHeader,
                  onShowHeaderChanged: (value) => setState(() => showHeader = value),
                  interaction: interactionBody,
                  interactionHeader: interactionHeader,
                  snapping: snapping,
                ),
              ),
          ],
        );
      },
    );
  }
}

// The input for `fix_calendar_to_kalender.yaml`. Run `dart fix --compare-to-golden test_fixes`.

import 'package:flutter/widgets.dart';
import 'package:kalender/kalender.dart';

CalendarBody? body;
CalendarCallbacks? callbacks;
CalendarComponents? components;
CalendarController? controller;
CalendarEvent? event;
CalendarHeader? header;
CalendarInteraction? interaction;
CalendarSnapping? snapping;

Locale? localeOf(BuildContext context) => context.calendarLocale;

// The input for `fix_calendar_to_kalender.yaml`. Run `dart fix --compare-to-golden test_fixes`.

// `context.calendarLocale` is left alone on purpose. A rename on an extension member
// only matches where the extension is applied explicitly, so the bare spelling is the
// analyzer's to report. See fix_kalender_locale.yaml.

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
Locale? namedExtension(BuildContext context) => CalendarLocale(context).calendarLocale;

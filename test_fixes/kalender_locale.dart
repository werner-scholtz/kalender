// The input for `fix_kalender_locale.yaml`. Run `dart fix --compare-to-golden test_fixes`.
//
// The transform does not rewrite the bare `context.calendarLocale` below.

import 'package:flutter/widgets.dart';
import 'package:kalender/kalender.dart';

Locale? namedExtension(BuildContext context) => KalenderLocale(context).calendarLocale;
Locale? bareGetter(BuildContext context) => context.calendarLocale;

// This file is part of kalender.
//
// SPDX-FileCopyrightText: 2023 Klarälvdalens Datakonsult AB, a KDAB Group company <info@kdab.com>
//
// SPDX-License-Identifier: MIT

// The input for `fix_kalender_members.yaml`. Run `dart fix --compare-to-golden test_fixes`.

import 'package:flutter/widgets.dart';
import 'package:kalender/kalender.dart';
import 'package:kalender/kalender_extensions.dart';

Widget build(BuildContext context, KalenderController c, EventsController e) =>
    KalenderView(calendarController: c, eventsController: e);

KalenderController field(KalenderView view) => view.calendarController;
KalenderController of(BuildContext context) => KalenderScope.calendarControllerOf(context);
KalenderController? maybe(BuildContext context) => KalenderScope.maybeCalendarControllerOf(context);
InternalDateTimeRange? visible(ViewController c) => c.visibleDateTimeRange.value;

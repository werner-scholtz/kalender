// This file is part of kalender.
//
// SPDX-FileCopyrightText: 2023 Klarälvdalens Datakonsult AB, a KDAB Group company <info@kdab.com>
//
// SPDX-License-Identifier: MIT

// The input for `fix_default_constants.yaml`. Run `dart fix --compare-to-golden test_fixes`.

import 'package:kalender/kalender.dart';

double tileHeight = defaultTileHeight;
bool showMultiDayEvents = defaultShowMultiDayEvents;
EventLayoutStrategy eventLayoutStrategy = defaultEventLayoutStrategy;
MultiDayLayoutStrategy multiDayLayoutStrategy = defaultMultiDayLayoutStrategy;
int firstDayOfWeek = defaultFirstDayOfWeek;
bool showEventTiles = defaultShowEventTiles;
KalenderTime initialTimeOfDay = defaultInitialTimeOfDay;
double heightPerMinute = defaultHeightPerMinute;
EdgeInsets horizontalPadding = defaultHorizontalPadding;
MultiDayRule multiDayRule = defaultMultiDayRule;
EventSnapStrategy snapStrategy = defaultSnapStrategy;

MultiDayViewConfiguration inArgument() =>
    MultiDayViewConfiguration.week(initialHeightPerMinute: defaultHeightPerMinute);

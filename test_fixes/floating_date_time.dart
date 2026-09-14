// This file is part of kalender.
//
// SPDX-FileCopyrightText: 2023 Klarälvdalens Datakonsult AB, a KDAB Group company <info@kdab.com>
//
// SPDX-License-Identifier: MIT

// The input for `fix_floating_date_time.yaml`. Run `dart fix --compare-to-golden test_fixes`.

import 'package:kalender/kalender.dart';

InternalDateTime? dateTime;
InternalDateTimeRange? range;

InternalDateTime fromDateTime(DateTime value) => InternalDateTime.fromDateTime(value);

InternalDateTimeRange rangeOf(DateTime start, DateTime end) => InternalDateTimeRange(start: start, end: end);

InternalDateTime startOfDay(KalenderTime time, InternalDateTime date) => time.toInternalDateTime(date);

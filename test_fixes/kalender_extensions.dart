// This file is part of kalender.
//
// SPDX-FileCopyrightText: 2023 Klarälvdalens Datakonsult AB, a KDAB Group company <info@kdab.com>
//
// SPDX-License-Identifier: MIT

// The input for `fix_range_members.yaml` through `kalender_extensions.dart` alone. Run
// `dart fix --compare-to-golden test_fixes`.

import 'package:kalender/kalender_extensions.dart';

FloatingDateTimeRange? onDate(FloatingDateTimeRange r, FloatingDateTime d) => r.dateTimeRangeOnDate(d);

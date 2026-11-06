// This file is part of kalender.
//
// SPDX-FileCopyrightText: 2023 Klarälvdalens Datakonsult AB, a KDAB Group company <info@kdab.com>
//
// SPDX-License-Identifier: MIT

import 'package:clock/clock.dart';
import 'package:kalender/kalender_extensions.dart';

/// The current time from the package's [clock], in [location] or the system's local timezone when it is null.
DateTime currentTime(Location? location) {
  final now = clock.now();
  return location == null ? now : TZDateTime.from(now, location);
}

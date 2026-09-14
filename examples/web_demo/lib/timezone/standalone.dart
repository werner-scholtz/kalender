// This file is part of kalender.
//
// SPDX-FileCopyrightText: 2023 Klarälvdalens Datakonsult AB, a KDAB Group company <info@kdab.com>
//
// SPDX-License-Identifier: MIT

import 'package:timezone/data/latest.dart';
export 'package:timezone/timezone.dart';

Future<void> initializeTimeZonePackage() async {
  initializeTimeZones();
}

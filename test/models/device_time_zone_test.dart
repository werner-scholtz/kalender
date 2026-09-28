// This file is part of kalender.
//
// SPDX-FileCopyrightText: 2023 Klarälvdalens Datakonsult AB, a KDAB Group company <info@kdab.com>
//
// SPDX-License-Identifier: MIT

import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:kalender/src/models/device_time_zone.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  test('a resume in another timezone changes the generation, including the first one', () {
    final readZone = DeviceTimeZone.readZone;
    addTearDown(() => DeviceTimeZone.readZone = readZone);
    var zone = 'UTC';
    DeviceTimeZone.readZone = () => zone;
    DeviceTimeZone.observe();
    final start = DeviceTimeZone.generation;

    final generations = <int>[];
    for (final next in ['UTC', 'Asia/Tokyo', 'Asia/Tokyo', 'Europe/London']) {
      zone = next;
      TestWidgetsFlutterBinding.instance.handleAppLifecycleStateChanged(AppLifecycleState.resumed);
      generations.add(DeviceTimeZone.generation - start);
    }

    expect(generations, [0, 1, 1, 2]);
  });
}

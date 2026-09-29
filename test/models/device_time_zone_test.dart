// This file is part of kalender.
//
// SPDX-FileCopyrightText: 2023 Klarälvdalens Datakonsult AB, a KDAB Group company <info@kdab.com>
//
// SPDX-License-Identifier: MIT

import 'dart:convert';
import 'dart:ffi';
import 'dart:io';

import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:kalender/kalender.dart';
import 'package:kalender/src/models/device_time_zone.dart';

import '../utilities.dart';

/// The device timezone read on resume, and what follows a change of it.
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

  group('after the device timezone changes', () {
    setUp(() {
      _setProcessTimeZone('UTC');
      DeviceTimeZone.check();
    });
    tearDown(() {
      _setProcessTimeZone(Platform.environment['TZ']);
      DeviceTimeZone.check();
    });

    final event = KalenderEvent(start: DateTime.utc(2025, 1, 1, 23), end: DateTime.utc(2025, 1, 1, 23, 30));
    final january2 = FloatingDateTime(2025, 1, 2).dayRange;

    test('the events controller finds and removes an event on its new date', () {
      final eventsController = DefaultEventsController()..addEvent(event);
      addTearDown(eventsController.dispose);

      _setProcessTimeZone('Asia/Tokyo');
      DeviceTimeZone.check();
      final found = eventsController.eventsInRange(january2, multiDayRule: kDefaultMultiDayRule).toList();
      eventsController.removeEvent(event);

      expect(found, [event]);
      final indexed = eventsController.eventStore.locationDateIdMap[DefaultEventStore.defaultLocation]!;
      expect(indexed.values.expand((ids) => ids), isEmpty);
    });

    test('the controller converts the visible range into the new timezone', () {
      final kalenderController = KalenderController(
        viewConfiguration: MultiDayViewConfiguration.singleDay(initialDateTime: DateTime.utc(2025, 1, 2)),
      );
      addTearDown(kalenderController.dispose);

      _setProcessTimeZone('Asia/Tokyo');
      DeviceTimeZone.check();

      expect(kalenderController.visibleDateTimeRange.value, january2.forLocation(location: null));
    });

    testWidgets('a mounted view shows the events of its date in the new timezone', (tester) async {
      final eventsController = DefaultEventsController()..addEvent(event);
      final kalenderController = KalenderController(
        viewConfiguration: MultiDayViewConfiguration.singleDay(initialDateTime: DateTime.utc(2025, 1, 2)),
      );
      addTearDown(eventsController.dispose);
      addTearDown(kalenderController.dispose);
      await pumpKalender(tester, eventsController: eventsController, kalenderController: kalenderController);

      _setProcessTimeZone('Asia/Tokyo');
      DeviceTimeZone.check();
      await tester.pumpAndSettle();

      expect(kalenderController.visibleEvents.value, {event});
    });
  }, skip: !Platform.isLinux && !Platform.isMacOS);
}

final _libc = DynamicLibrary.process();
final _setenv = _libc
    .lookupFunction<
      Int32 Function(Pointer<Uint8>, Pointer<Uint8>, Int32),
      int Function(Pointer<Uint8>, Pointer<Uint8>, int)
    >('setenv');
final _unsetenv = _libc.lookupFunction<Int32 Function(Pointer<Uint8>), int Function(Pointer<Uint8>)>('unsetenv');
final _tzset = _libc.lookupFunction<Void Function(), void Function()>('tzset');
final _malloc = _libc.lookupFunction<Pointer<Uint8> Function(IntPtr), Pointer<Uint8> Function(int)>('malloc');

/// Sets the timezone of this process, or its default when [zone] is null.
void _setProcessTimeZone(String? zone) {
  if (zone == null) {
    _unsetenv(_cString('TZ'));
  } else {
    _setenv(_cString('TZ'), _cString(zone), 1);
  }
  _tzset();
}

Pointer<Uint8> _cString(String value) {
  final bytes = utf8.encode(value);
  final pointer = _malloc(bytes.length + 1);
  pointer.asTypedList(bytes.length + 1)
    ..setAll(0, bytes)
    ..[bytes.length] = 0;
  return pointer;
}

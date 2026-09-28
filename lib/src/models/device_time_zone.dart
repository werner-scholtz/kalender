// This file is part of kalender.
//
// SPDX-FileCopyrightText: 2023 Klarälvdalens Datakonsult AB, a KDAB Group company <info@kdab.com>
//
// SPDX-License-Identifier: MIT

import 'package:flutter/widgets.dart';

/// The device timezone, for conversions cached without a location.
abstract final class DeviceTimeZone {
  static int _generation = 0;
  static String? _zone;
  static _ResumeObserver? _observer;

  /// Reads the device timezone.
  @visibleForTesting
  static String Function() readZone = _current;

  /// Changes whenever [check] finds a different device timezone. A conversion cached for no location is valid
  /// while this is unchanged.
  static int get generation => _generation;

  /// Records the device timezone and checks it again every time the app resumes. Calling it again does nothing.
  static void observe() {
    if (_observer != null) return;
    _zone = readZone();
    WidgetsBinding.instance.addObserver(_observer = _ResumeObserver());
  }

  /// Updates [generation] when the device timezone differs from the one last recorded.
  static void check() {
    final zone = readZone();
    if (zone == _zone) return;
    _zone = zone;
    _generation++;
  }

  @visibleForTesting
  static void debugChange() => _generation++;

  static String _current() {
    final now = DateTime.now();
    return '${now.timeZoneName} ${now.timeZoneOffset}';
  }
}

class _ResumeObserver with WidgetsBindingObserver {
  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) DeviceTimeZone.check();
  }
}

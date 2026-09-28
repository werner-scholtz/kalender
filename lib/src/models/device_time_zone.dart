// This file is part of kalender.
//
// SPDX-FileCopyrightText: 2023 Klarälvdalens Datakonsult AB, a KDAB Group company <info@kdab.com>
//
// SPDX-License-Identifier: MIT

import 'package:flutter/widgets.dart';

/// The device timezone, for conversions cached without a location.
abstract final class DeviceTimeZone {
  static int _generation = 0;
  static String _zone = _current();
  static _ResumeObserver? _observer;

  /// Changes whenever [check] finds a different device timezone. A conversion cached for no location is valid
  /// while this is unchanged.
  static int get generation => _generation;

  /// Checks the device timezone every time the app resumes. Calling it again does nothing.
  static void observe() {
    if (_observer != null) return;
    WidgetsBinding.instance.addObserver(_observer = _ResumeObserver());
  }

  /// Updates [generation] when the device timezone differs from the last check.
  static void check() {
    final zone = _current();
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

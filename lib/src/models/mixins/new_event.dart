// This file is part of kalender.
//
// SPDX-FileCopyrightText: 2023 Klarälvdalens Datakonsult AB, a KDAB Group company <info@kdab.com>
//
// SPDX-License-Identifier: MIT

import 'package:kalender/kalender.dart';

mixin NewEvent {
  /// The event that is being created by the controller.
  KalenderEvent? _newEvent;
  KalenderEvent? get newEvent => _newEvent;

  void setNewEvent(KalenderEvent event) {
    if (_newEvent == event) return;
    _newEvent = event;
  }

  void clearNewEvent() {
    _newEvent = null;
  }
}

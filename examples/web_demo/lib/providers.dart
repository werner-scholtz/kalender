// This file is part of kalender.
//
// SPDX-FileCopyrightText: 2023 Klarälvdalens Datakonsult AB, a KDAB Group company <info@kdab.com>
//
// SPDX-License-Identifier: MIT

import 'package:flutter/material.dart';
import 'package:kalender/kalender.dart';
import 'package:web_demo/models/demo_configuration.dart';

class AppSettings {
  final ValueNotifier<ThemeMode> themeMode;
  final ValueNotifier<TextDirection> textDirection;
  final ValueNotifier<Locale> locale;

  AppSettings({
    required this.themeMode,
    required this.textDirection,
    required this.locale,
  });
}

class AppSettingsProvider extends InheritedWidget {
  final AppSettings settings;
  const AppSettingsProvider({required this.settings, required super.child, super.key});

  static AppSettings of(BuildContext context) {
    final result = context.dependOnInheritedWidgetOfExactType<AppSettingsProvider>();
    assert(result != null, 'No AppSettingsProvider found.');
    return result!.settings;
  }

  @override
  bool updateShouldNotify(covariant AppSettingsProvider oldWidget) => settings != oldWidget.settings;
}

class EventsControllerProvider extends InheritedWidget {
  final EventsController eventsController;
  const EventsControllerProvider({required this.eventsController, required super.child, super.key});

  static EventsController of(BuildContext context) {
    final result = context.dependOnInheritedWidgetOfExactType<EventsControllerProvider>();
    assert(result != null, 'No EventsControllerProvider found.');
    return result!.eventsController;
  }

  @override
  bool updateShouldNotify(covariant EventsControllerProvider oldWidget) {
    return eventsController != oldWidget.eventsController;
  }
}

/// Owns the [KalenderController] and [DemoConfiguration] of one calendar.
class DemoScope extends StatefulWidget {
  final Widget child;
  const DemoScope({required this.child, super.key});

  static _DemoScopeProvider _of(BuildContext context) {
    final result = context.dependOnInheritedWidgetOfExactType<_DemoScopeProvider>();
    assert(result != null, 'No DemoScope found.');
    return result!;
  }

  static KalenderController controllerOf(BuildContext context) => _of(context).controller;
  static DemoConfiguration configurationOf(BuildContext context) => _of(context).configuration;

  @override
  State<DemoScope> createState() => _DemoScopeState();
}

class _DemoScopeState extends State<DemoScope> {
  final _configuration = DemoConfiguration();
  late final _controller = KalenderController(viewConfiguration: _configuration.initialViewConfiguration);

  @override
  void dispose() {
    _controller.dispose();
    _configuration.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return _DemoScopeProvider(controller: _controller, configuration: _configuration, child: widget.child);
  }
}

class _DemoScopeProvider extends InheritedWidget {
  final KalenderController controller;
  final DemoConfiguration configuration;
  const _DemoScopeProvider({required this.controller, required this.configuration, required super.child});

  @override
  bool updateShouldNotify(covariant _DemoScopeProvider oldWidget) {
    return controller != oldWidget.controller || configuration != oldWidget.configuration;
  }
}

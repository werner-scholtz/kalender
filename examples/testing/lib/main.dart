// This file is part of kalender.
//
// SPDX-FileCopyrightText: 2023 Klarälvdalens Datakonsult AB, a KDAB Group company <info@kdab.com>
//
// SPDX-License-Identifier: MIT

import 'package:flutter/material.dart';
import 'package:kalender/kalender.dart';
import 'package:testing/test_configuration.dart';
import 'package:testing/tiles.dart';

void main() {
  final config = TestConfiguration.week();
  config.eventsController.addEvents(TestConfiguration.generate(timeOfDayRanges.take(10).toList()));
  runApp(MyApp(config: config));
}

class MyApp extends StatelessWidget {
  final TestConfiguration config;
  const MyApp({super.key, required this.config});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Performance Profiling',
      theme: ThemeData(colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue)),
      home: Home(config: config),
    );
  }
}

class Home extends StatefulWidget {
  final TestConfiguration? config;
  const Home({super.key, this.config});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  late final TestConfiguration config = widget.config ?? TestConfiguration.week();
  EventsController get eventsController => config.eventsController;
  KalenderController get kalenderController => config.kalenderController;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: KalenderView(
        eventsController: config.eventsController,
        kalenderController: config.kalenderController,
        components: KalenderComponents(),
        callbacks: KalenderCallbacks(
          onEventTapped: (event) => kalenderController.selectEvent(event),
          onEventCreate: (event) => event,
          onEventCreated: (event) => eventsController.addEvent(event),
          onEventChanged: (event, updatedEvent) =>
              eventsController.updateEvent(event: event, updatedEvent: updatedEvent),
        ),
        views: [
          MultiDayViewParts(
            header: MultiDayHeader(tileComponents: _multiDayTileComponents),
            body: MultiDayBody(tileComponents: _tileComponents),
          ),
          MonthViewParts(body: MonthBody(tileComponents: _multiDayTileComponents)),
          ScheduleViewParts(body: ScheduleBody(tileComponents: _scheduleTileComponents)),
        ],
      ),
    );
  }

  TileComponents get _tileComponents {
    return TileComponents(
      tileBuilder: (context, event, range) => EventTile.builder(event as Event, range),
      dropTargetTile: (context, event) => DropTargetTile.builder(event as Event),
      feedbackTileBuilder: (context, event, size) => FeedbackTile.builder(event as Event, size),
      tileWhenDraggingBuilder: (context, event) => TileWhenDragging.builder(event as Event),
    );
  }

  TileComponents get _multiDayTileComponents {
    return TileComponents(
      tileBuilder: (context, event, range) => MultiDayEventTile.builder(event as Event, range),
      overlayTileBuilder: (context, event, range) => OverlayEventTile.builder(event as Event, range),
      dropTargetTile: (context, event) => DropTargetTile.builder(event as Event),
      feedbackTileBuilder: (context, event, size) => FeedbackTile.builder(event as Event, size),
      tileWhenDraggingBuilder: (context, event) => TileWhenDragging.builder(event as Event),
    );
  }

  ScheduleTileComponents get _scheduleTileComponents {
    return ScheduleTileComponents(
      tileBuilder: (context, event, range) => MultiDayEventTile.builder(event as Event, range),
      feedbackTileBuilder: (context, event, size) => FeedbackTile.builder(event as Event, size),
      tileWhenDraggingBuilder: (context, event) => TileWhenDragging.builder(event as Event),
    );
  }
}

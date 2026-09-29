// This file is part of kalender.
//
// SPDX-FileCopyrightText: 2023 Klarälvdalens Datakonsult AB, a KDAB Group company <info@kdab.com>
//
// SPDX-License-Identifier: MIT

import 'package:advanced_example/main.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:kalender/kalender.dart';

/// Groups the events of a day by person.
///
/// Value equality keeps the body configuration comparable, so a rebuild with the
/// same people does not read as a change.
class PeopleLayoutStrategy extends EventLayoutStrategy {
  /// The people to group the events by.
  final List<Person> people;

  const PeopleLayoutStrategy(this.people);

  @override
  EventLayoutDelegate createDelegate({
    required Iterable<KalenderEvent> events,
    required FloatingDateTime date,
    required KalenderTimeRange timeOfDayRange,
    required double heightPerMinute,
    required double? minimumTileHeight,
    required EventLayoutDelegateCache? cache,
    required Location? location,
  }) {
    return CustomSideBySideLayoutDelegate(
      events: events,
      heightPerMinute: heightPerMinute,
      date: date,
      timeOfDayRange: timeOfDayRange,
      minimumTileHeight: minimumTileHeight,
      layoutCache: cache ?? EventLayoutDelegateCache(),
      people: people,
      location: location,
    );
  }

  @override
  bool operator ==(Object other) => other is PeopleLayoutStrategy && listEquals(other.people, people);

  @override
  int get hashCode => Object.hashAll(people);
}

class CustomSideBySideLayoutDelegate extends EventLayoutDelegate {
  /// A List of people to group the events by.
  final List<Person> people;

  CustomSideBySideLayoutDelegate({
    required super.events,
    required super.heightPerMinute,
    required super.date,
    required super.timeOfDayRange,
    required super.minimumTileHeight,
    required super.layoutCache,
    required this.people,
    required super.location,
  });

  @override
  List<KalenderEvent> sortEvents(Iterable<KalenderEvent> events) => events.toList();

  @override
  List<VerticalLayoutData> sortVerticalLayoutData(List<VerticalLayoutData> layoutData) {
    // Sort the data from top to bottom.
    // If the top values are equal compare the bottom
    return layoutData..sort((a, b) {
      return a.top.compareTo(b.top) == 0 ? b.bottom.compareTo(a.bottom) : a.top.compareTo(b.top);
    });
  }

  @override
  void performLayout(Size size) {
    // Calculate the vertical layout data.
    final verticalLayoutData = calculateVerticalLayoutData(size);

    // Now split the events into the different people.
    final verticalData = <Person, List<VerticalLayoutData>>{};
    for (var event in verticalLayoutData) {
      final data = events.elementAt(event.id);
      if (data is Event) {
        final person = data.person;
        verticalData.putIfAbsent(person, () => []).add(event);
      }
    }

    // Calculate the space available for each person.
    final space = Size(size.width / people.length, size.height);

    for (final (i, person) in people.indexed) {
      final rect = Rect.fromLTWH(i * space.width, 0, space.width, space.height);
      performGroupLayout(verticalData[person] ?? [], rect);
    }
  }

  /// Places one person's events side by side within [rect].
  void performGroupLayout(List<VerticalLayoutData> verticalLayoutData, Rect rect) {
    final byId = {for (final data in verticalLayoutData) data.id: data};
    // Every event is placed, including culled ones, so an on-screen tile keeps its column when an overlapping
    // partner is off-screen.
    for (final placement in SideBySideLayoutDelegate.arrange(verticalLayoutData)) {
      final id = placement.id;
      if (!hasChild(id)) continue;
      final data = byId[id]!;
      final (:left, :width) = placement.horizontal(rect.width);
      layoutChild(id, BoxConstraints.tightFor(width: width, height: data.height));
      positionChild(id, Offset(rect.left + left, data.top));
    }
  }
}

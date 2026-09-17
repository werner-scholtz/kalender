// This file is part of kalender.
//
// SPDX-FileCopyrightText: 2023 Klarälvdalens Datakonsult AB, a KDAB Group company <info@kdab.com>
//
// SPDX-License-Identifier: MIT

/// A range between two [DateTime]s. `FloatingDateTimeRange.forLocation` converts to it,
/// `FloatingDateTimeRange.fromDateTimeRange` back.
///
/// {@category Dates and times}
final class KalenderDateTimeRange {
  KalenderDateTimeRange({required this.start, required this.end}) : assert(!start.isAfter(end));

  /// The start of the range.
  final DateTime start;

  /// The end of the range.
  final DateTime end;

  /// The [Duration] between [start] and [end].
  Duration get duration => end.difference(start);

  @override
  bool operator ==(Object other) => other is KalenderDateTimeRange && other.start == start && other.end == end;

  @override
  int get hashCode => Object.hash(start, end);

  @override
  String toString() => '$start - $end';
}

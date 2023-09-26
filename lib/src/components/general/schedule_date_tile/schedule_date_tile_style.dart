import 'package:flutter/material.dart';

/// The [ScheduleDateTile] class is used by the default [WeekNumber] widget.
class ScheduleDateTileStyle {
  const ScheduleDateTileStyle({
    this.margin = const EdgeInsets.symmetric(vertical: 4),
    this.datePadding = const EdgeInsets.symmetric(horizontal: 8),
    this.tilePadding = const EdgeInsets.symmetric(horizontal: 8),
  });

  /// The padding around the [ScheduleDateTile].
  final EdgeInsetsGeometry? margin;

  /// The padding around the date in the [ScheduleDateTile].
  final EdgeInsetsGeometry? datePadding;

  /// The padding around the date in the [ScheduleDateTile].
  final EdgeInsetsGeometry? tilePadding;
}

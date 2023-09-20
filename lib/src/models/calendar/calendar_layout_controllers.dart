import 'package:flutter/material.dart';
import 'package:kalender/src/models/tile_layout_controllers/day_tile_layout_controller/day_tile_layout_controller.dart';
import 'package:kalender/src/models/tile_layout_controllers/day_tile_layout_controller/default_day_tile_layout_controller.dart';
import 'package:kalender/src/models/tile_layout_controllers/month_tile_layout_controller/default_month_tile_layout_controller.dart';
import 'package:kalender/src/models/tile_layout_controllers/month_tile_layout_controller/month_tile_layout_controller.dart';
import 'package:kalender/src/models/tile_layout_controllers/multi_day_layout_controller/default_multi_day_layout_controller.dart';
import 'package:kalender/src/models/tile_layout_controllers/multi_day_layout_controller/multi_day_layout_controller.dart';
import 'package:kalender/src/type_definitions.dart';

/// The [CalendarLayoutControllers] class contains layout controllers used by the calendar view.
class CalendarLayoutControllers<T> {
  CalendarLayoutControllers({
    DayLayoutController<T>? dayTileLayoutController,
    MultiDayLayoutController<T>? multiDayTileLayoutController,
    MonthLayoutController<T>? monthTileLayoutController,
  }) {
    this.dayTileLayoutController =
        dayTileLayoutController ?? defaultDayTileLayoutController;

    this.multiDayTileLayoutController =
        multiDayTileLayoutController ?? defaultMultiDayTileLayoutController;

    this.monthTileLayoutController =
        monthTileLayoutController ?? defaultMonthTileLayoutController;
  }

  /// The [DayLayoutController] used to layout the day tiles.
  late DayLayoutController<T> dayTileLayoutController;

  /// The [MultiDayLayoutController] used to layout the multiday tiles.
  late MultiDayLayoutController<T> multiDayTileLayoutController;

  /// The [MonthLayoutController] used to layout the month tiles.
  late MonthLayoutController<T> monthTileLayoutController;

  /// The default [DayLayoutController] used to layout the day tiles.
  DayTileLayoutControllerOLD<T> defaultDayTileLayoutController({
    required DateTimeRange visibleDateRange,
    required List<DateTime> visibleDates,
    required double heightPerMinute,
    required double dayWidth,
  }) {
    return DefaultDayTileLayoutController<T>(
      visibleDateRange: visibleDateRange,
      visibleDates: visibleDates,
      heightPerMinute: heightPerMinute,
      dayWidth: dayWidth,
    );
  }

  /// The default [MultiDayLayoutController] used to layout the multiday tiles.
  MultiDayTileLayoutController<T> defaultMultiDayTileLayoutController({
    required DateTimeRange visibleDateRange,
    required double dayWidth,
    required double tileHeight,
  }) {
    return DefaultMultidayLayoutController<T>(
      visibleDateRange: visibleDateRange,
      dayWidth: dayWidth,
      tileHeight: tileHeight,
    );
  }

  /// The default [MonthLayoutController] used to layout the month tiles.
  MonthTileLayoutController<T> defaultMonthTileLayoutController({
    required DateTimeRange visibleDateRange,
    required double cellWidth,
    required double tileHeight,
  }) {
    return DefaultMonthTileLayoutController<T>(
      visibleDateRange: visibleDateRange,
      cellWidth: cellWidth,
      tileHeight: tileHeight,
    );
  }

  @override
  operator ==(Object other) {
    return other is CalendarLayoutControllers &&
        other.dayTileLayoutController == dayTileLayoutController &&
        other.multiDayTileLayoutController == multiDayTileLayoutController &&
        other.monthTileLayoutController == monthTileLayoutController;
  }

  @override
  int get hashCode => Object.hash(
        dayTileLayoutController,
        multiDayTileLayoutController,
        monthTileLayoutController,
      );

  CalendarLayoutControllers<T> copyWith({
    DayLayoutController<T>? dayTileLayoutController,
    MultiDayLayoutController<T>? multiDayTileLayoutController,
    MonthLayoutController<T>? monthTileLayoutController,
  }) {
    return CalendarLayoutControllers<T>(
      dayTileLayoutController: dayTileLayoutController,
      multiDayTileLayoutController: multiDayTileLayoutController,
      monthTileLayoutController: monthTileLayoutController,
    );
  }
}

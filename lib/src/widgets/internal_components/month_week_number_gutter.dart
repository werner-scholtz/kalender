import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:kalender/kalender.dart';
import 'package:kalender/src/models/providers/calendar_provider.dart';

class MonthWeekNumberGutter extends StatelessWidget {
  final InternalDateTimeRange visibleRange;
  final int numberOfRows;
  final WeekNumberBuilder weekNumberBuilder;
  final WeekNumberStyle? weekNumberStyle;
  final BorderSide dividerSide;

  const MonthWeekNumberGutter({
    super.key,
    required this.visibleRange,
    required this.numberOfRows,
    required this.weekNumberBuilder,
    required this.weekNumberStyle,
    required this.dividerSide,
  });

  @override
  Widget build(BuildContext context) {
    return IntrinsicWidth(
      child: Column(
        children: List.generate(
          numberOfRows,
          (index) {
            final range = _rangeForRow(index);
            return Expanded(
              child: DecoratedBox(
                decoration: BoxDecoration(
                  border: Border(
                    top: index == 0 ? dividerSide : BorderSide.none,
                    bottom: dividerSide,
                  ),
                ),
                child: weekNumberBuilder(
                  range.forLocation(location: context.location),
                  weekNumberStyle,
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  InternalDateTimeRange _rangeForRow(int index) {
    final start = visibleRange.start.add(Duration(days: index * DateTime.daysPerWeek));
    return InternalDateTimeRange(start: start, end: start.add(const Duration(days: DateTime.daysPerWeek)));
  }
}

class MonthWeekNumberSpacer extends StatelessWidget {
  final InternalDateTimeRange visibleRange;
  final int numberOfRows;
  final WeekNumberBuilder weekNumberBuilder;
  final WeekNumberStyle? weekNumberStyle;

  const MonthWeekNumberSpacer({
    super.key,
    required this.visibleRange,
    required this.numberOfRows,
    required this.weekNumberBuilder,
    required this.weekNumberStyle,
  });

  @override
  Widget build(BuildContext context) {
    return _WidthOnly(
      child: IntrinsicWidth(
        child: Stack(
          children: List.generate(
            numberOfRows,
            (index) {
              final start = visibleRange.start.add(Duration(days: index * DateTime.daysPerWeek));
              final range = InternalDateTimeRange(
                start: start,
                end: start.add(const Duration(days: DateTime.daysPerWeek)),
              );

              return weekNumberBuilder(
                range.forLocation(location: context.location),
                weekNumberStyle,
              );
            },
          ),
        ),
      ),
    );
  }
}

class _WidthOnly extends SingleChildRenderObjectWidget {
  const _WidthOnly({required super.child});

  @override
  RenderObject createRenderObject(BuildContext context) => _RenderWidthOnly();
}

class _RenderWidthOnly extends RenderProxyBox {
  @override
  void performLayout() {
    child?.layout(constraints, parentUsesSize: true);
    final childWidth = child?.size.width ?? 0;
    size = constraints.constrain(Size(childWidth, 0));
  }

  @override
  void paint(PaintingContext context, Offset offset) {}
}

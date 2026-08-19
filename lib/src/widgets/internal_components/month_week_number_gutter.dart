import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:kalender/kalender.dart';
import 'package:kalender/src/models/providers/calendar_provider.dart';
import 'package:kalender/src/models/providers/gutter_styles.dart';

/// The month grid puts the week number at the top of its row rather than
/// centring it, which is where every other week number sits.
const _monthWeekNumberDefaults = WeekNumberStyle(alignment: Alignment.topCenter);

/// The style the month week number is drawn with.
///
/// [KalenderThemeData.weekNumberStyle] wins over the top alignment. It comes from
/// [GutterStyles], resolved above both the header and the body, so the gutter and
/// the header's spacer always measure the same width.
WeekNumberStyle _resolveStyle(BuildContext context) {
  final shared = GutterStyles.of(context).weekNumberStyle;
  // Read outside the assert so the widget depends on the theme in release builds
  // too, then compared inside it so the warning costs nothing when shipped.
  final scoped = KalenderTheme.of(context).weekNumberStyle;
  assert(debugCheckGutterStyleReaches(field: 'weekNumberStyle', shared: shared, scoped: scoped));
  return _monthWeekNumberDefaults.merge(shared);
}

class MonthWeekNumberGutter extends StatelessWidget {
  final InternalDateTimeRange visibleRange;
  final int numberOfRows;
  final WeekNumberBuilder weekNumberBuilder;
  final BorderSide dividerSide;

  const MonthWeekNumberGutter({
    super.key,
    required this.visibleRange,
    required this.numberOfRows,
    required this.weekNumberBuilder,
    required this.dividerSide,
  });

  @override
  Widget build(BuildContext context) {
    return KalenderTheme(
      data: KalenderTheme.of(context).copyWith(weekNumberStyle: _resolveStyle(context)),
      child: IntrinsicWidth(
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
                  child: Builder(
                    builder: (context) => weekNumberBuilder(context, range.forLocation(location: context.location)),
                  ),
                ),
              );
            },
          ),
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

  const MonthWeekNumberSpacer({
    super.key,
    required this.visibleRange,
    required this.numberOfRows,
    required this.weekNumberBuilder,
  });

  @override
  Widget build(BuildContext context) {
    return KalenderTheme(
      data: KalenderTheme.of(context).copyWith(weekNumberStyle: _resolveStyle(context)),
      child: _WidthOnly(
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

                return Builder(
                  builder: (context) => weekNumberBuilder(context, range.forLocation(location: context.location)),
                );
              },
            ),
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

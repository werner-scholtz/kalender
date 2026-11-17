// This file is part of kalender.
//
// SPDX-FileCopyrightText: 2023 Klarälvdalens Datakonsult AB, a KDAB Group company <info@kdab.com>
//
// SPDX-License-Identifier: MIT

import 'package:flutter/widgets.dart';
import 'package:kalender/src/models/controllers/kalender_controller.dart';
import 'package:kalender/src/models/floating_date_time.dart';
import 'package:kalender/src/models/providers/kalender_provider.dart';
import 'package:kalender/src/theme/kalender_theme.dart';
import 'package:kalender/src/widgets/components/day_cell.dart';

/// Builds [builder] with whether [date] is in [KalenderController.selectedRange].
///
/// Rebuilds only when that changes for [date], not on every change of the selection.
class DaySelectionBuilder extends StatefulWidget {
  const DaySelectionBuilder({super.key, required this.date, required this.builder});

  final FloatingDateTime date;

  final Widget Function(BuildContext context, bool isSelected) builder;

  @override
  State<DaySelectionBuilder> createState() => _DaySelectionBuilderState();
}

class _DaySelectionBuilderState extends State<DaySelectionBuilder> {
  KalenderController? _controller;
  var _isSelected = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final controller = context.kalenderController;
    if (controller == _controller) return;
    _controller?.selectedRange.removeListener(_onSelectionChanged);
    _controller = controller..selectedRange.addListener(_onSelectionChanged);
    _isSelected = _computeIsSelected();
  }

  @override
  void didUpdateWidget(DaySelectionBuilder oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.date != widget.date) _isSelected = _computeIsSelected();
  }

  @override
  void dispose() {
    _controller?.selectedRange.removeListener(_onSelectionChanged);
    super.dispose();
  }

  bool _computeIsSelected() => _controller!.isDateSelected(widget.date);

  void _onSelectionChanged() {
    final isSelected = _computeIsSelected();
    if (isSelected != _isSelected) setState(() => _isSelected = isSelected);
  }

  @override
  Widget build(BuildContext context) => widget.builder(context, _isSelected);
}

/// The background of a day cell that has no builder: [DayCellStyle.selectedColor] when [isSelected], nothing otherwise.
class DefaultDayCell extends StatelessWidget {
  const DefaultDayCell({super.key, required this.isSelected});

  final bool isSelected;

  @override
  Widget build(BuildContext context) {
    final color = isSelected ? KalenderTheme.of(context).dayCellStyle?.selectedColor : null;
    return color == null ? const SizedBox.shrink() : ColoredBox(color: color);
  }
}

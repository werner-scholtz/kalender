// This file is part of kalender.
//
// SPDX-FileCopyrightText: 2023 Klarälvdalens Datakonsult AB, a KDAB Group company <info@kdab.com>
//
// SPDX-License-Identifier: MIT

import 'dart:math' as math;

import 'package:flutter/rendering.dart';
import 'package:flutter/widgets.dart';
import 'package:linked_pageview/linked_pageview.dart';

/// Thanks to https://gist.github.com/andrzejchm for https://gist.github.com/andrzejchm/02c1728b6f31a69fde2fb4e10b636060
/// Modified to fit the needs of the calendar header.
class ExpandablePageView extends StatefulWidget {
  final int itemCount;
  final Widget Function(BuildContext context, int index) itemBuilder;
  final LinkedPageController controller;

  const ExpandablePageView({super.key, required this.controller, required this.itemCount, required this.itemBuilder});

  @override
  State<ExpandablePageView> createState() => _ExpandablePageViewState();
}

/// The height used until the first item has been measured.
const double _defaultItemHeight = 80;

class _ExpandablePageViewState extends State<ExpandablePageView> {
  /// The measured heights of the items in the page view, null for an item not measured yet.
  late List<double?> _heights;

  /// The height of the item measured last, null until one has been measured.
  double? _lastMeasuredHeight;

  /// Whether the next height change applies without the animation.
  bool _skipAnimation = false;

  /// The index of the first page currently within the viewport.
  int _firstVisiblePage = 0;

  /// The index of the last page within the viewport, equal to [_firstVisiblePage] when one page fills it.
  int _lastVisiblePage = 0;

  /// The height of the tallest measured page within the viewport.
  ///
  /// Falls back to [_lastMeasuredHeight] when no visible page has been measured, and to [_defaultItemHeight] before any
  /// page has been measured.
  double get _visibleHeight {
    final fallback = _lastMeasuredHeight ?? _defaultItemHeight;
    if (_heights.isEmpty) return fallback;
    final lo = _firstVisiblePage.clamp(0, _heights.length - 1);
    final hi = _lastVisiblePage.clamp(0, _heights.length - 1);
    final measured = _heights.getRange(lo, hi + 1).nonNulls;
    return measured.isEmpty ? fallback : measured.reduce(math.max);
  }

  /// Computes the inclusive range of page indices currently in the viewport.
  ///
  /// A fractional page position means a transition is in progress, so one extra trailing page is partially visible and
  /// must be included.
  (int, int) _computeVisibleRange() {
    final visibleCount = (1 / widget.controller.viewportFraction).round().clamp(1, widget.itemCount);
    final page = widget.controller.hasClients ? widget.controller.page : null;
    final basePage = page ?? widget.controller.initialPage.toDouble();
    final first = basePage.floor();
    final transitioning = basePage != basePage.floorToDouble();
    final last = first + visibleCount - 1 + (transitioning ? 1 : 0);
    return (first, last);
  }

  bool _updateVisibleRange() {
    final (first, last) = _computeVisibleRange();
    if (first == _firstVisiblePage && last == _lastVisiblePage) return false;
    _firstVisiblePage = first;
    _lastVisiblePage = last;
    return true;
  }

  @override
  void initState() {
    super.initState();
    _heights = List.filled(widget.itemCount, null, growable: true);
    _updateVisibleRange();
    widget.controller.addListener(_onScroll);
  }

  @override
  void didUpdateWidget(covariant ExpandablePageView oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.controller != widget.controller) {
      oldWidget.controller.removeListener(_onScroll);
      widget.controller.addListener(_onScroll);
    }
    if (oldWidget.itemCount != widget.itemCount) {
      _heights = List.filled(widget.itemCount, null, growable: true);
    }
    _updateVisibleRange();
  }

  @override
  void dispose() {
    widget.controller.removeListener(_onScroll);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final duration = _skipAnimation ? Duration.zero : const Duration(milliseconds: 100);
    _skipAnimation = false;
    return TweenAnimationBuilder<double>(
      curve: Curves.easeInOutCubic,
      tween: Tween<double>(begin: _visibleHeight, end: _visibleHeight),
      duration: duration,
      builder: (context, value, child) => SizedBox(height: value, child: child),
      child: LinkedPageView.builder(
        key: ObjectKey(widget.controller),
        padEnds: false,
        controller: widget.controller,
        itemCount: widget.itemCount,
        itemBuilder: _itemBuilder,
      ),
    );
  }

  Widget _itemBuilder(BuildContext context, int index) {
    final item = widget.itemBuilder(context, index);
    return OverflowBox(
      minHeight: 0,
      maxHeight: double.infinity,
      alignment: Alignment.topCenter,
      child: _SizeReporter(
        onSizeChanged: (size) {
          final first = _lastMeasuredHeight == null;
          _lastMeasuredHeight = size.height;
          // Rebuild only when the height changed.
          if (_heights[index] == size.height) return;
          setState(() {
            _skipAnimation = _skipAnimation || first;
            _heights[index] = size.height;
          });
        },
        child: item,
      ),
    );
  }

  /// Rebuilds when the set of pages in the viewport changes so [_visibleHeight] tracks the tallest visible page as the
  /// user scrolls.
  void _onScroll() {
    if (_updateVisibleRange()) setState(() {});
  }
}

/// Reports its child's size after layout using a custom [RenderProxyBox].
///
/// The size is read in `performLayout`, the only point in the pipeline where the render object is guaranteed to have a
/// valid size.
class _SizeReporter extends SingleChildRenderObjectWidget {
  final ValueChanged<Size> onSizeChanged;

  const _SizeReporter({required this.onSizeChanged, required super.child});

  @override
  RenderObject createRenderObject(BuildContext context) => _RenderSizeReporter(onSizeChanged);

  @override
  void updateRenderObject(BuildContext context, _RenderSizeReporter renderObject) {
    renderObject.onSizeChanged = onSizeChanged;
  }
}

class _RenderSizeReporter extends RenderProxyBox {
  _RenderSizeReporter(this.onSizeChanged);

  ValueChanged<Size> onSizeChanged;
  Size? _previousSize;

  @override
  void performLayout() {
    super.performLayout();
    final newSize = size;
    if (_previousSize != newSize) {
      _previousSize = newSize;
      // Defer the callback to avoid triggering setState during layout.
      WidgetsBinding.instance.addPostFrameCallback((_) => onSizeChanged(newSize));
    }
  }
}

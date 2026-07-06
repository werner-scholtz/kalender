import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:linked_pageview/linked_pageview.dart';

/// Thanks to https://gist.github.com/andrzejchm for https://gist.github.com/andrzejchm/02c1728b6f31a69fde2fb4e10b636060
/// Modified to fit the needs of the calendar header.
class ExpandablePageView extends StatefulWidget {
  final int itemCount;
  final Widget Function(BuildContext context, int index) itemBuilder;
  final LinkedPageController controller;

  const ExpandablePageView({
    super.key,
    required this.controller,
    required this.itemCount,
    required this.itemBuilder,
  });

  @override
  State<ExpandablePageView> createState() => _ExpandablePageViewState();
}

/// The height used for an item until its real height has been measured.
const double _defaultItemHeight = 80;

class _ExpandablePageViewState extends State<ExpandablePageView> {
  /// The heights of the items in the page view.
  late List<double> _heights;

  /// The index of the first page currently within the viewport.
  late int _firstVisiblePage;

  /// The index of the last page currently within the viewport.
  ///
  /// When [LinkedPageController.viewportFraction] is `1.0` this equals
  /// [_firstVisiblePage] while settled, so only the current page drives the
  /// height. For a fractional viewport (e.g. free-scroll, where several days
  /// are visible at once) it spans every page in view, so the tallest of them
  /// sets the height instead of the header clipping the busier days.
  late int _lastVisiblePage;

  /// The height needed to fit the tallest page currently in the viewport.
  ///
  /// Seeded from the first visible page's own height (not the default) so a
  /// single visible page shorter than [_defaultItemHeight] keeps its measured
  /// height rather than being floored up to the placeholder value.
  double get _visibleHeight {
    if (_heights.isEmpty) return _defaultItemHeight;
    final lo = _firstVisiblePage.clamp(0, _heights.length - 1);
    final hi = _lastVisiblePage.clamp(0, _heights.length - 1);
    var height = _heights[lo];
    for (var i = lo + 1; i <= hi; i++) {
      if (_heights[i] > height) height = _heights[i];
    }
    return height;
  }

  /// Computes the inclusive range of page indices currently in the viewport.
  ///
  /// A fractional page position means a transition is in progress, so one extra
  /// trailing page is partially visible and must be included.
  (int, int) _computeVisibleRange() {
    final visibleCount = (1 / widget.controller.viewportFraction).round().clamp(1, widget.itemCount);
    final page = widget.controller.hasClients ? widget.controller.page : null;
    final basePage = page ?? widget.controller.initialPage.toDouble();
    final first = basePage.floor();
    final transitioning = basePage != basePage.floorToDouble();
    final last = first + visibleCount - 1 + (transitioning ? 1 : 0);
    return (first, last);
  }

  @override
  void initState() {
    super.initState();
    // Initialize the heights with a default value.
    _heights = List.filled(widget.itemCount, _defaultItemHeight, growable: true);

    final (first, last) = _computeVisibleRange();
    _firstVisiblePage = first;
    _lastVisiblePage = last;
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
      _heights = List.filled(widget.itemCount, _defaultItemHeight, growable: true);
    }
    final (first, last) = _computeVisibleRange();
    _firstVisiblePage = first;
    _lastVisiblePage = last;
  }

  @override
  void dispose() {
    widget.controller.removeListener(_onScroll);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return TweenAnimationBuilder<double>(
      curve: Curves.easeInOutCubic,
      tween: Tween<double>(begin: _visibleHeight, end: _visibleHeight),
      duration: const Duration(milliseconds: 100),
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
          // Only rebuild if the height actually changed to avoid layout thrashing.
          if (_heights[index] != size.height) {
            setState(() => _heights[index] = size.height);
          }
        },
        child: item,
      ),
    );
  }

  /// Rebuilds when the set of pages in the viewport changes so [_visibleHeight]
  /// tracks the tallest visible page as the user scrolls.
  void _onScroll() {
    final (first, last) = _computeVisibleRange();
    if (first != _firstVisiblePage || last != _lastVisiblePage) {
      setState(() {
        _firstVisiblePage = first;
        _lastVisiblePage = last;
      });
    }
  }
}

/// Reports its child's size after layout using a custom [RenderProxyBox].
///
/// Unlike approaches that read size via [GlobalKey] in a post-frame callback,
/// this reads the child's size directly in [performLayout] — the only point in
/// the pipeline where the render object is guaranteed to have a valid size.
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

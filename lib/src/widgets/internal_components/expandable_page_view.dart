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

class _ExpandablePageViewState extends State<ExpandablePageView> {
  /// The heights of the items in the page view.
  late List<double> _heights;

  /// The current page of the page view.
  late int _currentPage;

  /// The current height of the page view.
  double get _currentHeight => _heights.elementAtOrNull(_currentPage) ?? 80;

  @override
  void initState() {
    super.initState();
    // Initialize the heights with a default value.
    _heights = List.filled(widget.itemCount, 80, growable: true);

    _currentPage = widget.controller.initialPage;
    widget.controller.addListener(_updatePage);
  }

  @override
  void didUpdateWidget(covariant ExpandablePageView oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.controller != widget.controller) {
      oldWidget.controller.removeListener(_updatePage);
      _currentPage = widget.controller.initialPage;
      widget.controller.addListener(_updatePage);
    }
    if (oldWidget.itemCount != widget.itemCount) {
      _heights = List.filled(widget.itemCount, 80, growable: true);
      _currentPage = widget.controller.initialPage;
    }
  }

  @override
  void dispose() {
    widget.controller.removeListener(_updatePage);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return TweenAnimationBuilder<double>(
      curve: Curves.easeInOutCubic,
      tween: Tween<double>(begin: _heights.first, end: _currentHeight),
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

  void _updatePage() {
    final newPage = widget.controller.page!.round();
    if (_currentPage != newPage) {
      setState(() {
        _currentPage = newPage;
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

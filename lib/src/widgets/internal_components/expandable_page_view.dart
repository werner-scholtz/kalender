import 'package:flutter/material.dart';

/// Thanks to https://gist.github.com/andrzejchm for https://gist.github.com/andrzejchm/02c1728b6f31a69fde2fb4e10b636060
/// Modified to fit the needs of the calendar header.
class ExpandablePageView extends StatefulWidget {
  final int itemCount;
  final Widget Function(BuildContext context, int index) itemBuilder;
  final PageController controller;

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
  double get _currentHeight => _heights[_currentPage];

  @override
  void initState() {
    super.initState();
    // Initialize the heights with a default value.
    _heights = List.filled(widget.itemCount, 80, growable: true);

    _currentPage = widget.controller.initialPage;
    widget.controller.addListener(_updatePage);
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
      child: PageView.builder(
        padEnds: false,
        controller: widget.controller,
        itemCount: widget.itemCount,
        itemBuilder: _itemBuilder,
        physics: const NeverScrollableScrollPhysics(),
      ),
    );
  }

  Widget _itemBuilder(BuildContext context, int index) {
    final item = widget.itemBuilder(context, index);
    return OverflowBox(
      minHeight: 0,
      maxHeight: double.infinity,
      alignment: Alignment.topCenter,
      child: SizeReportingWidget(
        onSizeChange: (size) => setState(() => _heights[index] = size.height),
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

/// This widget reports its size to the parent widget.
class SizeReportingWidget extends StatefulWidget {
  /// The child widget.
  final Widget child;

  /// The callback that is called when the size of the widget changes.
  final ValueChanged<Size> onSizeChange;

  const SizeReportingWidget({
    super.key,
    required this.child,
    required this.onSizeChange,
  });

  @override
  State<SizeReportingWidget> createState() => _SizeReportingWidgetState();
}

class _SizeReportingWidgetState extends State<SizeReportingWidget> {
  /// The key of the widget.
  final _widgetKey = GlobalKey();

  /// The old size of the widget.
  Size? _oldSize;

  @override
  Widget build(BuildContext context) {
    // Notify the parent widget about the size after the first frame.
    WidgetsBinding.instance.addPostFrameCallback((_) => _notifySize());

    // Listen for size changes.
    return NotificationListener<SizeChangedLayoutNotification>(
      onNotification: (_) {
        WidgetsBinding.instance.addPostFrameCallback((_) => _notifySize());
        return true;
      },
      child: SizeChangedLayoutNotifier(
        child: Container(
          key: _widgetKey,
          child: widget.child,
        ),
      ),
    );
  }

  void _notifySize() {
    final context = _widgetKey.currentContext;
    if (context == null) return;
    final size = context.size;

    // Notify the parent widget if the size has changed.
    if (_oldSize != size && size != null) {
      _oldSize = size;
      widget.onSizeChange(size);
    }
  }
}

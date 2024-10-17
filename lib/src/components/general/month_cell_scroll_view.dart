import 'package:flutter/material.dart';

class MonthCellScrollView extends StatefulWidget {
  const MonthCellScrollView({super.key, required this.child});

  final Widget child;

  @override
  State<MonthCellScrollView> createState() => _MonthCellScrollViewState();
}

class _MonthCellScrollViewState extends State<MonthCellScrollView> {
  double _stopStart = 0;
  double _stopEnd = 1;
  final double overlayHeight = 10;
  final ScrollController _scrollController = ScrollController();

  @override
  Widget build(BuildContext context) {
    return NotificationListener<ScrollNotification>(
      onNotification: (scrollNotification) {
        if (mounted) {
          WidgetsBinding.instance.addPostFrameCallback((_) {
            setState(() {
              _stopStart = scrollNotification.metrics.pixels / overlayHeight;
              _stopEnd = (scrollNotification.metrics.maxScrollExtent -
                      scrollNotification.metrics.pixels) /
                  overlayHeight;

              _stopStart = _stopStart.clamp(0.0, 1.0);
              _stopEnd = _stopEnd.clamp(0.0, 1.0);
            });
          });
        }

        return true;
      },
      child: ShaderMask(
        shaderCallback: (rect) {
          return LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: <Color>[
              Theme.of(context).colorScheme.surface,
              Colors.transparent,
              Colors.transparent,
              Theme.of(context).colorScheme.surface,
            ],
            stops: <double>[0.0, 0.05 * _stopStart, 1 - 0.05 * _stopEnd, 1.0],
          ).createShader(rect);
        },
        blendMode: BlendMode.dstOut,
        child: Scrollbar(
          controller: _scrollController,
          thumbVisibility: true,
          child: SingleChildScrollView(
            controller: _scrollController,
            child: widget.child,
          ),
        ),
      ),
    );
  }
}

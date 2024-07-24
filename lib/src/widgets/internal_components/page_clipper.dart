import 'package:flutter/material.dart';

/// A widget that clips the child widget a certain distance from the left.
class PageClipWidget extends StatelessWidget {
  final double timelineWidth;
  final Widget child;
  const PageClipWidget({super.key, required this.timelineWidth, required this.child});

  @override
  Widget build(BuildContext context) {
    return ClipRect(
      clipper: PageClipper(timelineWidth),
      child: child,
    );
  }
}

class PageClipper extends CustomClipper<Rect> {
  final double timelineWidth;
  const PageClipper(this.timelineWidth);

  @override
  Rect getClip(Size size) {
    return Rect.fromLTRB(timelineWidth, 0, size.width, size.height);
  }

  @override
  bool shouldReclip(CustomClipper<Rect> oldClipper) => false;
}

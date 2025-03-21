import 'package:flutter/material.dart';

/// A widget that clips the child widget a certain distance from the left.
class PageClipWidget extends StatelessWidget {
  final double start;
  final Widget child;
  const PageClipWidget({super.key, required this.start, required this.child});

  @override
  Widget build(BuildContext context) {
    return ClipRect(clipper: PageClipper(start, Directionality.of(context)), child: child);
  }
}

/// A custom clipper that will clip a given value on the left.
class PageClipper extends CustomClipper<Rect> {
  final double start;
  final TextDirection textDirection;
  const PageClipper(this.start, this.textDirection);

  @override
  Rect getClip(Size size) {
    if (textDirection == TextDirection.ltr) {
      return Rect.fromLTRB(start, 0, size.width, size.height);
    } else {
      return Rect.fromLTRB(0, 0, size.width - start, size.height);
    }
  }

  @override
  bool shouldReclip(CustomClipper<Rect> oldClipper) => false;
}

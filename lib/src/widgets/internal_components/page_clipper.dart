import 'package:flutter/material.dart';

/// A widget that clips the child widget a certain distance from the left.
class PageClipWidget extends StatelessWidget {
  final double left;
  final Widget child;
  const PageClipWidget({super.key, required this.left, required this.child});

  @override
  Widget build(BuildContext context) {
    return ClipRect(clipper: PageClipper(left), child: child);
  }
}

/// A custom clipper that will clip a given value on the left.
class PageClipper extends CustomClipper<Rect> {
  final double left;
  const PageClipper(this.left);

  @override
  Rect getClip(Size size) {
    return Rect.fromLTRB(left, 0, size.width, size.height);
  }

  @override
  bool shouldReclip(CustomClipper<Rect> oldClipper) => false;
}

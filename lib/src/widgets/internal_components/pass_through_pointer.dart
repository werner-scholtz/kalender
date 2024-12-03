import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';

/// A widget that allows all pointer events to passthrough.
class PassThroughPointer extends SingleChildRenderObjectWidget {
  const PassThroughPointer({required super.child, super.key});

  @override
  RenderPassThroughPointer createRenderObject(BuildContext context) => RenderPassThroughPointer();
}

class RenderPassThroughPointer extends RenderProxyBox {
  RenderPassThroughPointer({RenderBox? child}) : super(child);

  @override
  bool hitTest(BoxHitTestResult result, {required Offset position}) => false;
}

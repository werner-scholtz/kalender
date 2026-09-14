// This file is part of kalender.
//
// SPDX-FileCopyrightText: 2023 Klarälvdalens Datakonsult AB, a KDAB Group company <info@kdab.com>
//
// SPDX-License-Identifier: MIT

import 'package:flutter/rendering.dart';
import 'package:flutter/widgets.dart';

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

// This file is part of kalender.
//
// SPDX-FileCopyrightText: 2023 Klarälvdalens Datakonsult AB, a KDAB Group company <info@kdab.com>
//
// SPDX-License-Identifier: MIT

import 'package:flutter/rendering.dart' hide ViewConfiguration;
import 'package:flutter/widgets.dart';
import 'package:kalender/kalender.dart';

/// Holds the render boxes of the [ViewSwitchArea]s in a view, and the transform of its [ViewSwitchColumns].
class ViewSwitchAreaHolder {
  final _boxes = <ViewSwitchAreaKind, RenderBox>{};

  /// The render box marked as [kind], when it is laid out.
  RenderBox? boxOf(ViewSwitchAreaKind kind) {
    final box = _boxes[kind];
    return box != null && box.attached && box.hasSize ? box : null;
  }

  final columns = ValueNotifier(ColumnTransform.identity);
}

/// Gives the [ViewSwitchArea] below it the holder to register with.
class ViewSwitchAreaScope extends InheritedWidget {
  final ViewSwitchAreaHolder? holder;

  const ViewSwitchAreaScope({super.key, required this.holder, required super.child});

  static ViewSwitchAreaHolder? maybeOf(BuildContext context) {
    return context.dependOnInheritedWidgetOfExactType<ViewSwitchAreaScope>()?.holder;
  }

  @override
  bool updateShouldNotify(ViewSwitchAreaScope oldWidget) => !identical(holder, oldWidget.holder);
}

/// The parts of a view that an animated switch animates.
enum ViewSwitchAreaKind {
  /// The body below the header.
  body,

  /// The day columns of a multi-day body.
  bodyColumns,

  /// The day columns of a multi-day header.
  headerColumns,
}

/// Marks the [kind] of area its child is.
class ViewSwitchArea extends SingleChildRenderObjectWidget {
  final ViewSwitchAreaKind kind;

  const ViewSwitchArea({super.key, required this.kind, super.child});

  @override
  RenderObject createRenderObject(BuildContext context) {
    return RenderViewSwitchArea(ViewSwitchAreaScope.maybeOf(context), kind);
  }

  @override
  void updateRenderObject(BuildContext context, RenderViewSwitchArea renderObject) {
    renderObject.holder = ViewSwitchAreaScope.maybeOf(context);
  }
}

class RenderViewSwitchArea extends RenderProxyBox {
  RenderViewSwitchArea(this._holder, this.kind);

  final ViewSwitchAreaKind kind;

  ViewSwitchAreaHolder? _holder;
  set holder(ViewSwitchAreaHolder? value) {
    if (identical(value, _holder)) return;
    _unregister();
    _holder = value;
    if (attached) _holder?._boxes[kind] = this;
  }

  void _unregister() {
    final holder = _holder;
    if (holder != null && identical(holder._boxes[kind], this)) holder._boxes.remove(kind);
  }

  @override
  void attach(PipelineOwner owner) {
    super.attach(owner);
    _holder?._boxes[kind] = this;
  }

  @override
  void detach() {
    _unregister();
    super.detach();
  }
}

/// Clips [child] to the area registered with [holder], or does not clip when it is null or holds no area.
///
/// With [align], the same area registered with it, inside [child], is moved onto the clip area. With [body], the area
/// is the body, else the day columns of the body and the header.
class ClipToViewSwitchArea extends SingleChildRenderObjectWidget {
  final ViewSwitchAreaHolder? holder;
  final ViewSwitchAreaHolder? align;
  final bool body;

  const ClipToViewSwitchArea({super.key, required this.holder, this.align, this.body = false, super.child});

  @override
  RenderObject createRenderObject(BuildContext context) => RenderClipToViewSwitchArea(holder, align, body: body);

  @override
  void updateRenderObject(BuildContext context, RenderClipToViewSwitchArea renderObject) {
    renderObject
      ..holder = holder
      ..align = align
      ..body = body;
  }
}

class RenderClipToViewSwitchArea extends RenderProxyBox {
  RenderClipToViewSwitchArea(this._holder, this._align, {required bool body}) : _body = body;

  bool _body;
  set body(bool value) {
    if (value == _body) return;
    _body = value;
    markNeedsPaint();
  }

  ViewSwitchAreaHolder? _holder;
  set holder(ViewSwitchAreaHolder? value) {
    if (identical(value, _holder)) return;
    _holder = value;
    markNeedsPaint();
  }

  ViewSwitchAreaHolder? _align;
  set align(ViewSwitchAreaHolder? value) {
    if (identical(value, _align)) return;
    _align = value;
    markNeedsPaint();
  }

  final _clipLayer = LayerHandle<ClipRectLayer>();

  /// The area of [holder]'s box in this box's coordinates, or null when it has none.
  Rect? _rectOf(RenderBox? box) {
    if (box == null) return null;
    return MatrixUtils.transformRect(box.getTransformTo(this), Offset.zero & box.size);
  }

  /// The clip area of [holder] in this box's coordinates, or null when it has none.
  Rect? _areaOf(ViewSwitchAreaHolder? holder) {
    if (_body) return _rectOf(holder?.boxOf(ViewSwitchAreaKind.body));
    final columns = _rectOf(holder?.boxOf(ViewSwitchAreaKind.bodyColumns));
    final header = _rectOf(holder?.boxOf(ViewSwitchAreaKind.headerColumns));
    if (columns == null || header == null) return columns;
    return columns.expandToInclude(header);
  }

  /// The area [align] is moved by, in this box's coordinates.
  Rect? _alignOf(ViewSwitchAreaHolder? holder) {
    return _rectOf(holder?.boxOf(_body ? ViewSwitchAreaKind.body : ViewSwitchAreaKind.bodyColumns));
  }

  @override
  void paint(PaintingContext context, Offset offset) {
    final area = _areaOf(_holder);
    if (area == null) {
      _clipLayer.layer = null;
      super.paint(context, offset);
      return;
    }
    final target = _alignOf(_holder);
    final own = _alignOf(_align);
    final shift = own == null || target == null ? Offset.zero : target.topLeft - own.topLeft;
    _clipLayer.layer = context.pushClipRect(
      needsCompositing,
      offset,
      area,
      (context, offset) => super.paint(context, offset + shift),
      oldLayer: _clipLayer.layer,
    );
  }

  @override
  void dispose() {
    _clipLayer.layer = null;
    super.dispose();
  }
}

/// A horizontal scale and shift of the day columns. [shift] is a fraction of the columns' width.
@immutable
class ColumnTransform {
  final double scale;
  final double shift;

  const ColumnTransform(this.scale, this.shift);

  static const identity = ColumnTransform(1, 0);

  @override
  bool operator ==(Object other) => other is ColumnTransform && other.scale == scale && other.shift == shift;

  @override
  int get hashCode => Object.hash(scale, shift);

  @override
  String toString() => 'ColumnTransform($scale, $shift)';
}

/// Lays out the day columns at the width and position the [ColumnTransform] of the [ViewSwitchAreaHolder] above it
/// gives, and clips them to their own bounds while it is not the identity.
///
/// The columns are laid out again at each step rather than scaled, so tiles and text keep their shape.
class ViewSwitchColumns extends SingleChildRenderObjectWidget {
  const ViewSwitchColumns({super.key, super.child});

  @override
  RenderObject createRenderObject(BuildContext context) {
    return RenderViewSwitchColumns(ViewSwitchAreaScope.maybeOf(context), Directionality.of(context));
  }

  @override
  void updateRenderObject(BuildContext context, RenderViewSwitchColumns renderObject) {
    renderObject
      ..holder = ViewSwitchAreaScope.maybeOf(context)
      ..textDirection = Directionality.of(context);
  }
}

class RenderViewSwitchColumns extends RenderProxyBox {
  RenderViewSwitchColumns(this._holder, this._textDirection);

  ViewSwitchAreaHolder? _holder;
  set holder(ViewSwitchAreaHolder? value) {
    if (identical(value, _holder)) return;
    if (attached) _holder?.columns.removeListener(markNeedsLayout);
    _holder = value;
    if (attached) _holder?.columns.addListener(markNeedsLayout);
    markNeedsLayout();
  }

  TextDirection _textDirection;
  set textDirection(TextDirection value) {
    if (value == _textDirection) return;
    _textDirection = value;
    markNeedsLayout();
  }

  ColumnTransform get _columns => _holder?.columns.value ?? ColumnTransform.identity;

  /// Where the columns start, measured from the left edge.
  double _dx = 0;

  final _clipLayer = LayerHandle<ClipRectLayer>();

  @override
  void attach(PipelineOwner owner) {
    super.attach(owner);
    _holder?.columns.addListener(markNeedsLayout);
  }

  @override
  void detach() {
    _holder?.columns.removeListener(markNeedsLayout);
    super.detach();
  }

  @override
  void performLayout() {
    final child = this.child;
    final columns = _columns;
    if (child == null || columns == ColumnTransform.identity) {
      _dx = 0;
      super.performLayout();
      return;
    }
    final width = constraints.maxWidth * columns.scale;
    child.layout(constraints.copyWith(minWidth: width, maxWidth: width), parentUsesSize: true);
    size = constraints.constrain(Size(constraints.maxWidth, child.size.height));
    _dx = switch (_textDirection) {
      TextDirection.ltr => columns.shift * size.width,
      TextDirection.rtl => size.width - width - columns.shift * size.width,
    };
  }

  @override
  void paint(PaintingContext context, Offset offset) {
    if (_columns == ColumnTransform.identity) {
      _clipLayer.layer = null;
      super.paint(context, offset);
      return;
    }
    _clipLayer.layer = context.pushClipRect(
      needsCompositing,
      offset,
      Offset.zero & size,
      (context, offset) => super.paint(context, offset + Offset(_dx, 0)),
      oldLayer: _clipLayer.layer,
    );
  }

  @override
  bool hitTestChildren(BoxHitTestResult result, {required Offset position}) {
    return result.addWithPaintOffset(
      offset: Offset(_dx, 0),
      position: position,
      hitTest: (result, position) => super.hitTestChildren(result, position: position),
    );
  }

  @override
  void applyPaintTransform(RenderBox child, Matrix4 transform) => transform.translateByDouble(_dx, 0, 0, 1);

  @override
  void dispose() {
    _clipLayer.layer = null;
    super.dispose();
  }
}

/// The column transforms that keep each date in the same place while one multi-day page turns into another.
class ColumnMorph {
  /// The scale of the outgoing columns at the end.
  final double _scale;

  /// The shift of the outgoing columns at the end, as a fraction of the width.
  final double _shift;

  /// The days from the outgoing page's first day to the incoming page's first day.
  final int _offset;
  final int _outgoingDays;

  const ColumnMorph._(this._scale, this._shift, this._offset, this._outgoingDays);

  /// The morph from the [outgoing] page to the [incoming] one, or null when the pages share no day or either view
  /// scrolls freely.
  static ColumnMorph? between(
    ViewConfiguration outgoing,
    FloatingDateTimeRange outgoingRange,
    ViewConfiguration incoming,
    FloatingDateTimeRange incomingRange,
  ) {
    if (outgoing is! MultiDayViewConfiguration || incoming is! MultiDayViewConfiguration) return null;
    if (outgoing.type == MultiDayViewType.freeScroll || incoming.type == MultiDayViewType.freeScroll) return null;
    final outgoingDays = outgoing.numberOfDays;
    final incomingDays = incoming.numberOfDays;
    final offset = incomingRange.start.startOfDay.difference(outgoingRange.start.startOfDay).inDays;
    if (offset >= outgoingDays || offset + incomingDays <= 0) return null;
    return ColumnMorph._(outgoingDays / incomingDays, -offset / incomingDays, offset, outgoingDays);
  }

  /// The outgoing columns at [t], from where they are at 0 to where the incoming page puts their dates at 1.
  ColumnTransform outgoingAt(double t) => ColumnTransform(1 + (_scale - 1) * t, _shift * t + 0.0);

  /// The incoming columns at [t], lined up with the outgoing columns at the same [t].
  ColumnTransform incomingAt(double t) {
    final start = 1 / _scale;
    return ColumnTransform(start + (1 - start) * t, _offset * (1 - t) / _outgoingDays + 0.0);
  }
}

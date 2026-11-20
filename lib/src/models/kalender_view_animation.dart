// This file is part of kalender.
//
// SPDX-FileCopyrightText: 2023 Klarälvdalens Datakonsult AB, a KDAB Group company <info@kdab.com>
//
// SPDX-License-Identifier: MIT

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:kalender/src/kalender_view.dart';

enum _Kind { fade, zoom }

/// How a [KalenderView] animates a switch to a view configuration with another `name`.
///
/// A configuration with the same name, such as a `copyWith` of the current one, replaces it without an animation.
/// The header of the incoming view shows at once, and only the bodies animate. Between two multi-day views, the day
/// columns move so each date stays in place, and the fade or zoom applies only to the outgoing columns. The outgoing
/// view stays on screen until the animation ends and does not take input. A change of location, or a
/// switch while the platform asks for reduced motion (`MediaQuery.disableAnimations`), does not animate.
///
/// {@category Views}
@immutable
class KalenderViewAnimation {
  /// Cross-fades the outgoing view into the incoming one.
  const KalenderViewAnimation.fade({this.duration = const Duration(milliseconds: 250), this.curve = Curves.easeInOut})
    : _kind = _Kind.fade;

  /// Fades the outgoing view out while it grows slightly, and fades the incoming view in while it grows to full size.
  const KalenderViewAnimation.zoom({this.duration = const Duration(milliseconds: 300), this.curve = Curves.easeInOut})
    : _kind = _Kind.zoom;

  final Duration duration;
  final Curve curve;
  final _Kind _kind;

  /// Wraps [child], the [incoming] or outgoing view, in the animation driven by [animation], which runs from 0 to 1.
  ///
  /// Without [zoom], a zoom only fades. The widget shape stays the same either way.
  @internal
  Widget build(Animation<double> animation, Widget child, {required bool incoming, bool zoom = true}) {
    final curved = animation.drive(CurveTween(curve: curve));
    final opacity = incoming ? curved : ReverseAnimation(curved);
    return switch (_kind) {
      _Kind.fade => FadeTransition(opacity: opacity, child: child),
      _Kind.zoom => FadeTransition(
        opacity: opacity,
        child: ScaleTransition(
          scale: zoom
              ? curved.drive(incoming ? Tween(begin: 0.92, end: 1.0) : Tween(begin: 1.0, end: 1.08))
              : kAlwaysCompleteAnimation,
          child: child,
        ),
      ),
    };
  }

  @override
  bool operator ==(Object other) {
    return other is KalenderViewAnimation && other._kind == _kind && other.duration == duration && other.curve == curve;
  }

  @override
  int get hashCode => Object.hash(_kind, duration, curve);
}

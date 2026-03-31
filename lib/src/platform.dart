import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

/// Check if the current platform is a mobile device.
bool get isMobileDevice =>
    defaultTargetPlatform == TargetPlatform.iOS || defaultTargetPlatform == TargetPlatform.android;

bool? _isTouchDevice;

/// Whether the device primarily uses touch input. Computed once and cached.
bool isTouchDevice(BuildContext context) => _isTouchDevice ??= _computeIsTouchDevice(context);

bool _computeIsTouchDevice(BuildContext context) {
  // On native platforms, platform identity is a reasonable proxy
  if (!kIsWeb) {
    return defaultTargetPlatform == TargetPlatform.iOS || defaultTargetPlatform == TargetPlatform.android;
  }
  // On web, check if primary pointer is coarse (touch)
  final data = MediaQuery.of(context);
  // hover-less devices are almost certainly touch-primary
  return !data.navigationMode.toString().contains('traditional') ||
      defaultTargetPlatform == TargetPlatform.iOS ||
      defaultTargetPlatform == TargetPlatform.android;
}

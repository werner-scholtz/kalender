import 'package:flutter/foundation.dart';

/// Check if the current platform is a mobile device.
bool get isMobileDevice {
  defaultTargetPlatform;
  return defaultTargetPlatform == TargetPlatform.android || defaultTargetPlatform == TargetPlatform.iOS;
}

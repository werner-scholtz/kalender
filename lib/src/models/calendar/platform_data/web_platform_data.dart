import 'package:flutter/foundation.dart';

class PlatformData {
  PlatformData({
    bool? isMobileDevice,
  }) {
    this.isMobileDevice = defaultTargetPlatform == TargetPlatform.android ||
        defaultTargetPlatform == TargetPlatform.iOS;
  }

  late bool isMobileDevice;

  @override
  operator ==(Object other) {
    return other is PlatformData && other.isMobileDevice == isMobileDevice;
  }

  @override
  int get hashCode => isMobileDevice.hashCode;
}

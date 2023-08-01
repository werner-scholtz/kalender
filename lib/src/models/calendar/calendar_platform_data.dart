import 'dart:io';

class PlatformData {
  PlatformData({
    bool? isMobileDevice,
  }) {
    this.isMobileDevice = isMobileDevice ?? (Platform.isAndroid || Platform.isIOS);
  }


  late bool isMobileDevice;
}
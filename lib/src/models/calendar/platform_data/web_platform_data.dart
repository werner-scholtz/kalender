class PlatformData {
  PlatformData({
    bool? isMobileDevice,
  }) {
    this.isMobileDevice = isMobileDevice ?? false;
  }

  late bool isMobileDevice;

  @override
  operator ==(Object other) {
    return other is PlatformData && other.isMobileDevice == isMobileDevice;
  }

  @override
  int get hashCode => isMobileDevice.hashCode;
}

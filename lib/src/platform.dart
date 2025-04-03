import 'package:universal_platform/universal_platform.dart';

/// TODO: Remove this and use https://api.flutter.dev/flutter/foundation/defaultTargetPlatform.html ?
/// Check if the current platform is a mobile device.
///
/// Using the [UniversalPlatform] package,to cater for web and other platforms.
bool get isMobileDevice => UniversalPlatform.isAndroid || UniversalPlatform.isIOS;

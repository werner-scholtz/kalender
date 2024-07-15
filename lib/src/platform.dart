import 'package:universal_platform/universal_platform.dart';

bool get isMobileDevice => UniversalPlatform.isAndroid || UniversalPlatform.isIOS;

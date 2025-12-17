import 'package:timezone/browser.dart';
export 'package:timezone/timezone.dart';

Future<void> initializeTimeZonePackage() async {
  await initializeTimeZone('assets/packages/timezone/data/latest.tzf');
}

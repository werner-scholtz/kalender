import 'package:timezone/data/latest.dart';
export 'package:timezone/timezone.dart';

Future<void> initializeTimeZonePackage() async {
  initializeTimeZones();
}

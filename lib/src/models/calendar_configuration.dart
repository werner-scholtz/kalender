import 'dart:io';
import 'package:flutter/foundation.dart';

class CalendarConfiguration {
  CalendarConfiguration({
    this.firstDayOfWeek = DateTime.monday,
    bool? isMobileDevice,
  }) {
    this.isMobileDevice = isMobileDevice ?? kIsWeb ? false : (Platform.isIOS || Platform.isAndroid);
    assert(
      firstDayOfWeek >= DateTime.monday && firstDayOfWeek <= DateTime.sunday,
      'First day of week must be between 1 and 7',
    );
  }

  /// The [bool] that indicates if it is a Mobile Platform.
  ///
  /// This will affect how the gestures are detected.
  late bool isMobileDevice;

  /// Specifies the start of the week.
  ///
  /// Use [DateTime.monday] to [DateTime.sunday]
  final int firstDayOfWeek;
}

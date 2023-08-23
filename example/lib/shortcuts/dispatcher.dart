// import 'dart:developer';

import 'package:flutter/material.dart';

class LoggingActionDispatcher extends ActionDispatcher {
  @override
  Object? invokeAction(
    covariant Action<Intent> action,
    covariant Intent intent, [
    BuildContext? context,
  ]) {
    super.invokeAction(action, intent, context);

    return null;
  }
}

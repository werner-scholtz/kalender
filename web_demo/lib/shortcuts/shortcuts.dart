import 'package:example/shortcuts/intents.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

final shortcuts = <LogicalKeySet, Intent>{
  LogicalKeySet(LogicalKeyboardKey.minus): const ZoomInIntent(),
  LogicalKeySet(LogicalKeyboardKey.equal): const ZoomOutIntent(),
  LogicalKeySet(LogicalKeyboardKey.numpadSubtract): const ZoomInIntent(),
  LogicalKeySet(LogicalKeyboardKey.numpadAdd): const ZoomOutIntent(),
  LogicalKeySet(LogicalKeyboardKey.arrowLeft): const LeftArrowIntent(),
  LogicalKeySet(LogicalKeyboardKey.arrowRight): const RightArrowIntent(),
};

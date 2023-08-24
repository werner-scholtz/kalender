import 'package:flutter/material.dart';

/// An intent that zooms in the calendar.
class ZoomInIntent extends Intent {
  const ZoomInIntent();
}

/// An intent that zooms out the calendar.
class ZoomOutIntent extends Intent {
  const ZoomOutIntent();
}

/// An intent that moves the calendar to the left.
class LeftArrowIntent extends Intent {
  const LeftArrowIntent();
}

/// An intent that moves the calendar to the right.
class RightArrowIntent extends Intent {
  const RightArrowIntent();
}

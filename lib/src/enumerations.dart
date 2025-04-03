/// The [ResizeDirection] is used to differentiate between the different directions that an event can be resized in.
enum ResizeDirection {
  /// Resizes the event to the left.
  left,

  /// Resizes the event to the right.
  right,

  /// Resizes the event to the top.
  top,

  /// Resizes the event to the bottom.
  bottom;

  /// Is the [ResizeDirection] in a vertical direction. [top]/[bottom]
  bool get vertical => this == top || this == bottom;

  /// Is the [ResizeDirection] in a horizontal direction. [left]/[right]
  bool get horizontal => this == left || this == right;
}

enum TileType {
  /// A normal tile.
  ///
  /// This is the default tile.
  normal,

  /// A ghost tile.
  ///
  /// This is used to show the orignal size and position of a tile while it is being modified.
  ghost,

  /// A selected tile.
  ///
  /// This is used to show the size and position of a tile that is being modified.
  selected,
}

enum CreateEventTrigger {
  /// Creates event on tap gesture.
  tap,

  /// Creates event on tap hold gesture.
  longPress,
}

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

/// The size of a slot in minutes.
enum SlotSize {
  /// A slot size of 15 minutes.
  minute15(15),

  /// A slot size of 30 minutes.
  minute30(30),

  /// A slot size of 45 minutes.
  minute45(45),

  /// A slot size of 60 minutes.
  minute60(60);

  const SlotSize(this.minutes);
  final int minutes;
}

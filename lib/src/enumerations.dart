enum ViewType {
  /// A view that displays only a single day.
  singleDay,

  /// A view that displays more than one day.
  multiDay,

  /// A view that displays 42 days to cover a whole month.
  month,

  /// A view that displays 12 months in a list.
  schedule,
}

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

enum MinuteSlotSize {
  minute15(15),
  minute30(30),
  minute60(60);

  const MinuteSlotSize(this.minutes);
  final int minutes;
}

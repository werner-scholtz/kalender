/// Slot size for the calendar. ///TODO: replace this with a duration.
class SlotSize {
  const SlotSize({
    required this.minutes,
  });

  /// The number of minutes that this slot represents.
  final int minutes;

  /// The duration of this slot.
  Duration get duration => Duration(minutes: minutes);
}

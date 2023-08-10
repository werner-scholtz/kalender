/// Slot size for the calendar.
class SlotSize {
  const SlotSize({
    required this.minutes,
  });

  /// The number of minutes that this slot represents.
  final int minutes;

  Duration get duration => Duration(minutes: minutes);
}

enum ViewType {
  // A view that shows a single calendar.
  single('Single Calendar'),

  // A view that shows multiple calendars next to each other.
  double('Multi Calendar');

  const ViewType(this.label);
  final String label;
}

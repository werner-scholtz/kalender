import 'package:flutter/material.dart';

enum ViewType {
  // A view that shows a single calendar.
  single('Single Calendar'),

  // A view that shows multiple calendars next to each other.
  double('Multi Calendar');

  const ViewType(this.label);
  final String label;
}

class ViewTypePicker extends StatelessWidget {
  final ViewType type;
  final ValueChanged<ViewType> onChanged;
  const ViewTypePicker({super.key, required this.type, required this.onChanged});

  @override
  Widget build(BuildContext context) {
    return DropdownMenu<ViewType>(
      initialSelection: type,
      dropdownMenuEntries: [
        ...ViewType.values.map((e) => DropdownMenuEntry(value: e, label: e.label)),
      ],
      onSelected: (value) {
        if (value == null) return;
        onChanged(value);
      },
    );
  }
}

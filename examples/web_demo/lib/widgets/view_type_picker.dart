import 'package:flutter/material.dart';
import 'package:web_demo/enumerations.dart';

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

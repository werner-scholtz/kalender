import 'package:flutter/material.dart';
import 'package:web_demo/providers.dart';

enum ViewType {
  // A view that shows a single calendar.
  single(),

  // A view that shows multiple calendars next to each other.
  double();

  const ViewType();
}

class ViewTypePicker extends StatelessWidget {
  final ViewType type;
  final ValueChanged<ViewType> onChanged;
  const ViewTypePicker({super.key, required this.type, required this.onChanged});

  @override
  Widget build(BuildContext context) {
    return DropdownMenu<ViewType>(
      key: Key(Localizations.localeOf(context).languageCode),
      initialSelection: type,
      dropdownMenuEntries: [
        DropdownMenuEntry(
          value: ViewType.single,
          label: context.l10n.singleCalendar,
        ),
        DropdownMenuEntry(
          value: ViewType.double,
          label: context.l10n.multiCalendar,
        ),
      ],
      onSelected: (value) {
        if (value == null) return;
        onChanged(value);
      },
    );
  }
}

import 'package:flutter/material.dart';
import 'package:web_demo/utils.dart';
import 'package:web_demo/widgets/toolbar/chip_dropdown.dart';

enum ViewType {
  // A view that shows a single calendar.
  single(),

  // A view that shows multiple calendars next to each other.
  dual();

  const ViewType();
}

class ViewTypePicker extends StatelessWidget {
  final ViewType type;
  final ValueChanged<ViewType> onChanged;
  const ViewTypePicker({super.key, required this.type, required this.onChanged});

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final textStyle = Theme.of(context).textTheme.bodyMedium;
    return ChipDropdown<ViewType>(
      tooltip: context.l10n.calendarLayout,
      icon: type == ViewType.single ? Icons.calendar_view_day : Icons.calendar_view_week,
      label: type == ViewType.single ? context.l10n.singleCalendar : context.l10n.multiCalendar,
      onSelected: onChanged,
      itemBuilder: (_) => [
        for (final vt in ViewType.values)
          PopupMenuItem<ViewType>(
            value: vt,
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  vt == ViewType.single ? Icons.calendar_view_day : Icons.calendar_view_week,
                  size: 16,
                  color: vt == type ? cs.primary : cs.onSurfaceVariant,
                ),
                const SizedBox(width: 10),
                Text(
                  vt == ViewType.single ? context.l10n.singleCalendar : context.l10n.multiCalendar,
                  style: textStyle?.copyWith(
                    fontWeight: vt == type ? FontWeight.w600 : FontWeight.w400,
                    color: vt == type ? cs.primary : null,
                  ),
                ),
              ],
            ),
          ),
      ],
    );
  }
}

import 'package:flutter/material.dart';
import 'package:web_demo/utils.dart';

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
    final colorScheme = Theme.of(context).colorScheme;
    return PopupMenuButton<ViewType>(
      tooltip: 'Calendar layout',
      onSelected: onChanged,
      offset: const Offset(0, 40),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
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
                  color: vt == type ? colorScheme.primary : colorScheme.onSurfaceVariant,
                ),
                const SizedBox(width: 10),
                Text(
                  vt == ViewType.single ? context.l10n.singleCalendar : context.l10n.multiCalendar,
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        fontWeight: vt == type ? FontWeight.w600 : FontWeight.w400,
                        color: vt == type ? colorScheme.primary : null,
                      ),
                ),
              ],
            ),
          ),
      ],
      child: Container(
        height: 36,
        padding: const EdgeInsets.symmetric(horizontal: 12),
        decoration: BoxDecoration(
          color: colorScheme.surfaceContainerHighest.withAlpha(120),
          borderRadius: BorderRadius.circular(10),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              type == ViewType.single ? Icons.calendar_view_day : Icons.calendar_view_week,
              size: 16,
              color: colorScheme.primary,
            ),
            const SizedBox(width: 6),
            Text(
              type == ViewType.single ? context.l10n.singleCalendar : context.l10n.multiCalendar,
              style: Theme.of(context).textTheme.bodySmall?.copyWith(fontWeight: FontWeight.w600),
            ),
            const SizedBox(width: 4),
            Icon(Icons.arrow_drop_down, size: 18, color: colorScheme.onSurfaceVariant),
          ],
        ),
      ),
    );
  }
}

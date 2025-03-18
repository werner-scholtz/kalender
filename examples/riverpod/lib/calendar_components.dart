import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:kalender/kalender.dart';
import 'package:riverpod_example/main.dart';

TileComponents tileComponents(BuildContext context, {bool body = true}) {
  final color = Theme.of(context).colorScheme.primaryContainer;
  final radius = BorderRadius.circular(8);
  return TileComponents(
    tileBuilder: (event, tileRange) {
      return Card(
        margin: body ? EdgeInsets.zero : const EdgeInsets.symmetric(vertical: 1),
        color: color,
        child: Text("Event"),
      );
    },
    dropTargetTile: (event) => DecoratedBox(
      decoration: BoxDecoration(
        border: Border.all(color: Theme.of(context).colorScheme.onSurface.withAlpha(80), width: 2),
        borderRadius: radius,
      ),
    ),
    feedbackTileBuilder: (event, dropTargetWidgetSize) => AnimatedContainer(
      duration: const Duration(milliseconds: 250),
      width: dropTargetWidgetSize.width * 0.8,
      height: dropTargetWidgetSize.height,
      decoration: BoxDecoration(color: color.withAlpha(100), borderRadius: radius),
    ),
    tileWhenDraggingBuilder: (event) => Container(
      decoration: BoxDecoration(color: color.withAlpha(80), borderRadius: radius),
    ),
    dragAnchorStrategy: pointerDragAnchorStrategy,
  );
}

class CalendarToolBar extends ConsumerWidget {
  const CalendarToolBar({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    
    final view = ref.watch(kalenderView);
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Row(
        children: [
          Expanded(
            child: Row(
              children: [
                ValueListenableBuilder(
                  valueListenable: view.controller.visibleDateTimeRangeUtc,
                  builder: (context, value, child) {
                    final year = value.start.year;
                    final month = value.start.monthNameEnglish;
                    return FilledButton.tonal(
                      onPressed: () {},
                      style: FilledButton.styleFrom(minimumSize: const Size(160, kMinInteractiveDimension)),
                      child: Text('$month $year'),
                    );
                  },
                ),
              ],
            ),
          ),
          if (!Platform.isAndroid && !Platform.isIOS)
            IconButton.filledTonal(
              onPressed: () => view.controller.animateToPreviousPage(),
              icon: const Icon(Icons.chevron_left),
            ),
          if (!Platform.isAndroid && !Platform.isIOS)
            IconButton.filledTonal(
              onPressed: () => view.controller.animateToNextPage(),
              icon: const Icon(Icons.chevron_right),
            ),
          IconButton.filledTonal(
            onPressed: () => view.controller.animateToDate(DateTime.now()),
            icon: const Icon(Icons.today),
          ),
          Expanded(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                DropdownMenu<ViewConfiguration>(
                  dropdownMenuEntries: view.viewConfigurations.map((e) {
                    return DropdownMenuEntry(value: e, label: e.name);
                  }).toList(),
                  inputDecorationTheme: InputDecorationTheme(
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(kMinInteractiveDimension),
                    ),
                    enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(kMinInteractiveDimension),
                        borderSide: BorderSide(width: 2, color: Theme.of(context).colorScheme.outline)),
                  ),
                  initialSelection: view.viewConfiguration,
                  onSelected: (value) {
                    if (value == null) return;
                    view.viewConfiguration = value;
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

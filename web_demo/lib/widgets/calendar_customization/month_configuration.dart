import 'package:example/widgets/calendar_customization/list_tiles.dart';
import 'package:flutter/material.dart';
import 'package:kalender/kalender.dart';

class MonthConfiguarionEditor extends StatelessWidget {
  const MonthConfiguarionEditor({
    super.key,
    required this.config,
    required this.onConfigChanged,
  });

  final MonthConfiguration config;
  final void Function(MonthConfiguration newConfig) onConfigChanged;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        FirstDayOfWeek(
          value: config.firstDayOfWeek,
          onChanged: (value) {
            onConfigChanged(
              config.copyWith(
                firstDayOfWeek: value,
              ),
            );
          },
        ),
        CheckboxListTile.adaptive(
          title: const Text('enableRezising'),
          value: config.enableResizing,
          onChanged: (bool? value) {
            if (value == null) return;
            onConfigChanged(
              config.copyWith(
                enableResizing: value,
              ),
            );
          },
        ),
        CheckboxListTile.adaptive(
          title: const Text('createNewEvents'),
          value: config.createNewEvents,
          onChanged: (bool? value) {
            if (value == null) return;
            onConfigChanged(
              config.copyWith(
                createNewEvents: value,
              ),
            );
          },
        ),
      ],
    );
  }
}

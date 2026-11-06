// This file is part of kalender.
//
// SPDX-FileCopyrightText: 2023 Klarälvdalens Datakonsult AB, a KDAB Group company <info@kdab.com>
//
// SPDX-License-Identifier: MIT

import 'package:flutter/material.dart';
import 'package:kalender/kalender.dart';
import 'package:web_demo/models/demo_configuration.dart';
import 'package:web_demo/utils.dart';
import 'package:web_demo/widgets/configuration/body_editors.dart';
import 'package:web_demo/widgets/configuration/header_editor.dart';
import 'package:web_demo/widgets/configuration/view_editors.dart';

class ConfigurationPanel extends StatelessWidget {
  final DemoConfiguration configuration;
  final VoidCallback? onDismiss;
  const ConfigurationPanel({super.key, required this.configuration, this.onDismiss});

  static const borderRadius = BorderRadius.all(Radius.circular(12));

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    return Container(
      margin: const EdgeInsets.only(top: 4, bottom: 4, right: 4),
      decoration: BoxDecoration(
        color: colorScheme.surfaceContainerLowest,
        borderRadius: borderRadius,
        border: Border.all(color: colorScheme.outlineVariant.withAlpha(80)),
      ),
      child: ListenableBuilder(
        listenable: Listenable.merge([configuration, context.controller]),
        builder: (context, child) {
          final viewConfiguration = context.controller.viewConfiguration;
          return SingleChildScrollView(
            padding: const EdgeInsets.all(12),
            child: Column(
              spacing: 10,
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Padding(
                  padding: const EdgeInsets.only(left: 4, bottom: 4),
                  child: Row(
                    children: [
                      Icon(Icons.tune, size: 20, color: colorScheme.primary),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          context.l10n.configuration,
                          style: Theme.of(context).textTheme.titleSmall?.copyWith(
                                fontWeight: FontWeight.w600,
                                color: colorScheme.onSurface,
                              ),
                        ),
                      ),
                      if (onDismiss != null)
                        IconButton(
                          icon: const Icon(Icons.close, size: 18),
                          onPressed: onDismiss,
                          tooltip: MaterialLocalizations.of(context).closeButtonTooltip,
                          style: IconButton.styleFrom(
                            minimumSize: const Size(28, 28),
                            padding: EdgeInsets.zero,
                          ),
                        ),
                    ],
                  ),
                ),
                _PanelSwitch(
                  notifier: configuration.scopedThemeNotifier,
                  title: context.l10n.scopedTheme,
                  subtitle: context.l10n.scopedThemeHint,
                  onChanged: (value) => configuration.scopedTheme = value,
                ),
                _PanelSwitch(
                  notifier: configuration.tintSelectedDaysNotifier,
                  title: context.l10n.tintSelectedDays,
                  onChanged: (value) => configuration.tintSelectedDays = value,
                ),
                ViewConfigurationEditor(viewConfiguration: viewConfiguration),
                if (viewConfiguration is MultiDayViewConfiguration) ...[
                  MultiDayHeaderEditor(demoConfiguration: configuration),
                  MultiDayBodyEditor(demoConfiguration: configuration),
                ] else if (viewConfiguration is MonthViewConfiguration) ...[
                  MonthBodyEditor(demoConfiguration: configuration),
                ] else if (viewConfiguration is ScheduleViewConfiguration) ...[
                  ScheduleBodyEditor(demoConfiguration: configuration),
                ] else
                  const SizedBox.shrink(),
              ],
            ),
          );
        },
      ),
    );
  }
}

/// A switch placed directly in the panel's decorated Container.
///
/// The other switches sit inside an ExpansionTile, which supplies the Material a ListTile paints its ink on. This one
/// needs its own.
class _PanelSwitch extends StatelessWidget {
  final ValueNotifier<bool> notifier;
  final String title;
  final String? subtitle;
  final ValueChanged<bool> onChanged;

  const _PanelSwitch({required this.notifier, required this.title, this.subtitle, required this.onChanged});

  @override
  Widget build(BuildContext context) {
    final subtitle = this.subtitle;
    return Material(
      type: MaterialType.transparency,
      child: ValueListenableBuilder<bool>(
        valueListenable: notifier,
        builder: (context, value, _) => SwitchListTile.adaptive(
          title: Text(title),
          subtitle: subtitle == null ? null : Text(subtitle),
          value: value,
          onChanged: onChanged,
        ),
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:web_demo/utils.dart';

class WarningButton extends StatelessWidget {
  const WarningButton({super.key});

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    return IconButton(
      onPressed: () => showDialog(
        context: context,
        builder: (context) => AlertDialog(
          icon: Icon(Icons.info_outline, color: colorScheme.primary, size: 32),
          title: Text(context.l10n.preReleaseTitle),
          titleTextStyle: Theme.of(context).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w600),
          content: Text(context.l10n.preReleaseContent),
          contentTextStyle: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color: colorScheme.onSurfaceVariant,
              ),
          actions: [
            FilledButton(
              onPressed: () => Navigator.pop(context),
              child: Text(context.l10n.gotIt),
            ),
          ],
          actionsAlignment: MainAxisAlignment.center,
          actionsPadding: const EdgeInsets.only(bottom: 20),
        ),
      ),
      icon: Icon(Icons.info_outline, color: colorScheme.onSurfaceVariant),
      tooltip: context.l10n.preReleaseInfo,
    );
  }
}

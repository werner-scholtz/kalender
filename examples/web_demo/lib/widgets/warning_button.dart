import 'package:flutter/material.dart';

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
          title: const Text('Pre-release Example'),
          titleTextStyle: Theme.of(context).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w600),
          content: const Text(
            "This is a pre-release example for v0.16.0 which is not yet released.\n\nSee the 'main-wip' branch for progress.",
          ),
          contentTextStyle: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color: colorScheme.onSurfaceVariant,
              ),
          actions: [
            FilledButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Got it'),
            ),
          ],
          actionsAlignment: MainAxisAlignment.center,
          actionsPadding: const EdgeInsets.only(bottom: 20),
        ),
      ),
      icon: Icon(Icons.info_outline, color: colorScheme.onSurfaceVariant),
      tooltip: 'Pre-release info',
    );
  }
}

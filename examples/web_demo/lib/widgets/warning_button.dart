import 'package:flutter/material.dart';

class WarningButton extends StatelessWidget {
  const WarningButton({super.key});

  @override
  Widget build(BuildContext context) {
    return IconButton.filledTonal(
      onPressed: () => showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: const Text('This is a pre-release example for v0.16.0'),
          content: const Text(
            "This is a pre-release example for v0.16.0 which is not yet released, see 'main-wip' branch.",
          ),
          actions: [
            TextButton(onPressed: () => Navigator.pop(context), child: const Text('OK')),
          ],
        ),
      ),
      icon: Icon(Icons.warning, color: Theme.of(context).colorScheme.error),
      tooltip: 'Warning - v0.16.0 pre-release example.',
    );
  }
}

import 'package:flutter/material.dart';

class TriggerWidget extends StatelessWidget {
  const TriggerWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Container(
      decoration: BoxDecoration(
        color: theme.colorScheme.onSurface.withAlpha(15),
      ),
    );
  }
}

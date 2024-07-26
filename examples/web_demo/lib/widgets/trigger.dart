import 'package:flutter/material.dart';

class TriggerWidget extends StatelessWidget {
  final Size size;
  const TriggerWidget({super.key, required this.size});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Container(
      width: size.width,
      height: size.height,
      decoration: BoxDecoration(
        color: theme.colorScheme.onSurface.withAlpha(15),
      ),
    );
  }
}

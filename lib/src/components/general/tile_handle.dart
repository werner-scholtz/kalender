import 'package:flutter/material.dart';

class DefaultTileHandle extends StatelessWidget {
  const DefaultTileHandle({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.onBackground,
        borderRadius: BorderRadius.circular(8),
      ),
    );
  }
}

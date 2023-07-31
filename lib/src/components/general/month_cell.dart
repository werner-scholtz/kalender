import 'package:flutter/material.dart';

class MonthCell<T extends Object?> extends StatelessWidget {
  const MonthCell({
    super.key,
    required this.child,
  });

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        border: Border.all(
          color: Theme.of(context).colorScheme.surfaceVariant,
          width: 1,
        ),
      ),
      child: child,
    );
  }
}

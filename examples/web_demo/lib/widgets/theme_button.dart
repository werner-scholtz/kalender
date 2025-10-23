import 'package:flutter/material.dart';
import 'package:web_demo/providers.dart';

class ThemeButton extends StatelessWidget {
  const ThemeButton({super.key});

  @override
  Widget build(BuildContext context) {
    return IconButton.filledTonal(
      onPressed: () {
        context.themeMode.value = context.themeMode.value == ThemeMode.dark ? ThemeMode.light : ThemeMode.dark;
      },
      icon: Icon(context.themeMode.value == ThemeMode.dark ? Icons.brightness_2_rounded : Icons.brightness_7_rounded),
    );
  }
}

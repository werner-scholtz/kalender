import 'package:flutter/material.dart';
import 'package:web_demo/main.dart' show MyApp;

class ThemeButton extends StatelessWidget {
  const ThemeButton({super.key});

  @override
  Widget build(BuildContext context) {
    final appState = MyApp.of(context)!;
    return IconButton.filledTonal(
      onPressed: () => appState.toggleTheme(),
      icon: Icon(appState.themeMode == ThemeMode.dark ? Icons.brightness_2_rounded : Icons.brightness_7_rounded),
    );
  }
}

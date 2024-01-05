import 'package:flutter/material.dart';
import 'package:web_demo/main.dart';

class ThemeTile extends StatelessWidget {
  const ThemeTile({super.key});

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: const Text('Theme'),
      trailing: IconButton.filledTonal(
        onPressed: () => MyApp.of(context)!.toggleTheme(),
        icon: Icon(
          MyApp.of(context)!.themeMode == ThemeMode.dark
              ? Icons.brightness_2_rounded
              : Icons.brightness_7_rounded,
        ),
      ),
    );
  }
}

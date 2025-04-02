import 'package:flutter/material.dart';
import 'package:web_demo/main.dart' show MyApp;

class TextDirectionButton extends StatelessWidget {
  const TextDirectionButton({super.key});

  @override
  Widget build(BuildContext context) {
    final appState = MyApp.of(context)!;
    return IconButton.filledTonal(
      onPressed: () => appState.toggleTextDirection(),
      icon: Icon(
        appState.textDirection == TextDirection.ltr
            ? Icons.format_textdirection_l_to_r
            : Icons.format_textdirection_r_to_l,
      ),
    );
  }
}

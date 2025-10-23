import 'package:flutter/material.dart';
import 'package:web_demo/providers.dart';

class TextDirectionButton extends StatelessWidget {
  const TextDirectionButton({super.key});

  @override
  Widget build(BuildContext context) {
    return IconButton.filledTonal(
      onPressed: () {
        context.textDirection.value =
            context.textDirection.value == TextDirection.ltr ? TextDirection.rtl : TextDirection.ltr;
      },
      icon: Icon(
        context.textDirection.value == TextDirection.ltr
            ? Icons.format_textdirection_l_to_r
            : Icons.format_textdirection_r_to_l,
      ),
    );
  }
}

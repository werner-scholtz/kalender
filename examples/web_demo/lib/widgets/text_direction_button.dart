import 'package:flutter/material.dart';
import 'package:web_demo/utils.dart';


class TextDirectionButton extends StatelessWidget {
  const TextDirectionButton({super.key});

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder(
      valueListenable: context.textDirectionNotifier,
      builder: (context, textDirection, _) => IconButton.filledTonal(
        onPressed: () => context.textDirectionNotifier.value = textDirection == TextDirection.ltr ? TextDirection.rtl : TextDirection.ltr,
        icon: Icon(
          textDirection == TextDirection.ltr
              ? Icons.format_textdirection_l_to_r
              : Icons.format_textdirection_r_to_l,
        ),
      ),
    );
  }
}

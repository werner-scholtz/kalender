// This file is part of kalender.
//
// SPDX-FileCopyrightText: 2023 Klarälvdalens Datakonsult AB, a KDAB Group company <info@kdab.com>
//
// SPDX-License-Identifier: MIT

import 'package:flutter/material.dart';
import 'package:web_demo/utils.dart';

class ThemeButton extends StatelessWidget {
  const ThemeButton({super.key});

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder(
      valueListenable: context.themeModeNotifier,
      builder: (context, themeMode, _) => IconButton.filledTonal(
        onPressed: () =>
            context.themeModeNotifier.value = themeMode == ThemeMode.dark ? ThemeMode.light : ThemeMode.dark,
        icon: Icon(themeMode == ThemeMode.dark ? Icons.brightness_2_rounded : Icons.brightness_7_rounded),
      ),
    );
  }
}

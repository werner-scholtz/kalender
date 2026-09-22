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
    // The mode starts as ThemeMode.system, so the resolved brightness decides.
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return IconButton.filledTonal(
      onPressed: () => context.themeModeNotifier.value = isDark ? ThemeMode.light : ThemeMode.dark,
      icon: Icon(isDark ? Icons.brightness_2_rounded : Icons.brightness_7_rounded),
    );
  }
}

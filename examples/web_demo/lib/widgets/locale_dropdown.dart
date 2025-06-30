import 'package:flutter/material.dart';
import 'package:web_demo/locales.dart';
import 'package:web_demo/main.dart' show MyApp;

class LocaleDropdown extends StatelessWidget {
  const LocaleDropdown({super.key});

  @override
  Widget build(BuildContext context) {
    final appState = MyApp.of(context)!;

    return DropdownMenu<Locale>(
      initialSelection: appState.locale.value,
      dropdownMenuEntries: [
        ...supportedLocales.map(
          (locale) => DropdownMenuEntry<Locale>(
            value: locale,
            label: locale.toLanguageTag().split('_').first.toUpperCase(),
          ),
        ),
      ],
      onSelected: (value) {
        if (value == null) return;
        appState.setLocale(value);
      },
    );
  }
}

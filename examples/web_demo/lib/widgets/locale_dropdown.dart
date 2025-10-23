import 'package:flutter/material.dart';
import 'package:web_demo/locales.dart';
import 'package:web_demo/providers.dart';

class LocaleDropdown extends StatelessWidget {
  const LocaleDropdown({super.key});

  @override
  Widget build(BuildContext context) {
    return DropdownMenu<Locale>(
      initialSelection: context.locale.value,
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
        context.locale.value = value;
      },
    );
  }
}

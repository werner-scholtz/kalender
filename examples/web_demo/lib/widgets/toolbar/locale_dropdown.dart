import 'package:flutter/material.dart';
import 'package:web_demo/locales.dart';
import 'package:web_demo/utils.dart';
import 'package:web_demo/widgets/toolbar/chip_dropdown.dart';

class LocaleDropdown extends StatelessWidget {
  const LocaleDropdown({super.key});

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final textStyle = Theme.of(context).textTheme.bodyMedium;
    return ValueListenableBuilder(
      valueListenable: context.localeNotifier,
      builder: (context, locale, _) => ChipDropdown<Locale>(
        tooltip: context.l10n.language,
        icon: Icons.translate,
        label: locale.toLanguageTag().split('_').first.toUpperCase(),
        onSelected: (value) => context.localeNotifier.value = value,
        itemBuilder: (_) => [
          for (final loc in supportedLocales)
            ChipDropdown.checkMenuItem<Locale>(
              value: loc,
              label: loc.toLanguageTag().split('_').first.toUpperCase(),
              selected: loc == locale,
              colorScheme: cs,
              textStyle: textStyle,
            ),
        ],
      ),
    );
  }
}

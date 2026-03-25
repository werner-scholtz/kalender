import 'package:flutter/material.dart';
import 'package:web_demo/locales.dart';
import 'package:web_demo/providers.dart';
import 'package:web_demo/utils.dart';

class LocaleDropdown extends StatelessWidget {
  const LocaleDropdown({super.key});

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    return ValueListenableBuilder(
      valueListenable: context.localeNotifier,
      builder: (context, locale, _) => PopupMenuButton<Locale>(
        tooltip: context.l10n.language,
        onSelected: (value) => context.localeNotifier.value = value,
        offset: const Offset(0, 40),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        itemBuilder: (_) => supportedLocales
            .map(
              (loc) => PopupMenuItem<Locale>(
                value: loc,
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      loc == locale ? Icons.check_circle : Icons.circle_outlined,
                      size: 16,
                      color: loc == locale ? colorScheme.primary : colorScheme.onSurfaceVariant,
                    ),
                    const SizedBox(width: 10),
                    Text(
                      loc.toLanguageTag().split('_').first.toUpperCase(),
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                            fontWeight: loc == locale ? FontWeight.w600 : FontWeight.w400,
                            color: loc == locale ? colorScheme.primary : null,
                          ),
                    ),
                  ],
                ),
              ),
            )
            .toList(),
        child: Container(
          height: 36,
          padding: const EdgeInsets.symmetric(horizontal: 12),
          decoration: BoxDecoration(
            color: colorScheme.surfaceContainerHighest.withAlpha(120),
            borderRadius: BorderRadius.circular(10),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(Icons.translate, size: 16, color: colorScheme.primary),
              const SizedBox(width: 6),
              Text(
                locale.toLanguageTag().split('_').first.toUpperCase(),
                style: Theme.of(context).textTheme.bodySmall?.copyWith(fontWeight: FontWeight.w600),
              ),
              const SizedBox(width: 4),
              Icon(Icons.arrow_drop_down, size: 18, color: colorScheme.onSurfaceVariant),
            ],
          ),
        ),
      ),
    );
  }
}

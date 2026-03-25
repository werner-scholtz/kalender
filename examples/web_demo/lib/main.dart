import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:kalender/kalender.dart';
import 'package:web_demo/l10n/app_localizations.dart';
import 'package:web_demo/locales.dart';
import 'package:web_demo/pages/multi_calendar.dart';
import 'package:web_demo/pages/single_calendar.dart';
import 'package:web_demo/providers.dart';
import 'package:web_demo/utils.dart';
import 'package:web_demo/widgets/locale_dropdown.dart';
import 'package:web_demo/widgets/text_direction_button.dart';
import 'package:web_demo/widgets/theme_button.dart';
import 'package:web_demo/widgets/view_type_picker.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:web_demo/widgets/warning_button.dart';

import 'timezone/stub.dart'
    if (dart.library.html) 'timezone/browser.dart'
    if (dart.library.io) 'timezone/standalone.dart';

void main() async {
  await initializeDateFormatting();
  await initializeTimeZonePackage();

  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => MyAppState();
}

class MyAppState extends State<MyApp> {
  final _themeMode = ValueNotifier(ThemeMode.dark);
  final _textDirection = ValueNotifier(TextDirection.ltr);
  final _locale = ValueNotifier(supportedLocales.first);
  final _eventsController = DefaultEventsController();

  @override
  void initState() {
    super.initState();
    _eventsController.addEvents(generateEvents(context));
  }

  @override
  void dispose() {
    _themeMode.dispose();
    _textDirection.dispose();
    _locale.dispose();
    _eventsController.dispose();
    super.dispose();
  }

  static ThemeData _buildTheme(Brightness brightness) {
    final colorScheme = ColorScheme.fromSeed(
      seedColor: const Color(0xFF6366F1),
      brightness: brightness,
    );
    return ThemeData(
      useMaterial3: true,
      colorScheme: colorScheme,
      appBarTheme: AppBarTheme(
        elevation: 0,
        scrolledUnderElevation: 0,
        backgroundColor: colorScheme.surface,
        surfaceTintColor: Colors.transparent,
      ),
      cardTheme: CardThemeData(
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
          side: BorderSide(color: colorScheme.outlineVariant.withAlpha(80)),
        ),
      ),
      dialogTheme: DialogThemeData(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        elevation: 4,
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: colorScheme.surfaceContainerLow,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide.none,
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: colorScheme.outlineVariant.withAlpha(80)),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: colorScheme.primary, width: 1.5),
        ),
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      ),
      filledButtonTheme: FilledButtonThemeData(
        style: FilledButton.styleFrom(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        ),
      ),
      iconButtonTheme: IconButtonThemeData(
        style: IconButton.styleFrom(
          backgroundColor: colorScheme.surfaceContainerHighest.withAlpha(120),
          minimumSize: const Size(36, 36),
          padding: EdgeInsets.zero,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        ),
      ),
      expansionTileTheme: ExpansionTileThemeData(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        collapsedShape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        backgroundColor: colorScheme.surfaceContainerHigh.withAlpha(120),
        collapsedBackgroundColor: colorScheme.surfaceContainer.withAlpha(100),
        iconColor: colorScheme.primary,
        collapsedIconColor: colorScheme.onSurfaceVariant,
        tilePadding: const EdgeInsets.symmetric(horizontal: 16),
      ),
      listTileTheme: const ListTileThemeData(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(12)),
        ),
        dense: true,
        visualDensity: VisualDensity.compact,
        contentPadding: EdgeInsets.only(left: 16, right: 10, top: 0, bottom: 0),
      ),
      switchTheme: SwitchThemeData(
        thumbIcon: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.selected)) {
            return const Icon(Icons.check, size: 14);
          }
          return null;
        }),
      ),
    );
  }

  Locale _resolveLocale(Locale? locale, Iterable<Locale> supportedLocales) {
    if (locale == null) return const Locale('en', 'GB');
    for (var supportedLocale in supportedLocales) {
      if (supportedLocale.languageCode == locale.languageCode) {
        return supportedLocale;
      }
    }
    return const Locale('en', 'GB');
  }

  @override
  Widget build(BuildContext context) {
    final isMobile = defaultTargetPlatform == TargetPlatform.iOS || defaultTargetPlatform == TargetPlatform.android;
    return ThemeModeProvider(
      notifier: _themeMode,
      child: TextDirectionProvider(
        notifier: _textDirection,
        child: LocaleNotifierProvider(
          notifier: _locale,
          child: EventsControllerProvider(
            eventsController: _eventsController,
            child: ValueListenableBuilder(
              valueListenable: _themeMode,
              builder: (_, themeMode, __) => ValueListenableBuilder(
                valueListenable: _locale,
                builder: (_, locale, __) => ValueListenableBuilder(
                  valueListenable: _textDirection,
                  builder: (_, textDirection, __) => MaterialApp(
                    debugShowCheckedModeBanner: false,
                    themeMode: themeMode,
                    theme: _buildTheme(Brightness.light),
                    darkTheme: _buildTheme(Brightness.dark),
                    locale: locale,
                    supportedLocales: supportedLocales,
                    localizationsDelegates: const [
                      AppLocalizations.delegate,
                      GlobalMaterialLocalizations.delegate,
                      GlobalWidgetsLocalizations.delegate,
                      GlobalCupertinoLocalizations.delegate,
                    ],
                    localeResolutionCallback: (locale, supportedLocales) => _resolveLocale(locale, supportedLocales),
                    localeListResolutionCallback: (locales, supportedLocales) {
                      return _resolveLocale(
                        locales?.isNotEmpty == true ? locales!.first : null,
                        supportedLocales,
                      );
                    },
                    onGenerateTitle: (context) => AppLocalizations.of(context)!.appTitle,
                    home: Directionality(
                      textDirection: textDirection,
                      child: isMobile ? const MobileHomePage() : const DesktopHomePage(),
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class MobileHomePage extends StatelessWidget {
  const MobileHomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          context.l10n.appTitle,
          style: Theme.of(context).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.w600),
        ),
        actionsPadding: const EdgeInsets.symmetric(horizontal: 12),
        actions: const [
          ThemeButton(),
          SizedBox(width: 4),
          TextDirectionButton(),
          SizedBox(width: 4),
          WarningButton(),
        ],
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(1),
          child: Divider(height: 1, color: Theme.of(context).colorScheme.outlineVariant.withAlpha(80)),
        ),
      ),
      body: const SingleCalendarView(),
    );
  }
}

class DesktopHomePage extends StatefulWidget {
  const DesktopHomePage({super.key});
  @override
  State<DesktopHomePage> createState() => _DesktopHomePageState();
}

class _DesktopHomePageState extends State<DesktopHomePage> {
  /// The type of the calendar view.
  ViewType _type = ViewType.single;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          context.l10n.appTitle,
          style: Theme.of(context).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.w600),
        ),
        actionsPadding: const EdgeInsets.symmetric(horizontal: 12),
        actions: [
          const WarningButton(),
          const SizedBox(width: 8),
          const ThemeButton(),
          const SizedBox(width: 4),
          const TextDirectionButton(),
          const SizedBox(width: 8),
          const LocaleDropdown(),
          const SizedBox(width: 8),
          ViewTypePicker(type: _type, onChanged: (value) => setState(() => _type = value)),
        ],
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(1),
          child: Divider(height: 1, color: Theme.of(context).colorScheme.outlineVariant.withAlpha(80)),
        ),
      ),
      body: _type == ViewType.single ? const SingleCalendarView() : const MultiCalendarView(),
    );
  }
}

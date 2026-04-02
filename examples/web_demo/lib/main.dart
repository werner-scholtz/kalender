import 'package:flutter/material.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:kalender/kalender.dart';
import 'package:web_demo/l10n/app_localizations.dart';
import 'package:web_demo/locales.dart';
import 'package:web_demo/providers.dart';
import 'package:web_demo/widgets/calendar/calendar.dart';
import 'package:web_demo/utils.dart';
import 'package:web_demo/theme.dart';
import 'package:web_demo/widgets/toolbar/locale_dropdown.dart';
import 'package:web_demo/widgets/toolbar/text_direction_button.dart';
import 'package:web_demo/widgets/toolbar/theme_button.dart';
import 'package:web_demo/widgets/toolbar/view_type_picker.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:web_demo/widgets/toolbar/warning_button.dart';

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
  final _themeMode = ValueNotifier(ThemeMode.system);
  final _textDirection = ValueNotifier(TextDirection.ltr);
  final _locale = ValueNotifier(supportedLocales.first);
  final _eventsController = DefaultEventsController();
  late final _appSettings = AppSettings(themeMode: _themeMode, textDirection: _textDirection, locale: _locale);

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

  static ThemeData _buildTheme(Brightness brightness) => buildAppTheme(brightness);

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
    return AppSettingsProvider(
      settings: _appSettings,
      child: EventsControllerProvider(
        eventsController: _eventsController,
        child: ListenableBuilder(
          listenable: Listenable.merge([_themeMode, _locale, _textDirection]),
          builder: (_, __) => MaterialApp(
            debugShowCheckedModeBanner: false,
            themeMode: _themeMode.value,
            theme: _buildTheme(Brightness.light),
            darkTheme: _buildTheme(Brightness.dark),
            locale: _locale.value,
            supportedLocales: supportedLocales,
            localizationsDelegates: const [
              AppLocalizations.delegate,
              GlobalMaterialLocalizations.delegate,
              GlobalWidgetsLocalizations.delegate,
              GlobalCupertinoLocalizations.delegate,
            ],
            localeListResolutionCallback: (locales, supportedLocales) {
              return _resolveLocale(
                locales?.isNotEmpty == true ? locales!.first : null,
                supportedLocales,
              );
            },
            onGenerateTitle: (context) => AppLocalizations.of(context)!.appTitle,
            home: Directionality(
              textDirection: _textDirection.value,
              child: isTouch ? const MobileHomePage() : const DesktopHomePage(),
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
          WarningButton(),
          SizedBox(width: 4),
          ThemeButton(),
          SizedBox(width: 4),
          TextDirectionButton(),
          SizedBox(width: 4),
          SizedBox(width: 4),
          LocaleDropdown(),
        ],
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(1),
          child: Divider(height: 1, color: Theme.of(context).colorScheme.outlineVariant.withAlpha(80)),
        ),
      ),
      body: const Calendar(),
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
      body: _type == ViewType.single
          ? const Calendar()
          : const Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Flexible(flex: 3, child: Calendar(initialShowConfig: false)),
                Flexible(flex: 3, child: Calendar(initialShowConfig: false)),
              ],
            ),
    );
  }
}

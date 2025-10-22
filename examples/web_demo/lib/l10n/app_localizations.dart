import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_af.dart';
import 'app_localizations_en.dart';

// ignore_for_file: type=lint

/// Callers can lookup localized strings with an instance of AppLocalizations
/// returned by `AppLocalizations.of(context)`.
///
/// Applications need to include `AppLocalizations.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'l10n/app_localizations.dart';
///
/// return MaterialApp(
///   localizationsDelegates: AppLocalizations.localizationsDelegates,
///   supportedLocales: AppLocalizations.supportedLocales,
///   home: MyApplicationHome(),
/// );
/// ```
///
/// ## Update pubspec.yaml
///
/// Please make sure to update your pubspec.yaml to include the following
/// packages:
///
/// ```yaml
/// dependencies:
///   # Internationalization support.
///   flutter_localizations:
///     sdk: flutter
///   intl: any # Use the pinned version from flutter_localizations
///
///   # Rest of dependencies
/// ```
///
/// ## iOS Applications
///
/// iOS applications define key application metadata, including supported
/// locales, in an Info.plist file that is built into the application bundle.
/// To configure the locales supported by your app, you’ll need to edit this
/// file.
///
/// First, open your project’s ios/Runner.xcworkspace Xcode workspace file.
/// Then, in the Project Navigator, open the Info.plist file under the Runner
/// project’s Runner folder.
///
/// Next, select the Information Property List item, select Add Item from the
/// Editor menu, then select Localizations from the pop-up menu.
///
/// Select and expand the newly-created Localizations item then, for each
/// locale your application supports, add a new item and select the locale
/// you wish to add from the pop-up menu in the Value field. This list should
/// be consistent with the languages listed in the AppLocalizations.supportedLocales
/// property.
abstract class AppLocalizations {
  AppLocalizations(String locale) : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static AppLocalizations? of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations);
  }

  static const LocalizationsDelegate<AppLocalizations> delegate = _AppLocalizationsDelegate();

  /// A list of this localizations delegate along with the default localizations
  /// delegates.
  ///
  /// Returns a list of localizations delegates containing this delegate along with
  /// GlobalMaterialLocalizations.delegate, GlobalCupertinoLocalizations.delegate,
  /// and GlobalWidgetsLocalizations.delegate.
  ///
  /// Additional delegates can be added by appending to this list in
  /// MaterialApp. This list does not have to be used at all if a custom list
  /// of delegates is preferred or required.
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates = <LocalizationsDelegate<dynamic>>[
    delegate,
    GlobalMaterialLocalizations.delegate,
    GlobalCupertinoLocalizations.delegate,
    GlobalWidgetsLocalizations.delegate,
  ];

  /// A list of this localizations delegate's supported locales.
  static const List<Locale> supportedLocales = <Locale>[Locale('af'), Locale('en')];

  /// No description provided for @appTitle.
  ///
  /// In en, this message translates to:
  /// **'Kalender Web Demo'**
  String get appTitle;

  /// No description provided for @helloWorld.
  ///
  /// In en, this message translates to:
  /// **'Hello World!'**
  String get helloWorld;

  /// No description provided for @changeTheme.
  ///
  /// In en, this message translates to:
  /// **'Change theme'**
  String get changeTheme;

  /// No description provided for @changeLocale.
  ///
  /// In en, this message translates to:
  /// **'Change language'**
  String get changeLocale;

  /// No description provided for @changeTextDirection.
  ///
  /// In en, this message translates to:
  /// **'Change text direction'**
  String get changeTextDirection;

  /// No description provided for @singleCalendar.
  ///
  /// In en, this message translates to:
  /// **'Single Calendar View'**
  String get singleCalendar;

  /// No description provided for @multiCalendar.
  ///
  /// In en, this message translates to:
  /// **'Multi Calendar View'**
  String get multiCalendar;

  /// No description provided for @newEvent.
  ///
  /// In en, this message translates to:
  /// **'New event'**
  String get newEvent;

  /// No description provided for @allowResizing.
  ///
  /// In en, this message translates to:
  /// **'Allow Resizing'**
  String get allowResizing;

  /// No description provided for @allowRescheduling.
  ///
  /// In en, this message translates to:
  /// **'Allow Rescheduling'**
  String get allowRescheduling;

  /// No description provided for @allowEventCreation.
  ///
  /// In en, this message translates to:
  /// **'Allow Event Creation'**
  String get allowEventCreation;

  /// No description provided for @snapToOtherEvents.
  ///
  /// In en, this message translates to:
  /// **'Snap to other events'**
  String get snapToOtherEvents;

  /// No description provided for @snapToTimeIndicator.
  ///
  /// In en, this message translates to:
  /// **'Snap to time indicator'**
  String get snapToTimeIndicator;

  /// No description provided for @snapInterval.
  ///
  /// In en, this message translates to:
  /// **'Snap interval'**
  String get snapInterval;

  /// No description provided for @snapRange.
  ///
  /// In en, this message translates to:
  /// **'Snap range'**
  String get snapRange;

  /// No description provided for @firstDayOfWeek.
  ///
  /// In en, this message translates to:
  /// **'First day of week'**
  String get firstDayOfWeek;

  /// No description provided for @minutesLabel.
  ///
  /// In en, this message translates to:
  /// **'{minutes} minute(s)'**
  String minutesLabel(Object minutes);

  /// No description provided for @bodyConfiguration.
  ///
  /// In en, this message translates to:
  /// **'Body Configuration'**
  String get bodyConfiguration;

  /// No description provided for @showMultiDayEvents.
  ///
  /// In en, this message translates to:
  /// **'Show multi day events'**
  String get showMultiDayEvents;

  /// No description provided for @eventPaddingLR.
  ///
  /// In en, this message translates to:
  /// **'Event Padding (LR)'**
  String get eventPaddingLR;

  /// No description provided for @minimumTileHeight.
  ///
  /// In en, this message translates to:
  /// **'Minimum tile height'**
  String get minimumTileHeight;

  /// No description provided for @none.
  ///
  /// In en, this message translates to:
  /// **'None'**
  String get none;

  /// No description provided for @tileHeight.
  ///
  /// In en, this message translates to:
  /// **'Tile Height'**
  String get tileHeight;

  /// No description provided for @eventPaddingLRTB.
  ///
  /// In en, this message translates to:
  /// **'Event Padding (LRTB)'**
  String get eventPaddingLRTB;

  /// No description provided for @emptyDayBehavior.
  ///
  /// In en, this message translates to:
  /// **'Empty Day Behavior'**
  String get emptyDayBehavior;

  /// No description provided for @headerConfiguration.
  ///
  /// In en, this message translates to:
  /// **'Header Configuration'**
  String get headerConfiguration;

  /// No description provided for @showHeader.
  ///
  /// In en, this message translates to:
  /// **'Show Header'**
  String get showHeader;

  /// No description provided for @showHeaderForView.
  ///
  /// In en, this message translates to:
  /// **'Show header for {view} view'**
  String showHeaderForView(Object view);

  /// No description provided for @showTiles.
  ///
  /// In en, this message translates to:
  /// **'Show Tiles'**
  String get showTiles;

  /// No description provided for @maxNumberOfVerticalEvents.
  ///
  /// In en, this message translates to:
  /// **'Max number of vertical events'**
  String get maxNumberOfVerticalEvents;

  /// No description provided for @unlimited.
  ///
  /// In en, this message translates to:
  /// **'Unlimited'**
  String get unlimited;

  /// No description provided for @viewConfigurationTitle.
  ///
  /// In en, this message translates to:
  /// **'{name} Configuration'**
  String viewConfigurationTitle(Object name);

  /// No description provided for @numberOfDays.
  ///
  /// In en, this message translates to:
  /// **'Number of days'**
  String get numberOfDays;

  /// No description provided for @startTime.
  ///
  /// In en, this message translates to:
  /// **'Start Time'**
  String get startTime;

  /// No description provided for @endTime.
  ///
  /// In en, this message translates to:
  /// **'End Time'**
  String get endTime;

  /// No description provided for @noViewConfigurationOptions.
  ///
  /// In en, this message translates to:
  /// **'No view configuration options available for this view type.'**
  String get noViewConfigurationOptions;

  /// No description provided for @title.
  ///
  /// In en, this message translates to:
  /// **'Title'**
  String get title;

  /// No description provided for @delete.
  ///
  /// In en, this message translates to:
  /// **'Delete'**
  String get delete;
}

class _AppLocalizationsDelegate extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) => <String>['af', 'en'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {
  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'af':
      return AppLocalizationsAf();
    case 'en':
      return AppLocalizationsEn();
  }

  throw FlutterError(
    'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
    'an issue with the localizations generation tool. Please file an issue '
    'on GitHub with a reproducible sample app and the gen-l10n configuration '
    'that was used.',
  );
}

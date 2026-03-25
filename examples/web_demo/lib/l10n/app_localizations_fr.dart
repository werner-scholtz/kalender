// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for French (`fr`).
class AppLocalizationsFr extends AppLocalizations {
  AppLocalizationsFr([String locale = 'fr']) : super(locale);

  @override
  String get appTitle => 'Kalender Démo Web';

  @override
  String get helloWorld => 'Bonjour le monde !';

  @override
  String get changeTheme => 'Changer le thème';

  @override
  String get changeLocale => 'Changer la langue';

  @override
  String get changeTextDirection => 'Changer la direction du texte';

  @override
  String get singleCalendar => 'Vue calendrier unique';

  @override
  String get multiCalendar => 'Vue multi-calendrier';

  @override
  String get newEvent => 'Nouvel événement';

  @override
  String get allowResizing => 'Autoriser le redimensionnement';

  @override
  String get allowRescheduling => 'Autoriser le rééchelonnement';

  @override
  String get allowEventCreation => 'Autoriser la création d\'événements';

  @override
  String get snapToOtherEvents => 'Accrocher aux autres événements';

  @override
  String get snapToTimeIndicator => 'Accrocher à l\'indicateur de temps';

  @override
  String get snapInterval => 'Intervalle d\'accrochage';

  @override
  String get snapRange => 'Portée d\'accrochage';

  @override
  String get firstDayOfWeek => 'Premier jour de la semaine';

  @override
  String minutesLabel(Object minutes) {
    return '$minutes minute(s)';
  }

  @override
  String get bodyConfiguration => 'Configuration du corps';

  @override
  String get showMultiDayEvents => 'Afficher les événements multi-jours';

  @override
  String get eventPaddingLR => 'Marge des événements (GD)';

  @override
  String get minimumTileHeight => 'Hauteur minimale des tuiles';

  @override
  String get none => 'Aucun';

  @override
  String get tileHeight => 'Hauteur des tuiles';

  @override
  String get eventPaddingLRTB => 'Marge des événements (GDHB)';

  @override
  String get emptyDayBehavior => 'Comportement jour vide';

  @override
  String get headerConfiguration => 'Configuration de l\'en-tête';

  @override
  String get showHeader => 'Afficher l\'en-tête';

  @override
  String showHeaderForView(Object view) {
    return 'Afficher l\'en-tête pour la vue $view';
  }

  @override
  String get showTiles => 'Afficher les tuiles';

  @override
  String get maxNumberOfVerticalEvents => 'Nombre max d\'événements verticaux';

  @override
  String get unlimited => 'Illimité';

  @override
  String viewConfigurationTitle(Object name) {
    return 'Configuration $name';
  }

  @override
  String get numberOfDays => 'Nombre de jours';

  @override
  String get startTime => 'Heure de début';

  @override
  String get endTime => 'Heure de fin';

  @override
  String get noViewConfigurationOptions => 'Aucune option de configuration disponible pour ce type de vue.';

  @override
  String get title => 'Titre';

  @override
  String get delete => 'Supprimer';

  @override
  String get preReleaseTitle => 'Exemple pré-version';

  @override
  String get preReleaseContent =>
      'Ceci est un exemple pré-version pour v0.16.0 qui n\'est pas encore publié.\n\nVoir la branche \'main-wip\' pour la progression.';

  @override
  String get gotIt => 'Compris';

  @override
  String get preReleaseInfo => 'Info pré-version';

  @override
  String get language => 'Langue';

  @override
  String get calendarLayout => 'Disposition du calendrier';

  @override
  String get previous => 'Précédent';

  @override
  String get next => 'Suivant';

  @override
  String get today => 'Aujourd\'hui';

  @override
  String get viewType => 'Type de vue';

  @override
  String get timezone => 'Fuseau horaire';

  @override
  String get configuration => 'Configuration';

  @override
  String get start => 'Début';

  @override
  String get end => 'Fin';

  @override
  String get newEventTitle => 'Nouvel événement';

  @override
  String get hideConfiguration => 'Masquer la configuration';

  @override
  String get showConfiguration => 'Afficher la configuration';
}

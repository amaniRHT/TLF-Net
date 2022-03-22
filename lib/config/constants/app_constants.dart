import 'dart:ui';

import 'package:e_loan_mobile/api/models/activity_area_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:get/get.dart';

class AppConstants {
  AppConstants._();
  static const int MAX_ITEMS_PER_PAGE = 10;
  static const String AGENCIES_URL =
      'http://www.tlf.com.tn/site/fr/reseaux.php?id_article=221';
  static const String GENERAL_CONDITION_URL =
      "http://192.168.1.174:81/static/media/cd.3262f7df.pdf";
  static const String REQUIRED_FIELD = 'Ce champ est obligatoire !';
  static const String ERROR_OCCURED = 'Une erreur est survenue';

  static const String NO_RESULTS = 'Aucun résultat trouvé';
  static const String androidDefaultDownloadDirectory =
      '/storage/emulated/0/Download';

  static const String WRONG_PASSWORD = 'Mot de passe incorrect';

  /* Input Controlls */
  static const String numberedAndAccentuedRegExp =
      '[\' a-zA-Z0-9\u002E\u2212\u207B\u02D7\u005F\u00C7\u00E7\u00C9\u00E9\u00EA\u00C8\u00E8\u02C6\u00E5\u00E0\u00DB\u00FB\u00D9\u00F9\u00C2\u00E2\u00C6\u00E6\u00C0\u00CA\u00EE\u00CE\u00CF\u00EF\u00D4\u00F4]';
  static const String accentuedRegExp =
      '[\' a-zA-Z\u002E\u2212\u207B\u02D7\u005F\u00C7\u00E7\u00C9\u00E9\u00EA\u00C8\u00E8\u02C6\u00E5\u00E0\u00DB\u00FB\u00D9\u00F9\u00C2\u00E2\u00C6\u00E6\u00C0\u00CA\u00EE\u00CE\u00CF\u00EF\u00D4\u00F4]';

  static Future<bool> quarterSecond = 0.25.delay().then((_) => false);
  static Future<bool> halfSecond = 0.5.delay().then((_) => false);
  static Future<bool> oneSecond = 1.delay().then((_) => false);
  static Future<bool> twoSeconds = 2.delay().then((_) => false);
  static Future<bool> threeSeconds = 3.delay().then((_) => false);
  static Future<bool> fourSeconds = 4.delay().then((_) => false);
  static Future<bool> fiveSeconds = 5.delay().then((_) => false);
  static Future<bool> falseFutrue = 0.delay().then((_) => false);

  /* Widget heights */
  static const double defaultAppBarHeight = 55.0;
  static const double extendedAppBarHeight = 120.0;
  static const double minimalTextFieldHeight = 40;
  static const double maximumTextFieldHeight = 47;
  static const double minimalButtonHeight = 30;
  static const double regularButtonHeight = 44;
  static const double maximumButtonHeight = 45;
  static const double cardButtonsSize = 35;

  /* Paddings */
  static const double _smallPaddingValue = 10;
  static const double _normalPaddingValue = 15;
  static const double _mediumPaddingValue = 20;
  static const double _largePaddingValue = 30;

  static const EdgeInsets smallPadding = EdgeInsets.symmetric(
    horizontal: _smallPaddingValue,
  );
  static const EdgeInsets normalPadding = EdgeInsets.symmetric(
    horizontal: _normalPaddingValue,
  );
  static const EdgeInsets mediumPadding = EdgeInsets.symmetric(
    horizontal: _mediumPaddingValue,
  );
  static const EdgeInsets largePadding = EdgeInsets.symmetric(
    horizontal: _largePaddingValue,
  );

  static const EdgeInsets dropDownPadding =
      EdgeInsets.only(left: 16, right: 24);

  /* Default Border radius */
  static const double smallestRadiusValue = 3.0;
  static const double smallRadiusValue = 5.0;
  static const double regularRadiusValue = 10.0;
  static const double largeRadiusValue = 20.0;

  static const Radius smallestRadius = Radius.circular(smallestRadiusValue);
  static const Radius smallRadius = Radius.circular(smallRadiusValue);
  static const Radius regularRadius = Radius.circular(regularRadiusValue);
  static const Radius largeRadius = Radius.circular(largeRadiusValue);

  static const BorderRadius smallestBorderRadius =
      BorderRadius.all(smallestRadius);
  static const BorderRadius smallBorderRadius = BorderRadius.all(smallRadius);
  static const BorderRadius regularBorderRadius =
      BorderRadius.all(regularRadius);
  static const BorderRadius largeBorderRadius = BorderRadius.all(largeRadius);

  static const BorderRadius modalsBoderRadius = BorderRadius.all(largeRadius);

  static final List<ActivityAreaModel> activityAreasFullList =
      <ActivityAreaModel>[
    new ActivityAreaModel(
      id: 1,
      code: "SA006",
      label: "Agriculteur",
      activityArea: "Agri Chas Sylvicultur, foresti",
      activity:
          "Activites des services annexes a la sylviculture et aux exploitations forestieres",
    ),
    new ActivityAreaModel(
      id: 2,
      code: "SA055",
      label: "Artisan",
      activityArea: "Ser Coll services personnels",
      activity: "Autres services personnels",
    ),
    new ActivityAreaModel(
      id: 3,
      code: "SA051",
      label: "Profession libérales (meddecin, avocat,,,)",
      activityArea: "Sante et action sociale",
      activity: "Pratique medicale",
    ),
    new ActivityAreaModel(
      id: 4,
      label: "Entreprise de travaux (BTP,,)",
      activityArea: "Autres travaux de construction",
      activity: "Construction",
      code: "SA011",
    ),
    new ActivityAreaModel(
      id: 5,
      code: "SA023",
      label: "Industrie agro alimentaire",
      activityArea: "Ind Man alimentaires",
      activity: "Industries alimentaires n.c.a.",
    ),
    new ActivityAreaModel(
      id: 6,
      code: "SA040",
      label: "Autre Industrie",
      activityArea: "Ind Man meuble, indust diverse",
      activity: "Autres activites manufacturieres n.c.a.",
    ),
    new ActivityAreaModel(
      id: 8,
      code: "SA010",
      label: "Commerce",
      activityArea: "Com Répar détail, artic domest",
      activity: "Autres commerces de detail hors magasin",
    ),
    new ActivityAreaModel(
      id: 9,
      code: "SA057",
      label: "Activité de service",
      activityArea: "Services domestiques",
      activity: "Services domestiques",
    ),
    new ActivityAreaModel(
      id: 10,
      code: "SA044",
      label: "Confection ou textile",
      activityArea: "Ind Man textile",
      activity: "Industries textiles n.c.a.",
    ),
    new ActivityAreaModel(
      id: 11,
      code: "SA015",
      label: "Location de voiture",
      activityArea: "Immo Loc Ser locat sans operat",
      activity: "Location de voiture",
    ),
    new ActivityAreaModel(
      id: 12,
      code: "SA060",
      label: "Agence de voyage",
      activityArea: "Transp Commu service auxiliair",
      activity: "Agences de voyages",
    ),
    new ActivityAreaModel(
      id: 13,
      code: "SA013",
      label: "Café et restaurant",
      activityArea: "Hotels avec restaurant",
      activity: "Hotels et restaurants",
    ),
    new ActivityAreaModel(
      id: 14,
      label: "Activité touristique",
      activityArea: "Hotels sans restaurant",
      activity: "Hotels et restaurants",
      code: "SA013",
    ),
    new ActivityAreaModel(
      id: 15,
      code: "SA017",
      label: "Promotion immobilière",
      activityArea: "Immobilier",
      activity: "Promotion immobiliere",
    ),
    new ActivityAreaModel(
      id: 16,
      code: "SA051",
      label: "Activité de la santé",
      activity: "Autres activites pour la sante humaine",
      activityArea: "Sante et action sociale",
    ),
    new ActivityAreaModel(
      id: 17,
      code: "SA004",
      label: "Autre activité",
      activity: "Autre activité",
      activityArea: "Activite inconnue",
    ),
  ];
}

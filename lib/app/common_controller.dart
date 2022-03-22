import 'package:e_loan_mobile/Helpers/base_controller.dart';
import 'package:e_loan_mobile/api/models/enums.dart';
import 'package:flutter/material.dart';
import 'package:flutter_masked_text2/flutter_masked_text2.dart';

class CommonController extends BaseController {
  String isoCode = 'TN';
  bool isCodeError = false;

  TextEditingController legalFormTEC = TextEditingController();
  TextEditingController leaglFirstnameTEC = TextEditingController();
  TextEditingController legalLastnameTEC = TextEditingController();
  TextEditingController tradeNameTEC = TextEditingController();
  TextEditingController cinTEC = TextEditingController();
  TextEditingController residencePermitTEC = TextEditingController();
  TextEditingController socialReasonTEC = TextEditingController();
  TextEditingController rneTEC = TextEditingController();
  TextEditingController typeTEC = TextEditingController();
  TextEditingController activityAreaTEC = TextEditingController();
  TextEditingController activityTEC = TextEditingController();

  TextEditingController entryDateTEC = TextEditingController();
  TextEditingController clientCodeTEC = TextEditingController();
  TextEditingController contractCodeTEC = TextEditingController();
  TextEditingController streetTEC = TextEditingController();
  TextEditingController postalCodeTEC = TextEditingController();
  TextEditingController localityTEC = TextEditingController();
  TextEditingController governorateTEC = TextEditingController();
  TextEditingController firstnameTEC = TextEditingController();
  TextEditingController lastnameTEC = TextEditingController();
  TextEditingController functionTEC = TextEditingController();
  // TextEditingController phoneTEC = TextEditingController();
  // TextEditingController mobileTEC = TextEditingController();
  MaskedTextController phoneTEC = MaskedTextController(mask: '00 00 00 00');
  MaskedTextController mobileTEC = MaskedTextController(mask: '00 00 00 00');

  TextEditingController emailTEC = TextEditingController();

  FocusNode legalFormFocusNode = FocusNode();
  FocusNode leaglFirstnameFocusNode = FocusNode();
  FocusNode legalLastnameFocusNode = FocusNode();
  FocusNode tradeNameFocusNode = FocusNode();
  FocusNode cinFocusNode = FocusNode();
  FocusNode residencePermitFocusNode = FocusNode();
  FocusNode socialReasonFocusNode = FocusNode();
  FocusNode rneFocusNode = FocusNode();
  FocusNode typeFocusNode = FocusNode();
  FocusNode activityAreaFocusNode = FocusNode();
  FocusNode activityFocusNode = FocusNode();
  FocusNode entryDateFocusNode = FocusNode();
  FocusNode clientCodeFocusNode = FocusNode();
  FocusNode clientContractFocusNode = FocusNode();
  FocusNode streetFocusNode = FocusNode();
  FocusNode postalCodeFocusNode = FocusNode();
  FocusNode firstnameFocusNode = FocusNode();
  FocusNode lastnameFocusNode = FocusNode();
  FocusNode functionFocusNode = FocusNode();
  FocusNode phoneFocusNode = FocusNode();
  FocusNode mobileFocusNode = FocusNode();
  FocusNode emailFocusNode = FocusNode();

  final List<String> legalForms = const <String>[
    'Personne',
    'Société',
  ];
  // final List<String> activityAreas = const <String>[
  //   'Agriculteur',
  //   'Artisan',
  //   'Profession libérale (médecin, avocat, auxiliaire de justice, etc)',
  //   'Entreprise de travaux (BTP, électricité, fluide, etc)',
  //   'Industrie agro-alimentaire',
  //   'Autre Industrie',
  //   'Commerce',
  //   'Activité de service',
  //   'Confection ou textile',
  //   'Location de voiture',
  //   'Agence de voyage',
  //   'Café, restaurant, etc',
  //   'Activité touristique',
  //   'Promotion immobilière',
  //   'Activité de la santé',
  //   'Autre activité',
  // ];

  final List<String> functions = const <String>[
    'Gérant',
    'Directeur',
    'Comptable',
    'Financier',
  ];
  final List<String> types = const <String>[
    'Association',
    'Coopérative des Services Agricoles',
    'Établissement publique',
    'Société Anonyme',
    'Société à Responsabilité Limitée',
    'Société Civile Professionnelle',
    'Société en Commandite par Action',
    'Société en Commandite Simple',
    'Société de Fait',
    'Société en Nom Collectif',
    //'Société unipersonnelle à responsabilité limité',
    'SUARL',
  ];

  Gender isMale = Gender.male;
  Answers isClient = Answers.no;
  Identity identityNatue = Identity.cin;
  String legalForm;
  String function;
  String activityArea;
  String type;
  String iso8601EntryDate = '';
  bool legalFormSelected = false;
  bool functionSelected = false;
  bool isPerson = false;
  bool isSociety = false;
  bool otherActivity = false;
  bool generalConditionsAccepted = false;
  bool isErrorGeneralConditions = false;
}

import 'dart:io';

import 'package:basic_utils/basic_utils.dart';
import 'package:device_info/device_info.dart';
import 'package:e_loan_mobile/Helpers/cities_by_postalcode.dart';
import 'package:e_loan_mobile/app/pages.dart';
import 'package:e_loan_mobile/config/config.dart';
import 'package:e_loan_mobile/config/constants/app_constants.dart';
import 'package:e_loan_mobile/config/env/tlf_environnments.dart';
import 'package:e_loan_mobile/routes/app_routes.dart';
import 'package:e_loan_mobile/widgets/menu.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_utils/src/get_utils/get_utils.dart';
import 'package:intl/intl.dart';
import 'package:open_file/open_file.dart';
import 'package:url_launcher/url_launcher.dart';

class UsefullMethods {
  UsefullMethods._();

  //date formater for all the application's dates
  static DateFormat dateFormat = DateFormat("dd-MM-yyyy");
  // ignore: missing_return
  static String constructNotificationText(dynamic notif) {
    final String type = notif.type;
    final String requestNumber = notif.requestNumber;
    final int status =
        notif.status is int ? notif.status : int.tryParse(notif.status);
    switch (type) {
      case 'financement':
        switch (status) {
          case 0:
            return "La demande de financement n° ${requestNumber} est en attente d'un complément";
          case 1:
            return "La demande de financement n° ${requestNumber} n'a été prise en charge";
          case 2:
            return 'La demande de financement n° ${requestNumber} a eu une suite favorable';
          case 3:
            return 'La demande de financement n° ${requestNumber} a été classée sans suite';
          case 4:
            return "La demande de financement n° ${requestNumber} est en attente d'un complément";
          default:
            break;
        }
        break;
      case 'cotation':
        switch (status) {
          case 0:
            return "La demande de cotation n° ${requestNumber} est en cours d'étude";
          case 1:
            return 'La demande de cotation n° ${requestNumber} a été annulée';
          case 2:
            return 'La demande de cotation n° ${requestNumber} a été traitée';
        }
        break;
      case 'rdv':
        switch (status) {
          case 0:
            return 'La demande de rendez-vous n° ${requestNumber} a été traitée';
          case 1:
            return 'La demande de rendez-vous n° ${requestNumber} a été annulée';
        }
        break;

      case 'sav':
        switch (status) {
          case 0:
            return 'La demande de changement de RIB n° ${requestNumber} a été résolue';
          case 1:
            return "La demande de changement d'adresse de facturation n° ${requestNumber} a été résolue";
          case 2:
            return 'La demande de cession du bien/matériel n° ${requestNumber} a été résolue';
          case 3:
            return 'La demande de rééchelonnement n° ${requestNumber} a été résolue';
          case 4:
            return 'La demande de changement de RIB n° ${requestNumber} a été clôturée';
          case 5:
            return "La demande de changement d'adresse de facturation n° ${requestNumber} a été clôturée";
          case 6:
            return 'La demande de cession du bien/matériel n° ${requestNumber} a été clôturée';
          case 7:
            return 'La demande de rééchelonnement n° ${requestNumber} a été clôturée';
          default:
            break;
        }
        break;
      case 'autreDemande':
        return 'La demande particulière n° ${requestNumber} a été traitée';

      default:
        return 'La demande particulière n° ${requestNumber} a été traitée';
    }
  }

  static void redirectNotification(dynamic notification) {
    final int _requestId = notification.requestId is int
        ? notification.requestId
        : int.tryParse(notification.requestId);
    switch (notification.type) {
      case 'financement':
        comingFromNotificationsScreenToFundingRequestDetailsPage = true;
        Get.find<MenuController>().selectedIndex.value = 11;
        Get.toNamed(
          AppRoutes.requestDetails,
          arguments: _requestId,
        );
        break;
      case 'cotation':
        comingFromNotificationsScreenToQuotationRequestDetailsPage = true;
        Get.find<MenuController>().selectedIndex.value = 12;

        Get.toNamed(
          AppRoutes.quotationRequestDetails,
          arguments: _requestId,
        );
        break;
      case 'rdv':
        comingFromNotificationsScreenToRDVsListPage = true;
        Get.find<MenuController>().selectedIndex.value = 13;

        Get.toNamed(
          AppRoutes.rdvsList,
          arguments: {
            'shouldOpenRdvDetailsModal': true,
            'rdvId': _requestId,
          },
        );
        break;

      default:
        break;
    }
  }

  static Future<String> getDeviceId() async {
    final DeviceInfoPlugin deviceInfo = DeviceInfoPlugin();
    if (Platform.isIOS) {
      // import 'dart:io'
      final IosDeviceInfo iosDeviceInfo = await deviceInfo.iosInfo;
      return iosDeviceInfo.identifierForVendor; // unique ID on iOS
    } else {
      final AndroidDeviceInfo androidDeviceInfo = await deviceInfo.androidInfo;
      return androidDeviceInfo.androidId; // unique ID on Android
    }
  }

  static String formatInvalidDate(String date) {
    final temp = date.split(' ').first;

    var d = temp.split('/').first;
    var m = temp.split('/')[0];
    d = d.padLeft(2, '0');
    m = m.padLeft(2, '0');
    return '$d/$m/${temp.split('/').last}';
  }

  static bool phoneNumberIsValid = true;

  static void unfocus(BuildContext context) {
    FocusScope.of(context).requestFocus(FocusNode());
  }

  static String toAbbreviatedDate(DateTime date, String locale) {
    return DateFormat.yMd(locale).format(date);
  }

  static String validateNotNullOrEmpty(String value) {
    if (value == null || value.isEmpty) {
      return AppConstants.REQUIRED_FIELD;
    } else
      return null;
  }

  static String validateNumberOfMonths(String value) {
    if (value == null || value.isEmpty) {
      return AppConstants.REQUIRED_FIELD;
    } else if (double.tryParse(value) == 0) {
      return 'Le nombre de mois ne peut pas être nul';
    } else
      return null;
  }

  static String validateSelfFunding({
    bool oldCar,
    String value,
    String maximum,
  }) {
    final String max = maximum.removeAllWhitespace;
    final String val = value.removeAllWhitespace;
    if (val.removeAllWhitespace.isEmpty)
      return AppConstants.REQUIRED_FIELD;
    else {
      if (max.isNotEmpty && int.parse(val) >= int.parse(max)) {
        return oldCar
            ? "L'autofinancement doit être inférieur au prix total"
            : "L'autofinancement doit être inférieur au prix TTC";
      } else
        return null;
    }
  }

  static String validateNonNullPrice(String value) {
    if (value == null || value.isEmpty) {
      return AppConstants.REQUIRED_FIELD;
    } else if (double.tryParse(value.removeAllWhitespace) == 0) {
      return 'Le montant ne peut pas être nul';
    } else
      return null;
  }

  static String validatePrice(String value) {
    if (value == null || value.isEmpty) {
      return AppConstants.REQUIRED_FIELD;
    } else
      return null;
  }

  static String validEmail(String value) {
    if (value == null || value.isEmpty) {
      return AppConstants.REQUIRED_FIELD;
    }
    if (!GetUtils.isEmail(value)) {
      return 'Email invalide';
    }
    return null;
  }

  static String validEmailFormat(String value) {
    if (value.isNotEmpty) {
      if (!GetUtils.isEmail(value)) {
        return 'Email invalide';
      }
    }
    return null;
  }

  static String validMinAmount(String value, String max) {
    if (value != null && value.isNotEmpty && max != null && max.isNotEmpty) {
      if (double.parse(value) >= double.parse(max)) {
        return 'min invalide';
      }
    }
    return null;
  }

  static String validMaxAmount(String value, String min) {
    if (value != null && value.isNotEmpty && min != null && min.isNotEmpty) {
      if (double.parse(value) <= double.parse(min)) {
        return 'min invalide';
      }
    }
    return null;
  }

  static String isLegalPassword(String password) {
    final RegExp regExp = RegExp(r'(?=.*\d)(?=.*[a-z])(?=.*[A-Z])(?=.*\W)');
    if (password == null || password.isEmpty) {
      return AppConstants.REQUIRED_FIELD;
    }
    if (password.length < 8 || !regExp.hasMatch(password)) {
      return 'Mot de passe invalide';
    }
    return null;
  }

  static String validPhoneNumber(String value) {
    if (value == null || value.isEmpty) {
      return AppConstants.REQUIRED_FIELD;
    }
    if (value.length != 11) {
      return 'Numéro invalide';
    }
    return null;
  }

  static String validMobileNumber(String value) {
    if (value != null && value.isNotEmpty && value.length != 11) {
      return 'Numéro invalide';
    }
    return null;
  }

  static String valideRNE(String value) {
    if (value == null || value.isEmpty) {
      return AppConstants.REQUIRED_FIELD;
    }
    if (value.length != 8 ||
        double.tryParse(value.substring(1, 7)) == null ||
        !value.substring(7, 8).contains(RegExp(r'[A-Za-z]'))) {
      return "RNE invalide: 7 chiffres et 1 lettre requis.\nExemple d'identifiant unique : 1616343A";
    }

    return null;
  }

  static String validPostalCode(String value) {
    if (value == null || value.isEmpty) {
      return AppConstants.REQUIRED_FIELD;
    }
    if (value.length != 4 || getCityByPostalCode(value) == null) {
      return 'Code postal invalide';
    }
    return null;
  }

  static String validateClientCodeOrClientContractField(String value) {
    if (value != null && value.isNotEmpty && value.length != 6) {
      return '6 chiffres obligatoires !';
    }
    return null;
  }

  static String validCIN(String value) {
    if (value == null || value.isEmpty) {
      return AppConstants.REQUIRED_FIELD;
    }
    if (value.length != 8) {
      return '8 chiffres obligatoires !';
    }
    return null;
  }

  static String getEquivalentFundingTypeFromInteger(int type) {
    String fundingType = '';
    switch (type) {
      case 0:
        fundingType = 'Véhicules';
        break;
      case 1:
        fundingType = 'Matériels et équipements';
        break;
      case 2:
        fundingType = 'Terrains et locaux professionnels';
        break;

      default:
        fundingType = 'Collecte de données..';
        break;
    }
    return fundingType;
  }

  static String getEquivalentSingleFundingTypeFromString(String type) {
    if (type.toLowerCase().contains('véhicule')) {
      return 'Véhicules';
    } else if (type.toLowerCase().contains('matériel')) {
      return 'Matériels et équipements';
    } else if (type.toLowerCase().contains('terrain')) {
      return 'Terrains et locaux professionnels';
    } else {
      return "Aucun type de bien n'est sélectionné";
    }
  }

  static Color getUserStatusColorFromInteger(int status) {
    Color statusColor = AppColors.orange;
    switch (status) {
      case 0:
        statusColor = AppColors.orange;
        break;
      case 1:
        statusColor = AppColors.green;
        break;
      case 2:
        statusColor = AppColors.darkerBlue;
        break;
    }
    return statusColor;
  }

  static Color getRDVStatusColorFromInteger(int status) {
    Color statusColor = AppColors.orange;
    switch (status) {
      case 0:
        statusColor = AppColors.blue;
        break;
      case 1:
        statusColor = AppColors.green;
        break;
      case 2:
        statusColor = AppColors.red;
        break;
    }
    return statusColor;
  }

  static Set<String> buildFundingTypesCodesList(Set<String> typesList) {
    final Set<String> fundingTypesList = <String>{};
    typesList.forEach((element) {
      switch (element) {
        case 'Véhicules':
          fundingTypesList.add('0');
          break;
        case 'Matériels et équipements':
          fundingTypesList.add('1');
          break;
        case 'Terrains et locaux professionnels':
          fundingTypesList.add('2');
          break;

        default:
      }
    });

    return fundingTypesList;
  }

  static String buildStringFromArray(Set<String> selectedList) {
    String listPrameter = '';
    selectedList.forEach((element) {
      listPrameter.isEmpty
          ? listPrameter = element
          : listPrameter = '$listPrameter,$element';
    });
    return listPrameter;
  }

  static Set<String> buildFundingTypesStatusCodesList(Set<String> statusList) {
    final Set<String> requestStatusList = <String>{};
    statusList.forEach((element) {
      switch (element) {
        case 'Créé':
          requestStatusList.add('0');
          break;
        case 'Soumis':
          requestStatusList.add('1');
          break;
        case "Prise en charge":
          requestStatusList.add('2');
          break;
        case "À l'étude":
          requestStatusList.add('3');
          break;
        case "En attente d'un complément":
          requestStatusList.add('4');
          break;
        case 'Favorable':
          requestStatusList.add('5');
          break;
        case 'Défavorable':
          requestStatusList.add('6');
          break;
        case 'Défavorable (TLFNET)':
          requestStatusList.add('7');
          break;
        case 'Annulé':
          requestStatusList.add('8');
          break;

        default:
      }
    });

    return requestStatusList;
  }

  static Set<String> buildQuotationStatusCodesList(Set<String> statusList) {
    final Set<String> requestStatusList = <String>{};
    statusList.forEach((element) {
      switch (element) {
        case 'Créé':
          requestStatusList.add('0');
          break;
        case 'Soumis':
          requestStatusList.add('1');
          break;
        //TODO: check this !!
        // case 'En attente':
        //   requestStatusList.add('2');
        //   break;
        case "À l'étude":
          requestStatusList.add('2');
          requestStatusList.add('3');
          break;
        case 'Traité':
          requestStatusList.add('4');
          break;
        case 'Annulé':
          requestStatusList.add('5');
          break;

        default:
      }
    });

    return requestStatusList;
  }

  static String getRequestStateFromInteger(int status) {
    String statusText = '';
    switch (status) {
      case 0:
        statusText = 'Créé';
        break;
      case 1:
        statusText = 'Soumis';
        break;
      case 2:
        statusText = "Prise en charge";
        break;
      case 3:
        statusText = "À l'étude";
        break;
      case 4:
        statusText = "En attente d'un complément";
        break;
      case 5:
        statusText = 'Favorable';
        break;
      case 6:
        statusText = 'Défavorable';
        break;
      case 7:
        statusText = 'Défavorable (TLFNET)';
        break;
      case 8:
        statusText = 'Annulé';
        break;

      default:
        statusText = 'Créé';
    }
    return statusText;
  }

  static String getQuotationRequestStateFromInteger(int status) {
    String statusText = '';
    switch (status) {
      case 0:
        statusText = 'Créé';
        break;
      case 1:
        statusText = 'Soumis';
        break;
      case 2:
        statusText = "À l'étude";
        break;
      case 3:
        statusText = "À l'étude";
        break;
      case 4:
        statusText = 'Traité';
        break;
      case 5:
        statusText = 'Annulé';
        break;

      default:
        statusText = 'Créé';
    }
    return statusText;
  }

  static Set<String> buildRdvStatusCodesList(Set<String> statusList) {
    final Set<String> requestStatusList = <String>{};
    statusList.forEach((element) {
      switch (element) {
        case 'Soumis':
          requestStatusList.add('0');
          break;
        case 'Traité':
          requestStatusList.add('1');
          break;
        case 'Annulé':
          requestStatusList.add('2');
          break;

        default:
      }
    });

    return requestStatusList;
  }

  static String validateCode(String firstCode, String secondCode) {
    if ((firstCode == null || firstCode.isEmpty) &&
        (secondCode == null || secondCode.isEmpty)) {
      return '';
    } else
      return null;
  }

  static String validatePhone(String value) {
    if (value == null || value.isEmpty) {
      return 'Cet champ est obligatoire !';
    } else if (!phoneNumberIsValid) {
      return 'Cet numéro est invalide !';
    }
    return null;
  }

  static String validateMobilePhone(String value) {
    if (value != null && value.isNotEmpty && !phoneNumberIsValid) {
      return 'Cet numéro est invalide !';
    }
    return null;
  }

  static String formatIntegerWithSpaceEach3Characters(int numberToFormat) {
    if (numberToFormat is int == false) {
      return numberToFormat.toString();
    }
    var formattedNumber = StringUtils.reverse(numberToFormat.toString());
    formattedNumber =
        StringUtils.addCharAtPosition(formattedNumber, ' ', 3, repeat: true);
    return StringUtils.reverse(formattedNumber);
  }

  static String formatDoubleWithSpaceEach3Characters(double numberToFormat) {
    if (numberToFormat is double == false) {
      return numberToFormat.toString();
    }
    final formattedNumber =
        '${formatIntegerWithSpaceEach3Characters(numberToFormat.floor())}.${numberToFormat.toStringAsFixed(3).split('.').last}';

    return formattedNumber;
  }

  static String formatValueWithSpaceEach3Characters(dynamic numberToFormat) {
    return numberToFormat is int
        ? formatIntegerWithSpaceEach3Characters(numberToFormat)
        : formatDoubleWithSpaceEach3Characters(numberToFormat);
  }

  static String formatStringWithSpaceEach3Characters(String stringToFormat) {
    bool isNumeric(String string) {
      final String s = string.removeAllWhitespace;
      if (s == null || s.isEmpty) return false;
      try {
        double.parse(s);
        return true;
      } catch (e) {
        return false;
      }
    }

    final String temp = stringToFormat.removeAllWhitespace;
    if (!isNumeric(temp)) return stringToFormat;
    var formattedNumber = StringUtils.reverse(temp);
    formattedNumber =
        StringUtils.addCharAtPosition(formattedNumber, ' ', 3, repeat: true);
    return StringUtils.reverse(formattedNumber);
  }

  static String formatStringWithSpaceEach2Characters(String stringToFormat) {
    bool isNumeric(String string) {
      final String s = string.removeAllWhitespace;
      if (s == null || s.isEmpty) return false;
      try {
        double.parse(s);
        return true;
      } catch (e) {
        return false;
      }
    }

    final String temp = stringToFormat.removeAllWhitespace;
    if (!isNumeric(temp)) return stringToFormat;
    var formattedNumber = StringUtils.reverse(temp);
    formattedNumber =
        StringUtils.addCharAtPosition(formattedNumber, ' ', 2, repeat: true);
    return StringUtils.reverse(formattedNumber);
  }

  static int toSafeInteger(String value) {
    return value.removeAllWhitespace.isNotEmpty
        ? double.tryParse(value.removeAllWhitespace).toInt()
        : 0;
  }

  static String calculatePercentage(int contribution, int total) {
    if (total == 0) return '0';
    return (100 * (contribution / total)).toStringAsFixed(2);
  }

  static String formatDate(String dateString) {
    if (dateString.length != 10) return 'Date invalide !';
    return DateFormat('dd/MM/yyyy').format(DateTime.parse(dateString));
  }

  static void preview({final String path, bool existant}) {
    if (existant) {
      launch(
        '${TLFEnvrionnments.baseUrl}$path',
        forceSafariVC: true,
      );
    } else
      OpenFile.open(path);
  }

  static String getEquivalentSingleUserStatusFromInteger(int status) {
    String userStatus = '';
    switch (status) {
      case 0:
        userStatus = 'En attente';
        break;
      case 1:
        userStatus = 'Actif';
        break;
      case 2:
        userStatus = 'Inactif';
        break;

      default:
        userStatus = 'Collecte de données..';
        break;
    }
    return userStatus;
  }

  static String getEquivalentRDVStatusFromInteger(int status) {
    String userStatus = '';
    switch (status) {
      case 0:
        userStatus = 'Soumis';
        break;
      case 1:
        userStatus = 'Traité';
        break;
      case 2:
        userStatus = 'Annulé';
        break;

      default:
        userStatus = 'Collecte de données..';
        break;
    }
    return userStatus;
  }

  static Set<String> buildUserStatusCodesList(Set<String> statusList) {
    final Set<String> userStatusList = <String>{};
    statusList.forEach((element) {
      switch (element) {
        case 'En attente':
          userStatusList.add('0');
          break;
        case 'Actif':
          userStatusList.add('1');
          break;
        case 'Inactif':
          userStatusList.add('2');
          break;

        default:
      }
    });

    return userStatusList;
  }

  static Color getFundingRequestStatusColorFromInteger(int status) {
    Color statusColor = AppColors.orange;
    switch (status) {
      case 0:
        statusColor = AppColors.lighterGreen;
        break;
      case 1:
        statusColor = AppColors.blue;
        break;
      case 2:
        statusColor = AppColors.purple;
        break;
      case 3:
        statusColor = AppColors.darkerBlue;
        break;
      case 4:
        statusColor = AppColors.lighterOrange;
        break;
      case 5:
        statusColor = AppColors.darkGreen;
        break;
      case 6:
        statusColor = AppColors.lighterRed;
        break;
      case 7:
        statusColor = AppColors.darkerBlue;
        break;
      case 8:
        statusColor = AppColors.red;
        break;

      default:
        statusColor = AppColors.lighterGreen;
    }
    return statusColor;
  }

  static Color getQuotationgRequestStatusColorFromInteger(int status) {
    Color statusColor = AppColors.orange;
    switch (status) {
      case 0:
        statusColor = AppColors.lighterGreen;
        break;
      case 1:
        statusColor = AppColors.blue;
        break;
      case 2:
        statusColor = AppColors.darkerBlue;
        break;
      case 3:
        statusColor = AppColors.darkerBlue;
        break;
      case 4:
        statusColor = AppColors.green;
        break;
      case 5:
        statusColor = AppColors.lighterRed;
        break;

      default:
        statusColor = AppColors.lighterGreen;
    }
    return statusColor;
  }
}

import 'package:e_loan_mobile/Helpers/helpers.dart';
import 'package:e_loan_mobile/api/models/models.dart';
import 'package:e_loan_mobile/api/services/services.dart';
import 'package:e_loan_mobile/app/controllers.dart';
import 'package:e_loan_mobile/widgets/widgets.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class RDVCreationController extends BaseController {
  final RDVsService _rdvsService = RDVsService();

  RendezVous currentRDV = RendezVous();

  bool creationMode = false;
  bool detailsMode = false;

  final GlobalKey<FormState> rdvCreationFormKey = GlobalKey<FormState>();

  TextEditingController rdvObjectTEC = TextEditingController();
  final FocusNode rdvObjectFocusNode = FocusNode();
  TextEditingController additionalInformationsTEC = TextEditingController();
  final FocusNode additionalInformationsFocusNode = FocusNode();

  void resetTECs() {
    rdvObjectTEC.text = '';
    additionalInformationsTEC.text = '';
    update();
  }

  void fillFieldsWithRDVDetails() {
    if (currentRDV == null) return;

    rdvObjectTEC.text = currentRDV.object;
    additionalInformationsTEC.text = currentRDV.additionalInformation;

    update();
  }

  void createRDV() {
    final RDVParameters rdvParameters = RDVParameters(
      object: rdvObjectTEC.text,
      additionalInformation: additionalInformationsTEC.text,
    );
    _rdvsService.createRDV(rdvParameters: rdvParameters).then(
      (bool success) {
        if (success) {
          showCustomToast(
            showAfterInMilliseconds: 300,
            contentText:
                "La demande de rendez-vous a été enregistré avec succès",
            onTheTop: false,
            blurEffectEnabled: false,
          );
          Get.find<RDVsListController>().getRDVs();
          Get.back();
        } else {
          showCustomToast(
            toastType: ToastTypes.error,
            contentText: "La création de la demande de rendez-vous a échoué",
            onTheTop: false,
            blurEffectEnabled: false,
          );
        }
        update();
      },
    );
  }

  void updateRDV() {
    final RDVParameters rdvParameters = RDVParameters(
        object: rdvObjectTEC.text,
        additionalInformation: additionalInformationsTEC.text,
        status: currentRDV.status);
    _rdvsService
        .updateRDV(id: currentRDV.id, rdvParameters: rdvParameters)
        .then(
      (bool success) {
        if (success) {
          showCustomToast(
            showAfterInMilliseconds: 300,
            contentText:
                "La demande de rendez-vous a été mis à jour avec succès",
            onTheTop: false,
            blurEffectEnabled: false,
          );          Get.find<RDVsListController>().getRDVs();

          Get.back();
        } else {
          showCustomToast(
            toastType: ToastTypes.error,
            contentText:
                "La modification de la demande de rendez-vous a échoué",
            onTheTop: false,
            blurEffectEnabled: false,
          );
        }
        update();
      },
    );
  }
}

import 'package:e_loan_mobile/Helpers/helpers.dart';
import 'package:e_loan_mobile/api/models/enums.dart';
import 'package:e_loan_mobile/api/models/models.dart';
import 'package:e_loan_mobile/api/services/services.dart';
import 'package:e_loan_mobile/app/common_request_controller.dart';
import 'package:e_loan_mobile/routes/routing.dart';
import 'package:e_loan_mobile/widgets/custom_toast.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class RequestCreationController extends CommonRequestController {
  bool isQuotation;
  RequestService fundingRequestService = RequestService(isQuotation: false);

  final RequestCreationService _service = RequestCreationService();

  bool firstTabIsValid = false;

  TabController tabController;
  int selectedTab = 0;

  FocusNode netIncomeFocusNode = FocusNode();
  FocusNode turnoverIncomeFocusNode = FocusNode();

  final List<String> fundingTypes = <String>[
    'Véhicules',
    'Matériels et équipements',
    'Terrains et locaux professionnels',
  ];

  Answers propertyTitle = Answers.yes;

  String fundingType;
  bool fundingTypeSelected = false;
  bool noDocumentsRequired = true;

  void getRequestDetails(int requestId) {
    fundingRequestService.getRequestDetails(requestId: requestId).then((Request request) {
      if (request != null) {
        currentRequest = request;
        fillFieldsWithRequestDetails();
      }
    });
  }

  void fillFieldsWithRequestDetails({bool forQuotationPurpose = false}) {
    if (currentRequest == null) return;
    final int fundingTypeId = currentRequest.type;
    final bool oldCar = fundingTypeId == 0 && !currentRequest.neuf;
    final bool newCar = fundingTypeId == 0 && !currentRequest.neuf;
    final bool materialOrEquipement = fundingTypeId == 1;
    final bool landOrLocals = fundingTypeId == 2;
    carState = oldCar ? CarStates.oldCar : CarStates.newCar;
    if (fundingTypeId >= fundingTypes.length) return;
    fundingType = fundingTypes[fundingTypeId];
    fundingTypeTEC.text = fundingTypes[fundingTypeId];
    fundingTypeSelected = true;
    updateFundingTypeForCurrentRequest();
    carAgeTEC.text = currentRequest.ageVehicule?.toString() ?? '';
    objectTEC.text = currentRequest.objet ?? '';
    totalPriceTEC.text = currentRequest.prixTotal?.toString() ?? '';
    percentageTEC.text = currentRequest.autofinancementpourcentage?.toString() ?? '';
    selfFinancingTEC.text = currentRequest.autofinancement?.toString() ?? '';
    durationTEC.text = currentRequest.duree?.toString() ?? '';
    htPriceTEC.text = currentRequest.prixHT?.toString() ?? '';
    tvaTEC.text = currentRequest.tva?.toString() ?? '';
    ttcPriceTEC.text = UsefullMethods.formatStringWithSpaceEach3Characters(
      currentRequest.prixTTC?.toString() ?? '',
    );
    providerTEC.text = currentRequest.fournisseur ?? '';
    sellerTEC.text = currentRequest.fournisseur ?? '';
    propertyTitle = currentRequest.titrePropriete == null
        ? Answers.yes
        : currentRequest.titrePropriete.toLowerCase() == 'true'
            ? Answers.yes
            : Answers.no;
    if (oldCar) {
      firstTabIsValid = objectTEC.text.isNotEmpty &&
          carAgeTEC.text.isNotEmpty &&
          totalPriceTEC.text.isNotEmpty &&
          selfFinancingTEC.text.isNotEmpty &&
          percentageTEC.text.isNotEmpty &&
          durationTEC.text.isNotEmpty;
    } else if (newCar) {
      firstTabIsValid = objectTEC.text.isNotEmpty &&
          htPriceTEC.text.isNotEmpty &&
          tvaTEC.text.isNotEmpty &&
          ttcPriceTEC.text.isNotEmpty &&
          selfFinancingTEC.text.isNotEmpty &&
          percentageTEC.text.isNotEmpty &&
          durationTEC.text.isNotEmpty;
    } else if (materialOrEquipement) {
      firstTabIsValid = objectTEC.text.isNotEmpty &&
          providerTEC.text.isNotEmpty &&
          htPriceTEC.text.isNotEmpty &&
          tvaTEC.text.isNotEmpty &&
          ttcPriceTEC.text.isNotEmpty &&
          selfFinancingTEC.text.isNotEmpty &&
          percentageTEC.text.isNotEmpty &&
          durationTEC.text.isNotEmpty;
    } else if (landOrLocals) {
      firstTabIsValid = objectTEC.text.isNotEmpty &&
          sellerTEC.text.isNotEmpty &&
          htPriceTEC.text.isNotEmpty &&
          tvaTEC.text.isNotEmpty &&
          ttcPriceTEC.text.isNotEmpty &&
          selfFinancingTEC.text.isNotEmpty &&
          percentageTEC.text.isNotEmpty &&
          durationTEC.text.isNotEmpty;
    }

    if (forQuotationPurpose) {
      update();
      return;
    }

    for (int i = 0; i < (currentRequest.demDocMan?.length ?? 0); i++) {
      final DemDocMan document = currentRequest.demDocMan[i];
      final DocsManagement formattedDocument = DocsManagement(
        hasBeenUpdated: true,
        id: document.docMan.id,
        title: document.docMan.title,
        isRequired: document.docMan.isRequired,
        validDocument: true,
        status: document.status == 1,
        invalidDocument: false,
        validComplement: false,
        invalidComplement: false,
        moreThenOneFile: document.docMan.moreThenOneFile,
        filled: document.files.where((CategoryFiles files) => files.path.isNotEmpty).length != 0,
        files: document.files,
        isComplement: false,
      );
      requiredDouments.add(formattedDocument);
    }

    noDocumentsRequired = currentRequest.demDocMan?.isEmpty ?? true;
    update();
  }

  void reinitialiseTECs() {
    carAgeTEC.text = '';
    objectTEC.text = '';
    totalPriceTEC.text = '';
    percentageTEC.text = '';
    selfFinancingTEC.text = '';
    durationTEC.text = '';
    htPriceTEC.text = '';
    tvaTEC.text = '';
    ttcPriceTEC.text = '';
    providerTEC.text = '';
    sellerTEC.text = '';
    update();
  }

  void validateForms() {
    if (!shouldValidateForms || fundingTypeFormKey.currentState == null || informationsFormKey.currentState == null) return;

    fundingTypeFormKey.currentState.validate();
    informationsFormKey.currentState.validate();
    shouldValidateForms = false;
  }

  void getDocumentsforType() {
    final String documentsType = _equivalentIntegerForFundingType().toString();
    _service.getDocumentsforType(type: documentsType).then((RequiredDouments requiredDoumentsResponse) {
      requiredDouments = requiredDoumentsResponse.docsManagement;
      noDocumentsRequired = requiredDouments.isEmpty;
      update();
    });
  }

  void _showMissingDocumentsAlert() {
    if (requiredDouments.where((element) => element.filled).toList().length != requiredDouments.length)
      showCustomToast(
        showAfterInMilliseconds: 300,
        toastType: ToastTypes.warning,
        contentText: 'Votre dossier est non complet ! Vous avez encore des documents manquants !',
        onTheTop: false,
        duration: 3,
        blurEffectEnabled: false,
      );
  }

  void createRequest({
    bool withCreatedStatus = false,
  }) {
    final RequestParameters currentRequestParameters = RequestParameters(
      type: _equivalentIntegerForFundingType(),
      duree: durationTEC.text,
      autofinancementpourcentage: percentageTEC.text,
      autofinancement: selfFinancingTEC.text.removeAllWhitespace,
      objet: objectTEC.text,
      neuf: carState == CarStates.newCar,
      ageVehicule: carAgeTEC.text,
      prixTotal: totalPriceTEC.text.removeAllWhitespace,
      prixHT: htPriceTEC.text.removeAllWhitespace,
      tva: tvaTEC.text.removeAllWhitespace,
      prixTTC: ttcPriceTEC.text.removeAllWhitespace,
      fournisseur: _equivalentIntegerForFundingType() == 1 ? providerTEC.text : sellerTEC.text,
      titrePropriete: fundingType == fundingTypes[2]
          ? propertyTitle == Answers.yes
              ? true
              : false
          : null,
      status: withCreatedStatus ? 0 : 1,
      files: prepareFilesToAttach(requiredDouments),
    );
    DioRequestsInterceptor.hideLoader();
    _service.createFundingRequest(requestParameters: currentRequestParameters).then((String createdRequestCode) async {
      if (createdRequestCode != null) {
        if (withCreatedStatus) {
          //! Saved with CREATED State
          showCustomToast(
            showAfterInMilliseconds: 300,
            contentText: 'Votre demande de financement n°$createdRequestCode a été enregistrée',
            blurEffectEnabled: false,
            padding: 80,
          );
          Get.offAllNamed(AppRoutes.requestsList);
        } else {
          //? Saved with SUBMITTED State
          _showMissingDocumentsAlert();

          Get.offAllNamed(
            AppRoutes.requestCreationSuccess,
            arguments: _numberOFDaysToTreatRequest(),
          );
        }
      } else {
        showCustomToast(
          toastType: ToastTypes.error,
          contentText: 'La création de votre demande a échoué',
          onTheTop: false,
          blurEffectEnabled: false,
        );
      }
    });
  }

  void updateRequest({
    bool withCreatedStatus = false,
  }) {
    final RequestParameters currentRequestParameters = RequestParameters(
      id: currentRequest.id,
      type: _equivalentIntegerForFundingType(),
      duree: durationTEC.text,
      autofinancementpourcentage: percentageTEC.text,
      autofinancement: selfFinancingTEC.text.removeAllWhitespace,
      objet: objectTEC.text,
      neuf: carState == CarStates.newCar,
      ageVehicule: carAgeTEC.text,
      prixTotal: totalPriceTEC.text.removeAllWhitespace,
      prixHT: htPriceTEC.text.removeAllWhitespace,
      tva: tvaTEC.text.removeAllWhitespace,
      prixTTC: ttcPriceTEC.text.removeAllWhitespace,
      fournisseur: _equivalentIntegerForFundingType() == 1 ? providerTEC.text : sellerTEC.text,
      titrePropriete: fundingType == fundingTypes[2]
          ? propertyTitle == Answers.yes
              ? true
              : false
          : null,
      status: withCreatedStatus ? 0 : 1,
      files: prepareFilesToAttach(requiredDouments),
      filesToRemoveIds: filesToRemoveIds.join(', '),
    );
    DioRequestsInterceptor.hideLoader();
    _service.updateFundingRequest(requestParameters: currentRequestParameters).then((String updatedRequestCode) async {
      if (updatedRequestCode != null) {
        if (withCreatedStatus) {
          //! Saved with CREATED State
          showCustomToast(
            showAfterInMilliseconds: 300,
            contentText: 'Votre demande de financement n°$updatedRequestCode a été mise à jour',
            onTheTop: false,
            blurEffectEnabled: false,
            padding: 70,
          );
          Get.offAllNamed(AppRoutes.requestsList);
        } else {
          //? Saved with SUBMITTED State
          _showMissingDocumentsAlert();

          Get.offAllNamed(
            AppRoutes.requestCreationSuccess,
            arguments: _numberOFDaysToTreatRequest(),
          );
        }
      } else {
        showCustomToast(
          toastType: ToastTypes.error,
          contentText: 'La mise à jour de votre demande a échoué',
          onTheTop: false,
          blurEffectEnabled: false,
        );
      }
    });
  }

  int _equivalentIntegerForFundingType() {
    return fundingType == fundingTypes[0]
        ? 0
        : fundingType == fundingTypes[1]
            ? 1
            : 2;
  }

  int _numberOFDaysToTreatRequest() {
    return fundingType == fundingTypes[0]
        ? 2
        : fundingType == fundingTypes[1]
            ? 3
            : 5;
  }
}

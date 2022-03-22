import 'package:e_loan_mobile/Helpers/helpers.dart';
import 'package:e_loan_mobile/api/models/enums.dart';
import 'package:e_loan_mobile/api/models/models.dart';
import 'package:e_loan_mobile/api/services/services.dart';
import 'package:e_loan_mobile/app/common_request_controller.dart';
import 'package:e_loan_mobile/routes/routing.dart';
import 'package:e_loan_mobile/widgets/custom_toast.dart';
import 'package:get/get.dart';

class QuotationCreationController extends CommonRequestController {
  final QuotationCreationService _quotationCreationService = QuotationCreationService();
  final RequestService _fundingRequestService = RequestService(isQuotation: true);

  final List<String> fundingTypes = <String>[
    'Véhicules',
    'Matériels et équipements',
    'Terrains et locaux professionnels',
  ];

  Answers propertyTitle = Answers.yes;

  String fundingType;
  bool fundingTypeSelected = false;
  bool noDocumentsRequired = true;

  void reinitialiseTECs() {
    netIncomeTEC.text = '';
    turnoverIncomeTEC.text = '';
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

  void getRequestDetails(int requestId) {
    _fundingRequestService.getRequestDetails(requestId: requestId).then((Request request) {
      if (request != null) {
        currentRequest = request;
        fillFieldsWithRequestDetails();
      }
    });
  }

  void fillFieldsWithRequestDetails() {
    if (currentRequest == null) return;
    final int fundingTypeId = currentRequest.type;

    if (fundingTypeId >= fundingTypes.length) return;
    fundingType = fundingTypes[fundingTypeId];
    fundingTypeTEC.text = fundingTypes[fundingTypeId];
    fundingTypeSelected = true;
    updateFundingTypeForCurrentRequest();
    netIncomeTEC.text = currentRequest.revenus.toString() ?? '';
    turnoverIncomeTEC.text = currentRequest.benefice?.toString() ?? '';
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
        : currentRequest.titrePropriete.toLowerCase() == 'oui'
            ? Answers.yes
            : Answers.no;

    update();
  }

  void createRequest({
    bool withCreatedStatus = false,
  }) {
    final RequestParameters currentRequestParameters = RequestParameters(
      type: _equivalentIntegerForFundingType(),
      revenus: turnoverIncomeTEC.text.removeAllWhitespace,
      benefice: netIncomeTEC.text.removeAllWhitespace,
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
    );
    DioRequestsInterceptor.hideLoader();
    _quotationCreationService.createQuotaionRequest(requestParameters: currentRequestParameters).then((String createdRequestCode) async {
      if (createdRequestCode != null) {
        if (withCreatedStatus) {
          //! Saved with CREATED State
          showCustomToast(
            showAfterInMilliseconds: 300,
            contentText: 'Votre demande de cotation n°$createdRequestCode a été enregistrée',
            blurEffectEnabled: false,
            padding: 80,
          );
          Get.offAllNamed(AppRoutes.quotationRequestsList);
        } else {
          Get.offAllNamed(
            AppRoutes.requestCreationSuccess,
            arguments: null,
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
      revenus: turnoverIncomeTEC.text.removeAllWhitespace,
      benefice: netIncomeTEC.text.removeAllWhitespace,
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
    );
    DioRequestsInterceptor.hideLoader();
    _quotationCreationService
        .updateQuotationRequest(quotaionRequestId: currentRequest.id, requestParameters: currentRequestParameters)
        .then((String updatedRequestCode) async {
      if (updatedRequestCode != null) {
        if (withCreatedStatus) {
          //! Saved with CREATED State
          showCustomToast(
            showAfterInMilliseconds: 300,
            contentText: 'Votre demande de cotation n°$updatedRequestCode a été mise à jour',
            onTheTop: false,
            blurEffectEnabled: false,
            padding: 70,
          );
          Get.offAllNamed(AppRoutes.quotationRequestsList);
        } else {
          Get.offAllNamed(
            AppRoutes.requestCreationSuccess,
            arguments: null,
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
}

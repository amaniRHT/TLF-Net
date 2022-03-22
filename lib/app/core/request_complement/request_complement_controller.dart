import 'package:e_loan_mobile/Helpers/helpers.dart';
import 'package:e_loan_mobile/api/models/models.dart';
import 'package:e_loan_mobile/api/services/services.dart';
import 'package:e_loan_mobile/app/common_request_controller.dart';
import 'package:e_loan_mobile/app/controllers.dart';
import 'package:e_loan_mobile/widgets/custom_toast.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class RequestComplementController extends CommonRequestController {
  List<DocsManagement> requiredDouments = <DocsManagement>[];
  final RequestService _fundingRequestService = RequestService(isQuotation: false);

  final GlobalKey<FormState> documentNameFormKey = GlobalKey<FormState>();

  int requestId;

  Request currentRequest = Request();

  int requestStatus = -1;
  String requestCode = '';

  void getRequestDetails(int requestId) {
    this.requestId = requestId;
    _fundingRequestService.getRequestDetails(requestId: requestId).then(
      (Request request) {
        if (request != null) {
          successState();
          requiredDouments = <DocsManagement>[];
          currentRequest = request;
          requestStatus = request.status ?? 0;
          requestCode = request.code ?? '';
          final List<DemDocMan> _requestDocuments = request.demDocMan + request.demComplement;

          for (int i = 0; i < _requestDocuments.length; i++) {
            final DemDocMan document = _requestDocuments[i];
            final DocsManagement formattedDocument = DocsManagement(
              id: document.docMan.id,
              hasBeenUpdated: false,
              title: document.docMan.title,
              isRequired: document.docMan.isRequired,
              status: document.status == 1,
              validDocument: document.status == 0 && !document.isComplement,
              invalidDocument: document.status == 1 && !document.isComplement,
              validComplement: document.status == 0 && document.isComplement,
              invalidComplement: document.status == 1 && document.isComplement,
              moreThenOneFile: document.docMan.moreThenOneFile,
              filled: document.files.where((CategoryFiles files) => files.path.isNotEmpty).length != 0,
              files: List<CategoryFiles>.from(document.files),
              isComplement: document.isComplement,
              exists: true,
            );
            requiredDouments.add(formattedDocument);
          }

          update();
        }
      },
    );
  }

  TextEditingController documentNameTEC = TextEditingController();
  final FocusNode documentNameFocusNode = FocusNode();
  final RequestCreationService _requestCreationService = RequestCreationService();

  void addComplement() {
    UsefullMethods.unfocus(KeysStorage.mainNavigatorKey.currentContext);
    if (!documentNameFormKey.currentState.validate()) return;
    _requestCreationService
        .addComplement(
            requestId: currentRequest.id,
            moreThanOneFile: true,
            title: documentNameTEC.text,
            type: currentRequest.type.toString())
        .then((DocsManagement createdDocument) {
      if (createdDocument != null) {
        documentNameTEC.text = '';
        Get.back(closeOverlays: true);
        showCustomToast(
          showAfterInMilliseconds: 300,
          contentText: 'La jointure de document a été effectuée avec succès',
          onTheTop: false,
          blurEffectEnabled: false,
          padding: 80,
        );
      } else {
        showCustomToast(
          toastType: ToastTypes.error,
          contentText: 'La jointure de document a échoué',
          onTheTop: false,
          blurEffectEnabled: false,
        );
      }
      // getRequestDetails(requestId);
      requiredDouments.add(createdDocument);
      update();
    });
  }

  void updateRequestDocuments() async {
    final RequestParameters currentRequestParameters = RequestParameters(
      id: currentRequest.id,
      status: 1,
      files: prepareFilesToAttach(requiredDouments),
      filesToRemoveIds: filesToRemoveIds.join(', '),
    );
    _requestCreationService
        .updateFundingRequest(
      requestParameters: currentRequestParameters,
      documentsCompletionPurpose: true,
    )
        .then((String updatedRequestCode) async {
      if (updatedRequestCode != null) {
        Get.back<bool>(result: true);

        if (requiredDouments.where((element) => element.filled).toList().length != requiredDouments.length)
          showCustomToast(
            showAfterInMilliseconds: 300,
            toastType: ToastTypes.warning,
            contentText: 'Votre dossier est non complet ! Vous avez encore des documents manquants !',
            onTheTop: false,
            padding: 110,
            blurEffectEnabled: false,
          );
        showCustomToast(
          showAfterInMilliseconds: 300,
          contentText: 'Votre demande de financement n°$updatedRequestCode a été soumise',
          onTheTop: false,
          blurEffectEnabled: false,
        );
      } else {
        showCustomToast(
          toastType: ToastTypes.error,
          contentText: 'La soumission de votre demande a échoué',
          onTheTop: false,
          blurEffectEnabled: false,
        );
      }
    });
  }
}

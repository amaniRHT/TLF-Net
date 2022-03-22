import 'package:e_loan_mobile/Helpers/base_controller.dart';
import 'package:e_loan_mobile/api/models/enums.dart';
import 'package:e_loan_mobile/api/models/models.dart';
import 'package:e_loan_mobile/api/models/required_documents.dart';
import 'package:e_loan_mobile/api/services/request_service.dart';
import 'package:e_loan_mobile/routes/app_routes.dart';
import 'package:e_loan_mobile/widgets/custom_toast.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_masked_text2/flutter_masked_text2.dart';
import 'package:get/get.dart';

class CommonRequestController extends BaseController {
  bool creationMode = false;
  Request currentRequest = Request();

  final GlobalKey<FormState> informationsFormKey = GlobalKey<FormState>();
  final GlobalKey<FormState> fundingTypeFormKey = GlobalKey<FormState>();

  bool shouldValidateForms = false;

  FundingTypes selectedFundingType;
  CarStates carState = CarStates.newCar;

  TextEditingController fundingTypeTEC = TextEditingController();
  TextEditingController carAgeTEC = TextEditingController();
  TextEditingController objectTEC = TextEditingController();

  MaskedTextController totalPriceTEC = MaskedTextController(mask: '000 000 000');
  MaskedTextController htPriceTEC = MaskedTextController(mask: '000 000 000');
  MaskedTextController tvaTEC = MaskedTextController(mask: '000 000 000');

  TextEditingController ttcPriceTEC = TextEditingController();

  MaskedTextController selfFinancingTEC = MaskedTextController(mask: '000 000 000');
  TextEditingController percentageTEC = TextEditingController();

  TextEditingController providerTEC = TextEditingController();
  TextEditingController sellerTEC = TextEditingController();
  TextEditingController durationTEC = TextEditingController();
  MaskedTextController netIncomeTEC = MaskedTextController(mask: '000 000 000');
  MaskedTextController turnoverIncomeTEC = MaskedTextController(mask: '000 000 000');

  FocusNode fundingTypeFocusNode = FocusNode();
  FocusNode carAgeFocusNode = FocusNode();
  FocusNode objectFocusNode = FocusNode();
  FocusNode totalPriceFocusNode = FocusNode();
  FocusNode percentageFocusNode = FocusNode();
  FocusNode selfFinancingFocusNode = FocusNode();
  FocusNode htPriceFocusNode = FocusNode();
  FocusNode tvaFocusNode = FocusNode();
  FocusNode ttcPriceFocusNode = FocusNode();
  FocusNode providerFocusNode = FocusNode();
  FocusNode sellerFocusNode = FocusNode();
  FocusNode durationFocusNode = FocusNode();
  FocusNode netIncomeFocusNode = FocusNode();
  FocusNode turnoverIncomeFocusNode = FocusNode();

  List<DocsManagement> requiredDouments = <DocsManagement>[];

  List<String> filesToRemoveIds = <String>[];

  void pickFile(bool mounted, int index) async {
    List<PlatformFile> _paths = const <PlatformFile>[];
    const List<String> _allowedExtensions = <String>[
      'jpeg',
      'jpg',
      'png',
      'pdf',
    ];

    try {
      _paths = (await FilePicker.platform.pickFiles(
        type: FileType.custom,
        allowedExtensions: _allowedExtensions,
        allowMultiple: false,
        allowCompression: true,
      ))
          ?.files;
    } on PlatformException catch (e) {
      // ignore: avoid_print
      print('Unsupported operation $e');
    } catch (ex) {
      // ignore: avoid_print
      print(ex);
    }
    if (!mounted || _paths == null || _paths.isEmpty || index >= requiredDouments.length) return;

    final CategoryFiles pickedFile = CategoryFiles(
      parentCategoryId: requiredDouments[index].id,
      parentCategoryRefrenceId: requiredDouments[index].isComplement == null
          ? 'd${requiredDouments[index].id}'
          : '${requiredDouments[index].isComplement ? 'c' : 'd'}${requiredDouments[index].id}',
      originalname: _paths.first.name,
      name: _paths.first.name,
      ext: _paths.first.extension.toLowerCase(),
      path: _paths.first.path,
      size: _paths.first.size,
    );
    requiredDouments[index].files.add(pickedFile);
    requiredDouments[index].filled = true;
    requiredDouments[index].hasBeenUpdated = true;
    update();
  }

  void deleteFile(int documentIndex, int fileIndex) {
    if (documentIndex < requiredDouments.length && fileIndex < requiredDouments[documentIndex].files.length) {
      final DocsManagement requiredDocument = requiredDouments[documentIndex];
      if (requiredDocument.files[fileIndex].exists) {
        // Add the file id to the filesToRemoveIds array
        filesToRemoveIds.add(requiredDocument.files[fileIndex].id.toString());
      }
      requiredDocument.files.removeAt(fileIndex);
      requiredDocument.filled = requiredDocument.files.isNotEmpty;
      update();
    }
  }

  List<CategoryFiles> prepareFilesToAttach(
    List<DocsManagement> requiredDouments,
  ) {
    if (requiredDouments == null || requiredDouments.isEmpty) return <CategoryFiles>[];

    final List<CategoryFiles> filesToAttach = <CategoryFiles>[];
    requiredDouments.forEach((DocsManagement requiredDoument) {
      requiredDoument.files.forEach((CategoryFiles file) {
        filesToAttach.add(file);
      });
    });
    filesToAttach.removeWhere((CategoryFiles element) => element.parentCategoryRefrenceId == null);
    return filesToAttach;
  }

  void updateFundingTypeForCurrentRequest() {
    if (currentRequest.type == 0) {
      selectedFundingType = currentRequest.neuf ? FundingTypes.newCar : FundingTypes.oldCar;
      carState = currentRequest.neuf ? CarStates.newCar : CarStates.oldCar;
    } else if (currentRequest.type == 1) {
      selectedFundingType = FundingTypes.materialOrEquipement;
    } else {
      selectedFundingType = FundingTypes.landOrLocals;
    }
  }

  void deleteRequest({
    int requestId,
    String requestCode,
    bool forQuotationPurpose = false,
  }) {
    RequestService(isQuotation: forQuotationPurpose).deleteRequest(requestId: requestId).then(
      (bool success) async {
        if (success) {
          Get.offAllNamed(
            forQuotationPurpose ? AppRoutes.quotationRequestsList : AppRoutes.requestsList,
          );
          showCustomToast(
            showAfterInMilliseconds: 300,
            padding: 65,
            contentText: 'La demande n°$requestCode a été supprimé avec succès',
            blurEffectEnabled: false,
          );
        } else {
          showCustomToast(
            padding: 65,
            toastType: ToastTypes.error,
            contentText: 'La suppression de demande a échoué',
            blurEffectEnabled: false,
          );
        }
      },
    );
  }
}

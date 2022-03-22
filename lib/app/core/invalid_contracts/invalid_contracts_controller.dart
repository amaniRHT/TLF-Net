import 'package:e_loan_mobile/Helpers/helpers.dart';
import 'package:e_loan_mobile/api/models/models.dart';
import 'package:e_loan_mobile/api/services/invalid_contracts_service.dart';
import 'package:e_loan_mobile/app/common_account_tracking_controller.dart';
import 'package:e_loan_mobile/config/constants/app_constants.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:permission_handler/permission_handler.dart';

class InvalidContractsController extends CommonAccountTrackingController {
  void reinitialize() {
    filterCount = 0;
    totalResults = 0;
    getInvalidContracts(fromBeginnig: true);

    scrollController?.addListener(() {
      if (scrollController.position.pixels ==
          scrollController.position.maxScrollExtent) {
        getInvalidContracts();
      }
    });
  }

  final InvalidContractsService _invalidContractsService =
      InvalidContractsService();

  int filterCount = 0;
  int totalResults = 0;
  final ScrollController scrollController = ScrollController();
  List<Contrats> invalidContractsList = [];
  bool isLoading = false;
  bool noMorePages = false;
  int page = 1;

  void getInvalidContracts({bool fromBeginnig = false}) {
    if (isLoading) return;
    if (noMorePages && !fromBeginnig) return;
    isLoading = true;
    update();
    page = fromBeginnig ? 1 : page + 1;
    if (fromBeginnig)
      invalidContractsList.clear();
    else
      DioRequestsInterceptor.disableLoader();
    print(page);

    final RepaymentFilteringParameters filteringParameters =
        RepaymentFilteringParameters(
      column: null,
      order: null,
      limit: AppConstants.MAX_ITEMS_PER_PAGE,
      page: page,
    );
    _invalidContractsService
        .getInvalidContracts(parameters: filteringParameters)
        .then((InvalidContractsListModel invalidContractsListModel) {
      if (invalidContractsListModel != null &&
          invalidContractsListModel.contrats != null) {
        totalResults = invalidContractsListModel.contrats.length;
        noMorePages = invalidContractsListModel.contrats.length <
            AppConstants.MAX_ITEMS_PER_PAGE;
        invalidContractsList.addAll(invalidContractsListModel.contrats);
        invalidContractsList.sort((Contrats a, Contrats b) {
          return DateTime.parse(a.datePremierLoyer.substring(0, 10))
                  .isBefore(DateTime.parse(b.datePremierLoyer.substring(0, 10)))
              ? 1
              : -1;
        });
      }
      if (invalidContractsList.isEmpty) totalResults = 0;
      isLoading = false;
      update();
      DioRequestsInterceptor.enableLoader();
      if (Get.context.isTablet &&
          invalidContractsList.length == AppConstants.MAX_ITEMS_PER_PAGE)
        AppConstants.halfSecond.then(
          (value) => getInvalidContracts(fromBeginnig: false),
        );
    }).onError((dynamic error, StackTrace stackTrace) {
      page = fromBeginnig ? 1 : page - 1;
      isLoading = false;
      DioRequestsInterceptor.enableLoader();
    }).whenComplete(() {
      DioRequestsInterceptor.enableLoader();
      isLoading = false;
    });
  }

  void downloadInvalidContractsList() {
    final RepaymentFilteringParameters filteringParameters =
        RepaymentFilteringParameters();

    Permission.storage.request().then((PermissionStatus permissionStatus) {
      if (permissionStatus == PermissionStatus.granted)
        _invalidContractsService
            .downloadPDF(parameters: filteringParameters)
            .then((List<int> binaryFile) {
          handleDownloadState(
              binaryFile: binaryFile, fileName: 'contrats_échus');
        });
    });
  }
}

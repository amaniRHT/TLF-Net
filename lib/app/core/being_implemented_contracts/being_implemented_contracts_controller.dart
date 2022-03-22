import 'package:e_loan_mobile/Helpers/helpers.dart';
import 'package:e_loan_mobile/api/models/models.dart';
import 'package:e_loan_mobile/api/services/being_implemented_contracts_service.dart';
import 'package:e_loan_mobile/app/common_account_tracking_controller.dart';
import 'package:e_loan_mobile/config/config.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:permission_handler/permission_handler.dart';

class BeingImplementedContractsController
    extends CommonAccountTrackingController {
  void reinitialize() {
    filterCount = 0;
    totalResults = 0;
    getBeingImplementedContracts(fromBeginnig: true);

    scrollController?.addListener(() {
      if (scrollController.position.pixels ==
          scrollController.position.maxScrollExtent) {
        getBeingImplementedContracts();
      }
    });
  }

  final BeingImplementedContractsService _beingImplementedContractsService =
      BeingImplementedContractsService();

  int filterCount = 0;
  int totalResults = 0;
  final ScrollController scrollController = ScrollController();
  List<Contrats> beingImplementedContractsList = [];
  bool isLoading = false;
  bool noMorePages = false;
  int page = 1;

  void getBeingImplementedContracts({bool fromBeginnig = false}) {
    if (isLoading) return;
    if (noMorePages && !fromBeginnig) return;
    isLoading = true;
    update();
    page = fromBeginnig ? 1 : page + 1;
    if (fromBeginnig)
      beingImplementedContractsList.clear();
    else
      DioRequestsInterceptor.disableLoader();

    final RepaymentFilteringParameters filteringParameters =
        RepaymentFilteringParameters(
      column: null,
      order: null,
      limit: AppConstants.MAX_ITEMS_PER_PAGE,
      page: page,
    );
    _beingImplementedContractsService
        .getBeingImplementedContracts(parameters: filteringParameters)
        .then((BeingImplementedContractsListModel
            beingImplementedContractsListModel) {
      if (beingImplementedContractsListModel != null &&
          beingImplementedContractsListModel.contrats != null) {
        totalResults = beingImplementedContractsListModel.contrats.length;
        noMorePages = beingImplementedContractsListModel.contrats.length <
            AppConstants.MAX_ITEMS_PER_PAGE;
        beingImplementedContractsList
            .addAll(beingImplementedContractsListModel.contrats);
      }
      if (beingImplementedContractsList.isEmpty) totalResults = 0;
      isLoading = false;
      update();
      DioRequestsInterceptor.enableLoader();
      if (Get.context.isTablet &&
          beingImplementedContractsList.length ==
              AppConstants.MAX_ITEMS_PER_PAGE)
        AppConstants.halfSecond.then(
          (value) => getBeingImplementedContracts(fromBeginnig: false),
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

  void downloadBeingImplementedContractsList() {
    final RepaymentFilteringParameters filteringParameters =
        RepaymentFilteringParameters();

    Permission.storage.request().then((PermissionStatus permissionStatus) {
      if (permissionStatus == PermissionStatus.granted)
        _beingImplementedContractsService
            .downloadPDF(parameters: filteringParameters)
            .then((List<int> binaryFile) {
          handleDownloadState(
              binaryFile: binaryFile, fileName: 'contrats_en_cours');
        });
    });
  }
}

import 'package:e_loan_mobile/Helpers/helpers.dart';
import 'package:e_loan_mobile/api/models/in_force_contract_list_response.dart';
import 'package:e_loan_mobile/api/models/models.dart';
import 'package:e_loan_mobile/api/services/in_force_contracts_service.dart';
import 'package:e_loan_mobile/app/common_account_tracking_controller.dart';
import 'package:e_loan_mobile/config/constants/app_constants.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:permission_handler/permission_handler.dart';

class InForceContractsController extends CommonAccountTrackingController {
  void reinitialize() {
    filterCount = 0;
    totalResults = 0;
    getInForceContracts(fromBeginnig: true);

    scrollController?.addListener(() {
      if (scrollController.position.pixels ==
          scrollController.position.maxScrollExtent) {
        getInForceContracts();
      }
    });
  }

  final InForceContractsService _inForceContractsService =
      InForceContractsService();

  int filterCount = 0;
  int totalResults = 0;
  final ScrollController scrollController = ScrollController();
  List<Contrats> inForceContractsList = [];
  bool isLoading = false;
  bool noMorePages = false;
  int page = 1;

  void getInForceContracts({bool fromBeginnig = false}) {
    if (isLoading) return;
    if (noMorePages && !fromBeginnig) return;
    isLoading = true;
    update();
    page = fromBeginnig ? 1 : page + 1;
    if (fromBeginnig)
      inForceContractsList.clear();
    else
      DioRequestsInterceptor.disableLoader();

    final RepaymentFilteringParameters filteringParameters =
        RepaymentFilteringParameters(
      column: null,
      order: null,
      limit: AppConstants.MAX_ITEMS_PER_PAGE,
      page: page,
    );
    _inForceContractsService
        .getInForceContracts(parameters: filteringParameters)
        .then((InForceContractsListModel inForceContractsListModel) {
      if (inForceContractsListModel != null &&
          inForceContractsListModel.contrats != null) {
        totalResults = inForceContractsListModel.contrats.length;
        noMorePages = inForceContractsListModel.contrats.length <
            AppConstants.MAX_ITEMS_PER_PAGE;
        inForceContractsList.addAll(inForceContractsListModel.contrats);
        inForceContractsList.sort((Contrats a, Contrats b) {
          return DateTime.parse(a.datePremierLoyer.substring(0, 10))
                  .isBefore(DateTime.parse(b.datePremierLoyer.substring(0, 10)))
              ? 1
              : -1;
        });
      }
      if (inForceContractsList.isEmpty) totalResults = 0;
      isLoading = false;
      update();
      DioRequestsInterceptor.enableLoader();
      if (Get.context.isTablet &&
          inForceContractsList.length == AppConstants.MAX_ITEMS_PER_PAGE)
        AppConstants.halfSecond.then(
          (value) => getInForceContracts(fromBeginnig: false),
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

  void downloadInForceContractsList() {
    final RepaymentFilteringParameters filteringParameters =
        RepaymentFilteringParameters();

    Permission.storage.request().then((PermissionStatus permissionStatus) {
      if (permissionStatus == PermissionStatus.granted)
        _inForceContractsService
            .downloadPDF(parameters: filteringParameters)
            .then((List<int> binaryFile) {
          handleDownloadState(
              binaryFile: binaryFile, fileName: 'contrats_en_vigueur');
        });
    });
  }
}

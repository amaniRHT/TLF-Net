import 'package:e_loan_mobile/Helpers/helpers.dart';
import 'package:e_loan_mobile/api/models/models.dart';
import 'package:e_loan_mobile/api/services/unpaid_bills_service.dart';
import 'package:e_loan_mobile/app/common_account_tracking_controller.dart';
import 'package:e_loan_mobile/config/constants/app_constants.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:permission_handler/permission_handler.dart';

class UnpaidBillsController extends CommonAccountTrackingController {
  void reinitialize() {
    filterCount = 0;
    totalResults = 0;
    total = '';
    settlementAmount = '';
    getUnpaidBills(fromBeginnig: true);

    scrollController?.addListener(() {
      if (scrollController.position.pixels ==
          scrollController.position.maxScrollExtent) {
        getUnpaidBills();
      }
    });
  }

  final UnpaidBillsService _unpaidBillsService = UnpaidBillsService();

  int filterCount = 0;
  int totalResults = 0;
  String total = '';
  String settlementAmount = '';
  final ScrollController scrollController = ScrollController();
  List<Factures> unpaidBillsList = [];
  bool isLoading = false;
  bool noMorePages = false;
  int page = 1;

  void getUnpaidBills({bool fromBeginnig = false}) {
    if (isLoading) return;
    if (noMorePages && !fromBeginnig) return;
    isLoading = true;
    update();
    page = fromBeginnig ? 1 : page + 1;
    if (fromBeginnig)
      unpaidBillsList.clear();
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
    _unpaidBillsService
        .getUnpaidBills(parameters: filteringParameters)
        .then((UnpaidBillsListModel unpaidBillsListModel) {
      if (unpaidBillsListModel != null &&
          unpaidBillsListModel.factures != null) {
        totalResults = unpaidBillsListModel.factures.length;
        noMorePages = unpaidBillsListModel.factures.isEmpty;

        total = unpaidBillsListModel.sumResteARegler;
        settlementAmount = unpaidBillsListModel.sumMontantALettrer;
        noMorePages = unpaidBillsListModel.factures.length <
            AppConstants.MAX_ITEMS_PER_PAGE;

        unpaidBillsList.addAll(unpaidBillsListModel.factures);
        // unpaidBillsList.sort((Factures a, Factures b) => a.contractCode.compareTo(b.contractCode));
        unpaidBillsList.sort((Factures a, Factures b) {
          return DateTime.parse(a.dateEcheance.substring(0, 10))
                  .isBefore(DateTime.parse(b.dateEcheance.substring(0, 10)))
              ? 1
              : -1;
        });
      }

      if (unpaidBillsList.isEmpty) totalResults = 0;
      isLoading = false;
      update();
      DioRequestsInterceptor.enableLoader();
      if (Get.context.isTablet &&
          unpaidBillsList.length == AppConstants.MAX_ITEMS_PER_PAGE)
        AppConstants.halfSecond.then(
          (value) => getUnpaidBills(fromBeginnig: false),
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

  void downloadUnpaidBillsList() {
    final RepaymentFilteringParameters filteringParameters =
        RepaymentFilteringParameters();

    Permission.storage.request().then((PermissionStatus permissionStatus) {
      if (permissionStatus == PermissionStatus.granted)
        _unpaidBillsService
            .downloadPDF(parameters: filteringParameters)
            .then((List<int> binaryFile) {
          handleDownloadState(
              binaryFile: binaryFile, fileName: 'facutres_impayées');
        });
    });
  }
}

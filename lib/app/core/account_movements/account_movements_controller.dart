import 'package:e_loan_mobile/Helpers/helpers.dart';
import 'package:e_loan_mobile/api/models/models.dart';
import 'package:e_loan_mobile/api/services/account_movements_service.dart';
import 'package:e_loan_mobile/app/common_account_tracking_controller.dart';
import 'package:e_loan_mobile/config/config.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:permission_handler/permission_handler.dart';

class AccountMovementsController extends CommonAccountTrackingController {
  void reinitialize() {
    filterCount = 0;
    totalResults = 0;
    getAccountMovements(fromBeginnig: true);

    scrollController?.addListener(() {
      if (scrollController.position.pixels ==
          scrollController.position.maxScrollExtent) {
        getAccountMovements();
      }
    });
  }

  //filter begin !
  List<Tag> tags = <Tag>[];
  @override
  void onInit() {
    addTag();
    super.onInit();
  }

  void addTag() {
    tags = <Tag>[
      Tag(
        key: 1,
        value: fromDateText.isNotEmpty ? fromDateText : '',
      ),
      Tag(
        key: 2,
        value: toDateText.isNotEmpty ? toDateText : '',
      ),
    ];
    getFilterCount();
    update();
  }

  void onDeleteTag(int index) {
    final i = tags.indexOf(tags[index]);

    switch (tags[i].key) {
      case 1:
        fromDateText = '';
        break;
      case 2:
        toDateText = '';
        break;

      default:
    }
    tags.removeAt(index);
    getFilterCount();
    update();
  }

  void getFilterCount() {
    filterCount = 0;
    tags.forEach((element) {
      if (element.value.isNotEmpty) filterCount++;
    });
    update();
  }
  //end!

  TextEditingController fromTEC = TextEditingController();
  TextEditingController toTEC = TextEditingController();

  FocusNode fromFocusNode = FocusNode();
  FocusNode toFocusNode = FocusNode();

  DateTime fromDateTime = DateTime.now();
  DateTime toDateTime = DateTime.now();

  ValueNotifier<DateTime> fromNotifier;
  ValueNotifier<DateTime> toNotifier;

  String fromDateAsISO8601 = '';
  String toDateAsISO8601 = '';

  String fromDateText = '';
  String toDateText = '';
  DateTime fromDate;
  DateTime toDate;
  void resetTECs() {
    fromTEC.text = '';
    toTEC.text = '';

    update();
  }

  void initialiseTECs() {
    fromTEC.text = fromDateText;
    toTEC.text = toDateText;
    update();
  }

  void setFilterData({bool shoudUpdate = true}) {
    fromDateText = fromTEC.text;
    toDateText = toTEC.text;

    update();
  }

  final AccountMovementsService _accountMovementsService =
      AccountMovementsService();

  int filterCount = 0;
  int totalResults = 0;
  final ScrollController scrollController = ScrollController();
  List<MouvementCompte> accountMovementsList = [];
  bool isLoading = false;
  bool noMorePages = false;
  int page = 1;

  void getAccountMovements({bool fromBeginnig = false}) {
    if (isLoading) return;
    if (noMorePages && !fromBeginnig) return;
    isLoading = true;
    update();
    page = fromBeginnig ? 1 : page + 1;
    if (fromBeginnig)
      accountMovementsList.clear();
    else
      DioRequestsInterceptor.disableLoader();

    final RepaymentFilteringParameters filteringParameters =
        RepaymentFilteringParameters(
      startDate: fromDateText.isNotEmpty
          ? DateFormat("dd/MM/yyyy").format(fromDate)
          : null,
      endDate: toDateText.isNotEmpty
          ? DateFormat("dd/MM/yyyy").format(toDate)
          : null,
      limit: AppConstants.MAX_ITEMS_PER_PAGE,
      page: page,
    );
    _accountMovementsService
        .getAccountMovements(parameters: filteringParameters)
        .then((AccountMovementsListModel accountMovementsListModel) {
      if (accountMovementsListModel != null &&
          accountMovementsListModel.mouvementCompte != null) {
        totalResults = accountMovementsListModel.mouvementCompte.length;
        noMorePages = accountMovementsListModel.mouvementCompte.length <
            AppConstants.MAX_ITEMS_PER_PAGE;
        accountMovementsList.clear();
        accountMovementsList.addAll(accountMovementsListModel.mouvementCompte);
        accountMovementsList.sort((MouvementCompte a, MouvementCompte b) {
          return DateTime.parse(a.dateEcheance.substring(0, 10))
                  .isBefore(DateTime.parse(b.dateEcheance.substring(0, 10)))
              ? 1
              : -1;
        });
      }

      if (accountMovementsList.isEmpty) totalResults = 0;
      isLoading = false;
      update();
      DioRequestsInterceptor.enableLoader();
      if (Get.context.isTablet &&
          accountMovementsList.length == AppConstants.MAX_ITEMS_PER_PAGE)
        AppConstants.halfSecond.then(
          (value) => getAccountMovements(),
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
        RepaymentFilteringParameters(
      startDate: fromDateText.isNotEmpty
          ? DateFormat.yMd('en').format(fromDate)
          : null,
      endDate:
          toDateText.isNotEmpty ? DateFormat.yMd('en').format(toDate) : null,
    );

    Permission.storage.request().then((PermissionStatus permissionStatus) {
      if (permissionStatus == PermissionStatus.granted)
        _accountMovementsService
            .downloadPDF(parameters: filteringParameters)
            .then((List<int> binaryFile) {
          handleDownloadState(
              binaryFile: binaryFile, fileName: 'mouvements_compte');
        });
    });
  }
}

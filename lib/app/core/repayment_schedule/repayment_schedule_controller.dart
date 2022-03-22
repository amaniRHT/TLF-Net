import 'package:collection/collection.dart';
import 'package:e_loan_mobile/Helpers/helpers.dart';
import 'package:e_loan_mobile/api/models/models.dart';
import 'package:e_loan_mobile/api/services/repayment_schedule_service.dart';
import 'package:e_loan_mobile/app/common_account_tracking_controller.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:permission_handler/permission_handler.dart';

class RepaymentScheduleController extends CommonAccountTrackingController {
  void reinitialize() {
    filterCount = 0;
    totalResults = 0;
    getRepayments();
  }

  final RepaymentScheduleService _repaymentScheduleService =
      RepaymentScheduleService();

  List<String> filterTagsList = <String>[];
  List<String> savedFilterTagsList = <String>[];
  String currentText = '';

  // ! testing
  List<Tag> tags = <Tag>[];
  @override
  void onInit() {
    addTagFilter();
    super.onInit();
  }

  void addTagFilter() {
    tags = <Tag>[
      Tag(
        key: 1,
        value: fromDateText.isNotEmpty ? fromDateText : '',
      ),
      Tag(
        key: 2,
        value:
            filterTagsList.length > 0 ? filterTagsList.length.toString() : '',
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
        filterTagsList = [];
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
  // ! end testing

  // ! start date filter
  TextEditingController fromTEC = TextEditingController();

  FocusNode fromFocusNode = FocusNode();

  DateTime fromDateTime = DateTime.now();

  ValueNotifier<DateTime> fromNotifier;

  String fromDateAsISO8601 = '';

  String fromDateText = '';
  DateTime fromDate;

  void initialiseTECs() {
    fromTEC.text = fromDateText;
    update();
  }
  // ! end

  List<int> contractCodeList = [
    // 1232445,
    // 64744,
    // 8999,
    // 30030300,
  ];

  int filterCount = 0;
  int totalResults = 0;
  TextEditingController contractCodeTEC = TextEditingController();
  String contractCodeText = '';
  List<Echeanciers> repaymentList = [];
  Map<int, List<Echeanciers>> repaymentListMap = {};
  bool isLoading = false;

  void addTag(dynamic tag) {
    if (tag != null) {
      filterTagsList.add(tag.toString());
      contractCodeList.remove(tag);
    }
    update();
  }

  void removeTag(int index) {
    UsefullMethods.unfocus(KeysStorage.mainNavigatorKey.currentContext);
    if (index >= filterTagsList.length) return;
    contractCodeList.add(int.parse(filterTagsList[index]));
    filterTagsList.removeAt(index);
    update();
  }

  void resetTECsAndValidations() {
    filterTagsList.clear();
    contractCodeList.clear();
    savedFilterTagsList.clear();
    filterCount = 0;
    fromTEC.text = '';
    update();
  }

  void setFilterData() {
    savedFilterTagsList.clear();
    savedFilterTagsList.addAll(filterTagsList);
    fromDateText = fromTEC.text;
    update();
  }

  // void setFilterCount() {
  //   filterCount = savedFilterTagsList.isNotEmpty ? 1 : 0;
  //   update();
  // }

  void initialiseLists({bool shoudUpdate = true}) {
    filterTagsList.clear();
    filterTagsList.addAll(savedFilterTagsList);
    update();
  }

  void initContractsList() {
    if (savedFilterTagsList.isEmpty || contractCodeList.isEmpty) return;
    List<int> _temp = [];
    contractCodeList.forEach((int contractCode) {
      if (!savedFilterTagsList.contains(contractCode.toString()))
        _temp.add(contractCode);
    });
    contractCodeList = _temp;
  }

  void getRepayments() {
    isLoading = true;
    update();
    repaymentList.clear();

    final RepaymentFilteringParameters filteringParameters =
        RepaymentFilteringParameters(
      startDate: fromDateText.isNotEmpty
          ? DateFormat("dd/MM/yyyy").format(fromDate)
          : null,
      contract_code: filterTagsList.isNotEmpty
          ? UsefullMethods.buildStringFromArray(filterTagsList.toSet())
          : null,
    );
    _repaymentScheduleService
        .getRepaymentschedules(parameters: filteringParameters)
        .then((RepaymentScheduleListModel repaymentsListModel) {
      if (repaymentsListModel != null &&
          repaymentsListModel.echeanciers != null &&
          repaymentsListModel.echeanciers.isNotEmpty) {
        totalResults = repaymentsListModel.echeanciers.length;

        repaymentList.addAll(repaymentsListModel.echeanciers);
      } else {
        if (repaymentList.isEmpty) totalResults = 0;
      }
      repaymentList.sort((Echeanciers a, Echeanciers b) {
        // return DateTime.parse(a.dateDebutLoyer.substring(0, 10))
        //         .isBefore(DateTime.parse(b.dateDebutLoyer.substring(0, 10)))
        //     ? 1
        //     : -1;
        return a.numLoyer.compareTo(b.numLoyer);
      });
      repaymentListMap =
          groupBy(repaymentList, (Echeanciers obj) => obj.contractCode);
      if (contractCodeList.length == 0)
        getContracts(repaymentListMap.keys.toList());
      isLoading = false;
      update();
    }).onError((dynamic error, StackTrace stackTrace) {
      isLoading = false;
    });
  }

  // void getContracts() {
  //   _repaymentScheduleService
  //       .getContracts()
  //       .then((ContractListModel contractListModel) async {
  //     if (contractListModel != null &&
  //         contractListModel.contract != null &&
  //         contractListModel.contract.isNotEmpty) {
  //       contractCodeList = contractListModel.contract;
  //       initContractsList();
  //       update();
  //     }
  //   });
  // }
  void getContracts(List<int> contractList) {
    contractCodeList = contractList;
    initContractsList();
    update();
  }

  void downloadContractsList() {
    final RepaymentFilteringParameters filteringParameters =
        RepaymentFilteringParameters(
      contract_code: filterTagsList.isNotEmpty
          ? UsefullMethods.buildStringFromArray(filterTagsList.toSet())
          : null,
    );

    Permission.storage.request().then((PermissionStatus permissionStatus) {
      if (permissionStatus == PermissionStatus.granted)
        _repaymentScheduleService
            .downloadPDF(parameters: filteringParameters)
            .then((List<int> binaryFile) {
          handleDownloadState(binaryFile: binaryFile, fileName: 'échéancier');
        });
    });
  }
}

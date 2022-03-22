import 'package:e_loan_mobile/Helpers/helpers.dart';
import 'package:e_loan_mobile/api/models/models.dart';
import 'package:e_loan_mobile/api/services/rdvs_service.dart';
import 'package:e_loan_mobile/widgets/widgets.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

class RDVsListController extends BaseController {
  final RDVsService _rdvsService = RDVsService();

  List<RendezVous> allRDVs = <RendezVous>[];
  List<RendezVous> rdvsList = <RendezVous>[];

  int totalResults = 0;
  int filterCount = 0;
  List<Tag> tags = <Tag>[];

  String fromDateAsISO8601 = '';
  String toDateAsISO8601 = '';

  bool initialState = true;

  List<String> userFullNames = <String>[];

  String userName;

  final List<String> userStatusList = <String>['En attente', 'Actif', "Inactif"];
  String userStatus;
  bool userStatusSelected = false;

  void resetTECs() {
    fromTEC.text = '';
    toTEC.text = '';
    statusTEC.text = '';
    objectTEC.text = '';
    selectedStatusList.clear();
    userStatusSelected = false;
    update();
  }

  void initialiseTECs() {
    fromTEC.text = fromDateText;
    toTEC.text = toDateText;
    statusTEC.text = statusText;
    objectTEC.text = objectText;
    selectedStatusList.clear();
    selectedStatusList.addAll(savedSelectedStatusList);
    update();
  }

  void setFilterData() {
    fromDateText = fromTEC.text;
    toDateText = toTEC.text;
    statusText = statusTEC.text;
    objectText = objectTEC.text;
    savedSelectedStatusList.clear();
    savedSelectedStatusList.addAll(selectedStatusList);

    update();
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
      Tag(
        key: 3,
        value: objectText.isNotEmpty ? objectText : '',
      ),
      Tag(
        key: 4,
        value: statusText.isNotEmpty ? statusText : '',
      ),
    ];
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

  bool isLoading = false;

  TextEditingController fromTEC = TextEditingController();
  TextEditingController toTEC = TextEditingController();
  TextEditingController objectTEC = TextEditingController();
  TextEditingController statusTEC = TextEditingController();

  FocusNode fromFocusNode = FocusNode();
  FocusNode toFocusNode = FocusNode();
  FocusNode objectFocusNode = FocusNode();
  FocusNode statusFocusNode = FocusNode();

  DateTime fromDateTime = DateTime.now();
  DateTime toDateTime = DateTime.now();

  ValueNotifier<DateTime> fromNotifier;
  ValueNotifier<DateTime> toNotifier;

  Set<String> selectedStatusList = <String>{};
  Set<String> savedSelectedStatusList = <String>{};

  String fromDateText = '';
  String toDateText = '';
  DateTime fromDate;
  DateTime toDate;
  String objectText = '';
  String statusText = '';

  String requestStatus;
  bool requestStatusSelected = false;

  List<String> requestStatusList = ['Soumis', 'Traité', 'Annulé'];

  void setSelectedStatus() {
    statusTEC?.text = '';
    if (statusTEC?.text != null) {
      for (final item in selectedStatusList)
        statusTEC.text.isEmpty ? statusTEC?.text = item : statusTEC?.text = '${statusTEC.text} - $item';
    }
    Get.back();
    update();
  }

  Future<bool> getRDVs() {
    final RDVsFilteringParameters rdvsFilteringParameters = RDVsFilteringParameters(
      startDate: fromDateText.isNotEmpty ? DateFormat.yMd('en').format(fromDate) : null,
      endDate: toDateText.isNotEmpty ? DateFormat.yMd('en').format(toDate) : null,
      object: objectText.isNotEmpty ? objectText : null,
      status: selectedStatusList.isNotEmpty
          ? UsefullMethods.buildStringFromArray(UsefullMethods.buildRdvStatusCodesList(selectedStatusList))
          : null,
    );
    isLoading = true;
    update();
    return _rdvsService
        .getRDVs(parameters: rdvsFilteringParameters)
        .then((RDVsResponse rdvsResponse) {
          if (rdvsResponse != null && rdvsResponse.rdvs != null && rdvsResponse.rdvs.isNotEmpty) {
            totalResults = rdvsResponse.totalItems;
            rdvsList = rdvsResponse.rdvs;
          } else {
            totalResults = 0;
            rdvsList = <RendezVous>[];
          }
          isLoading = false;
          update();
          return true;
        })
        .onError((dynamic error, StackTrace stackTrace) => isLoading = false)
        .whenComplete(() => isLoading = false);
  }

  void deleteRDV({
    int rdvId,
    String rdvCode,
  }) {
    _rdvsService.deleteRDV(rdvId: rdvId).then(
      (bool success) {
        if (success) {
          showCustomToast(
            padding: 65,
            contentText: "La demande de rendez-vous n° $rdvCode a été supprimée avec succès",
            blurEffectEnabled: false,
          );
          rdvsList.removeWhere((item) => item.id == rdvId);
          totalResults -= 1;
          update();
        } else {
          showCustomToast(
            padding: 65,
            toastType: ToastTypes.error,
            contentText: "La suppression de la demande de rendez-vous a échoué",
            blurEffectEnabled: false,
          );
        }
      },
    );
  }
}

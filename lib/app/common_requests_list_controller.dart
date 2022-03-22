import 'package:e_loan_mobile/Helpers/helpers.dart';
import 'package:e_loan_mobile/api/models/enums.dart';
import 'package:e_loan_mobile/api/models/models.dart';
import 'package:e_loan_mobile/api/models/requests_list_response.dart';
import 'package:e_loan_mobile/api/services/request_service.dart';
import 'package:e_loan_mobile/config/config.dart';
import 'package:e_loan_mobile/widgets/widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter_masked_text2/flutter_masked_text2.dart';
import 'package:get/get.dart';

class CommonRequestsListController extends BaseController {
  bool isQuotation;

  // ignore: unused_field
  RequestService fundingRequestService;

  @mustCallSuper
  void init(bool isQuotation) {
    this.isQuotation = isQuotation;
    fundingRequestService = RequestService(isQuotation: isQuotation);
    reinitialize();
  }

  void reinitialize() {
    requestStatusList = isQuotation
        ? const <String>['Créé', 'Soumis', "À l'étude", 'Traité', 'Annulé']
        : const <String>[
            'Créé',
            'Soumis',
            'Prise en charge',
            "À l'étude",
            "En attente d'un complément",
            'Favorable',
            'Défavorable',
            'Défavorable (TLFNET)',
            'Annulé'
          ];

    resetTECs(shoudUpdate: false);
    filterCount = 0;
    totalResults = 0;
    setFilterData(shoudUpdate: false);
    getRequests(fromBeginnig: true);

    scrollController?.addListener(() {
      if (scrollController.position.pixels ==
          scrollController.position.maxScrollExtent) {
        getRequests();
      }
    });
  }

  final ScrollController scrollController = ScrollController();

  TextEditingController fromTEC = TextEditingController();
  TextEditingController toTEC = TextEditingController();
  MaskedTextController minAmountTEC = MaskedTextController(mask: '000 000 000');
  MaskedTextController maxAmountTEC = MaskedTextController(mask: '000 000 000');
  TextEditingController fundingTypeTEC = TextEditingController();
  TextEditingController requestStatusTEC = TextEditingController();

  FocusNode fromFocusNode = FocusNode();
  FocusNode toFocusNode = FocusNode();
  FocusNode minAmountFocusNode = FocusNode();
  FocusNode maxAmountFocusNode = FocusNode();

  String fundingType;
  bool fundingTypeSelected = false;

  String requestStatus;
  bool requestStatusSelected = false;

  String fromDateAsISO8601 = '';
  String toDateAsISO8601 = '';

  int totalResults = 0;
  int filterCount = 0;
  bool isDateTextFieldVisible = false;

  FundingTypes selectedFundingType;
  CarStates carState = CarStates.newCar;

  DateTime fromDateTime = DateTime.now();
  DateTime toDateTime = DateTime.now();

  ValueNotifier<DateTime> fromNotifier;
  ValueNotifier<DateTime> toNotifier;

  Color statusColor = AppColors.lighterGreen;

  String fromDateText = '';
  String toDateText = '';
  DateTime fromDate;
  DateTime toDate;
  String minAmountText = '';
  String maxAmountText = '';
  String fundingTypeText = '';
  String requestStatusText = '';

  String amountControlErrorText = '';
  bool isError = false;

  Set<String> selectedFundingTypesList = <String>{};
  Set<String> selectedRequestStatusList = <String>{};
  Set<String> savedSelectedFundingTypesList = <String>{};
  Set<String> savedSelectedRequestStatusList = <String>{};

  final List<String> fundingTypes = <String>[
    'Véhicules',
    'Matériels et équipements',
    'Terrains et locaux professionnels',
  ];

  List<String> requestStatusList;

  List<Tag> tags = <Tag>[];

  void resetTECs({bool shoudUpdate = true}) {
    fromTEC.text = '';
    toTEC.text = '';
    minAmountTEC.text = '';
    maxAmountTEC.text = '';
    fundingTypeTEC.text = '';
    requestStatusTEC.text = '';
    fundingTypeSelected = false;
    requestStatusSelected = false;
    fromDate = null;
    toDate = null;
    fromDateTime = DateTime.now();
    toDateTime = DateTime.now();
    fromNotifier = null;
    toNotifier = null;
    selectedFundingTypesList.clear();
    selectedRequestStatusList.clear();
    if (shoudUpdate) update();
  }

  void initialiseTECs({bool shoudUpdate = true}) {
    fromTEC.text = fromDateText;
    toTEC.text = toDateText;
    minAmountTEC.text =
        UsefullMethods.formatStringWithSpaceEach3Characters(minAmountText);
    maxAmountTEC.text =
        UsefullMethods.formatStringWithSpaceEach3Characters(maxAmountText);
    fundingTypeTEC.text = fundingTypeText;
    requestStatusTEC.text = requestStatusText;
    selectedFundingTypesList.clear();
    selectedFundingTypesList.addAll(savedSelectedFundingTypesList);
    selectedRequestStatusList.clear();
    selectedRequestStatusList.addAll(savedSelectedRequestStatusList);
    amountControlErrorText = '';
    isError = false;
    if (shoudUpdate) update();
  }

  void setFilterData({bool shoudUpdate = true}) {
    fromDateText = fromTEC.text;
    toDateText = toTEC.text;
    minAmountText = minAmountTEC.text;
    maxAmountText = maxAmountTEC.text;
    fundingTypeText = fundingTypeTEC.text;
    requestStatusText = requestStatusTEC.text;
    savedSelectedFundingTypesList.clear();
    savedSelectedFundingTypesList.addAll(selectedFundingTypesList);
    savedSelectedRequestStatusList.clear();
    savedSelectedRequestStatusList.addAll(selectedRequestStatusList);
    if (shoudUpdate) update();
  }

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
      Tag(
        key: 3,
        value: minAmountText.isNotEmpty ? minAmountText : '',
      ),
      Tag(
        key: 4,
        value: maxAmountText.isNotEmpty ? maxAmountText : '',
      ),
      Tag(
        key: 5,
        value: fundingTypeText.isNotEmpty ? fundingTypeText : '',
      ),
      Tag(
        key: 6,
        value: requestStatusText.isNotEmpty ? requestStatusText : '',
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
      case 3:
        minAmountText = '';
        break;
      case 4:
        maxAmountText = '';
        break;
      case 5:
        fundingTypeText = '';
        break;
      case 6:
        requestStatusText = '';
        break;

      default:
    }
    tags.removeAt(index);
    getFilterCount();
    update();
  }

  void setAmountError(bool errorState, int errorType) {
    isError = errorState;
    switch (errorType) {
      case 1:
        amountControlErrorText =
            "Le montant minimum doit être inférieur au montant maximum";
        break;
      case 2:
        amountControlErrorText =
            "Le montant maximum doit être supérieur au montant minimum";
        break;
      default:
        amountControlErrorText = '';
    }
    update();
  }

  void setSelectedFundingTypes() {
    fundingTypeTEC?.text = '';
    if (fundingTypeTEC?.text != null) {
      for (final item in selectedFundingTypesList)
        fundingTypeTEC.text.isEmpty
            ? fundingTypeTEC?.text = item
            : fundingTypeTEC?.text = '${fundingTypeTEC.text} - $item';
    }

    Get.back();
    update();
  }

  void setSelectedRequestStatus() {
    requestStatusTEC?.text = '';
    if (requestStatusTEC?.text != null) {
      for (final item in selectedRequestStatusList)
        requestStatusTEC.text.isEmpty
            ? requestStatusTEC?.text = item
            : requestStatusTEC?.text = '${requestStatusTEC.text} - $item';
    }
    Get.back();
    update();
  }

  void getFilterCount() {
    filterCount = 0;
    tags.forEach((element) {
      if (element.value.isNotEmpty) filterCount++;
    });
    update();
  }

  List<Request> requestList = <Request>[];
  int page = 1;
  bool isLoading = false;
  bool noMorePages = false;

  void getRequests({bool fromBeginnig = false}) {
    if (isLoading) return;
    if (noMorePages && !fromBeginnig) return;
    isLoading = true;
    update();
    page = fromBeginnig ? 1 : page + 1;
    if (fromBeginnig)
      requestList.clear();
    else
      DioRequestsInterceptor.disableLoader();

    final RequestsFilteringParameters filteringParameters =
        RequestsFilteringParameters(
      startDate: fromDate,
      endDate: toDate,
      maxAmount: maxAmountText.isNotEmpty
          ? double.parse(maxAmountText.removeAllWhitespace)
          : null,
      minAmount: minAmountText.isNotEmpty
          ? double.parse(minAmountText.removeAllWhitespace)
          : null,
      type: selectedFundingTypesList.isNotEmpty
          ? UsefullMethods.buildStringFromArray(
              UsefullMethods.buildFundingTypesCodesList(
                  selectedFundingTypesList))
          : null,
      status: selectedRequestStatusList.isNotEmpty
          ? UsefullMethods.buildStringFromArray(isQuotation
              ? UsefullMethods.buildQuotationStatusCodesList(
                  selectedRequestStatusList)
              : UsefullMethods.buildFundingTypesStatusCodesList(
                  selectedRequestStatusList))
          : null,
      limit: AppConstants.MAX_ITEMS_PER_PAGE,
      page: page,
    );
    fundingRequestService
        .getRequests(parameters: filteringParameters)
        .then((RequestsListModel requestsListModel) {
      if (requestsListModel != null && requestsListModel.demandes != null) {
        totalResults = requestsListModel.totalItems;
        noMorePages =
            requestsListModel.demandes.length < AppConstants.MAX_ITEMS_PER_PAGE;
        requestList.addAll(requestsListModel.demandes);
      }
      if (requestList.isEmpty) totalResults = 0;
      isLoading = false;
      update();
      DioRequestsInterceptor.enableLoader();
    }).onError((dynamic error, StackTrace stackTrace) {
      page = fromBeginnig ? 1 : page - 1;
      isLoading = false;
      DioRequestsInterceptor.enableLoader();
    }).whenComplete(() {
      isLoading = false;
      DioRequestsInterceptor.enableLoader();
    });
  }

  void deleteRequest({
    int requestId,
    String requestCode,
  }) {
    scrollController.animateTo(
      0,
      duration: Duration(milliseconds: 400),
      curve: Curves.easeOut,
    );
    fundingRequestService.deleteRequest(requestId: requestId).then(
      (bool success) {
        if (success) {
          showCustomToast(
            padding: 65,
            contentText:
                'La demande n°$requestCode a été supprimée avec succès',
            blurEffectEnabled: false,
          );
          getRequests(fromBeginnig: true);
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

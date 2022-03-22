import 'package:e_loan_mobile/Helpers/helpers.dart';
import 'package:e_loan_mobile/api/models/models.dart';
import 'package:e_loan_mobile/api/services/services.dart';
import 'package:flutter/foundation.dart';

class CommonRequestDetailsController extends BaseController {
  bool isQuotation;

  RequestService fundingRequestService;

  @mustCallSuper
  void init(bool isQuotation) {
    this.isQuotation = isQuotation;
    fundingRequestService = RequestService(isQuotation: isQuotation);
  }

  int requestId;

  Request currentRequest = Request();

  String requestCode = '';
  int fundingType = -1;
  int requestStatus = -1;
  bool neuf = false;
  String carAgeText = '';
  String objectText = '';
  String totalPriceText = '';
  String percentageText = '';
  String selfFinancingText = '';
  String durationText = '';
  String htPriceText = '';
  String tvaText = '';
  String ttcPriceText = '';
  String sellerText = '';
  String providerText = '';
  bool propertyTitle = false;

  bool oldCar = false;
  bool newCar = false;
  bool materialOrEquipement = false;
  bool landOrLocals = false;
}

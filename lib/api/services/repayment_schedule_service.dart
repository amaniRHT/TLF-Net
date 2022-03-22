import 'dart:async';
import 'dart:typed_data';

import 'package:dio/dio.dart';
import 'package:e_loan_mobile/Helpers/requests_interceptor.dart';
import 'package:e_loan_mobile/api/models/models.dart';
import 'package:e_loan_mobile/api/services/services.dart';
import 'package:e_loan_mobile/api/urls/app_urls.dart';
import 'package:e_loan_mobile/config/config.dart';

class RepaymentScheduleService {
  Future<RepaymentScheduleListModel> getRepaymentschedules({
    final RepaymentFilteringParameters parameters,
  }) {
    final Map<String, dynamic> params = {
      if (parameters.contract_code != null)
        'contract_code': parameters.contract_code,
      if (parameters.startDate != null) 'echeancier': parameters.startDate,
      if (parameters.column != null) 'column': parameters.column,
      if (parameters.order != null) 'order': parameters.order,
    };

    if (fakeData)
      return AppConstants.falseFutrue.then(
        (value) => RepaymentScheduleListModel.fromJson(fakeList),
      );
    else
      return DioRequestsInterceptor.dio
          .get(
        AppUrls.getRepaymentList,
        queryParameters: params,
      )
          .then((
        Response<dynamic> response,
      ) {
        if (response != null &&
            response.data != null &&
            response.statusCode == 200) {
          return RepaymentScheduleListModel.fromJson(
              response.data as Map<String, dynamic>);
        } else
          return null;
      });
  }

  Future<ContractListModel> getContracts() {
    return DioRequestsInterceptor.dio
        .get(AppUrls.getContractsList)
        .then((Response<dynamic> response) {
      if (response != null &&
          response.data != null &&
          response.statusCode == 200) {
        return ContractListModel.fromJson(
            response.data as Map<String, dynamic>);
      } else
        return null;
    });
  }

  Future<Uint8List> downloadPDF({
    final RepaymentFilteringParameters parameters,
  }) {
    final Map<String, dynamic> params = {
      if (parameters.contract_code != null)
        'contract_code': parameters.contract_code
    };
    DioRequestsInterceptor.responseType = ResponseType.bytes;
    return DioRequestsInterceptor.dio
        .get(
      AppUrls.downloadContractsList,
      queryParameters: params,
    )
        .then((response) {
      if (response != null &&
          response.data != null &&
          response.statusCode == 200)
        return response.data;
      else
        return null;
    });
  }
}

Map<String, Object> fakeList = {
  "order": "",
  "column": "",
  "page": "1",
  "limit": "10",
  "totalItems": 19,
  "echeanciers": [
    {
      "id": 2,
      "contract_code": 251847,
      "id_client": 1111,
      "date_debut_loyer": "25/11/2020 0:00",
      "date_fin_loyer": "25/11/2020 0:00",
      "num_loyer": 1,
      "loyer_ht": 1836.1970000000001,
      "periode_restante": 32,
      "loyer_ttc": 2285.914,
      "interets": 603.874,
      "amortissement": 1232.323,
      "services": 100.84,
      "restantdu": 53301.891
    },
    {
      "id": 3,
      "contract_code": 251847,
      "id_client": 1111,
      "date_debut_loyer": "25/11/2020 0:00",
      "date_fin_loyer": "25/11/2020 0:00",
      "num_loyer": 2,
      "loyer_ht": 1836.1970000000001,
      "periode_restante": 32,
      "loyer_ttc": 2185.074,
      "interets": 589.7520000000001,
      "amortissement": 1246.4450000000002,
      "services": 0,
      "restantdu": 52055.445999999996
    },
    {
      "id": 4,
      "contract_code": 251847,
      "id_client": 1111,
      "date_debut_loyer": "25/11/2020 0:00",
      "date_fin_loyer": "25/11/2020 0:00",
      "num_loyer": 3,
      "loyer_ht": 1836.1970000000001,
      "periode_restante": 32,
      "loyer_ttc": 2185.074,
      "interets": 575.469,
      "amortissement": 1260.728,
      "services": 0,
      "restantdu": 50794.718
    },
    {
      "id": 5,
      "contract_code": 251847,
      "id_client": 1111,
      "date_debut_loyer": "25/11/2020 0:00",
      "date_fin_loyer": "25/11/2020 0:00",
      "num_loyer": 4,
      "loyer_ht": 1836.1970000000001,
      "periode_restante": 32,
      "loyer_ttc": 2185.074,
      "interets": 561.022,
      "amortissement": 1275.175,
      "services": 0,
      "restantdu": 49519.543
    },
    {
      "id": 11,
      "contract_code": 251847,
      "id_client": 1111,
      "date_debut_loyer": "25/11/2020 0:00",
      "date_fin_loyer": "25/11/2020 0:00",
      "num_loyer": 10,
      "loyer_ht": 1836.1970000000001,
      "periode_restante": 32,
      "loyer_ttc": 2185.074,
      "interets": 470.798,
      "amortissement": 1365.3990000000001,
      "services": 0,
      "restantdu": 41555.707
    },
    {
      "id": 7,
      "contract_code": 251847,
      "id_client": 1111,
      "date_debut_loyer": "25/11/2020 0:00",
      "date_fin_loyer": "25/11/2020 0:00",
      "num_loyer": 6,
      "loyer_ht": 1836.1970000000001,
      "periode_restante": 32,
      "loyer_ttc": 2185.074,
      "interets": 531.63,
      "amortissement": 1304.567,
      "services": 0,
      "restantdu": 46925.189
    },
    {
      "id": 8,
      "contract_code": 251847,
      "id_client": 1111,
      "date_debut_loyer": "25/11/2020 0:00",
      "date_fin_loyer": "25/11/2020 0:00",
      "num_loyer": 7,
      "loyer_ht": 1836.1970000000001,
      "periode_restante": 32,
      "loyer_ttc": 2185.074,
      "interets": 516.681,
      "amortissement": 1319.516,
      "services": 0,
      "restantdu": 45605.673
    },
    {
      "id": 9,
      "contract_code": 251847,
      "id_client": 1111,
      "date_debut_loyer": "25/11/2020 0:00",
      "date_fin_loyer": "25/11/2020 0:00",
      "num_loyer": 8,
      "loyer_ht": 1836.1970000000001,
      "periode_restante": 32,
      "loyer_ttc": 2185.074,
      "interets": 501.56,
      "amortissement": 1334.6370000000002,
      "services": 0,
      "restantdu": 44271.036
    },
    {
      "id": 10,
      "contract_code": 251847,
      "id_client": 1111,
      "date_debut_loyer": "25/11/2020 0:00",
      "date_fin_loyer": "25/11/2020 0:00",
      "num_loyer": 9,
      "loyer_ht": 1836.1970000000001,
      "periode_restante": 32,
      "loyer_ttc": 2185.074,
      "interets": 486.267,
      "amortissement": 1349.93,
      "services": 0,
      "restantdu": 42921.106
    },
    {
      "id": 6,
      "contract_code": 251847,
      "id_client": 1111,
      "date_debut_loyer": "25/11/2020 0:00",
      "date_fin_loyer": "25/11/2020 0:00",
      "num_loyer": 5,
      "loyer_ht": 1836.1970000000001,
      "periode_restante": 32,
      "loyer_ttc": 2185.074,
      "interets": 546.41,
      "amortissement": 1289.787,
      "services": 0,
      "restantdu": 48229.756
    },
    {
      "id": 6,
      "contract_code": 251847,
      "id_client": 1111,
      "date_debut_loyer": "25/11/2020 0:00",
      "date_fin_loyer": "25/11/2020 0:00",
      "num_loyer": 5,
      "loyer_ht": 1836.1970000000001,
      "periode_restante": 32,
      "loyer_ttc": 2185.074,
      "interets": 546.41,
      "amortissement": 1289.787,
      "services": 0,
      "restantdu": 48229.756
    },
    {
      "id": 6,
      "contract_code": 251847,
      "id_client": 1111,
      "date_debut_loyer": "25/11/2020 0:00",
      "date_fin_loyer": "25/11/2020 0:00",
      "num_loyer": 5,
      "loyer_ht": 1836.1970000000001,
      "periode_restante": 32,
      "loyer_ttc": 2185.074,
      "interets": 546.41,
      "amortissement": 1289.787,
      "services": 0,
      "restantdu": 48229.756
    },
    {
      "id": 6,
      "contract_code": 251847,
      "id_client": 1111,
      "date_debut_loyer": "25/11/2020 0:00",
      "date_fin_loyer": "25/11/2020 0:00",
      "num_loyer": 5,
      "loyer_ht": 1836.1970000000001,
      "periode_restante": 32,
      "loyer_ttc": 2185.074,
      "interets": 546.41,
      "amortissement": 1289.787,
      "services": 0,
      "restantdu": 48229.756
    },
    {
      "id": 6,
      "contract_code": 251847,
      "id_client": 1111,
      "date_debut_loyer": "25/11/2020 0:00",
      "date_fin_loyer": "25/11/2020 0:00",
      "num_loyer": 5,
      "loyer_ht": 1836.1970000000001,
      "periode_restante": 32,
      "loyer_ttc": 2185.074,
      "interets": 546.41,
      "amortissement": 1289.787,
      "services": 0,
      "restantdu": 48229.756
    },
    {
      "id": 6,
      "contract_code": 251847,
      "id_client": 1111,
      "date_debut_loyer": "25/11/2020 0:00",
      "date_fin_loyer": "25/11/2020 0:00",
      "num_loyer": 5,
      "loyer_ht": 1836.1970000000001,
      "periode_restante": 32,
      "loyer_ttc": 2185.074,
      "interets": 546.41,
      "amortissement": 1289.787,
      "services": 0,
      "restantdu": 48229.756
    },
    {
      "id": 6,
      "contract_code": 251847,
      "id_client": 1111,
      "date_debut_loyer": "25/11/2020 0:00",
      "date_fin_loyer": "25/11/2020 0:00",
      "num_loyer": 5,
      "loyer_ht": 1836.1970000000001,
      "periode_restante": 32,
      "loyer_ttc": 2185.074,
      "interets": 546.41,
      "amortissement": 1289.787,
      "services": 0,
      "restantdu": 48229.756
    },
    {
      "id": 6,
      "contract_code": 251847,
      "id_client": 1111,
      "date_debut_loyer": "25/11/2020 0:00",
      "date_fin_loyer": "25/11/2020 0:00",
      "num_loyer": 5,
      "loyer_ht": 1836.1970000000001,
      "periode_restante": 32,
      "loyer_ttc": 2185.074,
      "interets": 546.41,
      "amortissement": 1289.787,
      "services": 0,
      "restantdu": 48229.756
    }
  ]
};

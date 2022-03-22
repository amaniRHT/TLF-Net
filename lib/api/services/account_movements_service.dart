import 'dart:async';
import 'dart:typed_data';

import 'package:dio/dio.dart';
import 'package:e_loan_mobile/Helpers/requests_interceptor.dart';
import 'package:e_loan_mobile/api/models/models.dart';
import 'package:e_loan_mobile/api/services/services.dart';
import 'package:e_loan_mobile/api/urls/app_urls.dart';
import 'package:e_loan_mobile/config/config.dart';

class AccountMovementsService {
  Future<AccountMovementsListModel> getAccountMovements({
    final RepaymentFilteringParameters parameters,
  }) {
    final Map<String, dynamic> params = {
      if (parameters.startDate != null) 'startDate': parameters.startDate,
      if (parameters.endDate != null) 'endDate': parameters.endDate,
      if (parameters.column != null) 'column': parameters.column,
      if (parameters.order != null) 'order': parameters.order,
      'limit': (parameters.limit != null)
          ? parameters.limit
          : AppConstants.MAX_ITEMS_PER_PAGE,
      if (parameters.page != null) 'page': parameters.page,
    };

    if (fakeData)
      return AppConstants.falseFutrue.then(
        (value) => AccountMovementsListModel.fromJson(_fakeList),
      );
    else
      return DioRequestsInterceptor.dio
          .get(
        AppUrls.getAccountMovementsList,
        queryParameters: params,
      )
          .then((
        Response<dynamic> response,
      ) {
        if (response != null &&
            response.data != null &&
            response.statusCode == 200) {
          return AccountMovementsListModel.fromJson(
              response.data as Map<String, dynamic>);
        } else
          return null;
      });
  }

  Future<Uint8List> downloadPDF({
    final RepaymentFilteringParameters parameters,
  }) {
    final Map<String, dynamic> params = {
      if (parameters.startDate != null) 'startDate': parameters.startDate,
      if (parameters.endDate != null) 'endDate': parameters.endDate,
    };
    DioRequestsInterceptor.responseType = ResponseType.bytes;
    return DioRequestsInterceptor.dio
        .get(
      AppUrls.downloadAccountMovementsList,
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

Map<String, Object> _fakeList = {
  "totalItems": 3,
  "page": "1",
  "limit": "10",
  "mouvementCompte": [
    {
      "id": 2,
      "contract_code": 19549,
      "id_client": 1111,
      "document_nb": "2104/115197",
      "libelle": "Cession",
      "date_echeance": "02/07/2021",
      "date_process": "4/16/2021 10:51",
      "montant_debit": 11399.555,
      "montant_Credit": null,
      "reste_a_regler": 0,
      "date_operation": "25/11/2021 0:00"
    },
    {
      "id": 3,
      "contract_code": 19549,
      "id_client": 1111,
      "document_nb": "P2105/004171",
      "libelle": "PRLAUTO ",
      "date_echeance": "02/07/2021",
      "date_process": "5/1/2021 0:00",
      "montant_debit": null,
      "montant_Credit": 2185.674,
      "reste_a_regler": 0,
      "date_operation": "25/11/2021 0:00"
    },
    {
      "id": 1,
      "contract_code": 19549,
      "id_client": 1111,
      "document_nb": "2104/114962",
      "libelle": "AnnulationLoyer",
      "date_echeance": "02/07/2021",
      "date_process": "4/15/2021 0:00",
      "montant_debit": null,
      "montant_Credit": 1251.577,
      "reste_a_regler": 0,
      "date_operation": "25/11/2021 0:00"
    },
    {
      "id": 1,
      "contract_code": 19549,
      "id_client": 1111,
      "document_nb": "2104/114962",
      "libelle": "AnnulationLoyer",
      "date_echeance": "02/07/2021",
      "date_process": "4/15/2021 0:00",
      "montant_debit": null,
      "montant_Credit": 1251.577,
      "reste_a_regler": 0,
      "date_operation": "25/11/2021 0:00"
    },
    {
      "id": 1,
      "contract_code": 19549,
      "id_client": 1111,
      "document_nb": "2104/114962",
      "libelle": "AnnulationLoyer",
      "date_echeance": "02/07/2021",
      "date_process": "4/15/2021 0:00",
      "montant_debit": null,
      "montant_Credit": 1251.577,
      "reste_a_regler": 0,
      "date_operation": "25/11/2021 0:00"
    },
    {
      "id": 1,
      "contract_code": 19549,
      "id_client": 1111,
      "document_nb": "2104/114962",
      "libelle": "AnnulationLoyer",
      "date_echeance": "02/07/2021",
      "date_process": "4/15/2021 0:00",
      "montant_debit": null,
      "montant_Credit": 1251.577,
      "reste_a_regler": 0,
      "date_operation": "25/11/2021 0:00"
    },
    {
      "id": 1,
      "contract_code": 19549,
      "id_client": 1111,
      "document_nb": "2104/114962",
      "libelle": "AnnulationLoyer",
      "date_echeance": "02/07/2021",
      "date_process": "4/15/2021 0:00",
      "montant_debit": null,
      "montant_Credit": 1251.577,
      "reste_a_regler": 0,
      "date_operation": "25/11/2021 0:00"
    },
    {
      "id": 1,
      "contract_code": 19549,
      "id_client": 1111,
      "document_nb": "2104/114962",
      "libelle": "AnnulationLoyer",
      "date_echeance": "02/07/2021",
      "date_process": "4/15/2021 0:00",
      "montant_debit": null,
      "montant_Credit": 1251.577,
      "reste_a_regler": 0,
      "date_operation": "25/11/2021 0:00"
    },
    {
      "id": 1,
      "contract_code": 19549,
      "id_client": 1111,
      "document_nb": "2104/114962",
      "libelle": "AnnulationLoyer",
      "date_echeance": "02/07/2021",
      "date_process": "4/15/2021 0:00",
      "montant_debit": null,
      "montant_Credit": 1251.577,
      "reste_a_regler": 0,
      "date_operation": "25/11/2021 0:00"
    },
    {
      "id": 1,
      "contract_code": 19549,
      "id_client": 1111,
      "document_nb": "2104/114962",
      "libelle": "AnnulationLoyer",
      "date_echeance": "02/07/2021",
      "date_process": "4/15/2021 0:00",
      "montant_debit": null,
      "montant_Credit": 1251.577,
      "reste_a_regler": 0,
      "date_operation": "25/11/2021 0:00"
    }
  ]
};

import 'dart:async';
import 'dart:typed_data';
import 'package:dio/dio.dart';
import 'package:e_loan_mobile/Helpers/requests_interceptor.dart';
import 'package:e_loan_mobile/api/models/models.dart';
import 'package:e_loan_mobile/api/services/services.dart';
import 'package:e_loan_mobile/api/urls/app_urls.dart';
import 'package:e_loan_mobile/config/config.dart';

class UnpaidBillsService {
  Future<UnpaidBillsListModel> getUnpaidBills({
    final RepaymentFilteringParameters parameters,
  }) {
    final Map<String, dynamic> params = {
      if (parameters.column != null) 'column': parameters.column,
      if (parameters.order != null) 'order': parameters.order,
      'limit': (parameters.limit != null) ? parameters.limit : AppConstants.MAX_ITEMS_PER_PAGE,
      if (parameters.page != null) 'page': parameters.page,
    };

    if (fakeData)
      return AppConstants.falseFutrue.then(
        (value) => UnpaidBillsListModel.fromJson(_fakeList),
      );
    else
      return DioRequestsInterceptor.dio
          .get(AppUrls.unpaidBillsList, queryParameters: params)
          .then((Response<dynamic> response) {
        if (response != null && response.data != null && response.statusCode == 200) {
          return UnpaidBillsListModel.fromJson(response.data as Map<String, dynamic>);
        } else
          return null;
      });
  }

  Future<Uint8List> downloadPDF({
    final RepaymentFilteringParameters parameters,
  }) {
    DioRequestsInterceptor.responseType = ResponseType.bytes;
    return DioRequestsInterceptor.dio.get(AppUrls.downloadUnpaidBillsList).then((response) {
      if (response != null && response.data != null && response.statusCode == 200)
        return response.data;
      else
        return null;
    });
  }
}

Map<String, Object> _fakeList = {
  "totalItems": 4,
  "page": "1",
  "sum_reste_a_regler": "3,200",
  "sum_montant_a_lettrer": "-4 895,280",
  "limit": "10",
  "factures": [
    {
      "id": 1,
      "contract_code": 19549,
      "id_client": 1111,
      "document_nb": "2009992/00000631",
      "libelle": "Cession",
      "date_echeance": "12/03/2009 0:00",
      "montant_facture": 1,
      "reste_a_regler": 1,
      "montant_a_lettrer": -1223.82
    },
    {
      "id": 1,
      "contract_code": 19549,
      "id_client": 1111,
      "document_nb": "2009992/00000631",
      "libelle": "Cession",
      "date_echeance": "12/03/2009 0:00",
      "montant_facture": 1,
      "reste_a_regler": 1,
      "montant_a_lettrer": -1223.82
    },
    {
      "id": 1,
      "contract_code": 19549,
      "id_client": 1111,
      "document_nb": "2009992/00000631",
      "libelle": "Cession",
      "date_echeance": "12/03/2009 0:00",
      "montant_facture": 1,
      "reste_a_regler": 1,
      "montant_a_lettrer": -1223.82
    },
    {
      "id": 1,
      "contract_code": 19549,
      "id_client": 1111,
      "document_nb": "2009992/00000631",
      "libelle": "Cession",
      "date_echeance": "12/03/2009 0:00",
      "montant_facture": 1,
      "reste_a_regler": 1,
      "montant_a_lettrer": -1223.82
    },
    {
      "id": 1,
      "contract_code": 19549,
      "id_client": 1111,
      "document_nb": "2009992/00000631",
      "libelle": "Cession",
      "date_echeance": "12/03/2009 0:00",
      "montant_facture": 1,
      "reste_a_regler": 1,
      "montant_a_lettrer": -1223.82
    },
    {
      "id": 1,
      "contract_code": 19549,
      "id_client": 1111,
      "document_nb": "2009992/00000631",
      "libelle": "Cession",
      "date_echeance": "12/03/2009 0:00",
      "montant_facture": 1,
      "reste_a_regler": 1,
      "montant_a_lettrer": -1223.82
    },
    {
      "id": 1,
      "contract_code": 19549,
      "id_client": 1111,
      "document_nb": "2009992/00000631",
      "libelle": "Cession",
      "date_echeance": "12/03/2009 0:00",
      "montant_facture": 1,
      "reste_a_regler": 1,
      "montant_a_lettrer": -1223.82
    },
    {
      "id": 1,
      "contract_code": 19549,
      "id_client": 1111,
      "document_nb": "2009992/00000631",
      "libelle": "Cession",
      "date_echeance": "12/03/2009 0:00",
      "montant_facture": 1,
      "reste_a_regler": 1,
      "montant_a_lettrer": -1223.82
    },
    {
      "id": 3,
      "contract_code": 25411,
      "id_client": 1111,
      "document_nb": "2009992/00000631",
      "libelle": "Cession",
      "date_echeance": "12/03/2009 0:00",
      "montant_facture": 1,
      "reste_a_regler": 1,
      "montant_a_lettrer": -1223.82
    },
    {
      "id": 2,
      "contract_code": 19549,
      "id_client": 1111,
      "document_nb": "2102/056058",
      "libelle": "Frais de dossier",
      "date_echeance": "05/02/2021 0:00",
      "montant_facture": 120.60000000000001,
      "reste_a_regler": 0.6,
      "montant_a_lettrer": -1223.82
    },
    {
      "id": 4,
      "contract_code": 25411,
      "id_client": 1111,
      "document_nb": "2102/056058",
      "libelle": "Frais de dossier",
      "date_echeance": "05/02/2021 0:00",
      "montant_facture": 120.60000000000001,
      "reste_a_regler": 0.6,
      "montant_a_lettrer": -1223.82
    }
  ]
};

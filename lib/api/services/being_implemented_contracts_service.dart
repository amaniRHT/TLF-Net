import 'dart:async';
import 'dart:typed_data';

import 'package:dio/dio.dart';
import 'package:e_loan_mobile/Helpers/requests_interceptor.dart';
import 'package:e_loan_mobile/api/models/models.dart';
import 'package:e_loan_mobile/api/services/services.dart';
import 'package:e_loan_mobile/api/urls/app_urls.dart';
import 'package:e_loan_mobile/config/config.dart';

class BeingImplementedContractsService {
  Future<BeingImplementedContractsListModel> getBeingImplementedContracts({
    final RepaymentFilteringParameters parameters,
  }) {
    final Map<String, dynamic> params = {
      if (parameters.column != null) 'column': parameters.column,
      if (parameters.order != null) 'order': parameters.order,
      'limit': (parameters.limit != null)
          ? parameters.limit
          : AppConstants.MAX_ITEMS_PER_PAGE,
      if (parameters.page != null) 'page': parameters.page,
    };

    if (fakeData)
      return AppConstants.falseFutrue.then(
        (value) => BeingImplementedContractsListModel.fromJson(fakeList),
      );
    else
      return DioRequestsInterceptor.dio
          .get(
        AppUrls.getBeingImplementedContractsList,
        queryParameters: params,
      )
          .then((
        Response<dynamic> response,
      ) {
        if (response != null &&
            response.data != null &&
            response.statusCode == 200) {
          return BeingImplementedContractsListModel.fromJson(
              response.data as Map<String, dynamic>);
        } else
          return null;
      });
  }

  Future<Uint8List> downloadPDF({
    final RepaymentFilteringParameters parameters,
  }) {
    DioRequestsInterceptor.responseType = ResponseType.bytes;
    return DioRequestsInterceptor.dio
        .get(AppUrls.downloadBeingImplementedContractsList)
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
  "totalItems": 2,
  "page": "1",
  "limit": "10",
  "contrats": [
    {
      "id": 3,
      "id_client": 1111,
      "contract_code": 257050,
      "objet": "19549_ETABLISSEMENT HENTATI_CAMION STAR TRUCK",
      "montant_finance": 27689.171000000002,
      "duree_globale": 36,
      "duree_residuelle": 1,
      "valeur_residuelle": 1,
      "statut": "En cours de mise en force"
    },
    {
      "id": 3,
      "id_client": 1111,
      "contract_code": 257050,
      "objet": "19549_ETABLISSEMENT HENTATI_CAMION STAR TRUCK",
      "montant_finance": 27689.171000000002,
      "duree_globale": 36,
      "duree_residuelle": 1,
      "valeur_residuelle": 1,
      "statut": "En cours de mise en force"
    },
    {
      "id": 3,
      "id_client": 1111,
      "contract_code": 257050,
      "objet": "19549_ETABLISSEMENT HENTATI_CAMION STAR TRUCK",
      "montant_finance": 27689.171000000002,
      "duree_globale": 36,
      "duree_residuelle": 1,
      "valeur_residuelle": 1,
      "statut": "En cours de mise en force"
    },
    {
      "id": 3,
      "id_client": 1111,
      "contract_code": 257050,
      "objet": "19549_ETABLISSEMENT HENTATI_CAMION STAR TRUCK",
      "montant_finance": 27689.171000000002,
      "duree_globale": 36,
      "duree_residuelle": 1,
      "valeur_residuelle": 1,
      "statut": "En cours de mise en force"
    },
    {
      "id": 3,
      "id_client": 1111,
      "contract_code": 257050,
      "objet": "19549_ETABLISSEMENT HENTATI_CAMION STAR TRUCK",
      "montant_finance": 27689.171000000002,
      "duree_globale": 36,
      "duree_residuelle": 1,
      "valeur_residuelle": 1,
      "statut": "En cours de mise en force"
    },
    {
      "id": 3,
      "id_client": 1111,
      "contract_code": 257050,
      "objet": "19549_ETABLISSEMENT HENTATI_CAMION STAR TRUCK",
      "montant_finance": 27689.171000000002,
      "duree_globale": 36,
      "duree_residuelle": 1,
      "valeur_residuelle": 1,
      "statut": "En cours de mise en force"
    },
    {
      "id": 2,
      "id_client": 1111,
      "contract_code": 257050,
      "objet": "19549_ETABLISSEMENT HENTATI_CAMION STAR TRUCK",
      "montant_finance": 27689.171000000002,
      "duree_globale": 36,
      "duree_residuelle": 1,
      "valeur_residuelle": 1,
      "statut": "En cours de mise en force"
    },
    {
      "id": 2,
      "id_client": 1111,
      "contract_code": 257050,
      "objet": "19549_ETABLISSEMENT HENTATI_CAMION STAR TRUCK",
      "montant_finance": 27689.171000000002,
      "duree_globale": 36,
      "duree_residuelle": 1,
      "valeur_residuelle": 1,
      "statut": "En cours de mise en force"
    },
    {
      "id": 2,
      "id_client": 1111,
      "contract_code": 257050,
      "objet": "19549_ETABLISSEMENT HENTATI_CAMION STAR TRUCK",
      "montant_finance": 27689.171000000002,
      "duree_globale": 36,
      "duree_residuelle": 1,
      "valeur_residuelle": 1,
      "statut": "En cours de mise en force"
    },
    {
      "id": 2,
      "id_client": 1111,
      "contract_code": 257050,
      "objet": "19549_ETABLISSEMENT HENTATI_CAMION STAR TRUCK",
      "montant_finance": 27689.171000000002,
      "duree_globale": 36,
      "duree_residuelle": 1,
      "valeur_residuelle": 1,
      "statut": "En cours de mise en force"
    },
    {
      "id": 2,
      "id_client": 1111,
      "contract_code": 257050,
      "objet": "19549_ETABLISSEMENT HENTATI_CAMION STAR TRUCK",
      "montant_finance": 27689.171000000002,
      "duree_globale": 36,
      "duree_residuelle": 1,
      "valeur_residuelle": 1,
      "statut": "En cours de mise en force"
    }
  ]
};

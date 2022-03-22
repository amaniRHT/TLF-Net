import 'dart:async';
import 'dart:typed_data';

import 'package:dio/dio.dart';
import 'package:e_loan_mobile/Helpers/requests_interceptor.dart';
import 'package:e_loan_mobile/api/models/in_force_contract_list_response.dart';
import 'package:e_loan_mobile/api/models/models.dart';
import 'package:e_loan_mobile/api/services/services.dart';
import 'package:e_loan_mobile/api/urls/app_urls.dart';
import 'package:e_loan_mobile/config/config.dart';

class InForceContractsService {
  Future<InForceContractsListModel> getInForceContracts({
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
        (value) => InForceContractsListModel.fromJson(fakeList),
      );
    else
      return DioRequestsInterceptor.dio
          .get(
        AppUrls.getInForceContractsList,
        queryParameters: params,
      )
          .then((
        Response<dynamic> response,
      ) {
        if (response != null &&
            response.data != null &&
            response.statusCode == 200) {
          return InForceContractsListModel.fromJson(
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
        .get(AppUrls.downloadInforceContractsList)
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
  "totalItems": 15,
  "page": "2",
  "limit": "10",
  "contrats": [
    {
      "id": 11,
      "id_client": 1111,
      "contract_code": 251847,
      "objet": "19549_ETABLISSEMENT HENTATI_TIVOLI",
      "montant_finance": 534.214,
      "date_premier_loyer": "2/5/2021 0:00",
      "date_dernier_loyer": "2/4/2024 0:00",
      "duree_globale": 36,
      "duree_residuelle": 1,
      "valeur_residuelle": 1,
      "statut": "Vigueur"
    },
    {
      "id": 12,
      "id_client": 1111,
      "contract_code": 251844,
      "objet": "19549_ETABLISSEMENT HENTATI_TIVOLI",
      "montant_finance": 54534.214,
      "date_premier_loyer": "2/5/2021 0:00",
      "date_dernier_loyer": "2/4/2024 0:00",
      "duree_globale": 36,
      "duree_residuelle": 32,
      "valeur_residuelle": 1,
      "statut": "Vigueur"
    },
    {
      "id": 15,
      "id_client": 1111,
      "contract_code": 251811,
      "objet": "19549_ETABLISSEMENT HENTATI_TIVOLI",
      "montant_finance": 54534.214,
      "date_premier_loyer": "2/5/2021 0:00",
      "date_dernier_loyer": "2/4/2024 0:00",
      "duree_globale": 36,
      "duree_residuelle": 32,
      "valeur_residuelle": 1,
      "statut": "Vigueur"
    },
    {
      "id": 14,
      "id_client": 1111,
      "contract_code": 251847,
      "objet": "19549_ETABLISSEMENT HENTATI_TIVOLI",
      "montant_finance": 54534.214,
      "date_premier_loyer": "2/5/2021 0:00",
      "date_dernier_loyer": "2/4/2024 0:00",
      "duree_globale": 36,
      "duree_residuelle": 32,
      "valeur_residuelle": 1,
      "statut": "Vigueur"
    },
    {
      "id": 13,
      "id_client": 1111,
      "contract_code": 251847,
      "objet": "19549_ETABLISSEMENT HENTATI_TIVOLI",
      "montant_finance": 54534.214,
      "date_premier_loyer": "2/5/2021 0:00",
      "date_dernier_loyer": "2/4/2024 0:00",
      "duree_globale": 36,
      "duree_residuelle": 32,
      "valeur_residuelle": 1,
      "statut": "Vigueur"
    },
    {
      "id": 13,
      "id_client": 1111,
      "contract_code": 251847,
      "objet": "19549_ETABLISSEMENT HENTATI_TIVOLI",
      "montant_finance": 54534.214,
      "date_premier_loyer": "2/5/2021 0:00",
      "date_dernier_loyer": "2/4/2024 0:00",
      "duree_globale": 36,
      "duree_residuelle": 32,
      "valeur_residuelle": 1,
      "statut": "Vigueur"
    },
    {
      "id": 13,
      "id_client": 1111,
      "contract_code": 251847,
      "objet": "19549_ETABLISSEMENT HENTATI_TIVOLI",
      "montant_finance": 54534.214,
      "date_premier_loyer": "2/5/2021 0:00",
      "date_dernier_loyer": "2/4/2024 0:00",
      "duree_globale": 36,
      "duree_residuelle": 32,
      "valeur_residuelle": 1,
      "statut": "Vigueur"
    },
    {
      "id": 13,
      "id_client": 1111,
      "contract_code": 251847,
      "objet": "19549_ETABLISSEMENT HENTATI_TIVOLI",
      "montant_finance": 54534.214,
      "date_premier_loyer": "2/5/2021 0:00",
      "date_dernier_loyer": "2/4/2024 0:00",
      "duree_globale": 36,
      "duree_residuelle": 32,
      "valeur_residuelle": 1,
      "statut": "Vigueur"
    },
    {
      "id": 13,
      "id_client": 1111,
      "contract_code": 251847,
      "objet": "19549_ETABLISSEMENT HENTATI_TIVOLI",
      "montant_finance": 54534.214,
      "date_premier_loyer": "2/5/2021 0:00",
      "date_dernier_loyer": "2/4/2024 0:00",
      "duree_globale": 36,
      "duree_residuelle": 32,
      "valeur_residuelle": 1,
      "statut": "Vigueur"
    },
    {
      "id": 13,
      "id_client": 1111,
      "contract_code": 251847,
      "objet": "19549_ETABLISSEMENT HENTATI_TIVOLI",
      "montant_finance": 54534.214,
      "date_premier_loyer": "2/5/2021 0:00",
      "date_dernier_loyer": "2/4/2024 0:00",
      "duree_globale": 36,
      "duree_residuelle": 32,
      "valeur_residuelle": 1,
      "statut": "Vigueur"
    },
    {
      "id": 13,
      "id_client": 1111,
      "contract_code": 251847,
      "objet": "19549_ETABLISSEMENT HENTATI_TIVOLI",
      "montant_finance": 54534.214,
      "date_premier_loyer": "2/5/2021 0:00",
      "date_dernier_loyer": "2/4/2024 0:00",
      "duree_globale": 36,
      "duree_residuelle": 32,
      "valeur_residuelle": 1,
      "statut": "Vigueur"
    },
    {
      "id": 13,
      "id_client": 1111,
      "contract_code": 251847,
      "objet": "19549_ETABLISSEMENT HENTATI_TIVOLI",
      "montant_finance": 54534.214,
      "date_premier_loyer": "2/5/2021 0:00",
      "date_dernier_loyer": "2/4/2024 0:00",
      "duree_globale": 36,
      "duree_residuelle": 32,
      "valeur_residuelle": 1,
      "statut": "Vigueur"
    },
    {
      "id": 13,
      "id_client": 1111,
      "contract_code": 251847,
      "objet": "19549_ETABLISSEMENT HENTATI_TIVOLI",
      "montant_finance": 54534.214,
      "date_premier_loyer": "2/5/2021 0:00",
      "date_dernier_loyer": "2/4/2024 0:00",
      "duree_globale": 36,
      "duree_residuelle": 32,
      "valeur_residuelle": 1,
      "statut": "Vigueur"
    },
    {
      "id": 13,
      "id_client": 1111,
      "contract_code": 251847,
      "objet": "19549_ETABLISSEMENT HENTATI_TIVOLI",
      "montant_finance": 54534.214,
      "date_premier_loyer": "2/5/2021 0:00",
      "date_dernier_loyer": "2/4/2024 0:00",
      "duree_globale": 36,
      "duree_residuelle": 32,
      "valeur_residuelle": 1,
      "statut": "Vigueur"
    },
    {
      "id": 13,
      "id_client": 1111,
      "contract_code": 251847,
      "objet": "19549_ETABLISSEMENT HENTATI_TIVOLI",
      "montant_finance": 54534.214,
      "date_premier_loyer": "2/5/2021 0:00",
      "date_dernier_loyer": "2/4/2024 0:00",
      "duree_globale": 36,
      "duree_residuelle": 32,
      "valeur_residuelle": 1,
      "statut": "Vigueur"
    },
    {
      "id": 13,
      "id_client": 1111,
      "contract_code": 251847,
      "objet": "19549_ETABLISSEMENT HENTATI_TIVOLI",
      "montant_finance": 54534.214,
      "date_premier_loyer": "2/5/2021 0:00",
      "date_dernier_loyer": "2/4/2024 0:00",
      "duree_globale": 36,
      "duree_residuelle": 32,
      "valeur_residuelle": 1,
      "statut": "Vigueur"
    },
    {
      "id": 13,
      "id_client": 1111,
      "contract_code": 251847,
      "objet": "19549_ETABLISSEMENT HENTATI_TIVOLI",
      "montant_finance": 54534.214,
      "date_premier_loyer": "2/5/2021 0:00",
      "date_dernier_loyer": "2/4/2024 0:00",
      "duree_globale": 36,
      "duree_residuelle": 32,
      "valeur_residuelle": 1,
      "statut": "Vigueur"
    }
  ]
};

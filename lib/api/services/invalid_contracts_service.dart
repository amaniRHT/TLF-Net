import 'dart:async';
import 'dart:typed_data';
import 'package:dio/dio.dart';
import 'package:e_loan_mobile/Helpers/requests_interceptor.dart';
import 'package:e_loan_mobile/api/models/models.dart';
import 'package:e_loan_mobile/api/services/services.dart';
import 'package:e_loan_mobile/api/urls/app_urls.dart';
import 'package:e_loan_mobile/config/config.dart';

class InvalidContractsService {
  Future<InvalidContractsListModel> getInvalidContracts({
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
        (value) => InvalidContractsListModel.fromJson(fakeList),
      );
    else
      return DioRequestsInterceptor.dio
          .get(
        AppUrls.getInvalidContractsList,
        queryParameters: params,
      )
          .then((
        Response<dynamic> response,
      ) {
        if (response != null && response.data != null && response.statusCode == 200) {
          return InvalidContractsListModel.fromJson(response.data as Map<String, dynamic>);
        } else
          return null;
      });
  }

  Future<Uint8List> downloadPDF({final RepaymentFilteringParameters parameters}) {
    DioRequestsInterceptor.responseType = ResponseType.bytes;
    return DioRequestsInterceptor.dio.get(AppUrls.downloadInvalidContractsList).then((response) {
      if (response != null && response.data != null && response.statusCode == 200)
        return response.data;
      else
        return null;
    });
  }
}

Map<String, Object> fakeList = {
  "totalItems": 11,
  "page": "1",
  "limit": "10",
  "contrats": [
    {
      "id": 18,
      "id_client": 1111,
      "contract_code": 251847,
      "objet": "19549_ETABLISSEMENT HENTATI_TIVOLI",
      "montant_finance": 54534.214,
      "date_premier_loyer": "2/5/2015 0:00",
      "date_dernier_loyer": "2/4/2024 0:00",
      "duree_globale": 36,
      "duree_residuelle": 1,
      "valeur_residuelle": 1,
      "statut": "Echu"
    },
    {
      "id": 23,
      "id_client": 1111,
      "contract_code": 251847,
      "objet": "19549_ETABLISSEMENT HENTATI_TIVOLI",
      "montant_finance": 54534.214,
      "date_premier_loyer": "2/5/2017 0:00",
      "date_dernier_loyer": "2/4/2024 0:00",
      "duree_globale": 36,
      "duree_residuelle": 33,
      "valeur_residuelle": 1,
      "statut": "Echu"
    },
    {
      "id": 16,
      "id_client": 1111,
      "contract_code": 146163,
      "objet": "01 TRACTOPELLE HIDROMEK",
      "montant_finance": 161090.6,
      "date_premier_loyer": "6/5/2018 0:00",
      "date_dernier_loyer": "12/4/2019 0:00",
      "duree_globale": 18,
      "duree_residuelle": 0,
      "valeur_residuelle": 2,
      "statut": "Echu"
    },
    {
      "id": 21,
      "id_client": 1111,
      "contract_code": 251847,
      "objet": "19549_ETABLISSEMENT HENTATI_TIVOLI",
      "montant_finance": 534.214,
      "date_premier_loyer": "2/5/2021 0:00",
      "date_dernier_loyer": "2/4/2024 0:00",
      "duree_globale": 36,
      "duree_residuelle": 32,
      "valeur_residuelle": 1,
      "statut": "Echu"
    },
    {
      "id": 22,
      "id_client": 1111,
      "contract_code": 251834,
      "objet": "19549_ETABLISSEMENT HENTATI_TIVOLI",
      "montant_finance": 534.214,
      "date_premier_loyer": "2/5/2021 0:00",
      "date_dernier_loyer": "2/4/2024 0:00",
      "duree_globale": 36,
      "duree_residuelle": 32,
      "valeur_residuelle": 12,
      "statut": "Echu"
    },
    {
      "id": 24,
      "id_client": 1111,
      "contract_code": 251811,
      "objet": "19549_ETABLISSEMENT HENTATI_TIVOLI",
      "montant_finance": 54534.214,
      "date_premier_loyer": "2/5/2021 0:00",
      "date_dernier_loyer": "2/4/2024 0:00",
      "duree_globale": 36,
      "duree_residuelle": 32,
      "valeur_residuelle": 4,
      "statut": "Echu"
    },
    {
      "id": 20,
      "id_client": 1111,
      "contract_code": 251847,
      "objet": "19549_ETABLISSEMENT HENTATI_TIVOLI",
      "montant_finance": 54534.214,
      "date_premier_loyer": "2/5/2021 0:00",
      "date_dernier_loyer": "2/4/2024 0:00",
      "duree_globale": 36,
      "duree_residuelle": 32,
      "valeur_residuelle": 1,
      "statut": "Echu"
    },
    {
      "id": 25,
      "id_client": 1111,
      "contract_code": 251847,
      "objet": "19549_ETABLISSEMENT HENTATI_TIVOLI",
      "montant_finance": 54534.214,
      "date_premier_loyer": "2/5/2021 0:00",
      "date_dernier_loyer": "2/4/2024 0:00",
      "duree_globale": 36,
      "duree_residuelle": 32,
      "valeur_residuelle": 11,
      "statut": "Echu"
    },
    {
      "id": 17,
      "id_client": 1111,
      "contract_code": 251847,
      "objet": "19549_ETABLISSEMENT HENTATI_TIVOLI",
      "montant_finance": 54534.214,
      "date_premier_loyer": "2/5/2021 0:00",
      "date_dernier_loyer": "2/4/2024 0:00",
      "duree_globale": 36,
      "duree_residuelle": 1,
      "valeur_residuelle": 4,
      "statut": "Echu"
    },
    {
      "id": 19,
      "id_client": 1111,
      "contract_code": 251825,
      "objet": "19549_ETABLISSEMENT HENTATI_TIVOLI",
      "montant_finance": 54534.214,
      "date_premier_loyer": "2/5/2021 0:00",
      "date_dernier_loyer": "2/4/2024 0:00",
      "duree_globale": 36,
      "duree_residuelle": 32,
      "valeur_residuelle": 2,
      "statut": "Echu"
    },
    {
      "id": 19,
      "id_client": 1111,
      "contract_code": 251825,
      "objet": "19549_ETABLISSEMENT HENTATI_TIVOLI",
      "montant_finance": 54534.214,
      "date_premier_loyer": "2/5/2021 0:00",
      "date_dernier_loyer": "2/4/2024 0:00",
      "duree_globale": 36,
      "duree_residuelle": 32,
      "valeur_residuelle": 2,
      "statut": "Echu"
    },
    {
      "id": 19,
      "id_client": 1111,
      "contract_code": 251825,
      "objet": "19549_ETABLISSEMENT HENTATI_TIVOLI",
      "montant_finance": 54534.214,
      "date_premier_loyer": "2/5/2021 0:00",
      "date_dernier_loyer": "2/4/2024 0:00",
      "duree_globale": 36,
      "duree_residuelle": 32,
      "valeur_residuelle": 2,
      "statut": "Echu"
    },
    {
      "id": 19,
      "id_client": 1111,
      "contract_code": 251825,
      "objet": "19549_ETABLISSEMENT HENTATI_TIVOLI",
      "montant_finance": 54534.214,
      "date_premier_loyer": "2/5/2021 0:00",
      "date_dernier_loyer": "2/4/2024 0:00",
      "duree_globale": 36,
      "duree_residuelle": 32,
      "valeur_residuelle": 2,
      "statut": "Echu"
    },
    {
      "id": 19,
      "id_client": 1111,
      "contract_code": 251825,
      "objet": "19549_ETABLISSEMENT HENTATI_TIVOLI",
      "montant_finance": 54534.214,
      "date_premier_loyer": "2/5/2021 0:00",
      "date_dernier_loyer": "2/4/2024 0:00",
      "duree_globale": 36,
      "duree_residuelle": 32,
      "valeur_residuelle": 2,
      "statut": "Echu"
    },
    {
      "id": 19,
      "id_client": 1111,
      "contract_code": 251825,
      "objet": "19549_ETABLISSEMENT HENTATI_TIVOLI",
      "montant_finance": 54534.214,
      "date_premier_loyer": "2/5/2021 0:00",
      "date_dernier_loyer": "2/4/2024 0:00",
      "duree_globale": 36,
      "duree_residuelle": 32,
      "valeur_residuelle": 2,
      "statut": "Echu"
    },
    {
      "id": 19,
      "id_client": 1111,
      "contract_code": 251825,
      "objet": "19549_ETABLISSEMENT HENTATI_TIVOLI",
      "montant_finance": 54534.214,
      "date_premier_loyer": "2/5/2021 0:00",
      "date_dernier_loyer": "2/4/2024 0:00",
      "duree_globale": 36,
      "duree_residuelle": 32,
      "valeur_residuelle": 2,
      "statut": "Echu"
    },
    {
      "id": 19,
      "id_client": 1111,
      "contract_code": 251825,
      "objet": "19549_ETABLISSEMENT HENTATI_TIVOLI",
      "montant_finance": 54534.214,
      "date_premier_loyer": "2/5/2021 0:00",
      "date_dernier_loyer": "2/4/2024 0:00",
      "duree_globale": 36,
      "duree_residuelle": 32,
      "valeur_residuelle": 2,
      "statut": "Echu"
    },
    {
      "id": 19,
      "id_client": 1111,
      "contract_code": 251825,
      "objet": "19549_ETABLISSEMENT HENTATI_TIVOLI",
      "montant_finance": 54534.214,
      "date_premier_loyer": "2/5/2021 0:00",
      "date_dernier_loyer": "2/4/2024 0:00",
      "duree_globale": 36,
      "duree_residuelle": 32,
      "valeur_residuelle": 2,
      "statut": "Echu"
    },
    {
      "id": 19,
      "id_client": 1111,
      "contract_code": 251825,
      "objet": "19549_ETABLISSEMENT HENTATI_TIVOLI",
      "montant_finance": 54534.214,
      "date_premier_loyer": "2/5/2021 0:00",
      "date_dernier_loyer": "2/4/2024 0:00",
      "duree_globale": 36,
      "duree_residuelle": 32,
      "valeur_residuelle": 2,
      "statut": "Echu"
    }
  ]
};

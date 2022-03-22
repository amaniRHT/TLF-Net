import 'dart:async';
import 'package:dio/dio.dart';
import 'package:e_loan_mobile/Helpers/requests_interceptor.dart';
import 'package:e_loan_mobile/api/models/requets_filtering_params.dart';
import 'package:e_loan_mobile/api/models/requests_list_response.dart';
import 'package:e_loan_mobile/api/services/services.dart';
import 'package:e_loan_mobile/api/urls/app_urls.dart';
import 'package:e_loan_mobile/config/config.dart';
import 'package:flutter/material.dart';

class RequestService {
  const RequestService({@required this.isQuotation});
  final bool isQuotation;

  Future<RequestsListModel> getRequests({
    final RequestsFilteringParameters parameters,
  }) {
    final Map<String, dynamic> params = {
      if (parameters.startDate != null) 'startDate': parameters.startDate,
      if (parameters.endDate != null) 'endDate': parameters.endDate,
      if (parameters.maxAmount != null) 'maxAmount': parameters.maxAmount,
      if (parameters.minAmount != null) 'minAmount': parameters.minAmount,
      if (parameters.type != null) 'type': parameters.type,
      if (parameters.status != null) 'status': parameters.status,
      'limit': (parameters.limit != null) ? parameters.limit : AppConstants.MAX_ITEMS_PER_PAGE,
      if (parameters.page != null) 'page': parameters.page,
    };

    if (fakeData)
      return AppConstants.falseFutrue.then(
        (value) => RequestsListModel.fromJson(fakeList),
      );
    else
      return DioRequestsInterceptor.dio
          .get(
        isQuotation ? AppUrls.getQuotationsList : AppUrls.getRequestsList,
        queryParameters: params,
      )
          .then((
        Response<dynamic> response,
      ) {
        if (response != null && response.data != null && response.statusCode == 200) {
          return RequestsListModel.fromJson(response.data as Map<String, dynamic>);
        } else
          return null;
      });
  }

  Future<bool> deleteRequest({@required int requestId}) {
    return DioRequestsInterceptor.dio
        .delete(isQuotation
            ? AppUrls.deleteQuotation(id: requestId?.toString() ?? '')
            : AppUrls.deleteRequest(id: requestId?.toString() ?? ''))
        .then((Response<dynamic> response) {
      return response != null && response.data != null && response.statusCode == 200;
    });
  }

  Future<Request> getRequestDetails({@required int requestId}) {
    return DioRequestsInterceptor.dio
        .get(isQuotation
            ? AppUrls.getQuotationDetails(id: requestId?.toString() ?? '')
            : AppUrls.getRequestDetails(id: requestId?.toString() ?? ''))
        .then((Response<dynamic> response) {
      if (response != null && response.data != null && response.statusCode == 200) {
        return Request.fromJson(response.data as Map<String, dynamic>);
      } else
        return null;
    });
  }
}

Map<String, Object> fakeList = {
  'totalItems': 14,
  'demandes': [
    {
      'id': 50,
      'code': '0034/2021',
      'type': 1,
      'duree': null,
      'autofinancement': null,
      'objet': null,
      'neuf': null,
      'ageVehicule': null,
      'prixTotal': null,
      'prixHT': null,
      'tva': null,
      'prixTCC': null,
      'fournisseur': null,
      'titrePropriete': null,
      'status': 0,
      'createdAt': '2021-04-28T10:37:14.924Z',
      'updatedAt': '2021-04-28T10:37:14.924Z',
      'updatedBy': {'id': 2, 'firstName': 'MEJRI', 'lastName': 'Jamel Eddine', 'email': 'mejri.jameleddine@gmail.com'},
      'createdBy': {
        'id': 2,
        'firstName': 'MEJRI',
        'lastName': 'Jamel Eddine',
        'email': 'mejri.jameleddine@gmail.com',
        'tier': {
          'id': 7,
          'name': 'Company',
          'socialReason': null,
          'profile': 0,
          'agent': {'id': 1, 'fullName': 'bilel khadhraoui', 'email': 'bih@wevioo.com'},
          'agency': {'id': 1, 'name': 'AG Tunis'}
        }
      }
    },
    {
      'id': 47,
      'code': '0031/2021',
      'type': 2,
      'duree': 252,
      'autofinancement': 11312619,
      'objet': 'gfgf',
      'neuf': null,
      'ageVehicule': null,
      'prixTotal': null,
      'prixHT': 45245252,
      'tva': 5224,
      'prixTCC': 45250476,
      'fournisseur': 'gfghfgh',
      'titrePropriete': 'oui',
      'status': 5,
      'createdAt': '2021-04-28T02:58:57.213Z',
      'updatedAt': '2021-04-28T10:08:20.112Z',
      'updatedBy': {'id': 1, 'firstName': 'loreù', 'lastName': 'loreù', 'email': 'bih@wevioo.com'},
      'createdBy': {
        'id': 2,
        'firstName': 'MEJRI',
        'lastName': 'Jamel Eddine',
        'email': 'mejri.jameleddine@gmail.com',
        'tier': {
          'id': 7,
          'name': 'Company',
          'socialReason': null,
          'profile': 0,
          'agent': {'id': 1, 'fullName': 'bilel khadhraoui', 'email': 'bih@wevioo.com'},
          'agency': {'id': 1, 'name': 'AG Tunis'}
        }
      }
    },
    {
      'id': 46,
      'code': '0030/2021',
      'type': 2,
      'duree': 15,
      'autofinancement': 657146,
      'objet': 'Terrain',
      'neuf': null,
      'ageVehicule': null,
      'prixTotal': null,
      'prixHT': 655631,
      'tva': 1515,
      'prixTCC': 657146,
      'fournisseur': 'Hmed',
      'titrePropriete': 'oui',
      'status': 2,
      'createdAt': '2021-04-28T02:56:49.849Z',
      'updatedAt': '2021-04-28T10:07:44.231Z',
      'updatedBy': {'id': 1, 'firstName': 'loreù', 'lastName': 'loreù', 'email': 'bih@wevioo.com'},
      'createdBy': {
        'id': 2,
        'firstName': 'MEJRI',
        'lastName': 'Jamel Eddine',
        'email': 'mejri.jameleddine@gmail.com',
        'tier': {
          'id': 7,
          'name': 'Company',
          'socialReason': null,
          'profile': 0,
          'agent': {'id': 1, 'fullName': 'bilel khadhraoui', 'email': 'bih@wevioo.com'},
          'agency': {'id': 1, 'name': 'AG Tunis'}
        }
      }
    },
    {
      'id': 45,
      'code': '0029/2021',
      'type': 0,
      'duree': 22,
      'autofinancement': 28,
      'objet': 'rere',
      'neuf': true,
      'ageVehicule': null,
      'prixTotal': null,
      'prixHT': 55,
      'tva': 1,
      'prixTCC': 56,
      'fournisseur': null,
      'titrePropriete': null,
      'status': 3,
      'createdAt': '2021-04-28T02:45:23.842Z',
      'updatedAt': '2021-04-28T09:59:58.508Z',
      'updatedBy': {'id': 1, 'firstName': 'loreù', 'lastName': 'loreù', 'email': 'bih@wevioo.com'},
      'createdBy': {
        'id': 2,
        'firstName': 'MEJRI',
        'lastName': 'Jamel Eddine',
        'email': 'mejri.jameleddine@gmail.com',
        'tier': {
          'id': 7,
          'name': 'Company',
          'socialReason': null,
          'profile': 0,
          'agent': {'id': 1, 'fullName': 'bilel khadhraoui', 'email': 'bih@wevioo.com'},
          'agency': {'id': 1, 'name': 'AG Tunis'}
        }
      }
    },
    {
      'id': 44,
      'code': '0028/2021',
      'type': 0,
      'duree': 12,
      'autofinancement': 97691446,
      'objet': 'Mon objet',
      'neuf': true,
      'ageVehicule': null,
      'prixTotal': null,
      'prixHT': 6516,
      'tva': 122,
      'prixTCC': 6638,
      'fournisseur': null,
      'titrePropriete': null,
      'status': 0,
      'createdAt': '2021-04-28T02:37:01.225Z',
      'updatedAt': '2021-04-28T02:37:01.225Z',
      'updatedBy': {'id': 2, 'firstName': 'MEJRI', 'lastName': 'Jamel Eddine', 'email': 'mejri.jameleddine@gmail.com'},
      'createdBy': {
        'id': 2,
        'firstName': 'MEJRI',
        'lastName': 'Jamel Eddine',
        'email': 'mejri.jameleddine@gmail.com',
        'tier': {
          'id': 7,
          'name': 'Company',
          'socialReason': null,
          'profile': 0,
          'agent': {'id': 1, 'fullName': 'bilel khadhraoui', 'email': 'bih@wevioo.com'},
          'agency': {'id': 1, 'name': 'AG Tunis'}
        }
      }
    },
    {
      'id': 43,
      'code': '0027/2021',
      'type': 1,
      'duree': 232,
      'autofinancement': 98378448,
      'objet': 'oB',
      'neuf': null,
      'ageVehicule': null,
      'prixTotal': null,
      'prixHT': 234234234,
      'tva': 224,
      'prixTCC': 2342344,
      'fournisseur': 'F',
      'titrePropriete': null,
      'status': 5,
      'createdAt': '2021-04-28T02:22:15.689Z',
      'updatedAt': '2021-04-28T09:59:24.029Z',
      'updatedBy': {'id': 1, 'firstName': 'loreù', 'lastName': 'loreù', 'email': 'bih@wevioo.com'},
      'createdBy': {
        'id': 2,
        'firstName': 'MEJRI',
        'lastName': 'Jamel Eddine',
        'email': 'mejri.jameleddine@gmail.com',
        'tier': {
          'id': 7,
          'name': 'Company',
          'socialReason': null,
          'profile': 0,
          'agent': {'id': 1, 'fullName': 'bilel khadhraoui', 'email': 'bih@wevioo.com'},
          'agency': {'id': 1, 'name': 'AG Tunis'}
        }
      }
    },
    {
      'id': 42,
      'code': '0026/2021',
      'type': 0,
      'duree': 48,
      'autofinancement': 47580,
      'objet': 'BMW',
      'neuf': true,
      'ageVehicule': null,
      'prixTotal': null,
      'prixHT': 100000,
      'tva': 18950,
      'prixTCC': 118950,
      'fournisseur': null,
      'titrePropriete': null,
      'status': 2,
      'createdAt': '2021-04-28T01:50:03.334Z',
      'updatedAt': '2021-04-28T09:59:14.713Z',
      'updatedBy': {'id': 1, 'firstName': 'loreù', 'lastName': 'loreù', 'email': 'bih@wevioo.com'},
      'createdBy': {
        'id': 2,
        'firstName': 'MEJRI',
        'lastName': 'Jamel Eddine',
        'email': 'mejri.jameleddine@gmail.com',
        'tier': {
          'id': 7,
          'name': 'Company',
          'socialReason': null,
          'profile': 0,
          'agent': {'id': 1, 'fullName': 'bilel khadhraoui', 'email': 'bih@wevioo.com'},
          'agency': {'id': 1, 'name': 'AG Tunis'}
        }
      }
    },
    {
      'id': 38,
      'code': '0024/2021',
      'type': 1,
      'duree': 36,
      'autofinancement': 10864,
      'objet': 'Moteur',
      'neuf': null,
      'ageVehicule': null,
      'prixTotal': null,
      'prixHT': 50000,
      'tva': 4320,
      'prixTCC': 54320,
      'fournisseur': 'DEGLA',
      'titrePropriete': null,
      'status': 3,
      'createdAt': '2021-04-28T01:41:12.638Z',
      'updatedAt': '2021-04-28T09:58:42.750Z',
      'updatedBy': {'id': 1, 'firstName': 'loreù', 'lastName': 'loreù', 'email': 'bih@wevioo.com'},
      'createdBy': {
        'id': 2,
        'firstName': 'MEJRI',
        'lastName': 'Jamel Eddine',
        'email': 'mejri.jameleddine@gmail.com',
        'tier': {
          'id': 7,
          'name': 'Company',
          'socialReason': null,
          'profile': 0,
          'agent': {'id': 1, 'fullName': 'bilel khadhraoui', 'email': 'bih@wevioo.com'},
          'agency': {'id': 1, 'name': 'AG Tunis'}
        }
      }
    },
    {
      'id': 38,
      'code': '0024/2021',
      'type': 1,
      'duree': 36,
      'autofinancement': 10864,
      'objet': 'Moteur',
      'neuf': null,
      'ageVehicule': null,
      'prixTotal': null,
      'prixHT': 50000,
      'tva': 4320,
      'prixTCC': 54320,
      'fournisseur': 'DEGLA',
      'titrePropriete': null,
      'status': 3,
      'createdAt': '2021-04-28T01:41:12.638Z',
      'updatedAt': '2021-04-28T09:58:42.750Z',
      'updatedBy': {'id': 1, 'firstName': 'loreù', 'lastName': 'loreù', 'email': 'bih@wevioo.com'},
      'createdBy': {
        'id': 2,
        'firstName': 'MEJRI',
        'lastName': 'Jamel Eddine',
        'email': 'mejri.jameleddine@gmail.com',
        'tier': {
          'id': 7,
          'name': 'Company',
          'socialReason': null,
          'profile': 0,
          'agent': {'id': 1, 'fullName': 'bilel khadhraoui', 'email': 'bih@wevioo.com'},
          'agency': {'id': 1, 'name': 'AG Tunis'}
        }
      }
    },
    {
      'id': 38,
      'code': '0024/2021',
      'type': 1,
      'duree': 36,
      'autofinancement': 10864,
      'objet': 'Moteur',
      'neuf': null,
      'ageVehicule': null,
      'prixTotal': null,
      'prixHT': 50000,
      'tva': 4320,
      'prixTCC': 54320,
      'fournisseur': 'DEGLA',
      'titrePropriete': null,
      'status': 3,
      'createdAt': '2021-04-28T01:41:12.638Z',
      'updatedAt': '2021-04-28T09:58:42.750Z',
      'updatedBy': {'id': 1, 'firstName': 'loreù', 'lastName': 'loreù', 'email': 'bih@wevioo.com'},
      'createdBy': {
        'id': 2,
        'firstName': 'MEJRI',
        'lastName': 'Jamel Eddine',
        'email': 'mejri.jameleddine@gmail.com',
        'tier': {
          'id': 7,
          'name': 'Company',
          'socialReason': null,
          'profile': 0,
          'agent': {'id': 1, 'fullName': 'bilel khadhraoui', 'email': 'bih@wevioo.com'},
          'agency': {'id': 1, 'name': 'AG Tunis'}
        }
      }
    },
    {
      'id': 38,
      'code': '0024/2021',
      'type': 1,
      'duree': 36,
      'autofinancement': 10864,
      'objet': 'Moteur',
      'neuf': null,
      'ageVehicule': null,
      'prixTotal': null,
      'prixHT': 50000,
      'tva': 4320,
      'prixTCC': 54320,
      'fournisseur': 'DEGLA',
      'titrePropriete': null,
      'status': 3,
      'createdAt': '2021-04-28T01:41:12.638Z',
      'updatedAt': '2021-04-28T09:58:42.750Z',
      'updatedBy': {'id': 1, 'firstName': 'loreù', 'lastName': 'loreù', 'email': 'bih@wevioo.com'},
      'createdBy': {
        'id': 2,
        'firstName': 'MEJRI',
        'lastName': 'Jamel Eddine',
        'email': 'mejri.jameleddine@gmail.com',
        'tier': {
          'id': 7,
          'name': 'Company',
          'socialReason': null,
          'profile': 0,
          'agent': {'id': 1, 'fullName': 'bilel khadhraoui', 'email': 'bih@wevioo.com'},
          'agency': {'id': 1, 'name': 'AG Tunis'}
        }
      }
    },
    {
      'id': 38,
      'code': '0024/2021',
      'type': 1,
      'duree': 36,
      'autofinancement': 10864,
      'objet': 'Moteur',
      'neuf': null,
      'ageVehicule': null,
      'prixTotal': null,
      'prixHT': 50000,
      'tva': 4320,
      'prixTCC': 54320,
      'fournisseur': 'DEGLA',
      'titrePropriete': null,
      'status': 3,
      'createdAt': '2021-04-28T01:41:12.638Z',
      'updatedAt': '2021-04-28T09:58:42.750Z',
      'updatedBy': {'id': 1, 'firstName': 'loreù', 'lastName': 'loreù', 'email': 'bih@wevioo.com'},
      'createdBy': {
        'id': 2,
        'firstName': 'MEJRI',
        'lastName': 'Jamel Eddine',
        'email': 'mejri.jameleddine@gmail.com',
        'tier': {
          'id': 7,
          'name': 'Company',
          'socialReason': null,
          'profile': 0,
          'agent': {'id': 1, 'fullName': 'bilel khadhraoui', 'email': 'bih@wevioo.com'},
          'agency': {'id': 1, 'name': 'AG Tunis'}
        }
      }
    }
  ]
};

import 'dart:convert';
import 'package:dio/dio.dart';
import 'package:e_loan_mobile/Helpers/helpers.dart';
import 'package:e_loan_mobile/api/models/models.dart';
import 'package:e_loan_mobile/api/services/services.dart';
import 'package:e_loan_mobile/api/urls/app_urls.dart';
import 'package:e_loan_mobile/config/config.dart';
import 'package:flutter/material.dart';

class RDVsService {
  Future<RDVsResponse> getRDVs({
    final RDVsFilteringParameters parameters,
  }) {
    final Map<String, dynamic> params = {
      if (parameters.startDate != null) 'startDate': parameters.startDate,
      if (parameters.endDate != null) 'endDate': parameters.endDate,
      if (parameters.object != null) 'object': parameters.object,
      if (parameters.status != null) 'status': parameters.status,
    };

    if (fakeData)
      return AppConstants.falseFutrue.then(
        (value) => RDVsResponse.fromJson(fakeRDVsList),
      );
    else
      return DioRequestsInterceptor.dio.get(AppUrls.getRDVsList, queryParameters: params).then((
        Response<dynamic> response,
      ) {
        if (response != null && response.data != null && response.statusCode == 200) {
          return RDVsResponse.fromJson(response.data as Map<String, dynamic>);
        } else
          return null;
      });
  }

  Future<bool> deleteRDV({@required int rdvId}) {
    return DioRequestsInterceptor.dio.delete(AppUrls.deleteRDV(id: rdvId?.toString() ?? '')).then((Response<dynamic> response) {
      return response != null && response.data != null && response.statusCode == 200;
    });
  }

  Future<bool> createRDV({
    @required RDVParameters rdvParameters,
  }) {
    final body = {
      'object': rdvParameters.object.trim(),
      'additionalInformation': rdvParameters.additionalInformation.trim(),
    };

    return DioRequestsInterceptor.dio.post(AppUrls.createRDV, data: jsonEncode(body)).then((Response<dynamic> response) {
      if (response != null && response.data != null && response.statusCode == 201) {
        return true;
      } else
        return false;
    });
  }

  Future<bool> updateRDV({
    @required int id,
    @required RDVParameters rdvParameters,
  }) {
    final body = {
      'object': rdvParameters.object.trim(),
      'additionalInformation': rdvParameters.additionalInformation.trim(),
      'status': rdvParameters.status,
    };

    return DioRequestsInterceptor.dio
        .put(
      AppUrls.updateRDV(id: id.toString() ?? ''),
      data: jsonEncode(body),
    )
        .then((
      Response<dynamic> response,
    ) {
      if (response != null && response.data != null && response.statusCode == 200) {
        return true;
      } else
        return false;
    });
  }

  Future<Users> getRDVDetails({@required int userId}) {
    return DioRequestsInterceptor.dio.get(AppUrls.getUserDetails(id: userId?.toString() ?? '')).then(
      (Response<dynamic> response) {
        if (response != null && response.data != null && response.statusCode == 200) {
          return Users.fromJson(response.data as Map<String, dynamic>);
        } else
          return null;
      },
    );
  }
}

Map<String, Object> fakeRDVsList = {
  "totalItems": 17,
  "demandes": [
    {
      "id": 9,
      "object": "RDV3",
      "additionalInformation": "sgfdfgdfgdfg",
      "status": 0,
      "code": "0008/2021",
      "createdAt": "2021-06-25T11:56:57.082Z",
      "updatedAt": "2021-06-25T11:56:57.082Z",
      "updatedBy": {"id": 46, "firstName": "khaled", "lastName": "Cheriaa", "email": "kahled@wevioo.tn"},
      "createdBy": {
        "id": 46,
        "firstName": "khaled",
        "lastName": "Cheriaa",
        "email": "kahled@wevioo.tn",
        "tier": {
          "id": 49,
          "name": "Khaled",
          "socialReason": null,
          "profile": 0,
          "clientCode": null,
          "agent": {"id": 1, "fullName": "bilel khadhraoui", "email": "bih@wevioo.com"},
          "agency": {"id": 1, "name": "AG Tunis"}
        }
      }
    },
    {
      "id": 8,
      "object": "RDV2",
      "additionalInformation": "fgfdhfghfjhgfjg",
      "status": 0,
      "code": "0007/2021",
      "createdAt": "2021-06-25T11:56:51.844Z",
      "updatedAt": "2021-06-25T11:56:51.844Z",
      "updatedBy": {"id": 46, "firstName": "khaled", "lastName": "Cheriaa", "email": "kahled@wevioo.tn"},
      "createdBy": {
        "id": 46,
        "firstName": "khaled",
        "lastName": "Cheriaa",
        "email": "kahled@wevioo.tn",
        "tier": {
          "id": 49,
          "name": "Khaled",
          "socialReason": null,
          "profile": 0,
          "clientCode": null,
          "agent": {"id": 1, "fullName": "bilel khadhraoui", "email": "bih@wevioo.com"},
          "agency": {"id": 1, "name": "AG Tunis"}
        }
      }
    },
    {
      "id": 7,
      "object": "RDV1",
      "additionalInformation": "ddfgdfg",
      "status": 0,
      "code": "0006/2021",
      "createdAt": "2021-06-25T11:56:45.502Z",
      "updatedAt": "2021-06-25T11:56:45.502Z",
      "updatedBy": {"id": 46, "firstName": "khaled", "lastName": "Cheriaa", "email": "kahled@wevioo.tn"},
      "createdBy": {
        "id": 46,
        "firstName": "khaled",
        "lastName": "Cheriaa",
        "email": "kahled@wevioo.tn",
        "tier": {
          "id": 49,
          "name": "Khaled",
          "socialReason": null,
          "profile": 0,
          "clientCode": null,
          "agent": {"id": 1, "fullName": "bilel khadhraoui", "email": "bih@wevioo.com"},
          "agency": {"id": 1, "name": "AG Tunis"}
        }
      }
    },
    {
      "id": 9,
      "object": "RDV3",
      "additionalInformation": "sgfdfgdfgdfg",
      "status": 0,
      "code": "0008/2021",
      "createdAt": "2021-06-25T11:56:57.082Z",
      "updatedAt": "2021-06-25T11:56:57.082Z",
      "updatedBy": {"id": 46, "firstName": "khaled", "lastName": "Cheriaa", "email": "kahled@wevioo.tn"},
      "createdBy": {
        "id": 46,
        "firstName": "khaled",
        "lastName": "Cheriaa",
        "email": "kahled@wevioo.tn",
        "tier": {
          "id": 49,
          "name": "Khaled",
          "socialReason": null,
          "profile": 0,
          "clientCode": null,
          "agent": {"id": 1, "fullName": "bilel khadhraoui", "email": "bih@wevioo.com"},
          "agency": {"id": 1, "name": "AG Tunis"}
        }
      }
    },
    {
      "id": 8,
      "object": "RDV2",
      "additionalInformation": "fgfdhfghfjhgfjg",
      "status": 0,
      "code": "0007/2021",
      "createdAt": "2021-06-25T11:56:51.844Z",
      "updatedAt": "2021-06-25T11:56:51.844Z",
      "updatedBy": {"id": 46, "firstName": "khaled", "lastName": "Cheriaa", "email": "kahled@wevioo.tn"},
      "createdBy": {
        "id": 46,
        "firstName": "khaled",
        "lastName": "Cheriaa",
        "email": "kahled@wevioo.tn",
        "tier": {
          "id": 49,
          "name": "Khaled",
          "socialReason": null,
          "profile": 0,
          "clientCode": null,
          "agent": {"id": 1, "fullName": "bilel khadhraoui", "email": "bih@wevioo.com"},
          "agency": {"id": 1, "name": "AG Tunis"}
        }
      }
    },
    {
      "id": 7,
      "object": "RDV1",
      "additionalInformation": "ddfgdfg",
      "status": 0,
      "code": "0006/2021",
      "createdAt": "2021-06-25T11:56:45.502Z",
      "updatedAt": "2021-06-25T11:56:45.502Z",
      "updatedBy": {"id": 46, "firstName": "khaled", "lastName": "Cheriaa", "email": "kahled@wevioo.tn"},
      "createdBy": {
        "id": 46,
        "firstName": "khaled",
        "lastName": "Cheriaa",
        "email": "kahled@wevioo.tn",
        "tier": {
          "id": 49,
          "name": "Khaled",
          "socialReason": null,
          "profile": 0,
          "clientCode": null,
          "agent": {"id": 1, "fullName": "bilel khadhraoui", "email": "bih@wevioo.com"},
          "agency": {"id": 1, "name": "AG Tunis"}
        }
      }
    },
    {
      "id": 9,
      "object": "RDV3",
      "additionalInformation": "sgfdfgdfgdfg",
      "status": 0,
      "code": "0008/2021",
      "createdAt": "2021-06-25T11:56:57.082Z",
      "updatedAt": "2021-06-25T11:56:57.082Z",
      "updatedBy": {"id": 46, "firstName": "khaled", "lastName": "Cheriaa", "email": "kahled@wevioo.tn"},
      "createdBy": {
        "id": 46,
        "firstName": "khaled",
        "lastName": "Cheriaa",
        "email": "kahled@wevioo.tn",
        "tier": {
          "id": 49,
          "name": "Khaled",
          "socialReason": null,
          "profile": 0,
          "clientCode": null,
          "agent": {"id": 1, "fullName": "bilel khadhraoui", "email": "bih@wevioo.com"},
          "agency": {"id": 1, "name": "AG Tunis"}
        }
      }
    },
    {
      "id": 8,
      "object": "RDV2",
      "additionalInformation": "fgfdhfghfjhgfjg",
      "status": 0,
      "code": "0007/2021",
      "createdAt": "2021-06-25T11:56:51.844Z",
      "updatedAt": "2021-06-25T11:56:51.844Z",
      "updatedBy": {"id": 46, "firstName": "khaled", "lastName": "Cheriaa", "email": "kahled@wevioo.tn"},
      "createdBy": {
        "id": 46,
        "firstName": "khaled",
        "lastName": "Cheriaa",
        "email": "kahled@wevioo.tn",
        "tier": {
          "id": 49,
          "name": "Khaled",
          "socialReason": null,
          "profile": 0,
          "clientCode": null,
          "agent": {"id": 1, "fullName": "bilel khadhraoui", "email": "bih@wevioo.com"},
          "agency": {"id": 1, "name": "AG Tunis"}
        }
      }
    },
    {
      "id": 7,
      "object": "RDV1",
      "additionalInformation": "ddfgdfg",
      "status": 0,
      "code": "0006/2021",
      "createdAt": "2021-06-25T11:56:45.502Z",
      "updatedAt": "2021-06-25T11:56:45.502Z",
      "updatedBy": {"id": 46, "firstName": "khaled", "lastName": "Cheriaa", "email": "kahled@wevioo.tn"},
      "createdBy": {
        "id": 46,
        "firstName": "khaled",
        "lastName": "Cheriaa",
        "email": "kahled@wevioo.tn",
        "tier": {
          "id": 49,
          "name": "Khaled",
          "socialReason": null,
          "profile": 0,
          "clientCode": null,
          "agent": {"id": 1, "fullName": "bilel khadhraoui", "email": "bih@wevioo.com"},
          "agency": {"id": 1, "name": "AG Tunis"}
        }
      }
    },
    {
      "id": 9,
      "object": "RDV3",
      "additionalInformation": "sgfdfgdfgdfg",
      "status": 0,
      "code": "0008/2021",
      "createdAt": "2021-06-25T11:56:57.082Z",
      "updatedAt": "2021-06-25T11:56:57.082Z",
      "updatedBy": {"id": 46, "firstName": "khaled", "lastName": "Cheriaa", "email": "kahled@wevioo.tn"},
      "createdBy": {
        "id": 46,
        "firstName": "khaled",
        "lastName": "Cheriaa",
        "email": "kahled@wevioo.tn",
        "tier": {
          "id": 49,
          "name": "Khaled",
          "socialReason": null,
          "profile": 0,
          "clientCode": null,
          "agent": {"id": 1, "fullName": "bilel khadhraoui", "email": "bih@wevioo.com"},
          "agency": {"id": 1, "name": "AG Tunis"}
        }
      }
    },
    {
      "id": 8,
      "object": "RDV2",
      "additionalInformation": "fgfdhfghfjhgfjg",
      "status": 0,
      "code": "0007/2021",
      "createdAt": "2021-06-25T11:56:51.844Z",
      "updatedAt": "2021-06-25T11:56:51.844Z",
      "updatedBy": {"id": 46, "firstName": "khaled", "lastName": "Cheriaa", "email": "kahled@wevioo.tn"},
      "createdBy": {
        "id": 46,
        "firstName": "khaled",
        "lastName": "Cheriaa",
        "email": "kahled@wevioo.tn",
        "tier": {
          "id": 49,
          "name": "Khaled",
          "socialReason": null,
          "profile": 0,
          "clientCode": null,
          "agent": {"id": 1, "fullName": "bilel khadhraoui", "email": "bih@wevioo.com"},
          "agency": {"id": 1, "name": "AG Tunis"}
        }
      }
    },
    {
      "id": 7,
      "object": "RDV1",
      "additionalInformation": "ddfgdfg",
      "status": 0,
      "code": "0006/2021",
      "createdAt": "2021-06-25T11:56:45.502Z",
      "updatedAt": "2021-06-25T11:56:45.502Z",
      "updatedBy": {"id": 46, "firstName": "khaled", "lastName": "Cheriaa", "email": "kahled@wevioo.tn"},
      "createdBy": {
        "id": 46,
        "firstName": "khaled",
        "lastName": "Cheriaa",
        "email": "kahled@wevioo.tn",
        "tier": {
          "id": 49,
          "name": "Khaled",
          "socialReason": null,
          "profile": 0,
          "clientCode": null,
          "agent": {"id": 1, "fullName": "bilel khadhraoui", "email": "bih@wevioo.com"},
          "agency": {"id": 1, "name": "AG Tunis"}
        }
      }
    },
    {
      "id": 9,
      "object": "RDV3",
      "additionalInformation": "sgfdfgdfgdfg",
      "status": 0,
      "code": "0008/2021",
      "createdAt": "2021-06-25T11:56:57.082Z",
      "updatedAt": "2021-06-25T11:56:57.082Z",
      "updatedBy": {"id": 46, "firstName": "khaled", "lastName": "Cheriaa", "email": "kahled@wevioo.tn"},
      "createdBy": {
        "id": 46,
        "firstName": "khaled",
        "lastName": "Cheriaa",
        "email": "kahled@wevioo.tn",
        "tier": {
          "id": 49,
          "name": "Khaled",
          "socialReason": null,
          "profile": 0,
          "clientCode": null,
          "agent": {"id": 1, "fullName": "bilel khadhraoui", "email": "bih@wevioo.com"},
          "agency": {"id": 1, "name": "AG Tunis"}
        }
      }
    },
    {
      "id": 8,
      "object": "RDV2",
      "additionalInformation": "fgfdhfghfjhgfjg",
      "status": 0,
      "code": "0007/2021",
      "createdAt": "2021-06-25T11:56:51.844Z",
      "updatedAt": "2021-06-25T11:56:51.844Z",
      "updatedBy": {"id": 46, "firstName": "khaled", "lastName": "Cheriaa", "email": "kahled@wevioo.tn"},
      "createdBy": {
        "id": 46,
        "firstName": "khaled",
        "lastName": "Cheriaa",
        "email": "kahled@wevioo.tn",
        "tier": {
          "id": 49,
          "name": "Khaled",
          "socialReason": null,
          "profile": 0,
          "clientCode": null,
          "agent": {"id": 1, "fullName": "bilel khadhraoui", "email": "bih@wevioo.com"},
          "agency": {"id": 1, "name": "AG Tunis"}
        }
      }
    },
    {
      "id": 7,
      "object": "RDV1",
      "additionalInformation": "ddfgdfg",
      "status": 0,
      "code": "0006/2021",
      "createdAt": "2021-06-25T11:56:45.502Z",
      "updatedAt": "2021-06-25T11:56:45.502Z",
      "updatedBy": {"id": 46, "firstName": "khaled", "lastName": "Cheriaa", "email": "kahled@wevioo.tn"},
      "createdBy": {
        "id": 46,
        "firstName": "khaled",
        "lastName": "Cheriaa",
        "email": "kahled@wevioo.tn",
        "tier": {
          "id": 49,
          "name": "Khaled",
          "socialReason": null,
          "profile": 0,
          "clientCode": null,
          "agent": {"id": 1, "fullName": "bilel khadhraoui", "email": "bih@wevioo.com"},
          "agency": {"id": 1, "name": "AG Tunis"}
        }
      }
    },
    {
      "id": 9,
      "object": "RDV3",
      "additionalInformation": "sgfdfgdfgdfg",
      "status": 0,
      "code": "0008/2021",
      "createdAt": "2021-06-25T11:56:57.082Z",
      "updatedAt": "2021-06-25T11:56:57.082Z",
      "updatedBy": {"id": 46, "firstName": "khaled", "lastName": "Cheriaa", "email": "kahled@wevioo.tn"},
      "createdBy": {
        "id": 46,
        "firstName": "khaled",
        "lastName": "Cheriaa",
        "email": "kahled@wevioo.tn",
        "tier": {
          "id": 49,
          "name": "Khaled",
          "socialReason": null,
          "profile": 0,
          "clientCode": null,
          "agent": {"id": 1, "fullName": "bilel khadhraoui", "email": "bih@wevioo.com"},
          "agency": {"id": 1, "name": "AG Tunis"}
        }
      }
    },
    {
      "id": 8,
      "object": "RDV2",
      "additionalInformation": "fgfdhfghfjhgfjg",
      "status": 0,
      "code": "0007/2021",
      "createdAt": "2021-06-25T11:56:51.844Z",
      "updatedAt": "2021-06-25T11:56:51.844Z",
      "updatedBy": {"id": 46, "firstName": "khaled", "lastName": "Cheriaa", "email": "kahled@wevioo.tn"},
      "createdBy": {
        "id": 46,
        "firstName": "khaled",
        "lastName": "Cheriaa",
        "email": "kahled@wevioo.tn",
        "tier": {
          "id": 49,
          "name": "Khaled",
          "socialReason": null,
          "profile": 0,
          "clientCode": null,
          "agent": {"id": 1, "fullName": "bilel khadhraoui", "email": "bih@wevioo.com"},
          "agency": {"id": 1, "name": "AG Tunis"}
        }
      }
    },
    {
      "id": 7,
      "object": "RDV1",
      "additionalInformation": "ddfgdfg",
      "status": 0,
      "code": "0006/2021",
      "createdAt": "2021-06-25T11:56:45.502Z",
      "updatedAt": "2021-06-25T11:56:45.502Z",
      "updatedBy": {"id": 46, "firstName": "khaled", "lastName": "Cheriaa", "email": "kahled@wevioo.tn"},
      "createdBy": {
        "id": 46,
        "firstName": "khaled",
        "lastName": "Cheriaa",
        "email": "kahled@wevioo.tn",
        "tier": {
          "id": 49,
          "name": "Khaled",
          "socialReason": null,
          "profile": 0,
          "clientCode": null,
          "agent": {"id": 1, "fullName": "bilel khadhraoui", "email": "bih@wevioo.com"},
          "agency": {"id": 1, "name": "AG Tunis"}
        }
      }
    }
  ]
};

import 'dart:convert';
import 'package:dio/dio.dart';
import 'package:e_loan_mobile/Helpers/helpers.dart';
import 'package:e_loan_mobile/api/models/models.dart';
import 'package:e_loan_mobile/api/services/services.dart';
import 'package:e_loan_mobile/api/urls/app_urls.dart';
import 'package:e_loan_mobile/config/config.dart';
import 'package:e_loan_mobile/static/statics.dart';

class NotificationsService {
  Future<bool> sendNotificationsRegistrationRequirements() async {
    final body = {
      "deviceId": await UsefullMethods.getDeviceId(),
      "token": Statics.fcmToken,
      "userId": Statics.loggedUser.id,
    };

    return DioRequestsInterceptor.dio
        .put(AppUrls.notificationsRequirements, data: jsonEncode(body))
        .then((Response<dynamic> response) {
      return response?.statusCode == 200 ?? false;
    });
  }

  Future<NotificationsResponse> getNotifications({int pageNumber}) {
    final Map<String, dynamic> params = {
      'limit': AppConstants.MAX_ITEMS_PER_PAGE,
      'page': pageNumber,
    };

    if (fakeData)
      return AppConstants.falseFutrue.then(
        (value) => NotificationsResponse.fromJson(fakeNotificationsList),
      );
    else
      return DioRequestsInterceptor.dio
          .get(AppUrls.notificationsList, queryParameters: params)
          .then((Response<dynamic> response) {
        if (response != null && response.data != null && response.statusCode == 200) {
          return NotificationsResponse.fromJson(response.data as Map<String, dynamic>);
        } else
          return null;
      });
  }

  Future<bool> readNotification(int id) {
    return DioRequestsInterceptor.dio
        .put(AppUrls.readNotification(id: id.toString()))
        .then((Response<dynamic> response) {
      return response?.statusCode == 200 ?? false;
    });
  }
}

Map<String, Object> fakeNotificationsList = {
  "totalUnreaded": 33,
  "notifications": [
    {
      'id': 1,
      'status': 0,
      'type': 'financement',
      'demandeId': '5',
      'demandeNumber': '2021/001',
      'date': '2021-09-08T13:32:39.874Z',
      'readed': false,
    },
    {
      'id': 1,
      'status': 0,
      'type': 'financement',
      'demandeId': '5',
      'demandeNumber': '2021/001',
      'date': '2021-09-08T13:32:39.874Z',
      'readed': false,
    },
    {
      'id': 1,
      'status': 0,
      'type': 'financement',
      'demandeId': '5',
      'demandeNumber': '2021/001',
      'date': '2021-09-08T13:32:39.874Z',
      'readed': false,
    },
    {
      'id': 1,
      'status': 0,
      'type': 'financement',
      'demandeId': '5',
      'demandeNumber': '2021/001',
      'date': '2021-09-08T13:32:39.874Z',
      'readed': false,
    },
    {
      'id': 1,
      'status': 0,
      'type': 'financement',
      'demandeId': '5',
      'demandeNumber': '2021/001',
      'date': '2021-09-08T13:32:39.874Z',
      'readed': false,
    },
    {
      'id': 1,
      'status': 0,
      'type': 'financement',
      'demandeId': '5',
      'demandeNumber': '2021/001',
      'date': '2021-09-08T13:32:39.874Z',
      'readed': false,
    },
    {
      'id': 1,
      'status': 0,
      'type': 'financement',
      'demandeId': '5',
      'demandeNumber': '2021/001',
      'date': '2021-09-08T13:32:39.874Z',
      'readed': false,
    },
    {
      'id': 1,
      'status': 0,
      'type': 'financement',
      'demandeId': '5',
      'demandeNumber': '2021/001',
      'date': '2021-09-08T13:32:39.874Z',
      'readed': false,
    },
    {
      'id': 1,
      'status': 0,
      'type': 'financement',
      'demandeId': '5',
      'demandeNumber': '2021/001',
      'date': '2021-09-08T13:32:39.874Z',
      'readed': false,
    },
    {
      'id': 1,
      'status': 0,
      'type': 'financement',
      'demandeId': '5',
      'demandeNumber': '2021/001',
      'date': '2021-09-08T13:32:39.874Z',
      'readed': false,
    },
    {
      'id': 1,
      'status': 0,
      'type': 'financement',
      'demandeId': '5',
      'demandeNumber': '2021/001',
      'date': '2021-09-08T13:32:39.874Z',
      'readed': false,
    },
    {
      'id': 1,
      'status': 0,
      'type': 'financement',
      'demandeId': '5',
      'demandeNumber': '2021/001',
      'date': '2021-09-08T13:32:39.874Z',
      'readed': false,
    },
    {
      'id': 1,
      'status': 0,
      'type': 'cotation',
      'demandeId': '5',
      'demandeNumber': '2021/002',
      'date': '2021-09-08T13:32:39.874Z',
      'readed': false,
    },
    {
      'id': 1,
      'status': 0,
      'type': 'rdv',
      'demandeId': '5',
      'demandeNumber': '2021/002',
      'date': '2021-09-08T13:32:39.874Z',
      'readed': false,
    },
  ]
};

import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:e_loan_mobile/Helpers/requests_interceptor.dart';
import 'package:e_loan_mobile/api/models/login_model.dart';
import 'package:e_loan_mobile/api/models/models.dart';
import 'package:e_loan_mobile/api/services/services.dart';
import 'package:e_loan_mobile/api/urls/app_urls.dart';
import 'package:e_loan_mobile/config/env/tlf_environnments.dart';
import 'package:e_loan_mobile/static/statics.dart';
import 'package:flutter/foundation.dart';

class LoginService {
  final NotificationsService _notificationsService = NotificationsService();
  Future<bool> signIn({
    @required String email,
    @required String password,
  }) {
    final Codec<String, String> stringToBase64 = utf8.fuse(base64);
    final body = TLFEnvrionnments.debugModeEnabled
        ? {
            'email': TLFEnvrionnments.email,
            'password': TLFEnvrionnments.password,
          }
        : {
            'email': email.trim().toLowerCase(),
            'password': stringToBase64.encode(password.trim()),
          };

    return DioRequestsInterceptor.dio
        .post(AppUrls.login, data: jsonEncode(body))
        .then((Response<dynamic> response) {
      if (response != null &&
          response.data != null &&
          response.statusCode == 200) {
        final loginResponse =
            LoginModel.fromJson(response.data as Map<String, dynamic>);

        Statics.saveLoggedUserToken(
          accessT: loginResponse.accessToken,
          refreshT: loginResponse.refreshToken,
        );
        Statics.isAdmin = loginResponse.user.isAdmin;
        Statics.loggedUser =
            UserModel.fromJson(response.data["user"] as Map<String, dynamic>);
        _notificationsService.sendNotificationsRegistrationRequirements();
        return true;
      } else
        return false;
    });
  }
}

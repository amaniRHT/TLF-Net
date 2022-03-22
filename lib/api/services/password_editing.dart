import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:e_loan_mobile/Helpers/requests_interceptor.dart';
import 'package:e_loan_mobile/api/urls/app_urls.dart';
import 'package:flutter/foundation.dart';

class PasswordEditingService {
  Future<bool> editPassword(
      {@required String oldPassword,
      @required String password,
      @required String confirmationPassword}) {
    final Codec<String, String> stringToBase64 = utf8.fuse(base64);

    final body = {
      'currentPassword': stringToBase64.encode(oldPassword.trim()),
      'password': stringToBase64.encode(password.trim()),
      'confirmPassword': stringToBase64.encode(confirmationPassword.trim())
    };
    return DioRequestsInterceptor.dio
        .post(AppUrls.editPassword, data: jsonEncode(body))
        .then((Response<dynamic> response) {
      if (response != null &&
          response.data != null &&
          response.statusCode == 200) {
        return true;
      } else
        return false;
    });
  }
}

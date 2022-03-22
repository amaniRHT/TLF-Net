import 'dart:convert';
import 'package:dio/dio.dart';
import 'package:e_loan_mobile/Helpers/requests_interceptor.dart';
import 'package:e_loan_mobile/api/urls/app_urls.dart';
import 'package:flutter/cupertino.dart';

class PasswordResetService {
  Future<bool> forgotPassword({@required String email}) {
    final body = {
      'email': email.trim(),
      'isMobile': true,
    };

    return DioRequestsInterceptor.dio.post(AppUrls.forgotPassword, data: jsonEncode(body)).then((Response<dynamic> response) {
      return response != null && response.data != null && response.statusCode == 200;
    });
  }

  Future<bool> checkResetCode({@required String resetCode}) {
    final body = {
      'mobileToken': resetCode,
    };

    return DioRequestsInterceptor.dio.post(AppUrls.checkResetCode, data: jsonEncode(body)).then((Response<dynamic> response) {
      return response != null && response.data != null && response.statusCode == 200;
    });
  }

  Future<bool> resetPassword({
    @required String password,
    @required String resetCode,
  }) {
    final body = {
      'password': password.trim(),
      'confirmPassword': password.trim(),
      'mobileToken': resetCode,
    };

    return DioRequestsInterceptor.dio.post(AppUrls.resetPassword, data: jsonEncode(body)).then((Response<dynamic> response) {
      return response != null && response.data != null && response.statusCode == 200;
    });
  }
}

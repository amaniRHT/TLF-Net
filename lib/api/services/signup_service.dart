import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:e_loan_mobile/Helpers/requests_interceptor.dart';
import 'package:e_loan_mobile/api/models/models.dart';
import 'package:e_loan_mobile/api/urls/app_urls.dart';
import 'package:e_loan_mobile/config/config.dart';
import 'package:e_loan_mobile/static/statics.dart';
import 'package:flutter/foundation.dart';
import 'package:get/get_utils/get_utils.dart';
import 'package:get_storage/get_storage.dart';

class SignupService {
  Future<bool> createAccout({
    @required String legalForm,
    @required String legalFirstname,
    @required String legalLastName,
    @required String tradeName,
    @required String socialReason,
    //  @required String activityArea,
    @required String activity,
    @required String entryDate,
    @required String identityNature,
    @required String cin,
    @required String residencePermit,
    @required String rne,
    @required String clientCode,
    @required String contractCode,
    @required String street,
    @required String postalCode,
    @required String locality,
    @required String governorate,
    @required String firstname,
    @required String lastName,
    @required String job,
    @required String phone,
    @required String mobilePhone,
    @required String gender,
    @required String email,
    @required String type,
  }) {
    final activityAreaObject = AppConstants.activityAreasFullList
        .firstWhere((o) => o.label == activity, orElse: () => null);
    ;
    final body = {
      'legalForm': legalForm,
      if (legalFirstname != null && legalFirstname.isNotEmpty)
        'firstName': legalFirstname.trim(),
      if (legalLastName != null && legalLastName.isNotEmpty)
        'lastName': legalLastName.trim(),
      if (tradeName != null && tradeName.isNotEmpty)
        'agentName': tradeName.trim(),
      'socialReason': (socialReason != null && socialReason.isNotEmpty)
          ? socialReason.trim()
          : 'Raison sociale fictive',
      'activityArea': activityAreaObject.activityArea,
      'label': activityAreaObject.label,
      // 'activityArea': (activityArea != null && activityArea.isNotEmpty)
      //     ? activityArea
      //     : activityAreaObject.activityArea,
      'activity': activityAreaObject.activity,
      'dateEntry': entryDate,
      if (identityNature != null && identityNature.isNotEmpty)
        'identityNature': identityNature,
      if (cin != null && cin.isNotEmpty) 'cin': cin,
      if (residencePermit != null && residencePermit.isNotEmpty)
        'carteSejour': residencePermit,
      if (rne != null && rne.isNotEmpty) 'rne': rne,
      if (clientCode != null && clientCode.isNotEmpty) 'clientCode': clientCode,
      if (contractCode != null && contractCode.isNotEmpty)
        'contractCode': contractCode,
      'isClient': (clientCode != null && clientCode.isNotEmpty) ||
              (contractCode != null && contractCode.isNotEmpty)
          ? 'true'
          : false,
      'street': street.trim(),
      'postalCode': postalCode,
      'local': locality,
      'governorate': governorate,
      if (type != null && type.isNotEmpty) 'type': type,
      'users': [
        {
          'firstName': firstname.trim(),
          'lastName': lastName.trim(),
          'job': job,
          'phone': phone.removeAllWhitespace,
          if (mobilePhone != null && mobilePhone.isNotEmpty)
            'mobilePhone': mobilePhone.removeAllWhitespace,
          'gender': gender,
          'email': email.trim().toLowerCase(),
        },
      ],
    };
    return DioRequestsInterceptor.dio
        .post(AppUrls.signup, data: jsonEncode(body))
        .then((Response<dynamic> response) {
      if (response != null &&
          response.data != null &&
          response.statusCode == 201) {
        final box = GetStorage();
        box.write('TLFCookies', "tlfnet2030");
        Statics.accessToken =
            PreCreatedUserToken.fromJson(response.data as Map<String, dynamic>)
                ?.token;
        return Statics.accessToken != null;
      } else
        return false;
    });
  }

  Future<bool> setupPassword({@required String password}) {
    final body = {
      'password': password.trim(),
      'confirmPassword': password.trim(),
      'token': Statics.accessToken,
    };
    return DioRequestsInterceptor.dio
        .post(AppUrls.setupPassword, data: jsonEncode(body))
        .then((Response<dynamic> response) {
      return response != null &&
          response.data != null &&
          response.statusCode == 201;
    });
  }
}

// import 'dart:convert';
// import 'package:dio/dio.dart';
// import 'package:e_loan_mobile/Helpers/requests_interceptor.dart';
// import 'package:e_loan_mobile/api/models/models.dart';
// import 'package:e_loan_mobile/api/models/user_model.dart';
// import 'package:e_loan_mobile/api/urls/app_urls.dart';
// import 'package:e_loan_mobile/static/statics.dart';
// import 'package:flutter/foundation.dart';
// import 'package:get/get_utils/get_utils.dart';

// class ProfileService {
//   Future<bool> getUserProfile() {
//     return DioRequestsInterceptor.dio.get(AppUrls.getUserProfile).then((
//       Response<dynamic> response,
//     ) {
//       if (response != null &&
//           response.data != null &&
//           response.statusCode == 200) {
//         Statics.loggedUser =
//             UserModel.fromJson(response.data as Map<String, dynamic>);
//         return true;
//       } else
//         return false;
//     });
//   }

//   Future<bool> updateProfile({
//     @required String legalForm,
//     @required String legalFirstname,
//     @required String legalLastName,
//     @required String tradeName,
//     @required String socialReason,
//     @required String activityArea,
//     @required String entryDate,
//     @required String identityNature,
//     @required String cin,
//     @required String residencePermit,
//     @required String rne,
//     @required String clientCode,
//     @required String contractCode,
//     @required String street,
//     @required String postalCode,
//     @required String locality,
//     @required String governorate,
//     @required String firstname,
//     @required String lastName,
//     @required String job,
//     @required String phone,
//     @required String mobilePhone,
//     @required String gender,
//     @required String email,
//   }) {
//     final body = {
//       'legalForm': legalForm,
//       if (legalFirstname != null && legalFirstname.isNotEmpty)
//         'firstName': legalFirstname,
//       if (legalLastName != null && legalLastName.isNotEmpty)
//         'lastName': legalLastName,
//       if (tradeName != null && tradeName.isNotEmpty) 'agentName': tradeName,
//       'socialReason': (socialReason != null && socialReason.isNotEmpty)
//           ? socialReason
//           : 'Raison sociale fictive',
//       'activityArea': activityArea,
//       'dateEntry': entryDate,
//       if (identityNature != null && identityNature.isNotEmpty)
//         'identityNature': identityNature,
//       if (cin != null && cin.isNotEmpty) 'cin': cin,
//       if (residencePermit != null && residencePermit.isNotEmpty)
//         'carteSejour': residencePermit,
//       if (rne != null && rne.isNotEmpty) 'rne': rne,
//       if (clientCode != null && clientCode.isNotEmpty) 'clientCode': clientCode,
//       if (contractCode != null && contractCode.isNotEmpty)
//         'contractCode': contractCode,
//       'street': street,
//       'postalCode': postalCode,
//       'local': locality,
//       'governorate': governorate,
//       'users': [
//         {
//           'firstName': firstname,
//           'lastName': lastName,
//           'job': job,
//           'phone': phone.removeAllWhitespace,
//           if (mobilePhone != null && mobilePhone.isNotEmpty)
//             'mobilePhone': mobilePhone.removeAllWhitespace,
//           'gender': gender,
//           'email': email,
//         },
//       ],
//     };
//     return DioRequestsInterceptor.dio
//         .put(
//       AppUrls.updateMyProfile(id: Statics.loggedUser?.id?.toString() ?? ''),
//       data: jsonEncode(body),
//     )
//         .then((
//       Response<dynamic> response,
//     ) {
//       if (response != null &&
//           response.data != null &&
//           response.statusCode == 200) {
//         Statics.loggedUser =
//             UserModel.fromJson(response.data as Map<String, dynamic>);
//         return true;
//       } else
//         return false;
//     });
//   }
// }
import 'dart:convert';
import 'package:dio/dio.dart';
import 'package:e_loan_mobile/Helpers/requests_interceptor.dart';
import 'package:e_loan_mobile/api/models/models.dart';
import 'package:e_loan_mobile/api/models/user_model.dart';
import 'package:e_loan_mobile/api/urls/app_urls.dart';
import 'package:e_loan_mobile/static/statics.dart';
import 'package:flutter/foundation.dart';
import 'package:get/get_utils/get_utils.dart';

class ProfileService {
  Future<UserModel> getUserProfile() {
    return DioRequestsInterceptor.dio.get(AppUrls.getUserProfile).then((
      Response<dynamic> response,
    ) {
      if (response != null && response.data != null && response.statusCode == 200) {
        Statics.loggedUser = UserModel.fromJson(response.data as Map<String, dynamic>);
        return Statics.loggedUser;
      } else
        return null;
    });
  }

  Future<bool> updateProfile({
    @required String firstname,
    @required String lastName,
    @required String job,
    @required String phone,
    @required String mobilePhone,
    @required String gender,
    @required String email,
  }) {
    final body = {
      'firstName': firstname.trim(),
      'lastName': lastName.trim(),
      'job': job,
      'phone': phone.removeAllWhitespace,
      if (mobilePhone != null && mobilePhone.isNotEmpty) 'mobilePhone': mobilePhone.removeAllWhitespace,
      'gender': gender,
      'email': email.trim(),
      'status': 1,
      'isAdmin': true,
    };
    return DioRequestsInterceptor.dio
        .put(AppUrls.updateMyProfile(id: Statics.loggedUser?.id?.toString() ?? ''), data: jsonEncode(body))
        .then((Response<dynamic> response) {
      if (response != null && response.data != null && response.statusCode == 200) {
        Statics.loggedUser = UserModel.fromJson(response.data as Map<String, dynamic>);
        return true;
      } else
        return false;
    });
  }
}

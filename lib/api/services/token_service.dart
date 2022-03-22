import 'dart:convert';
import 'dart:typed_data';

import 'package:dio/dio.dart';
import 'package:e_loan_mobile/api/models/login_model.dart';
import 'package:e_loan_mobile/api/models/models.dart';
import 'package:e_loan_mobile/api/urls/app_urls.dart';
import 'package:e_loan_mobile/app/core/notifications/notifications_list_page.dart';
import 'package:e_loan_mobile/app/core/profile/profile_page.dart';
import 'package:e_loan_mobile/config/env/tlf_environnments.dart';
import 'package:e_loan_mobile/routes/app_bindings.dart';
import 'package:e_loan_mobile/routes/app_routes.dart';
import 'package:e_loan_mobile/static/statics.dart';
import 'package:e_loan_mobile/widgets/menu.dart';
import 'package:get/get.dart';

class TokenService {
  Future<bool> refreshTokens() {
    var dio = Dio();

    final body = {
      'refreshToken': Statics.refreshToken,
    };
    return dio
        .post(
      TLFEnvrionnments.baseUrl + AppUrls.rokenRefresh,
      data: jsonEncode(body),
    )
        .then((response) {
      if (response != null &&
          response.data != null &&
          response.statusCode == 201) {
        final loginResponse =
            LoginModel.fromJson(response.data as Map<String, dynamic>);
        Statics.refreshSessionTokens(
          accessT: loginResponse.accessToken,
          refreshT: loginResponse.refreshToken,
        );
        Uint8List decodedFirstName =
            base64.decode(loginResponse.user.firstName);
        Uint8List decodedLastName = base64.decode(loginResponse.user.lastName);
        String firstName = utf8.decode(decodedFirstName);
        String lastName = utf8.decode(decodedLastName);

        final MenuController menuController = Get.find<MenuController>();
        menuController.firstname.value = firstName.capitalizeFirst;
        menuController.lastname.value = lastName.capitalizeFirst;
        return true;
      } else {
        Future.delayed(Duration.zero, () async {
          Get.offAllNamed(AppRoutes.login);
        });
        return false;
      }
    }).catchError((error) {
      Future.delayed(Duration.zero, () async {
        Get.offAllNamed(AppRoutes.login);
      });
    });
  }

  void refreshTokensTesting() {
    Get.offAllNamed(AppRoutes.login);
  }

  void refreshCurrentRoute() {
    if (Get.currentRoute == AppRoutes.profilePage) {
      Get.offAll(
        () => ProfilePage(),
        binding: ProfilePageBindings(),
        transition: Transition.upToDown,
      );
    }
    if (Get.currentRoute == AppRoutes.notificationsPage) {
      Get.offAll(
        () => NotificationsListPage(),
        transition: Transition.upToDown,
      );
    } else {
      Future.delayed(Duration.zero, () async {
        await Get.offAllNamed(Get.currentRoute);
      });
    }
  }
}

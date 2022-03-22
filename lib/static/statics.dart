import 'package:e_loan_mobile/api/models/user_model.dart';
import 'package:flutter/foundation.dart';

class Statics {
  Statics._();

  static String accessToken;
  static String refreshToken;
  static UserModel loggedUser;
  static bool isLoggedIn = false;
  static bool isAdmin = false;
  static String fcmToken;

  static void eraseLoggedUserInformations() {
    accessToken = null;
    refreshToken = null;
    loggedUser = null;
    isLoggedIn = false;
    isAdmin = false;
    fcmToken = null;
  }

  static void saveLoggedUserToken({
    @required String accessT,
    @required String refreshT,
  }) {
    accessToken = accessT;
    refreshToken = refreshT;
    isLoggedIn = true;
  }

  static void refreshSessionTokens({
    @required String accessT,
    @required String refreshT,
  }) {
    accessToken = accessT;
    refreshToken = refreshT;
  }
}

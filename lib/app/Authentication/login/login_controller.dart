import 'package:e_loan_mobile/Helpers/base_controller.dart';
import 'package:e_loan_mobile/api/models/enums.dart';
import 'package:e_loan_mobile/api/services/login_service.dart';
import 'package:e_loan_mobile/api/services/services.dart';
import 'package:e_loan_mobile/routes/app_routes.dart';
import 'package:e_loan_mobile/static/statics.dart';
import 'package:e_loan_mobile/widgets/custom_toast.dart';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';

class LoginController extends BaseController {
  final LoginService _service = LoginService();

  TextEditingController emailTEC = TextEditingController();
  TextEditingController passwordTEC = TextEditingController();

  final FocusNode emailFocusNode = FocusNode();
  final FocusNode passwordFocusNode = FocusNode();

  int numberOfTaps = 0;

  int selectedTab = 0;

  String email = '';
  String password = '';
  bool passwordIsHidden = true;

  Answers isEmployee = Answers.no;
  bool isConfirmedEmployee = false;

  void signIn() {
    if (fakeData) {
      Statics.isLoggedIn = true;
      Get.offAllNamed(AppRoutes.home);
      return;
    }

    _service.signIn(email: emailTEC.text, password: passwordTEC.text).then(
      (bool success) {
        if (success) {
          Get.offAllNamed(AppRoutes.home);
        } else {
          showCustomToast(
            toastType: ToastTypes.error,
            contentText: 'La connexion a échoué, vérifiez vos paramètres',
            onTheTop: false,
          );
        }
      },
    );
  }
}

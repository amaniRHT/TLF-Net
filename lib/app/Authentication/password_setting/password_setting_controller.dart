import 'package:e_loan_mobile/Helpers/base_controller.dart';
import 'package:e_loan_mobile/api/services/password_reset_service.dart';
import 'package:e_loan_mobile/api/services/services.dart';
import 'package:e_loan_mobile/api/services/signup_service.dart';
import 'package:e_loan_mobile/routes/routing.dart';
import 'package:e_loan_mobile/widgets/custom_toast.dart';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';

class PasswordSettingController extends BaseController {
  final SignupService _signupService = SignupService();
  final PasswordResetService _passwordResetService = PasswordResetService();

  TextEditingController passwordTEC = TextEditingController();
  TextEditingController confirmationTEC = TextEditingController();

  final FocusNode passwordFocusNode = FocusNode();
  final FocusNode confirmationFocusNode = FocusNode();

  bool passwordIsHidden = true;
  bool confimationIsHidden = true;

  bool passwordSettledSuccessfully = false;

  void setPassword() {
    if (fakeData) {
      Get.offAllNamed(AppRoutes.login);
      return;
    }
    _signupService.setupPassword(password: passwordTEC.text).then(
      (bool success) async {
        if (success) {
          passwordSettledSuccessfully = true;
          update();
          await showCustomToast(
            duration: 2,
            contentText: 'Votre mot de passe a bien été défini',
            onTheTop: false,
          );
          Get.offAllNamed(AppRoutes.login);
        } else
          showCustomToast(
            toastType: ToastTypes.error,
            contentText: 'La définition du mot de passe a échoué',
            onTheTop: false,
          );
      },
    );
  }

  void resetPassword({@required String resetCode}) {
    if (fakeData) {
      Get.offAllNamed(AppRoutes.login);
      return;
    }
    _passwordResetService.resetPassword(password: passwordTEC.text, resetCode: resetCode).then(
      (bool success) async {
        if (success) {
          passwordSettledSuccessfully = true;
          update();
          await showCustomToast(
            duration: 2,
            contentText: 'Votre mot de passe a été modifié avec succès',
            onTheTop: false,
          );
          Get.offAllNamed(AppRoutes.login);
        } else
          showCustomToast(
            toastType: ToastTypes.error,
            contentText: 'La définition du mot de passe a échoué',
            onTheTop: false,
          );
      },
    );
  }
}

import 'package:e_loan_mobile/Helpers/base_controller.dart';
import 'package:e_loan_mobile/api/services/services.dart';
import 'package:e_loan_mobile/routes/app_routes.dart';
import 'package:e_loan_mobile/widgets/custom_toast.dart';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';

class PasswordEditingController extends BaseController {
  final PasswordEditingService _editPasswordService = PasswordEditingService();

  TextEditingController oldPasswordTEC = TextEditingController();
  TextEditingController passwordTEC = TextEditingController();
  TextEditingController confirmationTEC = TextEditingController();

  final FocusNode oldPasswordFocusNode = FocusNode();
  final FocusNode passwordFocusNode = FocusNode();
  final FocusNode confirmationFocusNode = FocusNode();

  bool oldPasswordIsHidden = true;
  bool passwordIsHidden = true;
  bool confimationIsHidden = true;

  bool passwordSettledSuccessfully = false;

  void setPassword() {
    if (fakeData) {
      Get.offAllNamed(AppRoutes.login);
      return;
    }
    _editPasswordService
        .editPassword(
            oldPassword: oldPasswordTEC.text,
            password: passwordTEC.text,
            confirmationPassword: confirmationTEC.text)
        .then(
      (bool success) async {
        if (success) {
          passwordSettledSuccessfully = true;
          update();
          await showCustomToast(
            duration: 2,
            contentText: 'Votre mot de passe a bien été modifié ',
            onTheTop: false,
          );
          Get.offAllNamed(AppRoutes.login);
        } else
          showCustomToast(
            toastType: ToastTypes.error,
            contentText: 'La modification'
                ' du mot de passe a échoué',
            onTheTop: false,
          );
      },
    );
  }
}

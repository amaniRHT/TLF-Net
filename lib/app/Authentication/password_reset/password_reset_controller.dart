import 'package:e_loan_mobile/Helpers/base_controller.dart';
import 'package:e_loan_mobile/api/services/password_reset_service.dart';
import 'package:e_loan_mobile/api/services/services.dart';
import 'package:e_loan_mobile/routes/app_routes.dart';
import 'package:e_loan_mobile/widgets/custom_toast.dart';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';

class PasswordResetController extends BaseController {
  final PasswordResetService _service = PasswordResetService();

  TextEditingController emailTEC = TextEditingController();

  void forgotPassword() {
    if (fakeData) {
      Get.toNamed(AppRoutes.codeVerification);
      return;
    }
    _service.forgotPassword(email: emailTEC.text).then(
      (bool success) {
        if (success) {
          showCustomToast(
            showAfterInMilliseconds: 300,
            contentText: 'Lien de réinitialisation envoyé avec succès.\nVérifier votre boîte de réception',
            onTheTop: false,
            blurEffectEnabled: false,
          );
          Get.toNamed(AppRoutes.codeVerification);
        } else
          showCustomToast(
            toastType: ToastTypes.error,
            contentText: "L'adresse email renseignée ne correspond à aucun utilisateur, veuillez revérifier la saisie",
            onTheTop: false,
          );
      },
    );
  }
}

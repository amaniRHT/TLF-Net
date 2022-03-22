import 'package:e_loan_mobile/Helpers/base_controller.dart';
import 'package:e_loan_mobile/api/services/password_reset_service.dart';
import 'package:e_loan_mobile/api/services/services.dart';
import 'package:e_loan_mobile/routes/app_routes.dart';
import 'package:e_loan_mobile/widgets/custom_toast.dart';
import 'package:get/get.dart';

class VerificationController extends BaseController {
  final PasswordResetService _service = PasswordResetService();

  String resetCode = '';

  void checkResetCode() {
    if (fakeData) {
      Get.offAllNamed(
        AppRoutes.passwordSetting,
        arguments: resetCode,
      );
      return;
    }
    _service.checkResetCode(resetCode: resetCode).then(
      (bool success) async {
        if (success) {
          showCustomToast(
            showAfterInMilliseconds: 300,
            contentText: 'Votre code est valide, vous pouvez maintenant redéfinir votre mot de passe',
            onTheTop: false,
            blurEffectEnabled: false,
          );
          Get.offAllNamed(
            AppRoutes.passwordSetting,
            arguments: resetCode,
          );
        } else
          showCustomToast(
            toastType: ToastTypes.error,
            contentText: 'Le code de vérification saisi est invalide',
            onTheTop: false,
          );
      },
    );
  }
}

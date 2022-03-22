import 'package:e_loan_mobile/api/models/enums.dart';
import 'package:e_loan_mobile/api/models/models.dart';
import 'package:e_loan_mobile/api/services/services.dart';
import 'package:e_loan_mobile/app/common_controller.dart';
import 'package:e_loan_mobile/routes/routing.dart';
import 'package:e_loan_mobile/widgets/widgets.dart';
import 'package:get/get.dart';

class UserCreationController extends CommonController {
  final UsersService _usersService = UsersService();
  bool creationMode = false;
  Users currentUserAccount = Users();

  void getUserDetails(int userId) {
    _usersService.getUserDetails(userId: userId).then((Users user) {
      if (user != null) {
        currentUserAccount = user;
        fillFieldsWithUserDetails();
      }
    });
  }

  void fillFieldsWithUserDetails() {
    if (currentUserAccount == null) return;

    firstnameTEC.text = currentUserAccount.firstName;
    lastnameTEC.text = currentUserAccount.lastName;
    functionTEC.text = currentUserAccount.job;
    function = currentUserAccount.job;
    phoneTEC.text = currentUserAccount.phone;
    mobileTEC.text = currentUserAccount.mobilePhone;
    emailTEC.text = currentUserAccount.email;
    isMale = currentUserAccount.gender == 'Mr' ? Gender.male : Gender.female;

    update();
  }

  void createUserAccount() {
    final UserParameters userParameters = UserParameters(
      gender: isMale == Gender.male ? 'Mr' : 'Mme',
      firstName: firstnameTEC.text,
      lastName: lastnameTEC.text,
      job: functionTEC.text,
      phone: phoneTEC.text.removeAllWhitespace,
      mobilePhone: mobileTEC.text.removeAllWhitespace,
      email: emailTEC.text,
    );
    _usersService.createUserAccount(userParameters: userParameters).then(
      (bool success) {
        if (success) {
          showCustomToast(
            showAfterInMilliseconds: 300,
            contentText: "L'utilisateur a été enregistré avec succès",
            onTheTop: false,
            blurEffectEnabled: false,
            padding: 80,
          );
          Get.offAllNamed(AppRoutes.usersList);
        } else {
          showCustomToast(
            toastType: ToastTypes.error,
            contentText: "La création du l'utilisateur a échoué",
            onTheTop: false,
            blurEffectEnabled: false,
          );
        }
        update();
      },
    );
  }

  void updateUserAccount() {
    final UserParameters userParameters = UserParameters(
      gender: isMale == Gender.male ? 'Mr' : 'Mme',
      firstName: firstnameTEC.text,
      lastName: lastnameTEC.text,
      job: functionTEC.text,
      phone: phoneTEC.text,
      mobilePhone: mobileTEC.text,
      email: emailTEC.text,
      status: currentUserAccount.status,
    );
    _usersService.updateUserAccount(userId: currentUserAccount.id, userParameters: userParameters).then(
      (bool success) {
        if (success) {
          Get.offAllNamed(AppRoutes.usersList);
          showCustomToast(
            showAfterInMilliseconds: 300,
            contentText: "L'utilisateur a été mis à jour avec succès",
            onTheTop: false,
            blurEffectEnabled: false,
          );
        } else {
          showCustomToast(
            toastType: ToastTypes.error,
            contentText: "La mise à jour de l'utilisateur a échoué",
            onTheTop: false,
            blurEffectEnabled: false,
          );
        }
        update();
      },
    );
  }
}

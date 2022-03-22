import 'package:e_loan_mobile/api/models/models.dart';
import 'package:e_loan_mobile/app/common_controller.dart';

class UserDetailsController extends CommonController {
  Users currentUserAccount = Users();

  void fillFieldsWithUserDetails() {
    if (currentUserAccount == null) return;

    firstnameTEC.text = currentUserAccount.firstName;
    lastnameTEC.text = currentUserAccount.lastName;
    functionTEC.text = currentUserAccount.job;
    function = currentUserAccount.job;
    phoneTEC.text = currentUserAccount.phone;
    mobileTEC.text = currentUserAccount.mobilePhone;
    emailTEC.text = currentUserAccount.email;

    update();
  }
}

import 'package:e_loan_mobile/api/models/enums.dart';
import 'package:e_loan_mobile/api/services/services.dart';
import 'package:e_loan_mobile/app/common_controller.dart';
import 'package:e_loan_mobile/routes/app_routes.dart';
import 'package:e_loan_mobile/widgets/widgets.dart';
import 'package:get/get.dart';

class SignupController extends CommonController {
  final SignupService _service = SignupService();

  void createAccout() {
    _service
        .createAccout(
      legalForm: legalFormTEC.text.toLowerCase() == 'personne'
          ? 'personne'
          : 'company',
      legalFirstname: leaglFirstnameTEC.text,
      legalLastName: legalLastnameTEC.text,
      tradeName: tradeNameTEC.text,
      socialReason: socialReasonTEC.text,
      // activityArea: otherActivity ? activityTEC.text : null,
      // activity: otherActivity
      //     ? AppConstants.activityAreasFullList.last.label
      //     : activityAreaTEC.text,
      activity: activityAreaTEC.text,
      entryDate: iso8601EntryDate,
      identityNature: identityNatue == Identity.cin ? 'cin' : 'Carte séjour',
      cin: cinTEC.text,
      residencePermit: residencePermitTEC.text,
      rne: rneTEC.text,
      clientCode: clientCodeTEC.text.isNotEmpty ? clientCodeTEC.text : null,
      contractCode:
          contractCodeTEC.text.isNotEmpty ? contractCodeTEC.text : null,
      // clientCode: clientCodeTEC.text.isNotEmpty
      //     ? clientCodeTEC.text.padLeft(6, '0')
      //     : null,
      // contractCode: contractCodeTEC.text.isNotEmpty
      //     ? contractCodeTEC.text.padLeft(6, '0')
      //     : null,
      street: streetTEC.text,
      postalCode: postalCodeTEC.text,
      locality: localityTEC.text,
      governorate: governorateTEC.text,
      firstname: firstnameTEC.text,
      lastName: lastnameTEC.text,
      job: functionTEC.text,
      phone: phoneTEC.text,
      mobilePhone: mobileTEC.text,
      gender: isMale == Gender.male ? 'm' : 'f',
      email: emailTEC.text,
      type: typeTEC.text,
    )
        .then(
      (bool success) {
        if (success) {
          showCustomToast(
            showAfterInMilliseconds: 300,
            contentText: 'Félicitation, votre compte a été créé avec succès',
            blurEffectEnabled: false,
            padding: 70,
          );

          Get.offAllNamed(AppRoutes.passwordSetting);
        } else
          showCustomToast(
            toastType: ToastTypes.error,
            contentText: 'La création du compte a échoué',
          );
      },
    );
  }
}

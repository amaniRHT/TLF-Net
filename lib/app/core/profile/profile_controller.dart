import 'package:e_loan_mobile/Helpers/usefull_metods.dart';
import 'package:e_loan_mobile/api/models/enums.dart';
import 'package:e_loan_mobile/api/models/models.dart';
import 'package:e_loan_mobile/api/services/profile_service.dart';
import 'package:e_loan_mobile/app/common_controller.dart';
import 'package:e_loan_mobile/static/statics.dart';
import 'package:e_loan_mobile/widgets/widgets.dart';

class ProfileController extends CommonController {
  final ProfileService _profileService = ProfileService();

  int selectedTab = 0;
  bool editionMode = false;
  bool identifiedByCIN = true;
  bool isClientAlready = false;

  void initialiseProfile() {
    _profileService.getUserProfile().then(
      (UserModel user) {
        if (user != null) {
          // 1st Tab
          firstnameTEC.text = Statics.loggedUser?.firstName ?? '';
          lastnameTEC.text = Statics.loggedUser?.lastName ?? '';
          functionTEC.text = Statics.loggedUser?.job ?? '';
          function = functionTEC.text;
          phoneTEC.text = Statics.loggedUser?.phone ?? '';
          mobileTEC.text = Statics.loggedUser?.mobilePhone ?? '';
          emailTEC.text = Statics.loggedUser?.email ?? '';
          isMale =
              (Statics.loggedUser?.gender == 'm') ? Gender.male : Gender.female;
          isPerson =
              Statics.loggedUser?.tier?.legalForm?.toLowerCase() == 'personne';
          isSociety = !isPerson;
          update();

          // 2nd Tab
          legalFormTEC.text =
              Statics.loggedUser?.tier?.legalForm?.toLowerCase() == 'personne'
                  ? 'Personne'
                  : 'Société';
          leaglFirstnameTEC.text = Statics.loggedUser?.tier?.firstname ?? '';
          legalLastnameTEC.text = Statics.loggedUser?.tier?.lastname ?? '';
          tradeNameTEC.text = Statics.loggedUser?.tier?.tradeName ?? '';
          residencePermitTEC.text =
              Statics.loggedUser?.tier?.residencePermit ?? '';
          cinTEC.text = Statics.loggedUser?.tier?.cin ?? '';
          identifiedByCIN = Statics.loggedUser?.tier?.identityNature == 'cin';
          socialReasonTEC.text = Statics.loggedUser?.tier?.socialReason ?? '';
          activityAreaTEC.text = Statics.loggedUser?.tier?.label ?? '';
          entryDateTEC.text =
              Statics.loggedUser?.tier?.dateEntry?.isNotEmpty ?? false
                  ? UsefullMethods.dateFormat.format(
                      DateTime.parse(
                          Statics.loggedUser?.tier?.dateEntry.substring(0, 10)),
                    )
                  : '';

          typeTEC.text = Statics.loggedUser?.tier?.type ?? '';
          rneTEC.text = Statics.loggedUser?.tier?.rne ?? '';
          clientCodeTEC.text = Statics.loggedUser?.tier?.clientCode ?? '';
          contractCodeTEC.text = Statics.loggedUser?.tier?.contractCode ?? '';
          isClientAlready = Statics.loggedUser?.tier?.clientCode?.isNotEmpty;

          // 3rd Tab
          streetTEC.text = Statics.loggedUser?.tier?.street ?? '';
          postalCodeTEC.text = Statics.loggedUser?.tier?.postalCode ?? '';
          localityTEC.text = Statics.loggedUser?.tier?.local ?? '';
          governorateTEC.text = Statics.loggedUser?.tier?.governorate ?? '';
        }
      },
    );
  }

  void updateProfile() {
    _profileService
        .updateProfile(
      firstname: firstnameTEC.text,
      lastName: lastnameTEC.text,
      job: functionTEC.text,
      phone: phoneTEC.text,
      mobilePhone: mobileTEC.text,
      gender: isMale == Gender.male ? 'm' : 'f',
      email: emailTEC.text,
    )
        .then(
      (bool success) {
        if (success) {
          showCustomToast(
            contentText: 'Votre profil a été mis à jour avec succès',
            blurEffectEnabled: false,
            padding: 20,
            onTheTop: false,
          );
          editionMode = false;
        } else {
          showCustomToast(
            toastType: ToastTypes.error,
            contentText: 'La mise à jour du profil a échoué',
          );
        }
        update();
      },
    );
  }
}

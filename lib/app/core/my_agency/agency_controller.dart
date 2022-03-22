import 'package:e_loan_mobile/Helpers/base_controller.dart';
import 'package:e_loan_mobile/api/models/user_model.dart';
import 'package:e_loan_mobile/api/services/profile_service.dart';

class AgencyController extends BaseController {
  final ProfileService _profileService = ProfileService();

  AgencyModel myAgency = AgencyModel();
  void fillFieldsWithAgencyDetails() {
    _profileService.getUserProfile().then(
      (UserModel user) {
        if (user != null) {
          myAgency = AgencyModel(
            name: user.tier?.agency?.name ?? '',
            address: user.tier?.agency?.address ?? '',
            contactName: user.tier?.agent?.fullName ?? '',
            phone: user.tier?.agency?.firstPhone ?? '',
            email: user.tier?.agency?.email ?? '',
            isMale: true,
          );
          update();
        }
      },
    );
  }
}

class AgencyModel {
  final String name;
  final String address;
  final String contactName;
  final String phone;
  final String email;
  final bool isMale;

  const AgencyModel({
    this.name = 'Chargement des données..',
    this.address = 'Chargement des données..',
    this.contactName = 'Chargement des données..',
    this.phone = 'Chargement des données..',
    this.email = 'Chargement des données..',
    this.isMale = true,
  });
}

import 'package:e_loan_mobile/widgets/menu.dart';
import 'package:get/get.dart';

class UserModel {
  int id;
  String firstName;
  String lastName;
  String gender;
  String job;
  String phone;
  String mobilePhone;
  String email;
  int status;
  Tier tier;
  bool isAdmin;

  UserModel({
    this.id,
    this.firstName,
    this.lastName,
    this.gender,
    this.job,
    this.phone,
    this.mobilePhone,
    this.email,
    this.status,
    this.tier,
  });

  UserModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    firstName = json['firstName'];
    lastName = json['lastName'];
    gender = json['gender'];
    job = json['job'];
    phone = json['phone'];
    mobilePhone = json['mobilePhone'];
    email = json['email'];
    status = json['status'];
    tier = json['tier'] != null ? Tier.fromJson(json['tier']) : null;
    isAdmin = json['isAdmin'];
    final MenuController menuController = Get.find<MenuController>();
    menuController.firstname.value = firstName.capitalizeFirst;
    menuController.lastname.value = lastName.capitalizeFirst;
  }
}

class Tier {
  int id;
  String legalForm;
  String firstname;
  String lastname;
  String socialReason;
  String activityArea;
  String label;
  String dateEntry;
  String tradeName;
  String identityNature;
  String residencePermit;
  String cin;
  int profile;
  String rne;
  String clientCode;
  String contractCode;
  String street;
  String postalCode;
  String local;
  String governorate;
  String type;
  bool isClient;
  Agency agency;
  Agent agent;

  Tier({
    this.id,
    this.legalForm,
    this.firstname,
    this.lastname,
    this.socialReason,
    this.activityArea,
    this.label,
    this.dateEntry,
    this.tradeName,
    this.identityNature,
    this.residencePermit,
    this.cin,
    this.profile,
    this.rne,
    this.clientCode,
    this.contractCode,
    this.street,
    this.postalCode,
    this.local,
    this.governorate,
    this.isClient,
    this.type,
  });

  Tier.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    legalForm = json['legalForm'];
    firstname = json['firstName'];
    lastname = json['lastName'];
    socialReason = json['socialReason'];
    activityArea = json['activityArea'];
    label = json['label'];
    dateEntry = json['dateEntry'];
    tradeName = json['agentName'];
    identityNature = json['identityNature'];
    residencePermit = json['carteSejour'];
    cin = json['cin'];
    profile = json['profile'];
    rne = json['rne'];
    clientCode = json['clientCode'];
    contractCode = json['contractCode'];
    street = json['street'];
    postalCode = json['postalCode'];
    local = json['local'];
    governorate = json['governorate'];
    isClient = json['isClient'];
    type = json['type'];
    if (json["agency"] != null) agency = Agency.fromJson(json["agency"]);
    if (json["agent"] != null) agent = Agent.fromJson(json["agent"]);
  }
}

class Agency {
  Agency({
    this.id,
    this.codeAgency,
    this.name,
    this.address,
    this.email,
    this.firstPhone,
  });

  int id;
  int codeAgency;
  String name;
  String address;
  String email;
  String firstPhone;

  factory Agency.fromJson(Map<String, dynamic> json) => Agency(
        id: json["id"],
        codeAgency: json["codeAgency"],
        name: json["name"],
        address: json["address"],
        email: json["email"],
        firstPhone: json["firstPhone"],
      );
}

class Agent {
  Agent({
    this.id,
    this.fullName,
  });

  int id;
  String fullName;

  factory Agent.fromJson(Map<String, dynamic> json) => Agent(
        id: json["id"],
        fullName: json["fullName"],
      );
}

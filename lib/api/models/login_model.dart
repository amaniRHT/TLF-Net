import 'package:e_loan_mobile/widgets/menu.dart';
import 'package:get/get.dart';

class LoginModel {
  LoginUserModel user;
  String accessToken;
  String refreshToken;

  LoginModel({this.user, this.accessToken, this.refreshToken});

  LoginModel.fromJson(Map<String, dynamic> json) {
    user = json['user'] != null ? LoginUserModel.fromJson(json['user']) : null;
    accessToken = json['accessToken'];
    refreshToken = json['refreshToken'];
  }
}

class LoginUserModel {
  int id;
  String firstName;
  String lastName;
  String gender;
  String job;
  String phone;
  String mobilePhone;
  String email;
  bool isAdmin;

  LoginUserModel({
    this.id,
    this.firstName,
    this.lastName,
    this.gender,
    this.job,
    this.phone,
    this.mobilePhone,
    this.email,
    this.isAdmin,
  });

  LoginUserModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    firstName = json['firstName'];
    lastName = json['lastName'];
    gender = json['gender'];
    job = json['job'];
    phone = json['phone'];
    mobilePhone = json['mobilePhone'];
    email = json['email'];
    isAdmin = json['isAdmin'];
    final MenuController menuController = Get.find<MenuController>();
    menuController.firstname.value = firstName.capitalizeFirst;
    menuController.lastname.value = lastName.capitalizeFirst;
  }
}

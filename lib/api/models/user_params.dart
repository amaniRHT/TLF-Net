import 'package:flutter/foundation.dart';

class UserParameters {
  String firstName;
  String lastName;
  String gender;
  String job;
  String phone;
  String mobilePhone;
  String email;
  int status;

  UserParameters({
    @required this.firstName,
    @required this.lastName,
    @required this.gender,
    @required this.job,
    @required this.phone,
    @required this.mobilePhone,
    @required this.email,
    this.status = 0,
  });
}

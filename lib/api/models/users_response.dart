class UsersResponse {
  int totalItems;
  List<Users> users;

  UsersResponse({this.totalItems, this.users});

  UsersResponse.fromJson(Map<String, dynamic> json) {
    totalItems = json['totalItems'];
    if (json['users'] != null) {
      users = <Users>[];
      json['users'].forEach((v) {
        users.add(Users.fromJson(v));
      });
    }
  }
}

class Users {
  int id;
  String firstName;
  String lastName;
  String gender;
  String job;
  String phone;
  String mobilePhone;
  String email;
  String createdAt;
  String updatedAt;
  bool isAdmin;
  int status;

  Users(
      {this.id,
      this.firstName,
      this.lastName,
      this.gender,
      this.job,
      this.phone,
      this.mobilePhone,
      this.email,
      this.createdAt,
      this.updatedAt,
      this.isAdmin,
      this.status});

  Users.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    firstName = json['firstName'];
    lastName = json['lastName'];
    gender = json['gender'];
    job = json['job'];
    phone = json['phone'];
    mobilePhone = json['mobilePhone'];
    email = json['email'];
    createdAt = json['createdAt'];
    updatedAt = json['updatedAt'];
    isAdmin = json['isAdmin'];
    status = json['status'];
  }
}

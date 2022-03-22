class PreCreatedUserToken {
  String token;

  PreCreatedUserToken({this.token});

  PreCreatedUserToken.fromJson(Map<String, dynamic> json) {
    token = json['token'];
  }
}

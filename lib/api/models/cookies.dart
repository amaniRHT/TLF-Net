class CookiesModel {
  int id;
  String name;

  CookiesModel({this.id, this.name});

  CookiesModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
  }
}

import 'models.dart';

class InvalidContractsListModel {
  int totalItems;
  String page;
  String limit;
  List<Contrats> contrats;

  InvalidContractsListModel(
      {this.totalItems, this.page, this.limit, this.contrats});

  InvalidContractsListModel.fromJson(Map<String, dynamic> json) {
    totalItems = json['totalItems'];
    page = json['page'];
    limit = json['limit'];
    if (json['contrats'] != null) {
      contrats = <Contrats>[];
      json['contrats'].forEach((v) {
        contrats.add(new Contrats.fromJson(v));
      });
    }
  }
}

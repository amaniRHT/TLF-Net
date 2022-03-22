import 'models.dart';

class BeingImplementedContractsListModel {
  int totalItems;
  String page;
  String limit;
  List<Contrats> contrats;

  BeingImplementedContractsListModel(
      {this.totalItems, this.page, this.limit, this.contrats});

  BeingImplementedContractsListModel.fromJson(Map<String, dynamic> json) {
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

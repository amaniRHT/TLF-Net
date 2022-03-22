import 'package:e_loan_mobile/api/models/contract.dart';

class InForceContractsListModel {
  int totalItems;
  String page;
  String limit;
  List<Contrats> contrats;

  InForceContractsListModel(
      {this.totalItems, this.page, this.limit, this.contrats});

  InForceContractsListModel.fromJson(Map<String, dynamic> json) {
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

class RepaymentScheduleListModel {
  String order;
  String column;
  String page;
  String limit;
  int totalItems;
  List<Echeanciers> echeanciers;

  RepaymentScheduleListModel(
      {this.order,
      this.column,
      this.page,
      this.limit,
      this.totalItems,
      this.echeanciers});

  RepaymentScheduleListModel.fromJson(Map<String, dynamic> json) {
    order = json['order'];
    column = json['column'];
    page = json['page'];
    limit = json['limit'];
    totalItems = json['totalItems'];
    if (json['echeanciers'] != null) {
      echeanciers = <Echeanciers>[];
      json['echeanciers'].forEach((v) {
        echeanciers.add(new Echeanciers.fromJson(v));
      });
    }
  }
}

class Echeanciers {
  int id;
  int contractCode;
  int idClient;
  String dateDebutLoyer;
  String dateFinLoyer;
  int numLoyer;
  double loyerHt;
  int periodeRestante;
  double loyerTtc;
  double interets;
  double amortissement;
  double services;
  double restantdu;

  Echeanciers(
      {this.id,
      this.contractCode,
      this.idClient,
      this.dateDebutLoyer,
      this.dateFinLoyer,
      this.numLoyer,
      this.loyerHt,
      this.periodeRestante,
      this.loyerTtc,
      this.interets,
      this.amortissement,
      this.services,
      this.restantdu});

  Echeanciers.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    contractCode = json['contract_code'];
    idClient = json['id_client'];
    dateDebutLoyer = json['date_debut_loyer'];
    dateFinLoyer = json['date_fin_loyer'];
    numLoyer = json['num_loyer'];
    if (json['loyer_ht'] != null) loyerHt = json['loyer_ht'].toDouble();
    periodeRestante = json['periode_restante'];
    if (json['loyer_ttc'] != null) loyerTtc = json['loyer_ttc'].toDouble();
    if (json['interets'] != null) interets = json['interets'].toDouble();
    if (json['amortissement'] != null)
      amortissement = json['amortissement'].toDouble();
    if (json['services'] != null) services = (json['services']).toDouble();
    if (json['restantdu'] != null) restantdu = json['restantdu'].toDouble();
  }
}

class AccountMovementsListModel {
  int totalItems;
  String page;
  String limit;
  List<MouvementCompte> mouvementCompte;

  AccountMovementsListModel(
      {this.totalItems, this.page, this.limit, this.mouvementCompte});

  AccountMovementsListModel.fromJson(Map<String, dynamic> json) {
    // totalItems = json['totalItems'];
    // page = json['page'];
    // limit = json['limit'];
    if (json['mouvementCompte'] != null) {
      mouvementCompte = <MouvementCompte>[];
      json['mouvementCompte'].forEach((v) {
        mouvementCompte.add(MouvementCompte.fromJson(v));
      });
    }
  }
}

class MouvementCompte {
  int id;
  int contractCode;
  int idClient;
  String documentNb;
  String libelle;
  String dateEcheance;
  String dateProcess;
  double montantDebit;
  double montantCredit;
  double resteARegler;
  String dateOperation;

  MouvementCompte(
      {this.id,
      this.contractCode,
      this.idClient,
      this.documentNb,
      this.libelle,
      this.dateEcheance,
      this.dateProcess,
      this.montantDebit,
      this.montantCredit,
      this.resteARegler,
      this.dateOperation});

  MouvementCompte.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    if (json['contract_code'] != null) contractCode = json['contract_code'];
    idClient = json['id_client'];
    documentNb = json['document_nb'];
    libelle = json['libelle'];
    dateEcheance = json['date_echeance'];
    dateProcess = json['date_process'];
    if (json['montant_debit'] != null)
      montantDebit = json['montant_debit'].toDouble();
    if (json['montant_credit'] != null)
      montantCredit = json['montant_credit'].toDouble();
    if (json['reste_a_regler'] != null)
      resteARegler = json['reste_a_regler'].toDouble();
    dateOperation = json['date_operation'];
  }
}

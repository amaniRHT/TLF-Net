class UnpaidBillsListModel {
  int totalItems;
  String page;
  String sumResteARegler;
  String sumMontantALettrer;
  String limit;
  List<Factures> factures;

  UnpaidBillsListModel(
      {this.totalItems,
      this.page,
      this.sumResteARegler,
      this.sumMontantALettrer,
      this.limit,
      this.factures});

  UnpaidBillsListModel.fromJson(Map<String, dynamic> json) {
    totalItems = json['totalItems'];
    page = json['page'];
    sumResteARegler = json['sum_reste_a_regler'];
    sumMontantALettrer = json['sum_montant_a_lettrer'];
    limit = json['limit'];
    if (json['factures'] != null) {
      factures = <Factures>[];
      json['factures'].forEach((v) {
        factures.add(new Factures.fromJson(v));
      });
    }
  }
}

class Factures {
  int id;
  int contractCode;
  int idClient;
  String documentNb;
  String libelle;
  String dateEcheance;
  double montantFacture;
  double resteARegler;
  double montantALettrer;

  Factures(
      {this.id,
      this.contractCode,
      this.idClient,
      this.documentNb,
      this.libelle,
      this.dateEcheance,
      this.montantFacture,
      this.resteARegler,
      this.montantALettrer});

  Factures.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    contractCode = json['contract_code'];
    idClient = json['id_client'];
    documentNb = json['document_nb'];
    libelle = json['libelle'];
    dateEcheance = json['date_echeance'];
    if (json['montant_facture'] != null)
      montantFacture = (json['montant_facture']).toDouble();
    if (json['reste_a_regler'] != null)
      resteARegler = (json['reste_a_regler']).toDouble();
    if (json['montant_a_lettrer'] != null)
      montantALettrer = (json['montant_a_lettrer']).toDouble();
  }
}

class Contrats {
  int id;
  int idClient;
  int contractCode;
  String objet;
  double montantFinance;
  String datePremierLoyer;
  String dateDernierLoyer;
  int dureeGlobale;
  int dureeResiduelle;
  double valeurResiduelle;
  String statut;

  Contrats(
      {this.id,
      this.idClient,
      this.contractCode,
      this.objet,
      this.montantFinance,
      this.datePremierLoyer,
      this.dateDernierLoyer,
      this.dureeGlobale,
      this.dureeResiduelle,
      this.valeurResiduelle,
      this.statut});

  Contrats.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    idClient = json['id_client'];
    contractCode = json['contract_code'];
    objet = json['objet'];
    if (json['montant_finance'] != null)
      montantFinance = json['montant_finance'].toDouble();
    datePremierLoyer = json['date_premier_loyer'];
    dateDernierLoyer = json['date_dernier_loyer'];
    dureeGlobale = json['duree_globale'];
    dureeResiduelle = json['duree_residuelle'];
    valeurResiduelle = json['valeur_residuelle'].toDouble();
    statut = json['statut'];
  }
}

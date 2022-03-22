import 'package:e_loan_mobile/api/models/required_documents.dart';

class RequestParameters {
  int id;
  int type;
  String revenus;
  String benefice;
  String duree;
  String autofinancement;
  String autofinancementpourcentage;
  String objet;
  bool neuf;
  String ageVehicule;
  String prixTotal;
  String prixHT;
  String tva;
  String prixTTC;
  String fournisseur;
  bool titrePropriete;
  int status;
  List<CategoryFiles> files;
  String filesToRemoveIds;

  RequestParameters({
    this.id,
    this.type,
    this.revenus,
    this.benefice,
    this.duree,
    this.autofinancement,
    this.autofinancementpourcentage,
    this.objet,
    this.neuf,
    this.ageVehicule,
    this.prixTotal,
    this.prixHT,
    this.tva,
    this.prixTTC,
    this.fournisseur,
    this.titrePropriete,
    this.status,
    this.files,
    this.filesToRemoveIds,
  });
}

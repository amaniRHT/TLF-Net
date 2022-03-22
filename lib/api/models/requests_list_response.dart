import 'package:e_loan_mobile/api/models/required_documents.dart';

class RequestsListModel {
  int totalItems;
  List<Request> demandes;

  RequestsListModel({this.totalItems, this.demandes});

  RequestsListModel.fromJson(Map<String, dynamic> json) {
    totalItems = json['totalItems'] as int;
    if (json['demandes'] != null) {
      demandes = <Request>[];
      json['demandes'].forEach((v) {
        demandes.add(Request.fromJson(v));
      });
    }
  }
}

class Request {
  int id;
  String code;
  int type;
  int duree;
  int autofinancement;
  dynamic autofinancementpourcentage;
  String objet;
  bool neuf;
  int ageVehicule;
  int revenus;
  int benefice;
  int prixTotal;
  int prixHT;
  int tva;
  int prixTTC;
  String fournisseur;
  String titrePropriete;
  int status;
  String createdAt;
  String updatedAt;
  List<DemDocMan> demDocMan;
  List<DemDocMan> demComplement;
  UpdatedBy updatedBy;
  CreatedBy createdBy;

  Request({
    this.id,
    this.code,
    this.type,
    this.duree,
    this.autofinancement,
    this.autofinancementpourcentage,
    this.objet,
    this.neuf,
    this.ageVehicule,
    this.revenus,
    this.benefice,
    this.prixTotal,
    this.prixHT,
    this.tva,
    this.prixTTC,
    this.fournisseur,
    this.titrePropriete,
    this.status,
    this.createdAt,
    this.updatedAt,
    this.demDocMan,
    this.demComplement,
    this.updatedBy,
    this.createdBy,
  });

  Request.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    code = json['code'];
    type = json['type'];
    duree = json['duree'];
    autofinancement = json['autofinancement'];
    autofinancementpourcentage = json['autofinancementpourcentage'];
    objet = json['objet'];
    neuf = json['neuf'];
    ageVehicule = json['ageVehicule'];
    revenus = json['revenus'];
    benefice = json['benefice'];
    prixTotal = json['prixTotal'];
    prixHT = json['prixHT'];
    tva = json['tva'];
    prixTTC = json['prixTTC'];
    fournisseur = json['fournisseur'];
    titrePropriete = json['titrePropriete'];
    status = json['status'];
    createdAt = json['createdAt'];
    updatedAt = json['updatedAt'];
    if (json['demDocMan'] != null) {
      demDocMan = <DemDocMan>[];
      json['demDocMan'].forEach((v) {
        demDocMan.add(DemDocMan.fromJson(v));
      });
    }
    if (json['demComplement'] != null) {
      demComplement = <DemDocMan>[];
      json['demComplement'].forEach((v) {
        DemDocMan formattedComplement = DemDocMan(
          id: v['id'],
          status: v['status'],
          isComplement: true,
          docMan: DocMan(
            id: v['id'],
            status: v['status'] == "1" ? true : false,
            title: v['title'],
            moreThenOneFile: v['moreThenOneFile'],
            isRequired: v['isRequired'],
          ),
        );

        if (v['files'] != null) {
          List<CategoryFiles> files = <CategoryFiles>[];
          v['files'].forEach((v) {
            files.add(CategoryFiles.fromJson(v, formattedComplement.id));
          });
          formattedComplement.files = files;
          formattedComplement.docMan.filled = files != null && files.isNotEmpty
              ? files
                  .where((CategoryFiles file) => file.parentCategoryId == id)
                  .toList()
                  .isNotEmpty
              : false;
          formattedComplement.filled = formattedComplement.docMan.filled;
        }
        demComplement.add(formattedComplement);
      });
    }
    updatedBy = json['updatedBy'] != null
        ? UpdatedBy.fromJson(json['updatedBy'])
        : null;
    createdBy = json['createdBy'] != null
        ? CreatedBy.fromJson(json['createdBy'])
        : null;
  }
}

class DemDocMan {
  int id;
  int status;
  DocMan docMan;
  bool isComplement = false;
  List<CategoryFiles> files;
  bool filled = false;

  DemDocMan({
    this.id,
    this.status,
    this.docMan,
    this.isComplement,
    this.files,
    this.filled,
  });

  DemDocMan.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    status = json['status'];

    isComplement = false;
    if (json['files'] != null) {
      files = <CategoryFiles>[];
      json['files'].forEach((v) {
        files.add(CategoryFiles.fromJson(v, json['docMan']['id']));
      });
      files = List.from(files);
    }
    filled = files != null && files.isNotEmpty
        ? files
            .where((CategoryFiles file) => file.parentCategoryId == id)
            .toList()
            .isNotEmpty
        : false;
    docMan =
        json['docMan'] != null ? DocMan.fromJson(json['docMan'], files) : null;
  }
}

class DocMan {
  int id;
  String title;
  bool moreThenOneFile;
  bool isRequired;
  String createdAt;
  String updatedAt;
  bool status;
  bool filled = false;

  DocMan({
    this.id,
    this.title,
    this.moreThenOneFile,
    this.isRequired,
    this.createdAt,
    this.updatedAt,
    this.status,
    this.filled,
  });

  DocMan.fromJson(Map<String, dynamic> json, List<CategoryFiles> files) {
    id = json['id'];
    title = json['title'];
    moreThenOneFile = json['moreThenOneFile'];
    isRequired = json['isRequired'];
    createdAt = json['createdAt'];
    updatedAt = json['updatedAt'];
    status = json['status'];
    filled = files != null && files.isNotEmpty
        ? files
            .where((CategoryFiles file) => file.parentCategoryId == id)
            .toList()
            .isNotEmpty
        : false;
  }
}

class UpdatedBy {
  int id;
  String firstName;
  String lastName;
  String email;

  UpdatedBy({this.id, this.firstName, this.lastName, this.email});

  UpdatedBy.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    firstName = json['firstName'];
    lastName = json['lastName'];
    email = json['email'];
  }
}

class CreatedBy {
  int id;
  String firstName;
  String email;

  CreatedBy({this.id, this.firstName, this.email});

  CreatedBy.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    firstName = json['firstName'];
    email = json['email'];
  }
}

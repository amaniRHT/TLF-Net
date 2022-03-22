import 'package:e_loan_mobile/api/models/models.dart';

class RDVsResponse {
  int totalItems;
  List<RendezVous> rdvs;

  RDVsResponse({this.totalItems, this.rdvs});

  RDVsResponse.fromJson(Map<String, dynamic> json) {
    totalItems = json['totalItems'];
    if (json['demandes'] != null) {
      rdvs = <RendezVous>[];
      json['demandes'].forEach((v) {
        rdvs.add(RendezVous.fromJson(v));
      });
    }
  }
}

class RendezVous {
  int id;
  String object;
  String additionalInformation;
  int status;
  String code;
  String createdAt;
  String updatedAt;
  UpdatedBy updatedBy;
  CreatedBy createdBy;

  RendezVous(
      {this.id,
      this.object,
      this.additionalInformation,
      this.status,
      this.code,
      this.createdAt,
      this.updatedAt,
      this.updatedBy,
      this.createdBy});

  RendezVous.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    object = json['object'];
    additionalInformation = json['additionalInformation'];
    status = json['status'];
    code = json['code'];
    createdAt = json['createdAt'];
    updatedAt = json['updatedAt'];
    updatedBy = json['updatedBy'] != null
        ? UpdatedBy.fromJson(json['updatedBy'])
        : null;
    createdBy = json['createdBy'] != null
        ? CreatedBy.fromJson(json['createdBy'])
        : null;
  }
}

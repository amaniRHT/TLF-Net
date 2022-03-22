import 'dart:async';
import 'dart:convert';
import 'package:dio/dio.dart';
import 'package:e_loan_mobile/Helpers/requests_interceptor.dart';
import 'package:e_loan_mobile/api/models/models.dart';
import 'package:e_loan_mobile/api/urls/app_urls.dart';
import 'package:flutter/foundation.dart';

class QuotationCreationService {
  Future<String> createQuotaionRequest({
    @required RequestParameters requestParameters,
  }) {
    final body = {
      'type': requestParameters.type,
      if (requestParameters.revenus.isNotEmpty) 'revenus': int.parse(requestParameters.revenus),
      if (requestParameters.benefice.isNotEmpty) 'benefice': int.parse(requestParameters.benefice),
      'objet': requestParameters.objet.trim(),
      if (requestParameters.duree.isNotEmpty) 'duree': int.parse(requestParameters.duree),
      if (requestParameters.autofinancementpourcentage.isNotEmpty)
        'autofinancementpourcentage': double.parse(requestParameters.autofinancementpourcentage),
      if (requestParameters.autofinancement.isNotEmpty) 'autofinancement': int.parse(requestParameters.autofinancement),
      if (requestParameters.type == 0) 'neuf': requestParameters.neuf,
      if (requestParameters.ageVehicule.isNotEmpty) 'ageVehicule': int.parse(requestParameters.ageVehicule.trim()),
      if (requestParameters.prixTotal.isNotEmpty) 'prixTotal': int.parse(requestParameters.prixTotal),
      if (requestParameters.prixHT.isNotEmpty && requestParameters.neuf) 'prixHT': int.parse(requestParameters.prixHT),
      if (requestParameters.tva.isNotEmpty) 'tva': int.parse(requestParameters.tva),
      if (requestParameters.prixTTC.isNotEmpty && requestParameters.neuf) 'prixTTC': int.parse(requestParameters.prixTTC),
      if (requestParameters.fournisseur.isNotEmpty) 'fournisseur': requestParameters.fournisseur.trim(),
      if (requestParameters.titrePropriete != null) 'titrePropriete': requestParameters.titrePropriete ? 'Oui' : 'Non',
      'status': requestParameters.status,
    };

    return DioRequestsInterceptor.dio.post(AppUrls.createQuotation, data: jsonEncode(body)).then((Response<dynamic> response) {
      if (response != null && response.data != null && response.statusCode == 200) {
        return Request.fromJson(response.data as Map<String, dynamic>)?.code;
      } else
        return null;
    });
  }

  Future<String> updateQuotationRequest({
    @required int quotaionRequestId,
    @required RequestParameters requestParameters,
  }) {
    final body = {
      'type': requestParameters.type,
      if (requestParameters.revenus.isNotEmpty) 'revenus': int.parse(requestParameters.revenus),
      if (requestParameters.benefice.isNotEmpty) 'benefice': int.parse(requestParameters.benefice),
      'objet': requestParameters.objet.trim(),
      if (requestParameters.duree.isNotEmpty) 'duree': int.parse(requestParameters.duree),
      if (requestParameters.autofinancementpourcentage.isNotEmpty)
        'autofinancementpourcentage': double.parse(requestParameters.autofinancementpourcentage),
      if (requestParameters.autofinancement.isNotEmpty) 'autofinancement': int.parse(requestParameters.autofinancement),
      if (requestParameters.type == 0) 'neuf': requestParameters.neuf,
      if (requestParameters.ageVehicule.isNotEmpty) 'ageVehicule': int.parse(requestParameters.ageVehicule.trim()),
      if (requestParameters.prixTotal.isNotEmpty) 'prixTotal': int.parse(requestParameters.prixTotal),
      if (requestParameters.prixHT.isNotEmpty && requestParameters.neuf) 'prixHT': int.parse(requestParameters.prixHT),
      if (requestParameters.tva.isNotEmpty) 'tva': int.parse(requestParameters.tva),
      if (requestParameters.prixTTC.isNotEmpty && requestParameters.neuf) 'prixTTC': int.parse(requestParameters.prixTTC),
      if (requestParameters.fournisseur.isNotEmpty) 'fournisseur': requestParameters.fournisseur.trim(),
      if (requestParameters.titrePropriete != null) 'titrePropriete': requestParameters.titrePropriete ? 'Oui' : 'Non',
      'status': requestParameters.status,
    };

    return DioRequestsInterceptor.dio
        .put(AppUrls.updateQuotaion(id: quotaionRequestId?.toString() ?? ''), data: jsonEncode(body))
        .then((Response<dynamic> response) {
      if (response != null && response.data != null && response.statusCode == 200) {
        return Request.fromJson(response.data as Map<String, dynamic>)?.code;
      } else
        return null;
    });
  }
}

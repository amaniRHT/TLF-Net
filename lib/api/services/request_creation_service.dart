import 'dart:async';
import 'dart:convert';
import 'package:dio/dio.dart';
import 'package:e_loan_mobile/Helpers/requests_interceptor.dart';
import 'package:e_loan_mobile/api/models/models.dart';
import 'package:e_loan_mobile/api/urls/app_urls.dart';
import 'package:flutter/foundation.dart';
// import 'package:http_parser/http_parser.dart';

class RequestCreationService {
  Future<RequiredDouments> getDocumentsforType({
    @required final String type,
  }) {
    final Map<String, String> params = {'type': type};

    return DioRequestsInterceptor.dio.get(AppUrls.getDocumentsforType, queryParameters: params).then((Response<dynamic> response) {
      if (response != null && response.data != null && response.statusCode == 200) {
        return RequiredDouments.fromJson(response.data as Map<String, dynamic>);
      } else
        return null;
    });
  }

  Future<String> createFundingRequest({
    @required RequestParameters requestParameters,
  }) {
    final Map<String, dynamic> requestMap = {
      'type': requestParameters.type,
      'objet': requestParameters.objet,
      if (requestParameters.duree.isNotEmpty) 'duree': int.parse(requestParameters.duree),
      if (requestParameters.autofinancementpourcentage.isNotEmpty)
        'autofinancementpourcentage': double.parse(requestParameters.autofinancementpourcentage),
      if (requestParameters.autofinancement.isNotEmpty) 'autofinancement': int.parse(requestParameters.autofinancement),
      if (requestParameters.type == 0) 'neuf': requestParameters.neuf,
      if (requestParameters.ageVehicule.isNotEmpty) 'ageVehicule': int.parse(requestParameters.ageVehicule),
      if (requestParameters.prixTotal.isNotEmpty) 'prixTotal': int.parse(requestParameters.prixTotal),
      if (requestParameters.prixHT.isNotEmpty && requestParameters.neuf) 'prixHT': int.parse(requestParameters.prixHT),
      if (requestParameters.tva.isNotEmpty) 'tva': int.parse(requestParameters.tva),
      if (requestParameters.prixTTC.isNotEmpty && requestParameters.neuf) 'prixTTC': int.parse(requestParameters.prixTTC),
      if (requestParameters.fournisseur.isNotEmpty) 'fournisseur': requestParameters.fournisseur,
      if (requestParameters.titrePropriete != null) 'titrePropriete': requestParameters.titrePropriete,
      'status': requestParameters.status,
    };

    return _createMultipartFilesMap(requestParameters.files).then((
      Map<String, List<MultipartFile>> filesMap,
    ) {
      requestMap.addAll(filesMap);

      return DioRequestsInterceptor.dio
          .post(
        AppUrls.createRequest,
        data: FormData.fromMap(requestMap),
      )
          .then((Response<dynamic> response) {
        if (response != null && response.data != null && response.statusCode == 200) {
          return Request.fromJson(response.data as Map<String, dynamic>)?.code;
        } else
          return null;
      });
    });
  }

  Future<String> updateFundingRequest({
    @required RequestParameters requestParameters,
    bool documentsCompletionPurpose = false,
  }) {
    final Map<String, dynamic> requestMap = documentsCompletionPurpose
        ? {
            'status': 1,
            if (requestParameters.filesToRemoveIds.isNotEmpty) 'documents': requestParameters.filesToRemoveIds,
          }
        : {
            'type': requestParameters.type,
            'objet': requestParameters.objet,
            if (requestParameters.duree.isNotEmpty) 'duree': int.parse(requestParameters.duree),
            if (requestParameters.autofinancementpourcentage.isNotEmpty)
              'autofinancementpourcentage': double.parse(requestParameters.autofinancementpourcentage),
            if (requestParameters.autofinancement.isNotEmpty) 'autofinancement': int.parse(requestParameters.autofinancement),
            if (requestParameters.type == 0) 'neuf': requestParameters.neuf,
            if (requestParameters.ageVehicule.isNotEmpty) 'ageVehicule': int.parse(requestParameters.ageVehicule),
            if (requestParameters.prixTotal.isNotEmpty) 'prixTotal': int.parse(requestParameters.prixTotal),
            if (requestParameters.prixHT.isNotEmpty && requestParameters.neuf) 'prixHT': int.parse(requestParameters.prixHT),
            if (requestParameters.tva.isNotEmpty) 'tva': int.parse(requestParameters.tva),
            if (requestParameters.prixTTC.isNotEmpty && requestParameters.neuf) 'prixTTC': int.parse(requestParameters.prixTTC),
            if (requestParameters.fournisseur.isNotEmpty) 'fournisseur': requestParameters.fournisseur,
            if (requestParameters.titrePropriete != null) 'titrePropriete': requestParameters.titrePropriete,
            'status': requestParameters.status,
            if (requestParameters.filesToRemoveIds.isNotEmpty) 'documents': requestParameters.filesToRemoveIds,
          };

    return _createMultipartFilesMap(requestParameters.files).then((
      Map<String, List<MultipartFile>> filesMap,
    ) {
      requestMap.addAll(filesMap);

      return DioRequestsInterceptor.dio
          .put(
        AppUrls.updateRequest(id: requestParameters.id.toString()),
        data: FormData.fromMap(requestMap),
      )
          .then((Response<dynamic> response) {
        if (response != null && response.data != null && response.statusCode == 200) {
          return Request.fromJson(response.data as Map<String, dynamic>)?.code;
        } else
          return null;
      });
    });
  }

  Future<Map<String, List<MultipartFile>>> _createMultipartFilesMap(List<CategoryFiles> requestFiles) async {
    if (requestFiles == null) return {};

    final Map<String, List<MultipartFile>> mappedFiles = <String, List<MultipartFile>>{};

    for (final file in requestFiles) {
      addValueToMap(
        mappedFiles,
        file.parentCategoryRefrenceId,
        await MultipartFile.fromFile(
          file.path,
          filename: file.name,
        ),
      );
    }

    return mappedFiles;
  }

  void addValueToMap<K, V>(Map<K, List<V>> map, K key, V value) => map.update(
        key,
        (list) => list..add(value),
        ifAbsent: () => [value],
      );
// {title: "rrd", moreThenOneFile: true, demande: 247, type: "2"}

  Future<DocsManagement> addComplement({
    @required int requestId,
    @required bool moreThanOneFile,
    @required String title,
    @required String type,
  }) {
    final Map<String, dynamic> body = {'demande': requestId, 'moreThenOneFile': moreThanOneFile, 'title': title, 'type': type};

    return DioRequestsInterceptor.dio.post(AppUrls.addComplement, data: jsonEncode(body)).then((Response<dynamic> response) {
      if (response != null && response.data != null && response.statusCode == 201) {
        final createdComplement = response.data;
        return DocsManagement(
          id: createdComplement['id'],
          hasBeenUpdated: false,
          title: title,
          isRequired: true,
          status: createdComplement['status'] == 1,
          validDocument: false,
          invalidDocument: false,
          validComplement: false,
          invalidComplement: true,
          moreThenOneFile: true,
          filled: false,
          files: <CategoryFiles>[],
          isComplement: true,
          exists: true,
        );
      } else
        return null;
    });
  }
}

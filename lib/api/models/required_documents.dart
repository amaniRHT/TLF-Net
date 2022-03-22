import 'package:flutter/foundation.dart';

class RequiredDouments {
  int totalItems;
  List<DocsManagement> docsManagement;
  List<DocsManagement> complementDocument;

  RequiredDouments(
      {this.totalItems, this.docsManagement, this.complementDocument});

  RequiredDouments.fromJson(Map<String, dynamic> json) {
    totalItems = json['totalItems'];
    if (json['docsManagement'] != null) {
      docsManagement = <DocsManagement>[];
      json['docsManagement'].forEach((v) {
        docsManagement.add(DocsManagement.fromJson(v, false));
      });
    }
    if (json['complementDocument'] != null) {
      complementDocument = <DocsManagement>[];

      json['complementDocument'].forEach((v) {
        complementDocument.add(DocsManagement.fromJson(v, true));
      });
    }
  }
}

class DocsManagement {
  int id;
  String title;
  bool moreThenOneFile;
  bool hasBeenUpdated;
  bool isRequired;
  bool status;
  bool validDocument;
  bool invalidDocument;
  bool validComplement;
  bool invalidComplement;
  List<CategoryFiles> files;
  bool filled = false;
  bool isComplement;
  bool exists;

  DocsManagement({
    this.id,
    this.title,
    this.moreThenOneFile,
    this.hasBeenUpdated = false,
    this.isRequired,
    this.status,
    this.validDocument,
    this.invalidDocument,
    this.validComplement,
    this.invalidComplement,
    this.files,
    this.filled = false,
    this.isComplement,
    this.exists = true,
  });

  DocsManagement.fromJson(Map<String, dynamic> json, bool isAComplement) {
    id = json['id'];
    title = json['title'];
    moreThenOneFile = json['moreThenOneFile'];
    hasBeenUpdated = false;
    isRequired = json['isRequired'];
    status = json['status'];
    isComplement = isAComplement;
    validDocument = status && !isComplement;
    invalidDocument = status && !isComplement;
    validComplement = status && isComplement;
    invalidComplement = status && isComplement;
    files = List.from(const <CategoryFiles>[]);
    filled = false;
    exists = true;
  }
}

class CategoryFiles {
  int id;
  int parentCategoryId;
  String parentCategoryRefrenceId;
  String originalname;
  String name;
  String ext;
  String path;
  int size;
  bool exists;

  CategoryFiles({
    @required this.parentCategoryId,
    @required this.parentCategoryRefrenceId,
    this.originalname,
    @required this.name,
    @required this.ext,
    @required this.path,
    @required this.size,
    this.exists = false,
  });

  CategoryFiles.fromJson(Map<String, dynamic> json, int parentId) {
    id = json['id'];
    parentCategoryId = parentId;
    originalname = json['originalname'];
    name = json['filename'];
    path = json['path'];
    size = json['size'];
    exists = true;
  }
}

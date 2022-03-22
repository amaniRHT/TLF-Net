import 'dart:convert';
import 'package:dio/dio.dart';
import 'package:e_loan_mobile/Helpers/helpers.dart';
import 'package:e_loan_mobile/api/models/models.dart';
import 'package:e_loan_mobile/api/services/services.dart';
import 'package:e_loan_mobile/api/urls/app_urls.dart';
import 'package:e_loan_mobile/config/config.dart';
import 'package:flutter/material.dart';

class UsersService {
  Future<UsersResponse> getUsersAccounts({
    final UsersFilteringParameters parameters,
  }) {
    final Map<String, dynamic> params = {
      if (parameters.userIds != null) 'userIds': parameters.userIds,
      if (parameters.email != null) 'email': parameters.email,
      if (parameters.status != null) 'status': parameters.status,
      if (parameters.order != null) 'order': parameters.order,
    };
    if (fakeData)
      return AppConstants.falseFutrue.then(
        (value) => UsersResponse.fromJson(fakeUsersList),
      );
    else
      return DioRequestsInterceptor.dio.get(AppUrls.getUsersList, queryParameters: params).then((
        Response<dynamic> response,
      ) {
        if (response != null && response.data != null && response.statusCode == 200) {
          return UsersResponse.fromJson(response.data as Map<String, dynamic>);
        } else
          return null;
      });
  }

  Future<bool> deleteUserAccount({@required int userId}) {
    return DioRequestsInterceptor.dio.delete(AppUrls.deleteUser(id: userId?.toString() ?? '')).then((Response<dynamic> response) {
      return response != null && response.data != null && response.statusCode == 200;
    });
  }

  Future<bool> createUserAccount({
    @required UserParameters userParameters,
  }) {
    final body = {
      'firstName': userParameters.firstName.trim(),
      'lastName': userParameters.lastName.trim(),
      'job': userParameters.job,
      'phone': userParameters.phone,
      'gender': userParameters.gender,
      if (userParameters.mobilePhone.isNotEmpty) 'mobilePhone': userParameters.mobilePhone,
      'email': userParameters.email.trim(),
    };

    return DioRequestsInterceptor.dio.post(AppUrls.createUser, data: jsonEncode(body)).then((Response<dynamic> response) {
      if (response != null && response.data != null && response.statusCode == 201) {
        return true;
      } else
        return false;
    });
  }

  Future<bool> updateUserAccount({
    @required int userId,
    @required UserParameters userParameters,
  }) {
    final body = {
      'firstName': userParameters.firstName.trim(),
      'lastName': userParameters.lastName.trim(),
      'job': userParameters.job,
      'phone': userParameters.phone,
      'gender': userParameters.gender,
      if (userParameters.mobilePhone.isNotEmpty) 'mobilePhone': userParameters.mobilePhone,
      'email': userParameters.email.trim(),
      'status': userParameters.status,
    };

    return DioRequestsInterceptor.dio
        .put(
      AppUrls.updateUser(id: userId?.toString() ?? ''),
      data: jsonEncode(body),
    )
        .then((
      Response<dynamic> response,
    ) {
      if (response != null && response.data != null && response.statusCode == 200) {
        return true;
      } else
        return false;
    });
  }

  Future<Users> getUserDetails({@required int userId}) {
    return DioRequestsInterceptor.dio.get(AppUrls.getUserDetails(id: userId?.toString() ?? '')).then(
      (Response<dynamic> response) {
        if (response != null && response.data != null && response.statusCode == 200) {
          return Users.fromJson(response.data as Map<String, dynamic>);
        } else
          return null;
      },
    );
  }

  Future<bool> updateUserStatus({
    @required int userId,
    @required int status,
  }) {
    final body = {
      'status': status,
    };

    return DioRequestsInterceptor.dio
        .put(
      AppUrls.updateUser(id: userId?.toString() ?? ''),
      data: jsonEncode(body),
    )
        .then((
      Response<dynamic> response,
    ) {
      if (response != null && response.data != null && response.statusCode == 200) {
        return true;
      } else
        return false;
    });
  }
}

Map<String, Object> fakeUsersList = {
  "totalItems": 11,
  "users": [
    {
      "id": 21,
      "firstname": "hhh",
      "lastname": "gh",
      "gender": "mr",
      "job": "comptable",
      "phone": "22558877",
      "mobilephone": "22554455",
      "email": "ghhaykel@gmail.com",
      "createdAt": "2021-07-05T16:39:18.203Z",
      "updatedAt": "2021-07-05T16:39:18.203Z",
      "isAdmin": false,
      "status": 0
    },
    {
      "id": 21,
      "firstname": "hhh",
      "lastname": "gh",
      "gender": "mr",
      "job": "comptable",
      "phone": "22558877",
      "mobilephone": "22554455",
      "email": "ghhaykel@gmail.com",
      "createdAt": "2021-07-05T16:39:18.203Z",
      "updatedAt": "2021-07-05T16:39:18.203Z",
      "isAdmin": false,
      "status": 0
    },
    {
      "id": 21,
      "firstname": "hhh",
      "lastname": "gh",
      "gender": "mr",
      "job": "comptable",
      "phone": "22558877",
      "mobilephone": "22554455",
      "email": "ghhaykel@gmail.com",
      "createdAt": "2021-07-05T16:39:18.203Z",
      "updatedAt": "2021-07-05T16:39:18.203Z",
      "isAdmin": false,
      "status": 0
    },
    {
      "id": 21,
      "firstname": "hhh",
      "lastname": "gh",
      "gender": "mr",
      "job": "comptable",
      "phone": "22558877",
      "mobilephone": "22554455",
      "email": "ghhaykel@gmail.com",
      "createdAt": "2021-07-05T16:39:18.203Z",
      "updatedAt": "2021-07-05T16:39:18.203Z",
      "isAdmin": false,
      "status": 0
    },
    {
      "id": 21,
      "firstname": "hhh",
      "lastname": "gh",
      "gender": "mr",
      "job": "comptable",
      "phone": "22558877",
      "mobilephone": "22554455",
      "email": "ghhaykel@gmail.com",
      "createdAt": "2021-07-05T16:39:18.203Z",
      "updatedAt": "2021-07-05T16:39:18.203Z",
      "isAdmin": false,
      "status": 0
    },
    {
      "id": 21,
      "firstname": "hhh",
      "lastname": "gh",
      "gender": "mr",
      "job": "comptable",
      "phone": "22558877",
      "mobilephone": "22554455",
      "email": "ghhaykel@gmail.com",
      "createdAt": "2021-07-05T16:39:18.203Z",
      "updatedAt": "2021-07-05T16:39:18.203Z",
      "isAdmin": false,
      "status": 0
    },
    {
      "id": 21,
      "firstname": "hhh",
      "lastname": "gh",
      "gender": "mr",
      "job": "comptable",
      "phone": "22558877",
      "mobilephone": "22554455",
      "email": "ghhaykel@gmail.com",
      "createdAt": "2021-07-05T16:39:18.203Z",
      "updatedAt": "2021-07-05T16:39:18.203Z",
      "isAdmin": false,
      "status": 0
    },
    {
      "id": 21,
      "firstname": "hhh",
      "lastname": "gh",
      "gender": "mr",
      "job": "comptable",
      "phone": "22558877",
      "mobilephone": "22554455",
      "email": "ghhaykel@gmail.com",
      "createdAt": "2021-07-05T16:39:18.203Z",
      "updatedAt": "2021-07-05T16:39:18.203Z",
      "isAdmin": false,
      "status": 0
    },
    {
      "id": 21,
      "firstname": "hhh",
      "lastname": "gh",
      "gender": "mr",
      "job": "comptable",
      "phone": "22558877",
      "mobilephone": "22554455",
      "email": "ghhaykel@gmail.com",
      "createdAt": "2021-07-05T16:39:18.203Z",
      "updatedAt": "2021-07-05T16:39:18.203Z",
      "isAdmin": false,
      "status": 0
    },
    {
      "id": 21,
      "firstname": "hhh",
      "lastname": "gh",
      "gender": "mr",
      "job": "comptable",
      "phone": "22558877",
      "mobilephone": "22554455",
      "email": "ghhaykel@gmail.com",
      "createdAt": "2021-07-05T16:39:18.203Z",
      "updatedAt": "2021-07-05T16:39:18.203Z",
      "isAdmin": false,
      "status": 0
    },
    {
      "id": 21,
      "firstname": "hhh",
      "lastname": "gh",
      "gender": "mr",
      "job": "comptable",
      "phone": "22558877",
      "mobilephone": "22554455",
      "email": "ghhaykel@gmail.com",
      "createdAt": "2021-07-05T16:39:18.203Z",
      "updatedAt": "2021-07-05T16:39:18.203Z",
      "isAdmin": false,
      "status": 0
    },
  ]
};

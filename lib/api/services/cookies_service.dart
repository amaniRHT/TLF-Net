import 'package:dio/dio.dart';
import 'package:e_loan_mobile/Helpers/requests_interceptor.dart';
import 'package:e_loan_mobile/api/models/cookies.dart';
import 'package:e_loan_mobile/api/urls/app_urls.dart';

class CookiesService {
  Future<CookiesModel> getCookies() {
    return DioRequestsInterceptor.dio.get(AppUrls.cookies).then((
      Response<dynamic> response,
    ) {
      if (response != null &&
          response.data != null &&
          response.statusCode == 200) {
        final cookies =
            CookiesModel.fromJson(response.data as Map<String, dynamic>);
        return cookies;
      } else
        return null;
    });
  }
}

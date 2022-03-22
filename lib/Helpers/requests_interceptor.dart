import 'dart:io';

import 'package:connectivity/connectivity.dart';
import 'package:dio/dio.dart';
import 'package:e_loan_mobile/api/services/token_service.dart';
import 'package:e_loan_mobile/config/config.dart';
import 'package:e_loan_mobile/config/env/tlf_environnments.dart';
import 'package:e_loan_mobile/static/statics.dart';
import 'package:e_loan_mobile/widgets/widgets.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';

class DioRequestsInterceptor {
  static Dio _dio;

  static ResponseType responseType = ResponseType.json;

  static ConnectivityResult connectivityResult;

  static void initialiseConnectivityMonitorListener() {
    Connectivity().onConnectivityChanged.listen((ConnectivityResult result) {
      switch (connectivityResult) {
        case null:
          connectivityResult = result;
          break;
        default:
          connectivityResult = result;
          showConnectivityAlert();
      }
    });
  }

  static void showConnectivityAlert() {
    showCustomToast(
      padding: 15,
      onTheTop: false,
      toastType: connectivityResult == ConnectivityResult.none
          ? ToastTypes.warning
          : ToastTypes.success,
      contentText: connectivityResult == ConnectivityResult.none
          ? 'Il semble que vous soyez hors ligne. Veuillez vérifier votre connexion Internet'
          : 'Vous êtes connecté',
      blurEffectEnabled: false,
    );
  }

  //! Reconnect to the api just stopped
  static Future<Response<dynamic>> retry(RequestOptions requestOptions) async {
    final options = new Options(
      method: requestOptions.method,
      headers: requestOptions.headers,
    );
    return dio.request<dynamic>(requestOptions.path,
        data: requestOptions.data,
        queryParameters: requestOptions.queryParameters,
        options: options);
  }

  //! Interceptor Setup
  static Dio get dio {
    if (_dio == null) {
      _dio = Dio(
        BaseOptions(
          baseUrl: TLFEnvrionnments.baseUrl,
          connectTimeout: TLFEnvrionnments.connectTimeout,
          sendTimeout: TLFEnvrionnments.sendTimeout,
          receiveTimeout: TLFEnvrionnments.receiveTimeout,
        ),
      );

      _dio.interceptors.add(
        InterceptorsWrapper(
          onRequest: (
            RequestOptions requestOptions,
            RequestInterceptorHandler handler,
          ) {
            // if (fakeData) return;
            if (connectivityResult == null ||
                connectivityResult == ConnectivityResult.none) {
              hideLoader();
              showConnectivityAlert();
              //return;
            }
            ;

            // print(
            //   Statics.accessToken ?? 'Not connected yet',
            // );

            showLoader();

            requestOptions.responseType = responseType;

            requestOptions.headers.addAll({
              HttpHeaders.authorizationHeader: 'Bearer ${Statics.accessToken}',
              HttpHeaders.contentTypeHeader: ContentType.json.mimeType,
            });

            handler.next(requestOptions);
            return requestOptions;
          },
          onResponse: (
            Response<dynamic> response,
            ResponseInterceptorHandler handler,
          ) {
            EasyLoading.dismiss();
            responseType = ResponseType.json;
            handler.next(response);
          },
          onError: (
            DioError error,
            ErrorInterceptorHandler handler,
          ) {
            responseType = ResponseType.json;
            _handleError(error);
            handler.next(error);
          },
        ),
      );
    }
    return _dio;
  }

  //! Loader Setup
  static bool loaderEnabled = true;
  static void showLoader() {
    if (loaderEnabled) EasyLoading.show();
  }

  static void hideLoader() {
    EasyLoading.dismiss();
  }

  static void enableLoader() {
    DioRequestsInterceptor.loaderEnabled = true;
  }

  static void disableLoader() {
    DioRequestsInterceptor.loaderEnabled = false;
  }

  //! Error Handling

  static Dio tokenRefreshDio = Dio();

  static void _handleError(DioError error) {
    // ! This is just for test , its temporary
    // if (error.response?.statusCode == 403 ??
    //     false || error.response?.statusCode == 401 ??
    //     false) {
    //   showCustomToast(
    //     duration: 6,
    //     toastType: ToastTypes.error,
    //     contentText: AppConstants.ERROR_OCCURED,
    //     onTheTop: false,
    //   );
    //   final TokenService _tokenService = TokenService();
    //   _tokenService.refreshTokensTesting();
    // }

    // ! TOKEN REFRESHING
    if (error.response?.statusCode == 403 ?? false) {
      _dio.lock();
      tokenRefreshDio.unlock();
      final TokenService _tokenService = TokenService();
      _tokenService.refreshTokens().then((bool success) {
        _dio.unlock();
        tokenRefreshDio.lock();
        EasyLoading.dismiss();
        // ! either redirect to current route so we can refresh the screen
        _tokenService.refreshCurrentRoute();
        // ! refetch the last api called
        // return retry(error.requestOptions);
      });
    }
    // if (error.response?.statusCode == 404 ?? false) {
    //   _dio.lock();
    //   print("errorrrr");
    //   print(error.response);
    //   print(error.requestOptions);
    //   _dio.unlock();
    // }

    else {
      EasyLoading.dismiss();
      // ! Failure response toasting
      if (error.response != null && error.response.data != null) {
        showCustomToast(
          duration: 6,
          toastType: ToastTypes.error,
          contentText: getEquivalentErrorText(error: error),
          onTheTop: false,
        );
      } else
        showCustomToast(
          duration: 6,
          toastType: ToastTypes.error,
          contentText: AppConstants.ERROR_OCCURED,
          onTheTop: false,
        );
    }
  }

  static String getEquivalentErrorText({DioError error}) {
    if (error.response.statusCode == 404 &&
        error.response.data['message'] == 'tier not found in crm')
      return 'Les identifiants saisis ne correspondent pas au code contrat/client que vous avez saisi. Merci de vérifier votre saisie !';

    switch (error.response.data['code']) {
      case '39':
        return error.response.data['msg'];
      case '0001':
        return 'E-mail et/ou mot de passe incorrect ! Veuillez réessayer.';
      case '0002':
        return 'Un utilisateur est déjà créé avec cet email !';
      case '0003':
        return 'Non autorisé';
      case '0004':
        return 'Status invalide';
      case '0005':
        return 'Agent introuvable';
      case '0006':
        return 'Code invalide';
      case '0007':
        return 'Action invalide';
      case '0008':
        return 'Ce profil existe déjà';
      case '0009':
        return 'Profil introuvable';
      case '0010':
        return "Chevauchement dans la période d'intérim";
      case '0011':
        return 'Agence invalide';
      case '0012':
        return 'Cet agent existe déjà';
      case '0013':
        return 'La date de début est obligatoire';
      case '0014':
        return 'La date de fin est obligatoire';
      case '0015':
        return 'Agent intérim introuvable';
      case '0016':
        return 'Cet RNE existe déjà';
      case '0017':
        return 'Ce n°CIN existe déjà';
      case '0018':
        return 'Ce code client existe déjà';
      case '0019':
        return 'Ce code contrat existe déjà';
      case '0020':
        return "Cet utilisateur n'est pas encore confirmé";
      case '0021':
        return 'Cet utilisateur est bloqué';
      case '0022':
        return 'E-mail et/ou mot de passe incorrect ! Veuillez réessayer.';
      case '0023':
        return 'Le mot de passe et la confirmation du mot de passe ne correspondent pas !';
      case '0024':
        return 'Cette demande est introuvable';
      case '0025':
        return 'Ce compte ADMIN existe déjà';
      case '0026':
        return 'Tier introuvable';
      case '0027':
        return 'Agence introuvable';
      case '0028':
        return 'Token inexistant';
      case '0029':
        return 'Token expiré';
      case '0030':
        return 'Ce document existe déjà ! Veuillez vérifier le nom du document à ajouter !';
      case '0033':
        return 'Seules les images et les fichiers de type PDF sont autorisés!';
      case '0034':
        return "Cet utilisateur n'est pas encore activé!";
      case '0039':
        return 'Les identifiants saisis ne correspondent pas au code contrat/client que vous avez saisi. Merci de vérifier votre saisie !';
      case '0042':
        return 'Erreur de création, veuillez contacter votre agence';
      case '0044':
        return 'Mot de passe incorrect !';
      case '0045':
        return "Les identifiants saisis ne correspondent pas au code contrat/client que vous avez saisi. Merci de vérifier votre saisie !";
      case '0046':
        return "Les identifiants saisis ne correspondent pas au code contrat/client que vous avez saisi. Merci de vérifier votre saisie !";

      default:
        return AppConstants.ERROR_OCCURED;
    }
  }
}

import 'package:back_button_interceptor/back_button_interceptor.dart';
import 'package:e_loan_mobile/Helpers/requests_interceptor.dart';
import 'package:e_loan_mobile/app/controllers.dart';
import 'package:e_loan_mobile/app/core/quotation_creation/quotation_creation_controller.dart';
import 'package:e_loan_mobile/app/core/rdvs_list/rdvs_list_page.dart';
import 'package:e_loan_mobile/app/core/request_creation/request_creation_controller.dart';
import 'package:e_loan_mobile/routes/app_routes.dart';
import 'package:e_loan_mobile/widgets/common_modals.dart';
import 'package:e_loan_mobile/widgets/yes_no_dialog.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';

class BackPressInterceptorManager {
  static bool _escapeModalIsVisible = false;

  static void configureInterceptor() {
    BackButtonInterceptor.add(
      backPressInterceptor,
      ifNotYetIntercepted: true,
    );
  }

  static bool backPressInterceptor(
    bool stopDefaultButtonEvent,
    RouteInfo info,
  ) {
    if (Get.currentRoute == AppRoutes.requestCreation) {
      showCommonModal(
        modalType: ModalTypes.alert,
        message: Get.find<RequestCreationController>().creationMode
            ? 'Êtes-vous sûr de vouloir annuler la création de votre demande ?'
            : 'Êtes-vous sûr de vouloir annuler la modification de votre demande ?',
        buttonTitle: 'Confirmer',
        onPressed: () {
          Get.back(closeOverlays: true);
          Get.offAllNamed(AppRoutes.requestsList);
        },
        withCancelButton: true,
      );
    } else if (Get.currentRoute == AppRoutes.quotationRequestCreation) {
      showCommonModal(
        modalType: ModalTypes.alert,
        message: Get.find<QuotationCreationController>().creationMode
            ? 'Êtes-vous sûr de vouloir annuler la création de votre demande ?'
            : 'Êtes-vous sûr de vouloir annuler la modification de votre demande ?',
        buttonTitle: 'Confirmer',
        onPressed: () {
          Get.back(closeOverlays: true);
          Get.offAllNamed(AppRoutes.quotationRequestsList);
        },
        withCancelButton: true,
      );
    } else if (Get.currentRoute == AppRoutes.userCreation) {
      showCommonModal(
        modalType: ModalTypes.alert,
        message: Get.find<UserCreationController>().creationMode
            ? 'Êtes-vous sûr de vouloir annuler la création de cet utilisateur ?'
            : 'Êtes-vous sûr de vouloir annuler la modification de cet utilisateur ?',
        buttonTitle: 'Confirmer',
        onPressed: () {
          Get.back(closeOverlays: true);
          Get.offAllNamed(AppRoutes.usersList);
        },
        withCancelButton: true,
      );
    } else if (Get.currentRoute == AppRoutes.requestComplement) {
      showCommonModal(
        modalType: ModalTypes.alert,
        message: 'Êtes-vous sûr de vouloir annuler la jointure de documents ?',
        buttonTitle: 'Confirmer',
        onPressed: () {
          Get.back(closeOverlays: true);
          Get.back<bool>(result: false);
        },
        withCancelButton: true,
      );
    } else if (AppRoutes.initialRoutes.contains(Get.currentRoute) && !_escapeModalIsVisible) {
      if (Get.currentRoute == AppRoutes.rdvsList && comingFromNotificationsScreenToRDVsListPage) {
        Get.back();
        return true;
      }
      ;
      _escapeModalIsVisible = true;
      appEscapingDialog(
        content: "Êtes-vous sûr de vouloir quitter l'application ?",
        confirmationText: 'Oui',
        cancelText: 'Non',
      ).then((confirmed) {
        _escapeModalIsVisible = false;
        if (confirmed != null && confirmed) {
          SystemChannels.platform.invokeMethod('SystemNavigator.pop');
        }
      });
    } else {
      _escapeModalIsVisible = false;
      DioRequestsInterceptor.hideLoader();
      Get.back();
    }

    return true;
  }
}

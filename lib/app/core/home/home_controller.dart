import 'package:e_loan_mobile/Helpers/base_controller.dart';
import 'package:e_loan_mobile/api/models/cookies.dart';
import 'package:e_loan_mobile/api/models/segments_model.dart';
import 'package:e_loan_mobile/api/services/services.dart';
import 'package:e_loan_mobile/config/config.dart';
import 'package:e_loan_mobile/routes/app_routes.dart';
import 'package:e_loan_mobile/widgets/common_button.dart';
import 'package:e_loan_mobile/widgets/vertical_spacing.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

class HomeController extends BaseController {
  bool agencyIsSelected = false;

  //! get cookies value from api

  final CookiesService _cookiesService = CookiesService();
  final box = GetStorage();
  String cookiesName;

  void getCookiesName() {
    _cookiesService.getCookies().then((CookiesModel cookies) {
      cookiesName = cookies.name;
      update();
      if (cookiesName != null && box.read('TLFCookies') != cookiesName) {
        Get.dialog(
          AlertDialog(
            content: Container(
              height: 200,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    "En poursuivant votre navigation, vous acceptez l’utilisation de Cookies ou traceurs pour améliorer et personnaliser votre expérience, réaliser des statistiques d’audiences, vous proposer des produits et services ciblés et adaptés à vos centres d’intérêt.",
                    style: AppStyles.mediumBlue13,
                  ),
                  const VerticalSpacing(20),
                  SizedBox(
                    height: 40,
                    child: CommonButton(
                      title: "Accepter tout",
                      enabledColor: AppColors.lightBlue,
                      titleColor: AppColors.darkestBlue,
                      onPressed: () {
                        box.write('TLFCookies', cookiesName);
                        Get.back();
                      },
                    ),
                  ),
                ],
              ),
            ),
          ),
          barrierDismissible: false,
        );
      }
    });
  }

  final List<Segments> segments = const <Segments>[
    Segments(
      name: 'Véhicules',
      link: 'http://www.tlf.com.tn/site/fr/tl-auto.43.html',
      route: AppRoutes.requestCreation,
      image: AppImages.cars,
      index: 11,
    ),
    Segments(
      name: 'Matériels et équipements',
      link: 'http://www.tlf.com.tn/site/fr/tl-equipement.46.html',
      route: AppRoutes.requestCreation,
      image: AppImages.materials,
      index: 11,
    ),
    Segments(
      name: 'Terrains et locaux professionnels',
      link: 'http://www.tlf.com.tn/site/fr/tl-immobilier.48.html',
      route: AppRoutes.requestCreation,
      image: AppImages.lands,
      index: 11,
    ),
  ];

  final List<Segments> quickAccessRoutes = <Segments>[
    Segments(
      name: 'Mon agence',
      route: AppRoutes.agencyDialog,
      isDialog: true,
      image: AppImages.homeSmile,
      index: 0,
    ),
    Segments(
      name: 'Demander une cotation',
      route: AppRoutes.quotationRequestCreation,
      arguments: <String, dynamic>{
        'creationMode': true,
      },
      image: AppImages.requestQuotation,
      index: 12,
    ),
    Segments(
      name: 'Demander un RDV',
      image: AppImages.calendarEvent,
      route: AppRoutes.rdvsList,
      arguments: {'shouldOpenRdvCreationModal': true},
      index: 13,
    ),
    Segments(
      name: 'Mes demandes de financement',
      route: AppRoutes.requestsList,
      image: AppImages.fundingShortcut,
      index: 11,
    ),
    Segments(
      name: 'Mes demandes de RDV',
      route: AppRoutes.rdvsList,
      image: AppImages.rdvs,
      index: 13,
    ),
    Segments(
      name: 'Mes échéanciers',
      route: AppRoutes.repaymentSchedule,
      image: AppImages.myRepaymetns,
      index: 3,
    ),
  ];
  int currentPage = 0;
}

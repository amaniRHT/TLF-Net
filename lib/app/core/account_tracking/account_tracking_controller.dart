import 'dart:async';

import 'package:e_loan_mobile/Helpers/base_controller.dart';
import 'package:e_loan_mobile/api/models/segments_model.dart';
import 'package:e_loan_mobile/config/images/app_images.dart';
import 'package:e_loan_mobile/routes/routing.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class AccountTrackingController extends BaseController {
  TabController tabController;
  RxInt current = 0.obs;

  Timer timer;

  final List<List<Segments>> quickAccessRoutes = <List<Segments>>[
    [
      Segments(
        name: 'Echéanciers de remboursement',
        image: AppImages.tracking1,
        route: AppRoutes.repaymentSchedule,
        index: 3,
      ),
      Segments(
        name: 'Contrats en vigueur',
        image: AppImages.tracking2,
        route: AppRoutes.inForceContracts,
        index: 3,
      ),
    ],
    [
      Segments(
        name: 'Contrats échus non encore achetés',
        image: AppImages.tracking3,
        route: AppRoutes.invalidContracts,
        index: 3,
      ),
      Segments(
        name: 'Contrats en cours de mise en place',
        image: AppImages.tracking4,
        route: AppRoutes.beingImplementedContracts,
        index: 3,
      ),
    ],
    [
      Segments(
        name: 'Mouvement de votre compte',
        image: AppImages.tracking5,
        route: AppRoutes.accountMovements,
        index: 3,
      ),
      Segments(
        name: 'Factures impayées',
        image: AppImages.tracking6,
        route: AppRoutes.unpaidBills,
        index: 3,
      ),
    ],
  ];
}

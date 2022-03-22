import 'package:e_loan_mobile/app/core/rdvs_list/rdvs_list_page.dart';
import 'package:e_loan_mobile/config/config.dart';
import 'package:e_loan_mobile/routes/app_routes.dart';
import 'package:e_loan_mobile/widgets/menu.dart';
import 'package:e_loan_mobile/widgets/widgets.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class SuccessPage extends StatefulWidget {
  const SuccessPage({Key key}) : super(key: key);
  @override
  _State createState() => _State();
}

class _State extends State<SuccessPage> {
  final int numberOfDayToTreatRequest = Get.arguments as int;

  @override
  Widget build(BuildContext context) {
    return SafeAreaManager(
      child: Scaffold(
        appBar: const CommonAppBar(),
        body: Padding(
          padding: const EdgeInsets.only(top: 70, left: 55, right: 55),
          child: Column(
            children: [
              _topLogos(),
              const VerticalSpacing(30),
              _congratsLabel(),
              const VerticalSpacing(15),
              _numberOfDaysToTreatRequest(),
              const VerticalSpacing(55),
              _takeRDVButton(),
              const VerticalSpacing(16),
              _previewCreatedRequestButton(),
            ],
          ),
        ),
      ),
    );
  }

  SizedBox _topLogos() {
    return SizedBox(
      width: 145,
      child: Stack(
        children: [
          Image.asset(
            AppImages.agree,
            height: 86,
            color: AppColors.darkerBlue.withOpacity(.18),
          ),
          Padding(
            padding: const EdgeInsets.only(top: 35, left: 40),
            child: Image.asset(
              AppImages.agree,
              height: 55,
            ),
          ),
        ],
      ),
    );
  }

  Text _numberOfDaysToTreatRequest() {
    return Text(
      numberOfDayToTreatRequest != null
          ? 'Votre demande a été envoyée avec succès, et elle sera traitée dans $numberOfDayToTreatRequest jours.'
          : 'Votre demande a été envoyée avec succès, et elle sera traitée dans 48 heures.',
      style: AppStyles.mediumBlue13,
      textAlign: TextAlign.center,
    );
  }

  Text _congratsLabel() {
    return const Text(
      'Félicitations !',
      style: AppStyles.boldBlue14,
    );
  }

  CommonButton _previewCreatedRequestButton() {
    return CommonButton(
      title: 'Consulter le statut de ma demande',
      titleColor: AppColors.darkestBlue,
      enabledColor: AppColors.lightBlue,
      onPressed: () {
        Get.offAllNamed(
          numberOfDayToTreatRequest != null ? AppRoutes.requestsList : AppRoutes.quotationRequestsList,
        );
      },
    );
  }

  CommonButton _takeRDVButton() {
    return CommonButton(
      title: 'Prendre un RDV',
      spacing: 12,
      icon: Image.asset(
        AppImages.calendar2,
        color: Colors.white,
        height: 18,
      ),
      onPressed: () {
        Get.find<MenuController>().selectedIndex.value = 13;
        comingFromNotificationsScreenToRDVsListPage = false;
        Get.offAllNamed(AppRoutes.rdvsList);
      },
    );
  }
}

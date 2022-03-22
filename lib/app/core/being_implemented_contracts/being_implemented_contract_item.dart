import 'package:e_loan_mobile/Helpers/helpers.dart';
import 'package:e_loan_mobile/app/controllers.dart';
import 'package:e_loan_mobile/config/config.dart';
import 'package:e_loan_mobile/widgets/widgets.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class BeingImplementedContractItem extends StatelessWidget {
  BeingImplementedContractItem({
    Key key,
    @required this.index,
  }) : super(key: key);

  final BeingImplementedContractsController controller = Get.find();
  final int index;

  @override
  Widget build(BuildContext context) {
    return CommonCollapseItem(
      index: index,
      leftTitle: RichText(
        text: TextSpan(
            text: 'Contrat N° ',
            style: AppStyles.boldBlue13,
            children: [
              TextSpan(
                text: controller
                        .beingImplementedContractsList[index]?.contractCode
                        .toString() ??
                    '',
                style: AppStyles.boldBlack13,
              )
            ]),
      ),
      bodyContent: Column(
        children: [
          const CustomDivider(1, AppColors.dividerGrey),
          const VerticalSpacing(11),
          CommonParameterRow(
            parameter: 'Objet',
            value: controller.beingImplementedContractsList[index]?.objet ?? '',
          ),
          CommonParameterRow(
            parameter: 'Montant (DT)',
            value: controller
                        .beingImplementedContractsList[index]?.montantFinance !=
                    null
                ? UsefullMethods.formatDoubleWithSpaceEach3Characters(controller
                            .beingImplementedContractsList[index]
                            ?.montantFinance ??
                        0) ??
                    ''
                : '',
          ),
          CommonParameterRow(
            parameter: 'Durée contrat (*)',
            value: controller.beingImplementedContractsList[index]?.dureeGlobale
                    .toString() ??
                '',
          ),
          CommonParameterRow(
            parameter: 'Valeur résiduelle (DT)',
            value: controller.beingImplementedContractsList[index]
                        ?.valeurResiduelle !=
                    null
                ? UsefullMethods.formatDoubleWithSpaceEach3Characters(controller
                            .beingImplementedContractsList[index]
                            ?.valeurResiduelle ??
                        0) ??
                    ''
                : '',
          ),
          CommonParameterRow(
            parameter: 'Durée résiduelle (*)',
            value: controller
                    .beingImplementedContractsList[index]?.dureeResiduelle
                    .toString() ??
                '',
          ),
          CommonParameterRow(
            parameter: 'Statut',
            value:
                controller.beingImplementedContractsList[index]?.statut ?? '',
          ),
          const VerticalSpacing(15)
        ],
      ),
    );
  }
}

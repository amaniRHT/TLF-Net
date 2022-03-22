import 'package:e_loan_mobile/Helpers/helpers.dart';
import 'package:e_loan_mobile/app/controllers.dart';
import 'package:e_loan_mobile/config/config.dart';
import 'package:e_loan_mobile/widgets/widgets.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class InValidContractItem extends StatelessWidget {
  InValidContractItem({
    Key key,
    @required this.index,
  }) : super(key: key);

  final InvalidContractsController controller = Get.find();
  final int index;

  @override
  Widget build(BuildContext context) {
    return CommonCollapseItem(
      index: index,
      leftTitle: Align(
        alignment: Alignment.centerLeft,
        child: Column(
          children: [
            Text(
              'Contrat N°',
              style: AppStyles.boldBlue13,
            ),
            Text(
              controller.invalidContractsList[index]?.contractCode.toString() ??
                  '',
              style: AppStyles.boldBlack13,
            )
          ],
        ),
      ),
      rightTitle: Align(
        alignment: Alignment.centerRight,
        child: Column(
          children: [
            Text(
              'Date 1er loyer',
              style: AppStyles.boldBlue13,
            ),
            Text(
              // UsefullMethods.formatInvalidDate(controller.invalidContractsList[index].datePremierLoyer),
              UsefullMethods.dateFormat.format(DateTime.parse(controller
                  .invalidContractsList[index].datePremierLoyer
                  .substring(0, 10))),
              style: AppStyles.boldBlack13,
            )
          ],
        ),
      ),
      bodyContent: Column(
        children: [
          const CustomDivider(1, AppColors.dividerGrey),
          const VerticalSpacing(11),
          CommonParameterRow(
            parameter: 'Objet',
            value: controller.invalidContractsList[index]?.objet ?? '',
          ),
          CommonParameterRow(
            parameter: 'Montant (DT)',
            value: controller.invalidContractsList[index]?.montantFinance !=
                    null
                ? UsefullMethods.formatDoubleWithSpaceEach3Characters(controller
                            .invalidContractsList[index]?.montantFinance ??
                        0) ??
                    ''
                : '',
          ),
          CommonParameterRow(
            parameter: 'Fin de contrat',
            value: UsefullMethods.dateFormat.format(DateTime.parse(controller
                .invalidContractsList[index].dateDernierLoyer
                .substring(0, 10))),
          ),
          CommonParameterRow(
            parameter: 'Durée contrat (*)',
            value: controller.invalidContractsList[index]?.dureeGlobale
                    .toString() ??
                '',
          ),
          CommonParameterRow(
            parameter: 'Valeur résiduelle (DT)',
            value: controller.invalidContractsList[index]?.valeurResiduelle !=
                    null
                ? UsefullMethods.formatDoubleWithSpaceEach3Characters(controller
                            .invalidContractsList[index]?.valeurResiduelle ??
                        0) ??
                    ''
                : '',
          ),
          CommonParameterRow(
            parameter: 'Durée résiduelle (*)',
            value: controller.invalidContractsList[index]?.dureeResiduelle
                    .toString() ??
                '',
          ),
          const VerticalSpacing(15)
        ],
      ),
    );
  }
}

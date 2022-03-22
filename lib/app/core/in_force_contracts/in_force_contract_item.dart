import 'package:e_loan_mobile/Helpers/helpers.dart';
import 'package:e_loan_mobile/app/controllers.dart';
import 'package:e_loan_mobile/config/config.dart';
import 'package:e_loan_mobile/widgets/widgets.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class InForceContractItem extends StatelessWidget {
  InForceContractItem({
    Key key,
    @required this.index,
  }) : super(key: key);

  final InForceContractsController controller = Get.find();
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
              controller.inForceContractsList[index]?.contractCode.toString() ??
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
              // UsefullMethods.formatInvalidDate(controller.inForceContractsList[index].datePremierLoyer),
              UsefullMethods.dateFormat.format(DateTime.parse(controller
                  .inForceContractsList[index].datePremierLoyer
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
            value: controller.inForceContractsList[index]?.objet ?? '',
            rightAlignValue: true,
          ),
          CommonParameterRow(
            parameter: 'Montant (DT)',
            value: controller.inForceContractsList[index]?.montantFinance !=
                    null
                ? UsefullMethods.formatDoubleWithSpaceEach3Characters(controller
                            .inForceContractsList[index]?.montantFinance ??
                        0) ??
                    ''
                : '',
          ),
          CommonParameterRow(
            parameter: 'Fin du contrat',
            value: UsefullMethods.dateFormat.format(DateTime.parse(controller
                .inForceContractsList[index].dateDernierLoyer
                .substring(0, 10))),
          ),
          CommonParameterRow(
            parameter: 'Durée contrat (*)',
            value: controller.inForceContractsList[index]?.dureeGlobale
                    .toString() ??
                '',
          ),
          CommonParameterRow(
            parameter: 'Valeur résiduelle (DT)',
            value: controller.inForceContractsList[index]?.valeurResiduelle !=
                    null
                ? UsefullMethods.formatDoubleWithSpaceEach3Characters(controller
                            .inForceContractsList[index]?.valeurResiduelle ??
                        0) ??
                    ''
                : '',
          ),
          CommonParameterRow(
            parameter: 'Durée résiduelle (*)',
            value: controller.inForceContractsList[index]?.dureeResiduelle
                    .toString() ??
                '',
          ),
          const VerticalSpacing(15)
        ],
      ),
    );
  }
}

import 'package:e_loan_mobile/Helpers/helpers.dart';
import 'package:e_loan_mobile/app/controllers.dart';
import 'package:e_loan_mobile/config/config.dart';
import 'package:e_loan_mobile/widgets/widgets.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class AccountMovementsItem extends StatelessWidget {
  AccountMovementsItem({
    Key key,
    @required this.index,
  }) : super(key: key);

  final AccountMovementsController controller = Get.find();
  final int index;

  @override
  Widget build(BuildContext context) {
    return CommonCollapseItem(
      index: index,
      leftTitle: Align(
        alignment: Alignment.centerLeft,
        child: Column(
          children: [
            const Text(
              'Contrat N°',
              style: AppStyles.boldBlue13,
            ),
            Text(
              controller.accountMovementsList[index]?.contractCode != null
                  ? controller.accountMovementsList[index]?.contractCode
                      .toString()
                  : '-',
              style: AppStyles.boldBlack13,
            )
          ],
        ),
      ),
      rightTitle: Align(
        alignment: Alignment.centerRight,
        child: Column(
          children: [
            const Text(
              'Référence',
              style: AppStyles.boldBlue13,
            ),
            Text(
              controller.accountMovementsList[index].documentNb ?? '',
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
            parameter: 'Libellé',
            value: controller.accountMovementsList[index]?.libelle ?? '',
            flexKey: 7,
          ),
          CommonParameterRow(
            parameter: 'Date opération',
            value: UsefullMethods.dateFormat.format(DateTime.parse(controller
                    .accountMovementsList[index].dateOperation
                    .substring(0, 10))) ??
                '',
            flexKey: 7,
          ),
          CommonParameterRow(
            parameter: 'Date échéance',
            value: UsefullMethods.dateFormat.format(DateTime.parse(controller
                    .accountMovementsList[index].dateEcheance
                    .substring(0, 10))) ??
                '',
            flexKey: 7,
          ),
          CommonParameterRow(
            parameter: 'Montant débit (DT)',
            value: controller.accountMovementsList[index]?.montantDebit != null
                ? UsefullMethods.formatDoubleWithSpaceEach3Characters(
                        controller.accountMovementsList[index]?.montantDebit ??
                            0) ??
                    '-'
                : '',
            flexKey: 7,
          ),
          CommonParameterRow(
            parameter: 'Montant crédit (DT)',
            value: controller.accountMovementsList[index]?.montantCredit != null
                ? UsefullMethods.formatDoubleWithSpaceEach3Characters(
                        controller.accountMovementsList[index]?.montantCredit ??
                            0) ??
                    '-'
                : '',
            flexKey: 7,
          ),
          const VerticalSpacing(15)
        ],
      ),
    );
  }
}

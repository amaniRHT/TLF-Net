import 'package:e_loan_mobile/Helpers/helpers.dart';
import 'package:e_loan_mobile/app/controllers.dart';
import 'package:e_loan_mobile/config/config.dart';
import 'package:e_loan_mobile/widgets/widgets.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class UnpaidBillsItem extends StatelessWidget {
  UnpaidBillsItem({
    Key key,
    @required this.index,
  }) : super(key: key);

  final UnpaidBillsController controller = Get.find();
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
              controller.unpaidBillsList[index]?.contractCode.toString() ?? '',
              textAlign: TextAlign.center,
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
              'Référence',
              style: AppStyles.boldBlue13,
            ),
            Text(
              controller.unpaidBillsList[index].documentNb.split(' ').first ??
                  '',
              textAlign: TextAlign.center,
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
            value: controller.unpaidBillsList[index]?.libelle ?? '',
            rightAlignValue: true,
          ),
          CommonParameterRow(
            parameter: 'Echéance',
            value: UsefullMethods.dateFormat.format(DateTime.parse(controller
                    .unpaidBillsList[index].dateEcheance
                    .substring(0, 10))) ??
                '',
          ),
          CommonParameterRow(
            parameter: 'Montant facture (DT)',
            value: controller.unpaidBillsList[index]?.montantFacture != null
                ? UsefullMethods.formatDoubleWithSpaceEach3Characters(
                        controller.unpaidBillsList[index]?.montantFacture ??
                            0) ??
                    '-'
                : '',
          ),
          CommonParameterRow(
            parameter: 'Reste à régler (DT)',
            value: controller.unpaidBillsList[index]?.montantFacture != null
                ? UsefullMethods.formatDoubleWithSpaceEach3Characters(
                        controller.unpaidBillsList[index]?.resteARegler ?? 0) ??
                    '-'
                : '',
          ),
          const VerticalSpacing(15)
        ],
      ),
    );
  }
}

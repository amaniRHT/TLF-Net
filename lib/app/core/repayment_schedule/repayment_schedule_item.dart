import 'package:e_loan_mobile/Helpers/helpers.dart';
import 'package:e_loan_mobile/api/models/repayment_schedule_list_response.dart';
import 'package:e_loan_mobile/app/controllers.dart';
import 'package:e_loan_mobile/config/config.dart';
import 'package:e_loan_mobile/widgets/widgets.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class RepaymentScheduleItem extends StatelessWidget {
  RepaymentScheduleItem({
    Key key,
    @required this.index,
    this.repayment,
  }) : super(key: key);

  final RepaymentScheduleController controller = Get.find();
  final int index;
  final Echeanciers repayment;

  @override
  Widget build(BuildContext context) {
    return CommonCollapseItem(
      staticColor: AppColors.bgGrey,
      index: index,
      leftTitle: Align(
        alignment: Alignment.centerLeft,
        child: RichText(
          text: TextSpan(
              text: 'Loyer N° ',
              style: AppStyles.boldBlue13,
              children: [
                TextSpan(
                  text: repayment.numLoyer.toString() ?? '',
                  style: AppStyles.boldBlack13,
                )
              ]),
        ),
      ),
      rightTitle: Text(
        repayment.dateFinLoyer != null
            ? UsefullMethods.dateFormat.format(
                DateTime.parse(repayment.dateDebutLoyer.substring(0, 10)))
            : '-',
        style: AppStyles.boldBlue13,
      ),
      bodyContent: Column(
        children: [
          const CustomDivider(1, AppColors.dividerGrey),
          const VerticalSpacing(7),
          CommonParameterRow(
            parameter: 'Loyer TTC (DT)',
            value: repayment.loyerTtc != null
                ? UsefullMethods.formatDoubleWithSpaceEach3Characters(
                    repayment.loyerTtc ?? 0)
                : '',
          ),
          CommonParameterRow(
            parameter: 'Loyer HT (DT)',
            value: repayment.loyerHt != null
                ? UsefullMethods.formatDoubleWithSpaceEach3Characters(
                        repayment.loyerHt ?? 0) ??
                    ''
                : '',
          ),
          CommonParameterRow(
            parameter: 'intérêts (DT)',
            value: repayment.interets != null
                ? UsefullMethods.formatDoubleWithSpaceEach3Characters(
                        repayment.interets ?? 0) ??
                    ''
                : '',
          ),
          CommonParameterRow(
            parameter: 'Amortissement (DT)',
            value: repayment.amortissement != null
                ? UsefullMethods.formatDoubleWithSpaceEach3Characters(
                        repayment.amortissement ?? 0) ??
                    ''
                : '',
          ),
          CommonParameterRow(
            parameter: 'Services (DT)',
            value: repayment.services != null
                ? UsefullMethods.formatDoubleWithSpaceEach3Characters(
                        repayment.services ?? 0) ??
                    ''
                : '',
          ),
          CommonParameterRow(
            parameter: 'Restant dû (DT)',
            value: repayment.restantdu != null
                ? UsefullMethods.formatDoubleWithSpaceEach3Characters(
                        repayment.restantdu ?? 0) ??
                    ''
                : '',
          ),
          const VerticalSpacing(15)
        ],
      ),
    );
  }
}

import 'package:e_loan_mobile/config/colors/app_colors.dart';
import 'package:e_loan_mobile/widgets/widgets.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class CommonBackButton extends StatelessWidget {
  const CommonBackButton({
    Key key,
    this.onPressed,
  }) : super(key: key);

  final void Function() onPressed;
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const Spacer(),
        Row(
          children: [
            Expanded(
              child: CommonButton(
                title: 'Retour',
                titleColor: AppColors.darkestBlue,
                enabledColor: AppColors.lightBlue,
                icon: const Icon(
                  Icons.arrow_back_ios,
                  size: 17,
                  color: AppColors.darkestBlue,
                ),
                onPressed: () {
                  onPressed == null ? Get.back() : onPressed();
                },
              ),
            )
          ],
        ),
        const VerticalSpacing(12),
      ],
    );
  }
}

import 'package:e_loan_mobile/Helpers/keys_storage.dart';
import 'package:e_loan_mobile/config/config.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

Future<bool> appEscapingDialog({
  String content,
  String confirmationText,
  String cancelText,
}) {
  return showDialog<bool>(
      context: KeysStorage.mainNavigatorKey.currentContext,
      builder: (BuildContext context) {
        return Padding(
          padding: EdgeInsets.symmetric(horizontal: context.isTablet ? 160 : 20),
          child: AlertDialog(
            title: Row(
              children: [
                const Spacer(),
                Image.asset(
                  AppImages.secondLogo,
                  height: 30,
                ),
                const Spacer(),
              ],
            ),
            content: Padding(
              padding: const EdgeInsets.only(top: 8.0),
              child: Text(
                content,
                style: AppStyles.mediumBlue14.copyWith(fontSize: 14),
                textAlign: TextAlign.center,
              ),
            ),
            buttonPadding: const EdgeInsets.all(0),
            actionsPadding: const EdgeInsets.fromLTRB(20, 0, 20, 20),
            actions: [
              SizedBox(
                width: double.maxFinite,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    _buildConfirmButton(confirmationText),
                    _buildCancelButton(cancelText),
                  ],
                ),
              )
            ],
          ),
        );
      });
}

ElevatedButton _buildCancelButton(String cancel) {
  return ElevatedButton(
    style: ButtonStyle(
      foregroundColor: MaterialStateProperty.all<Color>(Colors.white),
      backgroundColor: MaterialStateProperty.all<Color>(
        AppColors.lighterBlue,
      ),
      shape: MaterialStateProperty.all<RoundedRectangleBorder>(
        const RoundedRectangleBorder(
          borderRadius: AppConstants.smallBorderRadius,
        ),
      ),
    ),
    onPressed: () {
      Get.back<bool>(result: false);
    },
    child: Text(
      cancel,
      style: AppStyles.boldBlue14.copyWith(color: AppColors.darkestBlue),
    ),
  );
}

ElevatedButton _buildConfirmButton(String confirm) {
  return ElevatedButton(
    style: ButtonStyle(
      foregroundColor: MaterialStateProperty.all<Color>(Colors.white),
      backgroundColor: MaterialStateProperty.all<Color>(
        AppColors.orange,
      ),
      shape: MaterialStateProperty.all<RoundedRectangleBorder>(
        const RoundedRectangleBorder(
          borderRadius: AppConstants.smallBorderRadius,
        ),
      ),
    ),
    onPressed: () {
      Get.back<bool>(result: true);
    },
    child: Text(
      confirm,
      style: AppStyles.boldBlue14.copyWith(color: Colors.white),
    ),
  );
}

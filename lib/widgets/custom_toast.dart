import 'package:e_loan_mobile/widgets/horizontal_spacing.dart';
import 'package:e_loan_mobile/widgets/vertical_spacing.dart';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:e_loan_mobile/config/config.dart';

enum ToastTypes {
  success,
  warning,
  error,
  push,
}
Future<void> showCustomToast({
  int showAfterInMilliseconds = 0,
  ToastTypes toastType = ToastTypes.success,
  @required String contentText,
  double padding = 40,
  bool onTheTop = true,
  int duration = 5,
  bool blurEffectEnabled = true,
}) async {
  await Future.delayed(Duration(milliseconds: showAfterInMilliseconds));

  Get.snackbar(
    '',
    '',
    snackPosition: onTheTop ? SnackPosition.TOP : SnackPosition.BOTTOM,
    margin: EdgeInsets.only(
      left: toastType == ToastTypes.push ? 10 : 20,
      right: toastType == ToastTypes.push ? 10 : 20,
      top: onTheTop ? padding : 0,
      bottom: onTheTop ? 0 : padding,
    ),
    overlayBlur: blurEffectEnabled ? 3 : 0,
    backgroundColor: Colors.white,
    borderColor: toastType == ToastTypes.success
        ? AppColors.green
        : toastType == ToastTypes.error
            ? AppColors.red
            : toastType == ToastTypes.warning
                ? AppColors.orange
                : AppColors.darkerBlue,
    borderWidth: 0.6,
    boxShadows: <BoxShadow>[
      BoxShadow(
        color: toastType == ToastTypes.success
            ? AppColors.green.withOpacity(0.1)
            : toastType == ToastTypes.error
                ? AppColors.red.withOpacity(0.1)
                : toastType == ToastTypes.warning
                    ? AppColors.orange.withOpacity(0.1)
                    : AppColors.blue.withOpacity(0.1),
        spreadRadius: toastType == ToastTypes.push ? 20 : 4,
        blurRadius: toastType == ToastTypes.push ? 20 : 4,
      )
    ],
    onTap: (GetBar<Object> _) {
      Get.back();
    },
    borderRadius: AppConstants.smallRadiusValue,
    animationDuration: const Duration(milliseconds: 400),
    duration: Duration(seconds: duration),
    padding: const EdgeInsets.only(top: 10, bottom: 7),
    titleText: toastType == ToastTypes.push
        ? Wrap(
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Text(
                          'Tunisie Leasing & Facotring',
                          style: AppStyles.boldBlue14.copyWith(
                            fontStyle: FontStyle.italic,
                            fontSize: 16,
                          ),
                          overflow: TextOverflow.ellipsis,
                        ),
                        const Spacer(),
                        Image.asset(
                          AppImages.secondLogo,
                          height: 22,
                        ),
                      ],
                    ),
                    const VerticalSpacing(8),
                    Padding(
                      padding: const EdgeInsets.only(left: 2, right: 30),
                      child: Text(
                        contentText,
                        maxLines: 10,
                        style: AppStyles.mediumDarkGrey13.copyWith(fontSize: 14),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          )
        : Row(
            children: [
              const HorizontalSpacing(12),
              Icon(
                toastType == ToastTypes.success
                    ? Icons.check
                    : toastType == ToastTypes.error
                        ? Icons.close
                        : Icons.warning,
                size: 28,
                color: toastType == ToastTypes.success
                    ? AppColors.green
                    : toastType == ToastTypes.error
                        ? AppColors.red
                        : AppColors.orange,
              ),
              const HorizontalSpacing(12),
              Flexible(
                child: Text(
                  contentText,
                  maxLines: 10,
                  style: AppStyles.mediumDarkGrey13,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              const HorizontalSpacing(16),
            ],
          ),
    messageText: const SizedBox(
      height: 0,
      width: 0,
    ),
  );
  await duration.delay();
  await Future.delayed(const Duration(milliseconds: 300));
  return;
}

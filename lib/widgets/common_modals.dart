import 'package:e_loan_mobile/Helpers/keys_storage.dart';
import 'package:e_loan_mobile/config/config.dart';
import 'package:e_loan_mobile/widgets/widgets.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

enum ModalTypes { alert, error }

bool commonModalIsVisible = false;
Future<void> showCommonModal({
  @required ModalTypes modalType,
  String title,
  @required String message,
  String secondaryMessage,
  @required String buttonTitle,
  @required Function() onPressed,
  bool withCancelButton = false,
}) {
  if (commonModalIsVisible) return Future.value();

  commonModalIsVisible = true;

  return showDialog(
    barrierDismissible: false,
    context: KeysStorage.mainNavigatorKey.currentContext,
    builder: (_) => AlertDialog(
      insetPadding: EdgeInsets.zero,
      contentPadding: EdgeInsets.zero,
      shape: const RoundedRectangleBorder(
        borderRadius: AppConstants.largeBorderRadius,
      ),
      content: Container(
        width: Get.context.isPhone ? Get.context.width * 0.9 : Get.context.width * 0.5,
        padding: const EdgeInsets.only(
          bottom: 22,
          left: 30,
          top: 22,
          right: 30,
        ),
        child: ClipRRect(
          borderRadius: AppConstants.regularBorderRadius,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              const VerticalSpacing(10),
              _buildMessageLabel(message),
              if (secondaryMessage != null) _buildSecondaryMessage(secondaryMessage),
              VerticalSpacing(secondaryMessage != null ? 32 : 26),
              if (withCancelButton)
                _buildCancelButton(buttonTitle, onPressed)
              else
                _buildConfirmationButton(buttonTitle, onPressed),
              const VerticalSpacing(5),
            ],
          ),
        ),
      ),
    ),
  );
}

Text _buildMessageLabel(String message) {
  return Text(
    message,
    textAlign: TextAlign.center,
    style: AppStyles.boldBlue14.copyWith(color: Colors.black),
  );
}

Column _buildSecondaryMessage(String secondaryMessage) {
  return Column(
    children: <Widget>[
      const VerticalSpacing(16),
      Text(
        secondaryMessage,
        textAlign: TextAlign.center,
        style: AppStyles.regularBlue12.copyWith(color: Colors.black),
      ),
    ],
  );
}

CommonButton _buildConfirmationButton(String buttonTitle, Function() onPressed) {
  return CommonButton(
    title: buttonTitle,
    onPressed: () {
      commonModalIsVisible = false;
      onPressed();
    },
  );
}

Row _buildCancelButton(String buttonTitle, Function() onPressed) {
  return Row(
    children: <Widget>[
      Expanded(
        child: CommonButton(
          enabledColor: AppColors.lightBlue,
          title: 'Annuler',
          titleColor: AppColors.darkestBlue,
          onPressed: () {
            commonModalIsVisible = false;
            Get.back(closeOverlays: true);
          },
        ),
      ),
      const SizedBox(width: 15),
      Expanded(
        child: _buildConfirmationButton(buttonTitle, onPressed),
      ),
    ],
  );
}

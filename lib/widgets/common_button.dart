import 'package:e_loan_mobile/config/config.dart';
import 'package:flutter/material.dart';

import 'horizontal_spacing.dart';

class CommonButton extends StatelessWidget {
  const CommonButton({
    Key key,
    this.width = double.infinity,
    @required this.title,
    this.icon,
    this.iconOnTheLeft = true,
    this.spacing = 6,
    this.titleColor = Colors.white,
    this.enabledColor = AppColors.orange,
    this.disabledColor = AppColors.inactiveOrange,
    this.enablingCondition = true,
    @required this.onPressed,
  }) : super(key: key);

  final double width;
  final String title;
  final Widget icon;
  final bool enablingCondition;
  final Color titleColor;
  final Color enabledColor;
  final Color disabledColor;
  final bool iconOnTheLeft;
  final void Function() onPressed;
  final double spacing;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: width,
      height: AppConstants.regularButtonHeight,
      child: ElevatedButton(
        style: ButtonStyle(
          foregroundColor: MaterialStateProperty.all<Color>(Colors.white),
          backgroundColor: MaterialStateProperty.all<Color>(
            enablingCondition ? enabledColor : disabledColor,
          ),
          shape: MaterialStateProperty.all<RoundedRectangleBorder>(
            const RoundedRectangleBorder(
              borderRadius: AppConstants.smallBorderRadius,
            ),
          ),
        ),
        onPressed: enablingCondition ? onPressed : null,
        child: icon != null
            ? iconOnTheLeft
                ? Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      icon,
                      HorizontalSpacing(spacing),
                      Text(
                        title,
                        style: AppStyles.boldBlue13.copyWith(
                          color: titleColor ?? Colors.white,
                        ),
                      ),
                    ],
                  )
                : Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        title,
                        style: AppStyles.boldBlue13.copyWith(
                          color: titleColor ?? Colors.white,
                        ),
                      ),
                      HorizontalSpacing(spacing),
                      icon,
                    ],
                  )
            : Text(
                title,
                style: AppStyles.boldBlue13.copyWith(
                  color: titleColor ?? Colors.white,
                ),
              ),
      ),
    );
  }
}

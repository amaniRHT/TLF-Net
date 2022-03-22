import 'package:e_loan_mobile/config/colors/app_colors.dart';
import 'package:flutter/material.dart';

class PasswordVisiblityToggler extends StatelessWidget {
  const PasswordVisiblityToggler({
    Key key,
    @required this.visibilityCondition,
    @required this.onPressed,
  }) : super(key: key);

  final bool visibilityCondition;
  final void Function() onPressed;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 30,
      child: IconButton(
        splashColor: Colors.transparent,
        highlightColor: Colors.transparent,
        icon: Icon(
          visibilityCondition ? Icons.visibility_off : Icons.visibility,
          color: AppColors.darkestBlue,
          size: 21,
        ),
        onPressed: onPressed,
      ),
    );
  }
}

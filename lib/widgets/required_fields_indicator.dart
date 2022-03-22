import 'package:e_loan_mobile/config/styles/app_styles.dart';
import 'package:flutter/material.dart';

class RequiredFieldsIndicator extends StatelessWidget {
  const RequiredFieldsIndicator({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const Text(
      '* Champs obligatoires',
      style: AppStyles.mediumDarkGrey12,
    );
  }
}

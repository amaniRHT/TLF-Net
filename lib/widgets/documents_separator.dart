import 'package:e_loan_mobile/config/colors/app_colors.dart';
import 'package:flutter/material.dart';

class DocumentsSeparator extends StatelessWidget {
  const DocumentsSeparator({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 1,
      color: AppColors.lightBlue,
    );
  }
}

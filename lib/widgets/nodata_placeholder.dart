import 'package:e_loan_mobile/config/styles/app_styles.dart';
import 'package:e_loan_mobile/widgets/vertical_spacing.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class NoDataPlaceholder extends StatelessWidget {
  const NoDataPlaceholder({
    Key key,
    @required this.placeholderText,
    @required this.onPressed,
  }) : super(key: key);

  final String placeholderText;
  final void Function() onPressed;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        children: [
          VerticalSpacing(Get.context.height * 0.1),
          Text(
            placeholderText,
            style: AppStyles.regularDarkGrey12,
          ),
          IconButton(
            splashColor: Colors.black12,
            onPressed: onPressed,
            icon: Icon(Icons.refresh),
          )
        ],
      ),
    );
  }
}

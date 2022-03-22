import 'package:e_loan_mobile/config/config.dart';
import 'package:flutter/material.dart';

import 'vertical_spacing.dart';

class CommonTitle extends StatelessWidget {
  const CommonTitle({
    Key key,
    @required this.title,
    this.padding = 0,
  }) : super(key: key);

  final String title;
  final double padding;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(left: padding),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text(title, style: AppStyles.boldBlue14),
          const VerticalSpacing(5),
          Container(
            width: 40,
            height: 2,
            color: AppColors.orange,
          )
        ],
      ),
    );
  }
}

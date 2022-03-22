import 'package:e_loan_mobile/config/config.dart';
import 'package:flutter/material.dart';

class TotalResult extends StatelessWidget {
  const TotalResult({
    Key key,
    @required this.title,
  }) : super(key: key);

  final String title;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 12.0),
      child: Text(title, style: AppStyles.mediumBlue10),
    );
  }
}

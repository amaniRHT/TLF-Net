

import 'package:flutter/material.dart';
import 'package:e_loan_mobile/config/config.dart';

class CustomBadge extends StatelessWidget {
  const CustomBadge(this.width, this.height, this.color, this.text);
  final double width;
  final double height;
  final Color color;
  final String text;
  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      height: height,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: color,
      ),
      child: Center(
        child: Text(
          text,
          style: AppStyles.semiBoldWhite11,
        ),
      ),
    );
  }
}

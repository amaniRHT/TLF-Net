import 'package:e_loan_mobile/config/styles/app_styles.dart';
import 'package:e_loan_mobile/widgets/horizontal_spacing.dart';
import 'package:flutter/material.dart';

class CommonCardInfo extends StatelessWidget {
  const CommonCardInfo({
    Key key,
    this.bgColor,
    this.hasBorder,
    this.title,
    this.value,
    this.borderColor,
  }) : super(key: key);

  final Color bgColor;
  final bool hasBorder;
  final String title;
  final String value;
  final Color borderColor;
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: bgColor,
        border: hasBorder ? Border.all(color: borderColor, width: 1.5) : null,
        borderRadius: BorderRadius.circular(5.0),
        boxShadow: const <BoxShadow>[
          BoxShadow(
            color: Colors.black12,
            blurRadius: 3.0,
            offset: const Offset(1.0, 1.0),
          ),
        ],
      ),
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 18),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            child: Text(
              title,
              style: AppStyles.boldBlue13,
            ),
          ),
          const HorizontalSpacing(12),
          Text(
            value,
            style: AppStyles.boldBlack13.copyWith(fontSize: 14),
          ),
        ],
      ),
    );
  }
}

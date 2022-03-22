import 'package:e_loan_mobile/config/config.dart';
import 'package:flutter/material.dart';

class CommonParameterRow extends StatelessWidget {
  const CommonParameterRow({
    Key key,
    @required this.parameter,
    this.value,
    this.flexKey = 6,
    this.flexValue = 7,
    this.rightAlignValue = true,
    this.isMultiline = false,
  }) : super(key: key);

  final String parameter;
  final String value;
  final int flexKey;
  final int flexValue;
  final bool rightAlignValue;
  final bool isMultiline;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 8.0, left: 18.0, right: 15.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            flex: flexKey,
            child: Text(parameter, style: AppStyles.boldBlue13),
          ),
          Expanded(
            flex: flexValue,
            child: Text(
              value,
              style: AppStyles.mediumBlue13,
              maxLines: isMultiline ? 2 : 1,
              overflow: TextOverflow.ellipsis,
              // textAlign: rightAlignValue ? TextAlign.right : TextAlign.left,
              textAlign: TextAlign.left,
            ),
          ),
          const Spacer()
        ],
      ),
    );
  }
}

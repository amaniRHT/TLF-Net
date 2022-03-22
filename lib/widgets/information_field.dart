import 'package:e_loan_mobile/Helpers/usefull_metods.dart';
import 'package:e_loan_mobile/config/config.dart';
import 'package:flutter/material.dart';

class InformationField extends StatelessWidget {
  const InformationField({
    Key key,
    @required this.parameter,
    @required this.value,
    this.visible = true,
    this.keysFlex = 60,
    this.shouldFormatValue = true,
  }) : super(key: key);

  final String parameter;
  final String value;
  final bool visible;
  final int keysFlex;
  final bool shouldFormatValue;
  @override
  Widget build(BuildContext context) {
    return Visibility(
      visible: visible,
      child: Padding(
        padding: const EdgeInsets.only(
          bottom: 12,
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
                flex: keysFlex,
                child: Text(
                  parameter,
                  style: AppStyles.boldBlue11,
                )),
            const Spacer(),
            Expanded(
              flex: 47,
              child: Text(
                shouldFormatValue
                    ? UsefullMethods.formatStringWithSpaceEach3Characters(value)
                    : value,
                style: AppStyles.mediumBlue13,
              ),
            )
          ],
        ),
      ),
    );
  }
}

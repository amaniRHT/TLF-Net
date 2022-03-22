import 'package:e_loan_mobile/config/config.dart';
import 'package:flutter/material.dart';

class CommonCollapseItem extends StatelessWidget {
  const CommonCollapseItem({
    Key key,
    this.index,
    this.leftTitle,
    this.rightTitle,
    this.bodyContent,
    this.staticColor,
    this.leftTitleKeyFlex = 2,
  }) : super(key: key);

  final int index;
  final Widget leftTitle;
  final Widget rightTitle;
  final Widget bodyContent;
  final Color staticColor;
  final int leftTitleKeyFlex;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 3),
      child: Card(
        color: staticColor != null
            ? staticColor
            : index.isEven
                ? AppColors.bgGrey
                : AppColors.lighterBlue,
        elevation: 3,
        child: _dataSection(),
      ),
    );
  }

  ExpansionTile _dataSection() {
    return ExpansionTile(
      title: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            flex: leftTitleKeyFlex,
            child: leftTitle,
          ),
          Expanded(
            flex: 2,
            child: Align(
              alignment: Alignment.centerRight,
              child: rightTitle,
            ),
          ),
        ],
      ),
      tilePadding: const EdgeInsets.symmetric(horizontal: 12),
      childrenPadding: EdgeInsets.zero,
      children: <Widget>[
        Container(
          color: Colors.white,
          child: bodyContent,
        )
      ],
    );
  }
}

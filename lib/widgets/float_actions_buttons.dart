import 'package:e_loan_mobile/config/config.dart';
import 'package:e_loan_mobile/widgets/widgets.dart';
import 'package:flutter/material.dart';

class FloatActions extends StatelessWidget {
  const FloatActions({
    Key key,
    this.onAddPressed,
    this.filterCount,
    this.onFilterPressed,
    this.iconData,
    this.visible = true,
    this.toolTip = '',
    this.showSearchButton = true,
    this.showTextInfo = false,
    this.showMonthInfo = true,
    this.paddingBottom = 6,
    this.paddingTop = 6,
    this.downloadButtonEnabled = true,
  }) : super(key: key);

  final void Function() onAddPressed;
  final void Function() onFilterPressed;
  final String filterCount;
  final IconData iconData;
  final bool visible;
  final String toolTip;
  final bool showSearchButton;
  final bool showTextInfo;
  final bool showMonthInfo;
  final double paddingBottom;
  final double paddingTop;
  final bool downloadButtonEnabled;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Visibility(
                maintainState: false,
                maintainSize: false,
                maintainAnimation: false,
                visible: showSearchButton,
                child: Padding(
                  padding: const EdgeInsets.only(top: 15.0),
                  child: Stack(
                    children: [
                      FilterButton(
                        onTap: onFilterPressed,
                      ),
                      Positioned(
                        right: 4.0,
                        child: CustomBadge(
                          17,
                          17,
                          AppColors.blue,
                          filterCount,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              Visibility(
                maintainState: false,
                maintainSize: false,
                maintainAnimation: false,
                visible: showTextInfo,
                child: Container(
                  margin: const EdgeInsets.only(top: 5),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.9),
                    border: Border.all(color: AppColors.grey, width: 1.5),
                    borderRadius: BorderRadius.circular(5.0),
                    boxShadow: const <BoxShadow>[
                      BoxShadow(
                        color: Colors.black12,
                        blurRadius: 3.0,
                        offset: const Offset(1.0, 1.0),
                      ),
                    ],
                  ),
                  padding: EdgeInsets.only(
                    left: 5,
                    right: 5,
                    top: paddingTop,
                    bottom: paddingBottom,
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Visibility(
                        visible: showMonthInfo,
                        child: Text(
                          ' * Durée en mois',
                          style: AppStyles.semiBoldBlue13.copyWith(
                            color: Colors.grey,
                          ),
                        ),
                      ),
                      const VerticalSpacing(5),
                      Row(
                        children: [
                          Icon(
                            Icons.info_rounded,
                            color: Colors.grey,
                            size: 19,
                          ),
                          const HorizontalSpacing(5),
                          Text(
                            'Sauf erreur ou omission',
                            style: AppStyles.semiBoldBlue13.copyWith(
                              color: Colors.grey,
                            ),
                          ),
                        ],
                      )
                    ],
                  ),
                ),
              ),
              const VerticalSpacing(5),
            ],
          ),
          Visibility(
            maintainState: true,
            maintainSize: true,
            maintainAnimation: true,
            visible: visible,
            child: FloatingActionButton(
                backgroundColor:
                    downloadButtonEnabled ? AppColors.orange : AppColors.grey,
                tooltip: toolTip,
                onPressed: downloadButtonEnabled ? onAddPressed : null,
                child: Icon(
                  iconData,
                  color: Colors.white,
                  size: 27,
                )),
          )
        ],
      ),
    );
  }
}

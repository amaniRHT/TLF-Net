import 'package:e_loan_mobile/config/config.dart';
import 'package:flutter/material.dart';

class FilterButton extends StatelessWidget {
  const FilterButton({
    Key key,
    this.onTap,
  }) : super(key: key);

  final void Function() onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            margin: const EdgeInsets.only(top: 5,right: 12),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.9),
              border: Border.all(color: AppColors.darkerBlue, width: 1.5),
              borderRadius: BorderRadius.circular(5.0),
              boxShadow: const <BoxShadow>[
                BoxShadow(
                  color: Colors.black12,
                  blurRadius: 3.0,
                  offset: Offset(1.0, 1.0),
                ),
              ],
            ),
            padding:
                const EdgeInsets.only(left: 12, right: 19, top: 7, bottom: 8),
            child: const Center(
              child: Text(
                'Filtrer votre recherche',
                style: AppStyles.semiBoldBlue13,
              ),
            ),
          )
        ],
      ),
    );
  }
}

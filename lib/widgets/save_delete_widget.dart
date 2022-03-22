import 'package:e_loan_mobile/config/config.dart';
import 'package:e_loan_mobile/widgets/widgets.dart';
import 'package:flutter/material.dart';

class SaveOrDeleteWidget extends StatelessWidget {
  const SaveOrDeleteWidget({
    Key key,
    @required this.onSaveTapped,
    this.onDeleteTapped,
  }) : super(key: key);

  final void Function() onSaveTapped;
  final void Function() onDeleteTapped;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        const Spacer(),
        _buildSaveButton(),
        const HorizontalSpacing(5),
        _buildActionsSeparator(),
        const HorizontalSpacing(5),
        buildDeleteButton(),
        const Spacer(),
      ],
    );
  }

  GestureDetector _buildSaveButton() {
    return GestureDetector(
      onTap: onSaveTapped,
      child: Container(
        color: Colors.white,
        width: 30,
        height: 30,
        padding: const EdgeInsets.all(7),
        child: Image.asset(
          AppImages.save,
        ),
      ),
    );
  }

  Widget _buildActionsSeparator() {
    return Container(
      width: 1,
      height: 17,
      color: AppColors.lightGrey,
    );
  }

  GestureDetector buildDeleteButton() {
    return GestureDetector(
      onTap: onDeleteTapped,
      child: Container(
        color: Colors.white,
        width: 30,
        height: 30,
        padding: const EdgeInsets.all(6),
        child: Image.asset(
          AppImages.delete,
        ),
      ),
    );
  }
}

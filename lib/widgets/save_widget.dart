import 'package:e_loan_mobile/config/config.dart';
import 'package:flutter/material.dart';

class SaveWidget extends StatelessWidget {
  const SaveWidget({
    Key key,
    @required this.onTap,
  }) : super(key: key);

  final void Function() onTap;
  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        const Spacer(),
        _buildSaveButton(),
        const Spacer(),
      ],
    );
  }

  GestureDetector _buildSaveButton() {
    return GestureDetector(
      onTap: onTap,
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
}

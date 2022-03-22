import 'package:e_loan_mobile/config/config.dart';
import 'package:flutter/material.dart';

class StatusIndicator extends StatelessWidget {
  const StatusIndicator({
    this.widht,
    this.height,
    this.statusColor = AppColors.blue,
  });

  final double widht;
  final double height;
  final Color statusColor;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: widht,
      height: height,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: statusColor,
      ),
    );
  }
}

import 'package:flutter/material.dart';

class CustomDivider extends StatelessWidget {
  const CustomDivider(
    this.height,
    this.color,
  );

  final double height;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: height,
      color: color,
    );
  }
}

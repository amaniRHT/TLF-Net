

import 'package:flutter/material.dart';

class HorizontalSpacing extends StatelessWidget {
  const HorizontalSpacing(this.widht);

  final double widht;

  @override
  Widget build(BuildContext context) {
    return SizedBox(width: widht);
  }
}

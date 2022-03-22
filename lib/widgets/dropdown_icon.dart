import 'package:flutter/material.dart';

class DropdownIcon extends StatelessWidget {
  const DropdownIcon({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const Icon(
      Icons.arrow_drop_down,
      color: Colors.black,
      size: 20,
    );
  }
}

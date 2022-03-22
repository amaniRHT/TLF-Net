import 'package:flutter/material.dart';

class CustomIconButton extends StatelessWidget {
  const CustomIconButton({
    this.width,
    this.height,
    this.color,
    this.image,
    this.onTap,
  });
  final double width;
  final double height;
  final Color color;
  final String image;
  final void Function() onTap;
  @override
  GestureDetector build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        color: Colors.transparent,
        width: width,
        height: height,
        padding: const EdgeInsets.all(9.0),
        child: Image.asset(
          image,
          color: color,
        ),
      ),
    );
  }
}

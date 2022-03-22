import 'package:e_loan_mobile/app/controllers.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class SafeAreaManager extends StatelessWidget {
  const SafeAreaManager({
    Key key,
    this.child,
  }) : super(key: key);

  final Widget child;

  @override
  Widget build(BuildContext context) => GetBuilder<NotificationsController>(
        builder: (_) {
          return GetPlatform.isIOS ? SafeArea(child: child) : child;
        },
      );
}

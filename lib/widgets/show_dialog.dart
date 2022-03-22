import 'package:e_loan_mobile/Helpers/keys_storage.dart';
import 'package:flutter/material.dart';

Future<void> presentDialog(Widget Function() targetDialog,
    {final bool barrierDismissible = false,
    Color barrierColor = Colors.black12}) {
  return showDialog(
    context: KeysStorage.mainNavigatorKey.currentContext,
    builder: (BuildContext context) => targetDialog(),
    barrierDismissible: barrierDismissible,
    barrierColor: barrierColor,
  ).then((value) => null);
}

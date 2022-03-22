import 'package:e_loan_mobile/Helpers/keys_storage.dart';
import 'package:flutter/material.dart';

void presentBottomSheetModal(Widget Function() targetModal) {
  showModalBottomSheet(
    useRootNavigator: true,
    isScrollControlled: true,
    context: KeysStorage.mainNavigatorKey.currentContext,
    backgroundColor: Colors.transparent,
    builder: (BuildContext context) => targetModal(),
  );
}

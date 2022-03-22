import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

class KeysStorage {
  static final GlobalKey<NavigatorState> mainNavigatorKey =
      GlobalKey<NavigatorState>();

  static const textFieldKey1 =  Key('__RIKEY1__');
  static const textFieldKey2 =  Key('__RIKEY2__');
}

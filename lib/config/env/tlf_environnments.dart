import 'package:flutter/cupertino.dart';

enum Environnement { dev, preprod, prod }

class TLFEnvrionnments {
  static const List<Locale> supportedLocales = const <Locale>[
    Locale('fr', 'FR'),
  ];

  static bool debugModeEnabled = false;

  static Environnement environnement = Environnement.dev;

  static const int connectTimeout = 20000;
  static const int sendTimeout = 100000;
  static const int receiveTimeout = 100000;

  static String get baseUrl {
    switch (environnement) {
      case Environnement.dev:
        return 'http://192.168.26.145:3000/api/';
      // return 'http://10.0.2.2:3000/api/';

      case Environnement.preprod:
        return 'http://192.168.26.145:3002/api/';

      case Environnement.prod:
        return 'http://192.168.1.14:3002/api/';
    }
  }

  static String get email {
    return environnement == Environnement.dev
        ? 'belhassen@yopmail.com'
        : environnement == Environnement.preprod
            ? 'amirahlel@yopmail.com'
            // : 'mejri.jameleddine+79@gmail.com';
            : 'chaalen.hajer+4@gmail.com';
  }

  static String get password {
    return environnement != Environnement.prod ? 'test=1AA' : 'Azerty@123';
    // 'Wevioo@2021';
  }

  static void enableTestMode() {
    debugModeEnabled = true;
  }

  static void disableTestMode() {
    debugModeEnabled = false;
  }
}

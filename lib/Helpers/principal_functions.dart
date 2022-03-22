import 'package:e_loan_mobile/Helpers/notifications_manager.dart';
import 'package:e_loan_mobile/api/services/services.dart';
import 'package:e_loan_mobile/config/env/tlf_environnments.dart';
import 'package:e_loan_mobile/config/colors/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:firebase_core/firebase_core.dart';

void configureGlobalLoader() {
  EasyLoading.instance
    ..animationStyle = EasyLoadingAnimationStyle.opacity
    ..displayDuration = const Duration(milliseconds: 5000)
    ..indicatorType = EasyLoadingIndicatorType.circle
    ..loadingStyle = EasyLoadingStyle.light
    ..indicatorSize = 35.0
    ..radius = 10.0
    ..maskColor = Colors.red
    ..indicatorColor = Colors.pink
    ..progressColor = Colors.yellow
    ..backgroundColor = Colors.green
    ..textColor = Colors.brown
    ..userInteractions = false;

  EasyLoading.instance.displayDuration = const Duration(milliseconds: 5000);
  EasyLoading.instance.loadingStyle = EasyLoadingStyle.custom;
  EasyLoading.instance.indicatorColor = AppColors.blue;
  EasyLoading.instance.progressColor = Colors.transparent;
  EasyLoading.instance.backgroundColor = Colors.black12;
  EasyLoading.instance.maskColor = Colors.black12;
}

void setupEnvironnment(Environnement environnement) {
  TLFEnvrionnments.environnement = environnement;
}

void setupStatusBarTransparency() {
  SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
    statusBarColor: Colors.transparent,
  ));
}

void setupAllowedDeviceOrientation() {
  SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
}

void enableDataFacking() {
  fakeData = true;
  TLFEnvrionnments.enableTestMode();
}

void disableDataFacking() {
  fakeData = false;
  TLFEnvrionnments.disableTestMode();
}

void setupFirebaseRequirements() async {
  await Firebase.initializeApp();

  await flutterLocalNotificationsPlugin
      .resolvePlatformSpecificImplementation<AndroidFlutterLocalNotificationsPlugin>()
      ?.createNotificationChannel(channel);

  await FirebaseMessaging.instance.setForegroundNotificationPresentationOptions(
    alert: true,
    badge: true,
    sound: true,
  );
}

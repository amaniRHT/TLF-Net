import 'package:e_loan_mobile/config/config.dart';

import 'package:flutter/material.dart';

class AppThemes {
  AppThemes._();

  static ThemeData defaultAppTheme = ThemeData(
    primaryColor: AppColors.orange,
    appBarTheme: const AppBarTheme(color: Colors.blue),
    bottomAppBarColor: Colors.red,
    bottomNavigationBarTheme:
        const BottomNavigationBarThemeData(backgroundColor: Colors.purple),
    backgroundColor: Colors.black,
    scaffoldBackgroundColor: AppColors.lightestBlue,
    visualDensity: VisualDensity.adaptivePlatformDensity,
    iconTheme: const IconThemeData(),
    unselectedWidgetColor: AppColors.darkGrey,
    disabledColor: AppColors.inactiveOrange,
    primarySwatch: const MaterialColor(
      0xFF00335D,
      // 0xFFFFB920,
      AppColors.primarySwatchMaterialColor,
    ),
    accentColor: AppColors.orange,
    splashColor: AppColors.orange,
    inputDecorationTheme: const InputDecorationTheme(
      prefixStyle: TextStyle(color: Colors.black),
      labelStyle: TextStyle(
        color: Colors.blue,
      ),
      border: OutlineInputBorder(
          borderRadius: BorderRadius.all(
        Radius.circular(8.0),
      )),
      enabledBorder: OutlineInputBorder(
        borderSide: BorderSide(width: .5),
        borderRadius: AppConstants.regularBorderRadius,
      ),
      focusedBorder: OutlineInputBorder(
        borderSide: BorderSide(width: .5),
        borderRadius: AppConstants.regularBorderRadius,
      ),
      errorBorder: OutlineInputBorder(
        borderSide: BorderSide(color: Colors.red),
        borderRadius: AppConstants.regularBorderRadius,
      ),
      focusedErrorBorder: OutlineInputBorder(
        borderSide: BorderSide(color: Colors.yellow),
        borderRadius: AppConstants.regularBorderRadius,
      ),
      fillColor: Colors.red,
      //focusColor: _darkBorderActiveColor,
    ),
  );
}

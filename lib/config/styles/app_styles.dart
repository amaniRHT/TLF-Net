import 'package:e_loan_mobile/config/colors/app_colors.dart';

import 'package:flutter/material.dart';

class AppStyles {
  AppStyles._();

  //Font families
  static const String _fontFamily = 'Montserrat';

  //Font weights
  static const FontWeight _regular = FontWeight.w400;
  static const FontWeight _medium = FontWeight.w500;
  static const FontWeight _semiBold = FontWeight.w600;
  static const FontWeight _bold = FontWeight.w700;

  /* Font sizes */
  static const double smallestTextSize = 6.0;
  static const double smallTextSize = 9.0;
  static const double lightTextSize = 10.0;
  static const double normalTextSize = 11.0;
  static const double mediumTextSize = 12.0;
  static const double largeTextSize = 13.0;
  static const double largestTextSize = 15.0;

  static const TextStyle errorStyle = TextStyle(
    fontFamily: _fontFamily,
    color: AppColors.red,
    fontWeight: _semiBold,
    fontSize: lightTextSize,
    fontStyle: FontStyle.italic,
  );

  static const TextStyle mediumBlue13 = TextStyle(
    fontFamily: _fontFamily,
    color: AppColors.blue,
    fontWeight: _medium,
    fontSize: largeTextSize,
  );

  static const TextStyle mediumBlue10 = TextStyle(
    fontFamily: _fontFamily,
    color: AppColors.blue,
    fontWeight: _medium,
    fontSize: lightTextSize,
  );

  static const TextStyle mediumBlue11 = TextStyle(
    fontFamily: _fontFamily,
    color: AppColors.blue,
    fontWeight: _medium,
    fontSize: normalTextSize,
  );

  static const TextStyle semiBoldBlue11 = TextStyle(
    fontFamily: _fontFamily,
    color: AppColors.blue,
    fontWeight: _semiBold,
    fontSize: normalTextSize,
  );

  static const TextStyle boldBlue11 = TextStyle(
    fontFamily: _fontFamily,
    color: AppColors.blue,
    fontWeight: _bold,
    fontSize: normalTextSize,
  );

  static const TextStyle boldBlue10 = TextStyle(
    fontFamily: _fontFamily,
    color: AppColors.blue,
    fontWeight: _bold,
    fontSize: lightTextSize,
  );

  static const TextStyle regularBlue14 = TextStyle(
    fontFamily: _fontFamily,
    color: AppColors.blue,
    fontWeight: _regular,
    fontSize: largeTextSize,
  );

  static const TextStyle regularDarkGrey12 = TextStyle(
    fontFamily: _fontFamily,
    color: AppColors.darkestGrey,
    fontWeight: _regular,
    fontSize: mediumTextSize,
  );

  static const TextStyle mediumDarkGrey13 = TextStyle(
    fontFamily: _fontFamily,
    color: AppColors.darkestGrey,
    fontWeight: _medium,
    fontSize: largeTextSize,
  );

  static const TextStyle mediumDarkGrey12 = TextStyle(
    fontFamily: _fontFamily,
    color: AppColors.darkestGrey,
    fontWeight: _medium,
    fontSize: mediumTextSize,
  );

  static const TextStyle mediumDarkGrey12WithShadow = TextStyle(
    fontFamily: _fontFamily,
    color: AppColors.darkestGrey,
    fontWeight: _medium,
    fontSize: mediumTextSize,
    shadows: <Shadow>[
      Shadow(
        offset: Offset(1.0, 1.0),
        blurRadius: 8.0,
        color: AppColors.orange,
      ),
    ],
  );

  static const TextStyle regularDarkGrey11 = TextStyle(
    fontFamily: _fontFamily,
    color: AppColors.darkestGrey,
    fontWeight: _regular,
    fontSize: normalTextSize,
  );

  static const TextStyle boldBlue14 = TextStyle(
    fontFamily: _fontFamily,
    color: AppColors.blue,
    fontWeight: _bold,
    fontSize: largestTextSize,
  );

  static const TextStyle boldBlue13 = TextStyle(
    fontFamily: _fontFamily,
    color: AppColors.blue,
    fontWeight: _bold,
    fontSize: largeTextSize,
  );

  static const TextStyle boldBlue12 = TextStyle(
    fontFamily: _fontFamily,
    color: AppColors.blue,
    fontWeight: _bold,
    fontSize: mediumTextSize,
  );
  static const TextStyle semiboldBlue12 = TextStyle(
    fontFamily: _fontFamily,
    color: AppColors.blue,
    fontWeight: _semiBold,
    fontSize: mediumTextSize,
  );

  static const TextStyle semiboldWhite14 = TextStyle(
    fontFamily: _fontFamily,
    color: Colors.white,
    fontWeight: _semiBold,
    fontSize: largestTextSize,
  );

  static const TextStyle mediumBlue14 = TextStyle(
    fontFamily: _fontFamily,
    color: AppColors.blue,
    fontWeight: _medium,
    fontSize: largestTextSize,
  );

  static const TextStyle mediumGreyBlue12 = TextStyle(
    fontFamily: _fontFamily,
    color: AppColors.darkestBlue,
    fontWeight: _medium,
    fontSize: mediumTextSize,
  );

  static const TextStyle regularBlue12 = TextStyle(
    fontFamily: _fontFamily,
    color: AppColors.blue,
    fontWeight: _regular,
    fontSize: mediumTextSize,
  );

  static const TextStyle regularBlue13 = TextStyle(
    fontFamily: _fontFamily,
    color: AppColors.blue,
    fontWeight: _regular,
    fontSize: largeTextSize,
  );

  static TextStyle inactiveMediumBlue14 = TextStyle(
    fontFamily: _fontFamily,
    color: AppColors.blue.withOpacity(0.4),
    fontWeight: _medium,
    fontSize: largestTextSize,
  );
  static TextStyle inactiveMediumBlue13 = TextStyle(
    fontFamily: _fontFamily,
    color: AppColors.blue.withOpacity(0.4),
    fontWeight: _medium,
    fontSize: largeTextSize,
  );

  static TextStyle inactiveBoldBlue12 = TextStyle(
    fontFamily: _fontFamily,
    color: AppColors.blue.withOpacity(0.4),
    fontWeight: _bold,
    fontSize: mediumTextSize,
  );

  static TextStyle inactiveRegularBlue12 = TextStyle(
    fontFamily: _fontFamily,
    color: AppColors.blue.withOpacity(0.4),
    fontWeight: _regular,
    fontSize: mediumTextSize,
  );

  static const TextStyle boldGrey12 = TextStyle(
    fontFamily: _fontFamily,
    color: AppColors.darkGrey,
    fontWeight: _bold,
    fontSize: mediumTextSize,
  );

  static const TextStyle mediumOrange11 = TextStyle(
    fontFamily: _fontFamily,
    color: AppColors.orange,
    fontWeight: _medium,
    fontSize: normalTextSize,
  );

  static const TextStyle mediumGreyBlue10 = TextStyle(
    fontFamily: _fontFamily,
    color: AppColors.darkestBlue,
    fontWeight: _medium,
    fontSize: lightTextSize,
  );

  static const TextStyle mediumWhite13 = TextStyle(
    fontFamily: _fontFamily,
    color: Colors.white,
    fontWeight: _medium,
    fontSize: largeTextSize,
  );

  static const TextStyle regularWhite14 = TextStyle(
    fontFamily: _fontFamily,
    color: Colors.white,
    fontWeight: _regular,
    fontSize: largestTextSize,
  );

  static const TextStyle boldWhite14 = TextStyle(
    fontFamily: _fontFamily,
    color: Colors.white,
    fontWeight: _bold,
    fontSize: largestTextSize,
  );

  static const TextStyle semiBoldWhite11 =
      TextStyle(fontFamily: _fontFamily, color: Colors.white, fontWeight: _semiBold, fontSize: normalTextSize);

  static const TextStyle mediumBlack12 = TextStyle(
    fontFamily: _fontFamily,
    color: Colors.black,
    fontWeight: _medium,
    fontSize: normalTextSize,
  );

  static const TextStyle mediumBlack13 = TextStyle(
    fontFamily: _fontFamily,
    color: Colors.black,
    fontWeight: _medium,
    fontSize: largeTextSize,
  );
  static const TextStyle boldBlack11 = TextStyle(
    fontFamily: _fontFamily,
    color: Colors.black,
    fontWeight: _bold,
    fontSize: normalTextSize,
  );

  static const TextStyle boldBlack12 = TextStyle(
    fontFamily: _fontFamily,
    color: Colors.black,
    fontWeight: _bold,
    fontSize: mediumTextSize,
  );

  static const TextStyle boldBlack13 = TextStyle(
    fontFamily: _fontFamily,
    color: Colors.black,
    fontWeight: _bold,
    fontSize: largeTextSize,
  );

  static const TextStyle semiBoldBlue13 = TextStyle(
    fontFamily: _fontFamily,
    color: AppColors.blue,
    fontWeight: _semiBold,
    fontSize: largeTextSize,
  );
}

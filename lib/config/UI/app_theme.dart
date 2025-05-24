import 'package:flutter/material.dart';

final appTheme = ThemeData(
  //appBar
  appBarTheme: AppBarTheme(
    centerTitle: true,
    // shadowColor: AppColors.hex696969,
  ),

  //style -> textfield
  inputDecorationTheme: InputDecorationTheme(
    border: _border,
    focusedBorder: _border,
    enabledBorder: _border,
  ),
  // textSelectionTheme: TextSelectionThemeData(
  //   //style -> textfield
  //   cursorColor: AppColors.hex000000,
  // ),
  // textTheme: TextTheme(
  //   //style -> textfield
  //   bodyLarge: AppTextStyles.s14w400h000000,
  // ),
);

final _border = OutlineInputBorder(
  borderSide: BorderSide(
    // color: AppColors.hexE7E7E7,
    width: 1,
  ),
  borderRadius: BorderRadius.circular(16),
);

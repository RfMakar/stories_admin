import 'package:flutter/material.dart';
import 'package:stories_admin/config/UI/app_colors.dart';
import 'package:stories_admin/config/UI/app_text_style.dart';


final appTheme = ThemeData(
   scaffoldBackgroundColor: AppColors.hexFBF7F4,
   
  //appBar
    appBarTheme: AppBarTheme(
        centerTitle: true,
        backgroundColor: AppColors.hexFBF7F4,
        surfaceTintColor: AppColors.hexFBF7F4,
        titleTextStyle: AppTextStyles.s18h000000n
        // shadowColor: AppColors.hex696969,
        ),

  //style -> textfield
  inputDecorationTheme: InputDecorationTheme(
    border: _border,
    focusedBorder: _border,
    enabledBorder: _border,
  ),
  textSelectionTheme: TextSelectionThemeData(
    //style -> textfield
    cursorColor: Colors.grey,
  ),
  // textTheme: TextTheme(
  //   //style -> textfield
  //   bodyLarge: AppTextStyles.s14w400h000000,
  // ),
);

final _border = OutlineInputBorder(
  borderSide: BorderSide(
    color: Colors.grey,
    width: 0.5,
  ),
  borderRadius: BorderRadius.circular(8),
);

import 'package:flutter/material.dart';
import 'package:flutter_blog_app/core/theme/app_palette.dart';

class AppTheme {
  static  _border([Color color=AppPallete.borderColor]) => OutlineInputBorder(
      borderSide:  BorderSide(
        color:color ,
        width: 3,
      ),
      borderRadius: BorderRadius.circular(10));
  static final darkThememode = ThemeData.dark().copyWith(
    appBarTheme: const AppBarTheme(
      backgroundColor: AppPallete.backgroundColor
    ),

    chipTheme: const ChipThemeData(
      side: BorderSide.none,
      color: WidgetStatePropertyAll(AppPallete.backgroundColor,
      )
    ),
      scaffoldBackgroundColor: AppPallete.backgroundColor,
      inputDecorationTheme: InputDecorationTheme(
        contentPadding: const EdgeInsets.all(27),
        border: _border(),
        errorBorder:_border(AppPallete.errorColor) ,
        enabledBorder:
          _border(),
        focusedBorder: _border(AppPallete.gradient2),
      ));
}

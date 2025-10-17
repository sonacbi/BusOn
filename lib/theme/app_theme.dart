// lib > theme > app_theme.dart 
// 앱 전체 테마(ThemeData)와 관련된 설정을 모아둔 파일
// (예: 라이트/다크 테마, 버튼 스타일, 기본 위젯 스타일 등)

import 'package:flutter/material.dart';
import 'app_colors.dart';

class AppTheme {
  static ThemeData lightTheme = ThemeData(
    primaryColor: AppColors.primaryColor,
    scaffoldBackgroundColor: AppColors.backgroundColor,
    textTheme: const TextTheme(
      headline6: TextStyle(color: AppColors.textColor),
      bodyText2: TextStyle(color: AppColors.textColor),
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: AppColors.buttonColor,
        minimumSize: const Size(double.infinity, 50),
      ),
    ),
  );
}

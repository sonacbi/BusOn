// lib > theme > app_colors.dart
// 앱 전반에서 공통으로 사용하는 색상 값들을 정의한 파일
// (예: primaryColor, backgroundColor, textColor 등)

import 'package:flutter/material.dart';

class AppColors {
  // 메인 오렌지 컬러 (r255 g149 b73)
  static const primaryColor = Color.fromRGBO(255, 149, 73, 1);

  // 화면 배경
  static const backgroundColor = Color(0xFFF5F5F5);

  // 텍스트
  static const textColor = Color(0xFF333333);

  // 비활성화 요소
  static const disabledColor = Colors.grey;

  // 버튼 (파란색 계열: #4A90E2)
  static const buttonActiveColor = Color(0xFF4A90E2);

  // 버튼 비활성화 (연한 회색)
  static const buttonDisabledColor = Colors.grey;
}

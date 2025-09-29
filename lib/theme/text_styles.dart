// lib > theme > text_styles.dart 
// 앱 전반에서 공통으로 사용하는 텍스트 스타일을 정의한 파일
// (예: 제목, 본문, 캡션 등 텍스트 스타일)

import 'package:flutter/material.dart';
import 'app_colors.dart';

class TextStyles {
  static const title = TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: AppColors.textColor);
  static const body = TextStyle(fontSize: 16, color: AppColors.textColor);
  static const caption = TextStyle(fontSize: 12, color: AppColors.disabledColor);
}

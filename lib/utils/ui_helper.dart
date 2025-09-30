// lib > until > ui_helper.dart 
// 앱 전반에서 공통으로 사용하는 포맷팅 함수를 모은 파일

import 'package:flutter/services.dart';

// 핸드폰 자동 포맷팅 전용 함수
class PhoneNumberFormatter extends TextInputFormatter { 
  @override
  TextEditingValue formatEditUpdate(
      TextEditingValue oldValue,
      TextEditingValue newValue,
  ) {
    // 입력값에서 숫자만 남김
    String digits = newValue.text.replaceAll(RegExp(r'\D'), '');

    // 길이에 따라 하이픈 추가
    String formatted = '';
    if (digits.length <= 3) {
      formatted = digits;
    } else if (digits.length <= 7) {
      formatted = '${digits.substring(0, 3)}-${digits.substring(3)}';
    } else if (digits.length <= 11) {
      formatted =
          '${digits.substring(0, 3)}-${digits.substring(3, 7)}-${digits.substring(7)}';
    } else {
      // 11자리 이상 잘라내기
      formatted =
          '${digits.substring(0, 3)}-${digits.substring(3, 7)}-${digits.substring(7, 11)}';
    }

    return TextEditingValue(
      text: formatted,
      selection: TextSelection.collapsed(offset: formatted.length),
    );
  }
}
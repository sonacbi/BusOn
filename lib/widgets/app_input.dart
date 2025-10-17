// 📁 lib > widgets > app_input.dart
// ✅ 앱 전역에서 사용할 공통 입력창 위젯 (AppInput)
// -------------------------------------------------------------
// ● 주요 기능
//   - 텍스트 입력을 위한 공통 스타일 컴포넌트
//   - prefix/suffix 아이콘, 힌트 텍스트, 그림자 효과 등 지원
//   - 재사용성과 일관된 디자인 유지 목적
//
// ● 주요 매개변수
//   - hintText: 입력창에 표시될 힌트 문구
//   - controller: TextField 제어용 컨트롤러
//   - obscureText: 비밀번호 입력 시 텍스트 숨김 여부
//   - keyboardType: 입력 키보드 타입 지정
//   - enabled: 입력 활성화 여부
//   - prefixIcon / suffixIcon: 아이콘 위젯 삽입
//   - fillColor / textColor: 배경색과 글자색
//   - width / height / fontSize: 크기 관련 설정
//   - onChanged: 입력 값 변경 콜백
//   - shadow 관련 설정: shadowColor, shadowBlur, shadowSpread, shadowOffset
//
// ● 활용 예시
//   AppInput(
//     hintText: '이메일을 입력하세요',
//     controller: emailController,
//     prefixIcon: Icon(Icons.email),
//   )
// -------------------------------------------------------------

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class AppInput extends StatelessWidget {
  final String hintText;
  final TextEditingController controller;
  final bool obscureText;
  final TextInputType keyboardType;
  final bool enabled;
  final Widget? prefixIcon;
  final Widget? suffixIcon;
  final double borderRadius;
  final Color fillColor;
  final Color textColor;
  final double width;
  final double height;
  final double fontSize;
  final ValueChanged<String>? onChanged;

  // TextField 고유 옵션 추가 (2025-10-17)
  final int? maxLength;
  final String? counterText;
  final EdgeInsetsGeometry? contentPadding;
  // TextField 포맷팅 변수 추가 (2025-10-17)
  final FocusNode? focusNode;
  final String? labelText;
  final List<TextInputFormatter>? inputFormatters;

  // 🎨 그림자 관련 설정
  final Color shadowColor;
  final double shadowBlur;
  final double shadowSpread;
  final Offset shadowOffset;

  const AppInput({
    super.key,
    required this.hintText,
    required this.controller,
    this.obscureText = false,
    this.keyboardType = TextInputType.text,
    this.enabled = true,
    this.prefixIcon,
    this.suffixIcon,
    this.borderRadius = 8.0,
    this.fillColor = Colors.white,
    this.textColor = Colors.black,
    this.width = double.infinity,
    this.height = 50,
    this.fontSize = 16,
    this.onChanged,
    this.focusNode, // 추가
    this.maxLength, // 선택사항
    this.counterText, // 선택사항
    this.contentPadding = const EdgeInsets.symmetric(horizontal: 16, vertical: 16), // 선택사항
    this.shadowColor = Colors.black26,
    this.shadowBlur = 6.0,
    this.shadowSpread = 0.0,
    this.shadowOffset = const Offset(0, 4),
    this.labelText, // 추가
    this.inputFormatters, // 추가
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      height: height,
      decoration: BoxDecoration(
        color: fillColor,
        borderRadius: BorderRadius.circular(borderRadius),
        boxShadow: [
          BoxShadow(
            color: shadowColor,
            blurRadius: shadowBlur,
            spreadRadius: shadowSpread,
            offset: shadowOffset,
          ),
        ],
      ),
      child: TextField(
        controller: controller,
        focusNode: focusNode, // 추가
        obscureText: obscureText,
        keyboardType: keyboardType,
        enabled: enabled,
        maxLength: maxLength, // 선택사항
        inputFormatters: inputFormatters, // 추가
        style: TextStyle(color: textColor, fontSize: fontSize),
        decoration: InputDecoration(
          labelText: labelText, // 추가
          hintText: hintText,
          filled: true,
          fillColor: fillColor,
          prefixIcon: prefixIcon,
          suffixIcon: suffixIcon,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(borderRadius),
            borderSide: BorderSide.none,
          ),
          counterText: counterText, // 선택사항
          contentPadding: contentPadding, // 선택사항
        ),
        onChanged: onChanged,
      ),
    );
  }
}
// lib > widgets > app_input.dart (앱에서 사용할 공통 입력창 위젯)

import 'package:flutter/material.dart';

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

  // 그림자 관련
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
    this.shadowColor = Colors.black26,
    this.shadowBlur = 6.0,
    this.shadowSpread = 0.0,
    this.shadowOffset = const Offset(0, 4),
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
        obscureText: obscureText,
        keyboardType: keyboardType,
        enabled: enabled,
        style: TextStyle(color: textColor, fontSize: fontSize),
        decoration: InputDecoration(
          hintText: hintText,
          filled: true,
          fillColor: fillColor,
          prefixIcon: prefixIcon,
          suffixIcon: suffixIcon,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(borderRadius),
            borderSide: BorderSide.none,
          ),
          contentPadding: const EdgeInsets.symmetric(horizontal: 16),
        ),
        onChanged: onChanged,
      ),
    );
  }
}

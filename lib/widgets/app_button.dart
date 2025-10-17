// 📂 lib/widgets/app_button.dart
// ---------------------------------------------
// ✅ AppButton : 앱 전역에서 사용할 공통 버튼 위젯
// ---------------------------------------------
// ▶ 주요 특징
//  - 색상, 크기, 텍스트, 아이콘 위치 등을 자유롭게 커스터마이징 가능
//  - ElevatedButton 기반 (눌림 효과, 그림자 지원)
//  - 버튼 내 아이콘 위치 (왼쪽/오른쪽/위/아래) 설정 가능
// ---------------------------------------------

import 'package:flutter/material.dart';

// ---------------------------------------------
/// 아이콘 위치를 정의하는 열거형
/// (왼쪽 / 오른쪽 / 위 / 아래 중 선택)
enum ButtonIconPosition { left, right, top, bottom }
// ---------------------------------------------
/// 공통 앱 버튼 위젯
class AppButton extends StatelessWidget {
  final String text; // 버튼에 표시할 텍스트
  final Color color; // 기본 배경색
  final Color pressedColor;  // 버튼이 눌렸을 때의 색상
  final Color textColor; // 텍스트 색상
  final double width; // 버튼 너비
  final double height; // 버튼 높이
  final double textSize; // 텍스트 크기
  final IconData? icon; // 아이콘 (선택 사항)
  final ButtonIconPosition iconPosition; // 아이콘 위치 설정 (기본값: 왼쪽)
  final VoidCallback onPressed; // 버튼 클릭 시 실행할 함수
  final double elevation; // 그림자 강도 (elevation)
  final double borderRadius; // 모서리 둥글기


/// 커스텀용 옵션 추가 (2025-10-17)
final EdgeInsetsGeometry? contentPadding; // 버튼 내부 패딩
final double iconSpacing; // 텍스트-아이콘 간격

// ---------------------------------------------
// 📌 생성자: 기본값 지정 + 필수 파라미터 설정
// ---------------------------------------------
  const AppButton({
    super.key,
    required this.text,
    this.color = const Color(0xFFFD9F28), // 주황색 계열 기본값
    this.pressedColor = const Color(0xFFFFB74D), // 눌렸을 때 색상
    this.textColor = Colors.white, // 흰색 글씨
    this.width = 150,
    this.height = 50,
    this.textSize = 16,
    this.icon,
    this.iconPosition = ButtonIconPosition.left,
    required this.onPressed,
    this.elevation = 4.0,
    this.borderRadius = 8.0,
    this.contentPadding, // 추가
    this.iconSpacing = 8, // 추가
  });
// ---------------------------------------------

  @override
  Widget build(BuildContext context) {
    Widget child;

    // 🔹 아이콘이 없는 경우 (텍스트만 표시)
    if (icon == null) {
      child = Text(text, style: TextStyle(fontSize: textSize, color: textColor)); } 
    
    // 🔹 아이콘이 있는 경우 위치별로 레이아웃 다르게 처리
    else {
      switch (iconPosition) {
        // 왼쪽 아이콘 ------------------------------------------------------------┤
        case ButtonIconPosition.left:
          child = Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(icon, size: textSize, color: textColor),
              SizedBox(width: iconSpacing), // 텍스트-아이콘 간격 (수정)
              Text(text, style: TextStyle(fontSize: textSize, color: textColor)),
            ],
          );
          break;
        // 오른쪽 아이콘 ---------------------------------------------------------┤
        case ButtonIconPosition.right:
          child = Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(text, style: TextStyle(fontSize: textSize, color: textColor)),
              SizedBox(width: iconSpacing), // 텍스트-아이콘 간격 (수정)
              Icon(icon, size: textSize, color: textColor),
            ],
          );
          break;
        // 위쪽 아이콘 ----------------------------------------------------------┤
        case ButtonIconPosition.top:
          child = Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(icon, size: textSize, color: textColor),
              const SizedBox(height: 4), // 사이즈가 달라서 수정 없음
              Text(text, style: TextStyle(fontSize: textSize, color: textColor)),
            ],
          );
          break;
        case ButtonIconPosition.bottom:
          child = Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(text, style: TextStyle(fontSize: textSize, color: textColor)),
              const SizedBox(height: 4), // 사이즈가 달라서 수정 없음
              Icon(icon, size: textSize, color: textColor),
            ],
          );
          break;
      }
    }
    
    // 최종 버튼 위젯 반환
    return SizedBox(
      width: width,
      height: height,
      child: ElevatedButton(
        style: ButtonStyle(
          // 선택옵션 패딩. 넣지 않으면 미적용
          padding: MaterialStateProperty.all(contentPadding ?? const EdgeInsets.symmetric(horizontal: 16)),

          // 그림자 깊이
          elevation: MaterialStateProperty.all(elevation),

          // 눌림 상태에 따라 색상 변경
          backgroundColor: MaterialStateProperty.resolveWith((states) {
            if (states.contains(MaterialState.pressed)) return pressedColor;
            return color;
          }),

          // 모서리 둥글기
          shape: MaterialStateProperty.all(
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(borderRadius)),
          ),
        ),
        onPressed: onPressed, // 클릭 이벤트
        child: child, // 버튼 내용 (텍스트 + 아이콘)
      ),
    );
  }
}

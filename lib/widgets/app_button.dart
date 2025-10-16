// lib > widgets > app_button.dart (앱에서 사용할 공통 앱 버튼 위젯)

import 'package:flutter/material.dart';

enum ButtonIconPosition { left, right, top, bottom }

class AppButton extends StatelessWidget {
  final String text;
  final Color color;
  final Color pressedColor;
  final Color textColor;
  final double width;
  final double height;
  final double textSize;
  final IconData? icon;
  final ButtonIconPosition iconPosition;
  final VoidCallback onPressed;
  final double elevation; // 그림자
  final double borderRadius; // 모서리 둥글기

  const AppButton({
    super.key,
    required this.text,
    this.color = const Color(0xFFFD9F28),
    this.pressedColor = const Color(0xFFFFB74D),
    this.textColor = Colors.white,
    this.width = 150,
    this.height = 50,
    this.textSize = 16,
    this.icon,
    this.iconPosition = ButtonIconPosition.left,
    required this.onPressed,
    this.elevation = 4.0,
    this.borderRadius = 8.0,
  });

  @override
  Widget build(BuildContext context) {
    Widget child;

    if (icon == null) {
      child = Text(text, style: TextStyle(fontSize: textSize, color: textColor));
    } else {
      switch (iconPosition) {
        case ButtonIconPosition.left:
          child = Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(icon, size: textSize, color: textColor),
              const SizedBox(width: 8),
              Text(text, style: TextStyle(fontSize: textSize, color: textColor)),
            ],
          );
          break;
        case ButtonIconPosition.right:
          child = Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(text, style: TextStyle(fontSize: textSize, color: textColor)),
              const SizedBox(width: 8),
              Icon(icon, size: textSize, color: textColor),
            ],
          );
          break;
        case ButtonIconPosition.top:
          child = Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(icon, size: textSize, color: textColor),
              const SizedBox(height: 4),
              Text(text, style: TextStyle(fontSize: textSize, color: textColor)),
            ],
          );
          break;
        case ButtonIconPosition.bottom:
          child = Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(text, style: TextStyle(fontSize: textSize, color: textColor)),
              const SizedBox(height: 4),
              Icon(icon, size: textSize, color: textColor),
            ],
          );
          break;
      }
    }

    return SizedBox(
      width: width,
      height: height,
      child: ElevatedButton(
        style: ButtonStyle(
          elevation: MaterialStateProperty.all(elevation),
          backgroundColor: MaterialStateProperty.resolveWith((states) {
            if (states.contains(MaterialState.pressed)) return pressedColor;
            return color;
          }),
          shape: MaterialStateProperty.all(
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(borderRadius)),
          ),
        ),
        onPressed: onPressed,
        child: child,
      ),
    );
  }
}

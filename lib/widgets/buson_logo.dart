// widgets/buson_logo.dart

import 'package:flutter/material.dart';

class BusOnLogo extends StatelessWidget {
  final double fontSize; // 글씨 크기 파라미터
  final Color color;     // 글자 색상 파라미터 (옵션)

  const BusOnLogo({
    super.key,
    this.fontSize = 48,       // 기본값 48
    this.color = Colors.black, // 기본 글자색
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min, // 텍스트 너비 최소화
      children: [
        Text(
          'Bu',
          style: TextStyle(
            fontSize: fontSize,
            fontWeight: FontWeight.bold,
            color: color,
            fontFamily: 'Bauhaus', // Bu 부분 폰트
          ),
        ),
        Text(
          's',
          style: TextStyle(
            fontSize: fontSize,
            fontWeight: FontWeight.bold,
            color: color,
            fontFamily: 'Bauhaus_93', // s 부분 폰트
          ),
        ),
        Text(
          'On',
          style: TextStyle(
            fontSize: fontSize,
            fontWeight: FontWeight.bold,
            color: color,
            fontFamily: 'Bauhaus', // On 부분 폰트
          ),
        ),
      ],
    );
  }
}

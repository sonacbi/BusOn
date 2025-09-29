// 01
// screens > intro > intro_screen.dart
// 앱 실행 시 보여지는 인트로(시작) 화면

// 애니메이션 관련하여 코드가 길어지면 별도의 animation 파일로 분리하시오.

import 'package:flutter/material.dart';

class IntroScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Intro Screen'),
      ),
      body: Center(
        child: Text(
          '인트로 화면입니다',
          style: TextStyle(fontSize: 24),
        ),
      ),
    );
  }
}

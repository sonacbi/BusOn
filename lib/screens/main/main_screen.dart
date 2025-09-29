// 04
// screens > main > main_screen.dart
// 로그인 이후 표시되는 메인 화면
// (예: 홈, 주요 기능 진입점)

// 상태 관리 관련 함수는 작성하다가 길어지면 state > app_state 로 분리하시오.

import 'package:flutter/material.dart';

class MainScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Main Screen'),
      ),
      body: Center(
        child: Text(
          '메인 화면입니다',
          style: TextStyle(fontSize: 24),
        ),
      ),
    );
  }
}

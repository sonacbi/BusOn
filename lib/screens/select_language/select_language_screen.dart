// 02
// screens > select_language > select_language_screen
// 앱 첫 실행 시, 사용자 언어를 선택하는 화면


// 상태 관리 관련 함수는 작성하다가 길어지면 state > app_state 로 분리하시오.

import 'package:flutter/material.dart';

class SelectLanguageScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Select Language Screen'),
      ),
      body: Center(
        child: Text(
          '언어 선택 화면입니다',
          style: TextStyle(fontSize: 24),
        ),
      ),
    );
  }
}

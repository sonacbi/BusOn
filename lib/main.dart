//  입력창 적용 예시

import 'package:flutter/material.dart';
import 'package:provider/provider.dart'; // Provider 패키지 추가

// 상태 import
import 'states/app_state.dart';
import 'widgets/app_input.dart';

// 테스트용 스크린 import
import 'package:bus_on/screens/intro/intro_screen.dart'; // 01. 앱 실행 시 보여지는 인트로 화면
import 'package:bus_on/screens/select_language/select_language_screen.dart'; // 02. 언어 선택 화면
import 'package:bus_on/screens/auth/auth_screen.dart'; // 03. 로그인/회원가입 화면
import 'package:bus_on/screens/main/main_screen.dart'; // 04. 로그인 후 메인 화면
import 'package:bus_on/screens/test/test_auth_screen.dart'; // ✅ 새로 추가할 테스트용 스크린


void main() {
  runApp(
    ChangeNotifierProvider(
      create: (_) => AppState(), // 전역 상태 등록
      child: MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: IntroScreen(),
    );
  }
}


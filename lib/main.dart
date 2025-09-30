// 앱 실행과 라우팅(홈 화면 선택 등)만 담당

import 'package:flutter/material.dart';
import 'package:provider/provider.dart'; // Provider 패키지 추가

// 상태 import
import 'states/app_state.dart';

// 테스트용 스크린 import
import 'screens/intro/intro_screen.dart'; // 01. 앱 실행 시 보여지는 인트로 화면
import 'screens/select_language/select_language_screen.dart'; // 02. 언어 선택 화면
import 'screens/auth/auth_screen.dart'; // 03. 로그인/회원가입 화면
import 'screens/main/main_screen.dart'; // 04. 로그인 후 메인 화면

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
    return MaterialApp(
      title: '테스트용 스크린 이동',
      home: HomeScreen(), // 앱 시작 시 보여줄 홈 화면
    );
  }
}

// 홈 화면: 테스트용 버튼 4개로 각 스크린 이동
class HomeScreen extends StatelessWidget {
  HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('테스트용 화면 이동'), // 상단 제목 표시
      ),
      body: Padding(
        padding: EdgeInsets.all(20.0), // 화면 가장자리 여백
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center, // 버튼 세로 중앙 정렬
          children: [
            // 01. Intro Screen 버튼
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => IntroScreen()),
                );
              },
              child: Text('01. Intro Screen'),
            ),
            SizedBox(height: 20), // 버튼 사이 간격

            // 02. Select Language Screen 버튼
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => SelectLanguageScreen()),
                );
              },
              child: Text('02. Select Language Screen'),
            ),
            SizedBox(height: 20),

            // 03. Auth Screen 버튼
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => AuthScreen()),
                );
              },
              child: Text('03. Auth Screen'),
            ),
            SizedBox(height: 20),

            // 04. Main Screen 버튼
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => MainScreen()),
                );
              },
              child: Text('04. Main Screen'),
            ),
          ],
        ),
      ),
    );
  }
}

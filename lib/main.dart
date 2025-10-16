//  입력창 적용 예시

import 'package:flutter/material.dart';
import 'widgets/app_input.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    final TextEditingController nameController = TextEditingController();
    final TextEditingController passwordController = TextEditingController();

    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(title: const Text("AppInput Demo")),
        body: Center(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // 아이디 입력창
                AppInput(
                  hintText: "아이디", // 입력찬 안내 문구
                  controller: nameController, // 외부에서 텍스트 값 가져오기/설정 기능
                  prefixIcon: const Icon(Icons.person), // 좌 측 아이콘
                  borderRadius: 12, // 모서리 둥글게
                  fillColor: Colors.white, // 배경 색
                  textColor: Colors.black, // 텍스트 색
                  width: 300, // 입력창 너비
                  height: 60, // 입력창 높이
                  fontSize: 18, // 텍스트 크기
                  shadowColor: Colors.black45, // 그림자 색
                  shadowBlur: 8.0, // 퍼지는 정도
                  shadowSpread: 1.0, // 그림자 크기를 늘리거나 줄임
                  shadowOffset: const Offset(2, 4), // 그림자 x, y축
                  onChanged: (value) { // 외부에서 변화 감지
                    print("Name: $value");
                  },
                ),
                const SizedBox(height: 20),
                // 비밀번호 입력창
                AppInput(
                  hintText: "비밀번호",
                  controller: passwordController,
                  obscureText: true,
                  prefixIcon: const Icon(Icons.lock),
                  borderRadius: 12,
                  fillColor: Colors.grey[200]!,
                  textColor: Colors.black,
                  width: 300,
                  height: 60,
                  fontSize: 18,
                  shadowColor: Colors.black26,
                  shadowBlur: 6.0,
                  shadowSpread: 0.0,
                  shadowOffset: const Offset(0, 3),
                  onChanged: (value) {
                    print("Password: $value");
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

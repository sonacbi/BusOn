import 'package:flutter/material.dart';
import 'widgets/app_button.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(title: const Text("Button Layout Example")),
        body: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              // 첫 번째 행 (아이콘 위, 텍스트 아래)
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  AppButton(
                    text: "좌측 아이콘",
                    icon: Icons.star, // 아이콘
                    iconPosition: ButtonIconPosition.left, // 아이콘 위치(좌)
                    color: Colors.blue, // 배경 색
                    pressedColor: Colors.blueAccent, // 클릭시 배경 색
                    textColor: Colors.white, // 텍스트 색
                    width: 140, // 버튼 너비
                    height: 50, // 버튼 높이
                    textSize: 10, // 텍스트(폰트) 크기
                    elevation: 6, // 그림자
                    borderRadius: 12, // 모서리 둥글게
                    onPressed: () {
                      print("좌측 버튼 눌림");
                    },
                  ),

                  AppButton(
                    text: "우측 아이콘",
                    icon: Icons.favorite,
                    iconPosition: ButtonIconPosition.right, // 우로 배치
                    onPressed: () {},
                  ),
                ],
              ),
              const SizedBox(height: 20),
              // 두 번째 행 (아이콘 위, 텍스트 아래)
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  AppButton(
                    text: "아이콘 위",
                    icon: Icons.star,
                    iconPosition: ButtonIconPosition.top, // 위로 배치
                    onPressed: () {},
                  ),

                  AppButton(
                    text: "아이콘 아래",
                    icon: Icons.settings,
                    iconPosition: ButtonIconPosition.bottom, // 아래로 배치
                    onPressed: () {},
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

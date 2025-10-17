// 01
// screens > intro > intro_screen.dart
// 앱 실행 시 보여지는 인트로(시작) 화면

// 애니메이션 관련하여 코드가 길어지면 별도의 animation 파일로 분리하시오.

import 'package:flutter/material.dart';
import 'dart:async';
import 'package:bus_on/screens/select_language/select_language_screen.dart';
import 'package:bus_on/widgets/buson_logo.dart';

class IntroScreen extends StatefulWidget {
  const IntroScreen({super.key});

  @override
  State<IntroScreen> createState() => _IntroScreenState();
}

class _IntroScreenState extends State<IntroScreen> {
  @override
  void initState() {
    super.initState();
    Timer(const Duration(seconds: 5), () {
      Navigator.of(context).pushReplacement(_createRoute());
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFD9F28),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            BusOnLogo(fontSize: 60, color: Colors.white),
            const SizedBox(height: 10),
            const Text(
              '환영합니다',
              style: TextStyle(
                fontSize: 22,
                color: Colors.black87, // 약간 투명 제거
              ),
            ),
          ],
        ),

      ),
    );
  }

  Route _createRoute() {
    return PageRouteBuilder(
      pageBuilder: (context, animation, secondaryAnimation) =>
      const LanguageSelectionScreen(),
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        const begin = Offset(0.0, 1.0);
        const end = Offset.zero;
        const curve = Curves.easeInOut;

        var tween =
        Tween(begin: begin, end: end).chain(CurveTween(curve: curve));
        var offsetAnimation = animation.drive(tween);

        return SlideTransition(
          position: offsetAnimation,
          child: child,
        );
      },
      transitionDuration: const Duration(milliseconds: 500),
    );
  }
}
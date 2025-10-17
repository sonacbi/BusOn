// 01
// screens > intro > intro_screen.dart
// 앱 실행 시 보여지는 인트로(시작) 화면

// 애니메이션 관련하여 코드가 길어지면 별도의 animation 파일로 분리하시오.

import 'package:flutter/material.dart';
import 'dart:async';
import 'dart:math';
import 'package:bus_on/theme/app_colors.dart';
import 'package:bus_on/screens/select_language/select_language_screen.dart';
import 'package:bus_on/widgets/buson_logo.dart';

class IntroScreen extends StatefulWidget {
  const IntroScreen({super.key});

  @override
  State<IntroScreen> createState() => _IntroScreenState();
}

class _IntroScreenState extends State<IntroScreen> with TickerProviderStateMixin {
  bool showWelcomeText = false;       // 첫 텍스트 등장 여부
  bool showBusOnText = false;         // 두 번째 텍스트 등장 여부

  late final AnimationController _fadeController;
  late final Animation<double> _fadeIn;
  late final Animation<Offset> _slide;

  late final AnimationController _flipController;
  late final Animation<double> _flipAnimation;
  @override
  void initState() {
    super.initState();

    _fadeController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1000),
    );
    _fadeIn = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _fadeController, curve: Curves.easeOut),
    );
    _slide = Tween<Offset>(begin: const Offset(0, -0.3), end: Offset.zero).animate(
      CurvedAnimation(parent: _fadeController, curve: Curves.easeOut),
    );

    _flipController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1200),
    );

    _flipAnimation = CurvedAnimation(
      parent: _flipController,
      curve: Curves.easeInOutSine, // 부드러운 회전
    );
  }

  // O 애니 완료 시 첫 텍스트 등장 및 교체
  void _onOAnimationComplete() {
    setState(() => showWelcomeText = true);
    _fadeController.forward();

    // 첫 텍스트 등장 후 1초 뒤 플립 애니메이션 시작
    Future.delayed(const Duration(seconds: 1), () async {
      await _flipController.forward(); // 느린 플립

      // 플립 끝난 뒤 다음 화면 이동
      Future.delayed(const Duration(seconds: 1), () {
        Navigator.of(context).pushReplacement(_createRoute());
      });
    });
  }


  void dispose() {
    _fadeController.dispose();
    _flipController.dispose(); // ✅ 반드시 dispose
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.primaryColor,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            BusOnLogo_A(fontSize: 60, color: Colors.white,
              onOAnimationComplete: _onOAnimationComplete, // 콜백 연결
            ),
            const SizedBox(height: 5),
            SlideTransition(
              position: _slide,
              child: FadeTransition(
                opacity: _fadeIn,
                child: AnimatedBuilder(
                  animation: _flipAnimation,
                  builder: (context, child) {
                    double angle = _flipAnimation.value * pi; // 0 ~ 180도
                    bool showBack = _flipAnimation.value >= 0.5; // 90° 이상이면 뒤쪽 텍스트

                    if (angle > pi / 2) angle = pi - angle; // 뒤집힌 글자 보정

                    return Transform(
                      transform: Matrix4.rotationY(angle),
                      alignment: Alignment.center,
                      child: Text(
                        showBack ? '당신의 버스온' : '환영합니다. 일상의 파트너!',
                        style: const TextStyle(fontSize: 22, color: Colors.black87),
                        textAlign: TextAlign.center,
                      ),
                    );
                  },
                ),
              ),
            ),
          ],
        )
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
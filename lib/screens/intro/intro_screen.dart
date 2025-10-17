// 01
// screens > intro > intro_screen.dart
// 앱 실행 시 보여지는 인트로(시작) 화면

// 애니메이션 관련하여 코드가 길어지면 별도의 animation 파일로 분리하시오.

import 'package:flutter/material.dart';
import 'dart:async';
import 'package:bus_on/theme/app_colors.dart';
import 'package:bus_on/screens/select_language/select_language_screen.dart';
import 'package:bus_on/widgets/buson_logo.dart';

class IntroScreen extends StatefulWidget {
  const IntroScreen({super.key});

  @override
  State<IntroScreen> createState() => _IntroScreenState();
}

class _IntroScreenState extends State<IntroScreen> with TickerProviderStateMixin {
  bool showWelcomeText = false; // 텍스트 등장 여부

  late final AnimationController _fadeController;
  late final Animation<double> _fadeIn;
  late final Animation<Offset> _slide;

  @override
  void initState() {
    super.initState();

    // Fade + Slide 애니메이션 컨트롤러
    _fadeController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 800),
    );
    _fadeIn = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _fadeController, curve: Curves.easeOut),
    );
    _slide = Tween<Offset>(begin: const Offset(0, -0.3), end: Offset.zero).animate(
      CurvedAnimation(parent: _fadeController, curve: Curves.easeOut),
    );

    // 애니메이션 완료 시 다음 화면으로 이동
    _fadeController.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        // 1초 여유 후 다음 화면으로 이동
        Future.delayed(const Duration(seconds: 1), () {
          Navigator.of(context).pushReplacement(_createRoute());
        });
      }
    });

  }

  // O 애니 완료 시 Fade + Slide 시작
  void _onOAnimationComplete() {
    setState(() {
      showWelcomeText = true;
      _fadeController.forward();
    });
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
                child: const Text(
                  '환영합니다. 일상의 파트너!',
                  style: TextStyle(
                    fontSize: 22,
                    color: Colors.black87,
                  ),
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
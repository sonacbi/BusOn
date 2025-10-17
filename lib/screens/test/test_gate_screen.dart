// screens/test/test_gate_screen.dart
import 'package:flutter/material.dart';
import '../intro/intro_screen.dart';
import '../auth/auth_screen.dart';
import '../main/main_screen.dart';
import 'test_auth_screen.dart';

class TestGateScreen extends StatelessWidget {
  const TestGateScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('임시 게이트 페이지')),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton(
              onPressed: () => Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => IntroScreen())),
              child: const Text('01. Intro Screen'),
            ),
            const SizedBox(height: 10),
            ElevatedButton(
              onPressed: () => Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => AuthScreen())),
              child: const Text('02. Auth Screen'),
            ),
            const SizedBox(height: 10),
            ElevatedButton(
              onPressed: () => Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => TestAuthScreen())),
              child: const Text('03. Test Auth Screen'),
            ),
            const SizedBox(height: 10),
            ElevatedButton(
              onPressed: () => Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => MainScreen())),
              child: const Text('04. Main Screen'),
            ),
          ],
        ),
      ),
    );
  }
}

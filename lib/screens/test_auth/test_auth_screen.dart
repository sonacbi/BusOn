// lib/screens/test_auth/test_auth_screen.dart

import 'package:flutter/material.dart';
import '../../widgets/app_input.dart'; // AppInput 위젯 불러오기

class TestAuthScreen extends StatelessWidget {
  const TestAuthScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final nameController = TextEditingController();
    final passwordController = TextEditingController();

    return Scaffold(
      appBar: AppBar(title: const Text("AppInput Demo")),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              AppInput(
                hintText: "아이디",
                controller: nameController,
                prefixIcon: const Icon(Icons.person),
                borderRadius: 12,
                fillColor: Colors.white,
                textColor: Colors.black,
                width: 300,
                height: 60,
                fontSize: 18,
                shadowColor: Colors.black45,
                shadowBlur: 8.0,
                shadowSpread: 1.0,
                shadowOffset: const Offset(2, 4),
                onChanged: (value) => print("Name: $value"),
              ),
              const SizedBox(height: 20),
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
                onChanged: (value) => print("Password: $value"),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

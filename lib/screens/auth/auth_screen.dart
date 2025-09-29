// 03
// screens > auth > auth_screen.dart
// 로그인 및 회원가입 등 인증 관련 화면

import 'package:flutter/material.dart';

class AuthScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Auth Screen'),
      ),
      body: Center(
        child: Text(
          '로그인/회원가입 화면입니다',
          style: TextStyle(fontSize: 24),
        ),
      ),
    );
  }
}

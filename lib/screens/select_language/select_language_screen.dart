// 02
// screens > select_language > select_language_screen
// 앱 첫 실행 시, 사용자 언어를 선택하는 화면

import 'package:flutter/material.dart';
import 'dart:async';
import 'package:flutter/scheduler.dart';

import '../test/test_gate_screen.dart';
import 'package:bus_on/theme/app_colors.dart';
import 'package:bus_on/widgets/language_button.dart';

class LanguageSelectionScreen extends StatefulWidget {
  const LanguageSelectionScreen({super.key});

  @override
  _LanguageSelectionScreenState createState() =>
      _LanguageSelectionScreenState();
}

class _LanguageSelectionScreenState extends State<LanguageSelectionScreen> {
  String _selectedLanguage = '한국어';

  void _selectLanguage(String lang) {
    setState(() {
      _selectedLanguage = lang;
    });
    // ScaffoldMessenger.of(context).showSnackBar(
    //   SnackBar(content: Text('$lang 선택됨')),
    // );
  }

  @override
  Widget build(BuildContext context) {
    const baseTextStyle = TextStyle(
      fontWeight: FontWeight.w500,
      color: Colors.black87,
    );

    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(30, 60, 30, 30),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                '여러분의\n언어를 설정하세요',
                style: baseTextStyle.copyWith(
                  fontSize: 38,
                  fontWeight: FontWeight.w700,
                ),
              ),
              const SizedBox(height: 10),
              Text(
                'Select a language',
                style: baseTextStyle.copyWith(
                  fontSize: 26,
                  color: Color(0xFF8A94A3),
                ),
              ),
              const SizedBox(height: 50),

              // --- 2x2 언어 선택 버튼 ---
              Center(
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        _langButton('한국어', 'assets/flags/kr.png'),
                        const SizedBox(width: 8), // 기존 16 → 8
                        _langButton('English', 'assets/flags/us.png'),
                      ],
                    ),
                    const SizedBox(height: 8), // 기존 16 → 8
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        _langButton('中文', 'assets/flags/cn.png'),
                        const SizedBox(width: 8),
                        _langButton('日本語', 'assets/flags/jp.png'),
                      ],
                    ),
                  ],
                ),
              ),


              const Spacer(),

              // --- 테스트 페이지 이동 버튼 ---
              GestureDetector(
                onTap: () => Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => const TestGateScreen()),
                ),
                child: Container(
                  width: double.infinity,
                  height: 50,
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    color: Colors.black87,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: const Text(
                    '테스트 페이지로 이동',
                    style: TextStyle(color: Colors.white, fontSize: 18),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // ------------------------
  // 국기 + 텍스트 버튼
  // ------------------------
    Widget _langButton(String lang, String flagPath) {
    return LanguageButton(
      lang: lang,
      flagPath: flagPath,
      isSelected: _selectedLanguage == lang,
      onSelect: () => _selectLanguage(lang),
    );
  }

}

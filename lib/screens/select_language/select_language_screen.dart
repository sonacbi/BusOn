// 02
// screens > select_language > select_language_screen
// 앱 첫 실행 시, 사용자 언어를 선택하는 화면
import 'package:flutter/material.dart';
import 'package:bus_on/theme/app_colors.dart';
import 'package:bus_on/widgets/language_button.dart';
import '../test/test_gate_screen.dart';
import '../auth/auth_screen.dart';

class LanguageSelectionScreen extends StatefulWidget {
  const LanguageSelectionScreen({super.key});

  @override
  _LanguageSelectionScreenState createState() =>
      _LanguageSelectionScreenState();
}

class _LanguageSelectionScreenState extends State<LanguageSelectionScreen> {
  String _selectedLanguage = '';

  // 언어 선택 처리 + 2초 후 다음 화면 이동

void _selectLanguage(String lang) {
  setState(() {
    _selectedLanguage = lang;
  });

  // 2초 후 AuthScreen으로 이동
  Future.delayed(const Duration(seconds: 2), () {
    if (!mounted) return;
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (_) => AuthScreen()),
    );
  });
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
          padding: const EdgeInsets.fromLTRB(30, 60, 30, 30), // 상단 여백 충분히 확보
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // 상단 텍스트
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
                  color: const Color(0xFF8A94A3),
                ),
              ),
              const SizedBox(height: 50), // 텍스트와 버튼 사이 간격

              // 2x2 버튼 그리드
              Center(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        _langButton('한국어', 'assets/flags/kr.png'),
                        const SizedBox(width: 8),
                        _langButton('English', 'assets/flags/us.png'),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        _langButton('中文', 'assets/flags/cn.png'),
                        const SizedBox(width: 8),
                        _langButton('日本語', 'assets/flags/jp.png'),
                      ],
                    ),
                  ],
                ),
              ),

              const Spacer(), // 버튼 그리드와 하단 버튼 사이 공간

              // 테스트 페이지 버튼
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

  Widget _langButton(String lang, String flagPath) {
    return LanguageButton(
      lang: lang,
      flagPath: flagPath,
      isSelected: _selectedLanguage == lang,
      onSelect: () => _selectLanguage(lang),
    );
  }
}

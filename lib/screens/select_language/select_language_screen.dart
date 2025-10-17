// 02
// screens > select_language > select_language_screen
// 앱 첫 실행 시, 사용자 언어를 선택하는 화면


// 상태 관리 관련 함수는 작성하다가 길어지면 state > app_state 로 분리하시오.
import 'package:flutter/material.dart';

import '../test/test_gate_screen.dart';

class LanguageSelectionScreen extends StatefulWidget {
  const LanguageSelectionScreen({super.key});

  @override
  _LanguageSelectionScreenState createState() =>
      _LanguageSelectionScreenState();
}

class _LanguageSelectionScreenState extends State<LanguageSelectionScreen> {
  String _selectedLanguage = '한국어';

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
                  color: const Color(0xFF8A94A3),
                ),
              ),


              const Spacer(),

              // --- 임시 게이트 버튼 ---
              ElevatedButton(
                onPressed: () => Navigator.push(
                    context,
                    MaterialPageRoute(builder: (_) => TestGateScreen())),
                child: const Text('테스트 페이지로 이동'),
              ),
             
            ],
          ),
        ),
      ),
    );
  }
}
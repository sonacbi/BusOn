import 'package:flutter/material.dart';

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
            ],
          ),
        ),
      ),
    );
  }
}

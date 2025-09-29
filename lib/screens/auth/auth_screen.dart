// 03
// screens > auth > auth_screen.dart
// 로그인 및 회원가입 등 인증 관련 화면

import 'package:flutter/material.dart';
import '../../theme/app_colors.dart';
import '../../theme/text_styles.dart';

class AuthScreen extends StatefulWidget {
  const AuthScreen({super.key});

  @override
  State<AuthScreen> createState() => _AuthScreenState();
}

class _AuthScreenState extends State<AuthScreen> with SingleTickerProviderStateMixin {
  String loginMethod = "phone"; // 현재 로그인 방식 ("phone" 또는 "email")
  TextEditingController phoneController = TextEditingController(); // 휴대폰/이메일 입력 컨트롤러
  TextEditingController authController = TextEditingController();  // 인증번호 입력 컨트롤러
  String? selectedCarrier; // 통신사 선택 값
  bool isAuthRequested = false; // 인증 요청 여부
  late AnimationController _buttonAnimationController; // 버튼 애니메이션 컨트롤러
  late Animation<double> _buttonAnimation; // 버튼 애니메이션 효과

  @override
  void initState() {
    super.initState();
    // 버튼 애니메이션 초기화
    _buttonAnimationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 300),
    );
    _buttonAnimation = Tween<double>(begin: 0, end: 1).animate(CurvedAnimation(
      parent: _buttonAnimationController,
      curve: Curves.easeOut,
    ));
  }

  @override
  void dispose() {
    // 컨트롤러 해제
    phoneController.dispose();
    authController.dispose();
    _buttonAnimationController.dispose();
    super.dispose();
  }

  // 휴대폰/이메일 입력 변경 시 상태 갱신
  void onPhoneChanged(String value) {
    setState(() {});
  }

  // 통신사 선택 시 애니메이션 실행
  void onCarrierSelected(String carrier) {
    setState(() {
      selectedCarrier = carrier;
      _buttonAnimationController.forward();
    });
  }

  // 인증 요청 버튼 클릭 시
  void onRequestAuth() {
    setState(() {
      isAuthRequested = true;
    });
  }

  // 로그인 방식(phone <-> email) 전환
  void onSwitchMethod() {
    setState(() {
      loginMethod = loginMethod == "phone" ? "email" : "phone";
      phoneController.clear(); // 입력 초기화
      authController.clear();
      selectedCarrier = null;
      isAuthRequested = false;
      _buttonAnimationController.reset(); // 애니메이션 리셋
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            // 상단바 (앱 로고 영역)
            Container(
              height: 60,
              color: AppColors.primaryColor,
              alignment: Alignment.center,
              child: Text("앱 로고", style: TextStyles.title.copyWith(color: Colors.white)),
            ),

            // 본문 영역
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // 화면 제목 + 로그인 방식 전환 버튼
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          loginMethod == "phone" ? "휴대폰 로그인" : "이메일 로그인",
                          style: TextStyles.title,
                        ),
                        TextButton(
                          onPressed: phoneController.text.isEmpty ? onSwitchMethod : null,
                          child: Text(
                            "이메일로 로그인",
                            style: TextStyles.body.copyWith(
                              color: phoneController.text.isEmpty
                                  ? AppColors.primaryColor
                                  : AppColors.disabledColor,
                            ),
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(height: 20),

                    // 휴대폰 번호 / 이메일 입력창
                    TextField(
                      controller: phoneController,
                      keyboardType: TextInputType.phone,
                      decoration: InputDecoration(
                        labelText: loginMethod == "phone" ? "휴대폰 번호" : "이메일",
                        border: const OutlineInputBorder(),
                      ),
                      onChanged: onPhoneChanged,
                    ),

                    // 휴대폰 번호 입력 시 통신사 선택 가능
                    if (phoneController.text.isNotEmpty) ...[
                      const SizedBox(height: 10),
                      DropdownButtonFormField<String>(
                        value: selectedCarrier,
                        decoration: const InputDecoration(
                          labelText: "통신사 선택",
                          border: OutlineInputBorder(),
                        ),
                        items: ["SKT", "KT", "LG"]
                            .map((e) => DropdownMenuItem(value: e, child: Text(e)))
                            .toList(),
                        onChanged: (val) => onCarrierSelected(val!),
                      ),
                    ],

                    // 통신사 선택 후 인증번호 입력창 노출
                    if (selectedCarrier != null) ...[
                      const SizedBox(height: 10),
                      TextField(
                        controller: authController,
                        maxLength: 6,
                        keyboardType: TextInputType.number,
                        decoration: const InputDecoration(
                          labelText: "인증번호 6자리 입력",
                          border: OutlineInputBorder(),
                        ),
                      ),
                      const SizedBox(height: 10),
                      Text(isAuthRequested ? "유효시간: 03:00" : ""),
                    ],

                    const Spacer(),

                    // 인증하기 / 로그인하기 버튼 (애니메이션 적용)
                    SizeTransition(
                      sizeFactor: _buttonAnimation,
                      axisAlignment: -1.0,
                      child: ElevatedButton(
                        onPressed: selectedCarrier != null ? onRequestAuth : null,
                        child: Text(isAuthRequested ? "로그인하기" : "인증하기"),
                      ),
                    ),

                    // 이메일 로그인 전환 버튼 (추가 UX)
                    if (phoneController.text.isNotEmpty)
                      Align(
                        alignment: Alignment.center,
                        child: TextButton(
                          onPressed: onSwitchMethod,
                          child: const Text("[이메일로 로그인(체인지)]"),
                        ),
                      ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

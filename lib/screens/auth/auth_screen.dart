// 03
// screens > auth > auth_screen.dart

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../theme/app_colors.dart';
import '../../theme/text_styles.dart';
import '../../states/app_state.dart';

class AuthScreen extends StatefulWidget {
  const AuthScreen({super.key});

  @override
  State<AuthScreen> createState() => _AuthScreenState();
}

class _AuthScreenState extends State<AuthScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _buttonAnimationController;
  late Animation<double> _buttonAnimation;

  @override
  void initState() {
    super.initState();
    _buttonAnimationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 300),
    );
    _buttonAnimation = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(
        parent: _buttonAnimationController,
        curve: Curves.easeOut,
      ),
    );
  }

  @override
  void dispose() {
    _buttonAnimationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final appState = Provider.of<AppState>(context);

    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            // 상단바 (앱 로고 영역)
            Container(
              height: 60,
              color: AppColors.primaryColor,
              alignment: Alignment.center,
              child: Text("앱 로고",
                  style: TextStyles.title.copyWith(color: Colors.white)),
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
                          appState.loginMethod == "phone"
                              ? "휴대폰 로그인"
                              : "이메일 로그인",
                          style: TextStyles.title,
                        ),
                        TextButton(
                          onPressed: appState.phoneController.text.isEmpty
                              ? appState.onSwitchMethod
                              : null,
                          child: Text(
                            "이메일로 로그인",
                            style: TextStyles.body.copyWith(
                              color: appState.phoneController.text.isEmpty
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
                      controller: appState.phoneController,
                      keyboardType: TextInputType.phone,
                      decoration: InputDecoration(
                        labelText: appState.loginMethod == "phone"
                            ? "휴대폰 번호"
                            : "이메일",
                        border: const OutlineInputBorder(),
                      ),
                      onChanged: appState.onPhoneChanged,
                    ),

                    // 휴대폰 번호 입력 시 통신사 선택 가능
                    if (appState.phoneController.text.isNotEmpty) ...[
                      const SizedBox(height: 10),
                      DropdownButtonFormField<String>(
                        value: appState.selectedCarrier,
                        decoration: const InputDecoration(
                          labelText: "통신사 선택",
                          border: OutlineInputBorder(),
                        ),
                        items: ["SKT", "KT", "LG"]
                            .map((e) =>
                                DropdownMenuItem(value: e, child: Text(e)))
                            .toList(),
                        onChanged: (val) {
                          appState.onCarrierSelected(val!);
                          _buttonAnimationController.forward();
                        },
                      ),
                    ],

                    // 통신사 선택 후 인증번호 입력창 노출
                    if (appState.selectedCarrier != null) ...[
                      const SizedBox(height: 10),
                      TextField(
                        controller: appState.authController,
                        maxLength: 6,
                        keyboardType: TextInputType.number,
                        decoration: const InputDecoration(
                          labelText: "인증번호 6자리 입력",
                          border: OutlineInputBorder(),
                        ),
                      ),
                      const SizedBox(height: 10),
                      Text(appState.isAuthRequested ? "유효시간: 03:00" : ""),
                    ],

                    const Spacer(),

                    // 인증하기 / 로그인하기 버튼 (애니메이션 적용)
                    SizeTransition(
                      sizeFactor: _buttonAnimation,
                      axisAlignment: -1.0,
                      child: ElevatedButton(
                        onPressed: appState.selectedCarrier != null
                            ? appState.onRequestAuth
                            : null,
                        child: Text(
                            appState.isAuthRequested ? "로그인하기" : "인증하기"),
                      ),
                    ),

                    // 이메일 로그인 전환 버튼 (추가 UX)
                    if (appState.phoneController.text.isNotEmpty)
                      Align(
                        alignment: Alignment.center,
                        child: TextButton(
                          onPressed: appState.onSwitchMethod,
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

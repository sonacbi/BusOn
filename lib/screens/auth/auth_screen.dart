// 03
// screens > auth > auth_screen.dart

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../theme/app_colors.dart';
import '../../theme/text_styles.dart';
import '../../states/app_state.dart';

import 'package:flutter/services.dart';


class PhoneNumberFormatter extends TextInputFormatter { // 핸드폰 자동 포맷팅 전용 함수
  @override
  TextEditingValue formatEditUpdate(
      TextEditingValue oldValue,
      TextEditingValue newValue,
  ) {
    // 입력값에서 숫자만 남김
    String digits = newValue.text.replaceAll(RegExp(r'\D'), '');

    // 길이에 따라 하이픈 추가
    String formatted = '';
    if (digits.length <= 3) {
      formatted = digits;
    } else if (digits.length <= 7) {
      formatted = '${digits.substring(0, 3)}-${digits.substring(3)}';
    } else if (digits.length <= 11) {
      formatted =
          '${digits.substring(0, 3)}-${digits.substring(3, 7)}-${digits.substring(7)}';
    } else {
      // 11자리 이상 잘라내기
      formatted =
          '${digits.substring(0, 3)}-${digits.substring(3, 7)}-${digits.substring(7, 11)}';
    }

    return TextEditingValue(
      text: formatted,
      selection: TextSelection.collapsed(offset: formatted.length),
    );
  }
}

class AuthScreen extends StatefulWidget {
  const AuthScreen({super.key});

  @override
  State<AuthScreen> createState() => _AuthScreenState();
}

class _AuthScreenState extends State<AuthScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _buttonAnimationController;
  late Animation<double> _buttonAnimation;

  // 상태 관리
  FocusNode idFocus = FocusNode(); // 아이디 입력창 FocusNode
  FocusNode customDomainFocus = FocusNode(); // 도메인 포커스 벗어남 이벤트 시행여부 기록용
  TextEditingController customDomainController = TextEditingController();
  bool isCustomDomain = false; // 직접입력 선택 여부
  String? selectedDomain; // 선택된 도메인
  

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

      // 포커스 잃음 이벤트
      customDomainFocus.addListener(() {
        if (!customDomainFocus.hasFocus && customDomainController.text.isEmpty) {
          setState(() {
            isCustomDomain = false;
          });
        }
      });
    }

  @override
    void dispose() {
      _buttonAnimationController.dispose();
      customDomainFocus.dispose();
      customDomainController.dispose();
      super.dispose();
    }

  @override
  Widget build(BuildContext context) {
    final appState = Provider.of<AppState>(context);

    bool showAuthField = false;// 인증번호 입력창 (조건별 표시)

    if (appState.loginMethod == "phone") {
      // 전화번호 11자리 이상 + 통신사 선택 시
      if ((appState.phoneController.text.replaceAll('-', '').length >= 11) &&
          appState.selectedCarrier != null) {
        showAuthField = true;
      }
    } else {
      // 이메일 모드: 아이디 1자 이상 + 도메인 1자 이상
      String domainText = isCustomDomain
          ? customDomainController.text
          : (selectedDomain ?? "");
      if (appState.phoneController.text.isNotEmpty && domainText.isNotEmpty) {
        showAuthField = true;
      }
    }

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
                padding: const EdgeInsets.all(40.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
// ----- 화면 제목 + 로그인 방식 전환 버튼 -------------------------------------- //
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
          // 타이틀 ------------------------------------------------------------- //
                        Text(
                          appState.loginMethod == "phone"
                              ? "휴대폰 로그인"
                              : "이메일 로그인",
                          style: TextStyles.title,
                        ),
          // -------------------------------------------------------------------- //

          // 전환버튼 ----------------------------------------------------------- //
                        ElevatedButton(
                          onPressed: appState.phoneController.text.isEmpty
                              ? () {
                                  // 로그인 방식 전환
                                  appState.onSwitchMethod();

                                  // 이메일 모드로 돌아올 때 도메인 관련 초기화
                                  setState(() {
                                    isCustomDomain = false;
                                    selectedDomain = null;
                                    customDomainController.clear();
                                  });
                                }
                              : null,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: appState.phoneController.text.isEmpty
                                ? AppColors.buttonActiveColor
                                : AppColors.buttonDisabledColor,
                            foregroundColor: Colors.white,
                            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 0),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(5),
                            ),
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Text(
                                appState.loginMethod == "phone" ? "이메일" : "휴대폰",
                                style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                              ),
                              const SizedBox(width: 2),
                              const Icon(Icons.autorenew, size: 18, color: Colors.white),
                            ],
                          ),
                        ),
          // -------------------------------------------------------------------- //

                      ],
                    ),

                    const SizedBox(height: 20),
// ------------------------------------------------------------------------------ //

// ----- 인증 수단 정보 입력창 -------------------------------------------------- //

                    // 아이디/도메인 분리 이메일 입력

                    // 이메일 모드 입력 -------------------------------------- //
                    if (appState.loginMethod == "email") ...[
                      Row(
                        children: [
                          // 아이디 입력
                          Expanded(
                            child: TextField(
                              focusNode: idFocus,
                              controller: appState.phoneController,
                              decoration: const InputDecoration(
                                labelText: "아이디",
                                hintText: "example",
                                border: OutlineInputBorder(),
                              ),
                            ),
                          ),
                          const SizedBox(width: 8),

                          // 도메인
                          Expanded(
                            child: isCustomDomain
                                ? TextField(
                                    focusNode: customDomainFocus,
                                    controller: customDomainController,
                                    decoration: const InputDecoration(
                                      labelText: "도메인 입력",
                                      hintText: "example.com",
                                      border: OutlineInputBorder(),
                                    ),
                                    onChanged: (val) {
                                      // 비워진 상태에서 삭제 키 감지
                                      if (val.isEmpty && !customDomainFocus.hasFocus) return;

                                      // 직접 입력 비우면 Dropdown으로 전환
                                      if (val.isEmpty) {
                                        setState(() {
                                          isCustomDomain = false;
                                          selectedDomain = null;
                                        });
                                        // 이전 입력창으로 포커스 이동
                                        Future.microtask(() => idFocus.requestFocus());
                                      }
                                    },
                                  )
                                : DropdownButtonFormField<String>(
                                    value: selectedDomain,
                                    decoration: const InputDecoration(
                                      labelText: "도메인",
                                      border: OutlineInputBorder(),
                                    ),
                                    items: [
                                      "gmail.com", "naver.com", "daum.net", "hanmail.net",
                                      "kakao.com", "hotmail.com", "outlook.com", "yahoo.com",
                                      "icloud.com", "직접입력"
                                    ].map((e) => DropdownMenuItem(
                                          value: e,
                                          child: Text(e),
                                        )).toList(),
                                    onChanged: (val) {
                                      if (val == "직접입력") {
                                        setState(() {
                                          isCustomDomain = true;
                                          selectedDomain = null;
                                        });
                                        Future.microtask(() => customDomainFocus.requestFocus());
                                      } else {
                                        setState(() {
                                          isCustomDomain = false;
                                          selectedDomain = val;
                                        });
                                      }
                                    },
                                  ),
                          ),
                        ],
                      )

                    ] else ...[
                      // 핸드폰 모드 입력 -------------------------------------- //
                      TextField(
                        controller: appState.phoneController,
                        keyboardType: TextInputType.phone,
                        inputFormatters: [PhoneNumberFormatter()],
                        decoration: const InputDecoration(
                          labelText: "휴대폰 번호",
                          hintText: "000-0000-0000",
                          border: OutlineInputBorder(),
                        ),
                        onChanged: appState.onPhoneChanged,
                      ),

                      // 통신사 선택 (핸드폰 모드일 때만)
                      if (appState.loginMethod == "phone" &&
                          appState.phoneController.text.isNotEmpty) ...[
                        const SizedBox(height: 10),
                        DropdownButtonFormField<String>(
                          value: appState.selectedCarrier,
                          decoration: const InputDecoration(
                            labelText: "통신사 선택",
                            border: OutlineInputBorder(),
                          ),
                          items: ["SKT", "KT", "LG"]
                              .map((e) => DropdownMenuItem(value: e, child: Text(e)))
                              .toList(),
                          onChanged: (val) {
                            appState.onCarrierSelected(val!);
                            _buttonAnimationController.forward();
                          },
                        ),
                      ],
                    ],

                    if (showAuthField) ...[
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

// ------------------------------------------------------------------------------ //

// ----- 인증번호 발송 / 로그인하기 버튼 ---------------------------------------- //

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

                    // 화면 하단 UX 버튼
                    if (appState.phoneController.text.isNotEmpty)
                      Align(
                        alignment: Alignment.center,
                        child: TextButton.icon(
                          onPressed: () {
                            appState.onSwitchMethod();

                            // 도메인 초기화
                            setState(() {
                              isCustomDomain = false;
                              selectedDomain = null;
                              customDomainController.clear();
                            });
                          },
                          icon: const Icon(Icons.autorenew, size: 18),
                          label: Text(appState.loginMethod == "phone" ? "이메일 로그인" : "휴대폰 로그인"),
                        ),
                      ),

// ------------------------------------------------------------------------------ //

                  ],
                ),
              ),
            ),
          ], // 본문 콘텐츠 끝

        ),
      ),
    );
  }
}

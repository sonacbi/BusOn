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
  
  final GlobalKey _authFieldKey = GlobalKey();
  double topPosition = 0; // TextField 아래 인증버튼 위치

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

      WidgetsBinding.instance.addPostFrameCallback((_) {
        _updateAuthButtonPosition();
      });

    }

  // TextField 렌더 후 위치 계산
  void _updateAuthButtonPosition() {
    if (!mounted) return;
    final context = _authFieldKey.currentContext;
    if (context == null) return;
    final box = context.findRenderObject() as RenderBox?;
    if (box == null || !box.hasSize) return; // 여기서 layout 안 끝나면 그냥 return
    final offset = box.localToGlobal(Offset.zero);
    setState(() {
      topPosition = offset.dy + box.size.height + 8;
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

    // ① 버튼 위치 계산 (build 시작 직후)
    double buttonTop = 0;
    if (showAuthField && _authFieldKey.currentContext != null) {
      final box = _authFieldKey.currentContext!.findRenderObject() as RenderBox?;
      if (box != null && box.hasSize) {
        final offset = box.localToGlobal(Offset.zero);
        buttonTop = offset.dy + box.size.height + 8; // TextField 아래 8px
      }
    }

    if (appState.loginMethod == "phone") {
      // 전화번호 11자리 이상 + 통신사 선택 시
      if ((appState.phoneController.text.replaceAll('-', '').length >= 11) &&
          appState.selectedCarrier != null) {
        showAuthField = true;
        // showAuthField가 true가 됐으니 버튼 위치 재계산
        WidgetsBinding.instance.addPostFrameCallback((_) {
          _updateAuthButtonPosition();
        });
      }
    } else {
      // 이메일 모드: 아이디 1자 이상 + 도메인 1자 이상
      String domainText = isCustomDomain
          ? customDomainController.text
          : (selectedDomain ?? "");
      if (appState.phoneController.text.isNotEmpty && domainText.isNotEmpty) {
        showAuthField = true;
        // showAuthField가 true가 됐으니 버튼 위치 재계산
        WidgetsBinding.instance.addPostFrameCallback((_) {
          _updateAuthButtonPosition();
        });
      }
    }

    return Scaffold(
      body: SafeArea(
        child: Stack(
          children: [
            Column(
              children: [
                // 상단바
                Container(
                  height: 60,
                  color: AppColors.primaryColor,
                  alignment: Alignment.center,
                  child: Text("앱 로고",
                      style: TextStyles.title.copyWith(color: Colors.white)),
                ),
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.all(40.0),
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
                            ElevatedButton(
                              onPressed: appState.phoneController.text.isEmpty
                                  ? () {
                                      appState.onSwitchMethod();
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
                                padding: const EdgeInsets.symmetric(horizontal: 10),
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
                          ],
                        ),

                        const SizedBox(height: 20),

                        // 인증 수단 입력창
                        if (appState.loginMethod == "email") ...[
                          // 이메일 모드 입력
                          Row(
                            children: [
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
                                          if (val.isEmpty && !customDomainFocus.hasFocus) return;
                                          if (val.isEmpty) {
                                            setState(() {
                                              isCustomDomain = false;
                                              selectedDomain = null;
                                            });
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
                                          "kakao.com", "hotmail.com", "outlook.com", "yahoo.com", "icloud.com", "직접입력"
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
                          // 핸드폰 모드 입력
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
                          Stack(
                            children: [
                              TextField(
                                key: _authFieldKey, // key 추가
                                controller: appState.authController,
                                maxLength: 6,
                                keyboardType: TextInputType.number,
                                decoration: const InputDecoration(
                                  labelText: "인증번호 6자리 입력",
                                  border: OutlineInputBorder(),
                                  counterText: "",
                                  contentPadding: EdgeInsets.symmetric(vertical: 16, horizontal: 12),
                                ),
                                onChanged: (_) {
                                  WidgetsBinding.instance.addPostFrameCallback((_) {
                                    _updateAuthButtonPosition();
                                  });
                                },
                              ),
                              Positioned(
                                right: 8,
                                top: 12,
                                bottom: 12,
                                child: Container(
                                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 1),
                                  decoration: BoxDecoration(
                                    color: Colors.orange.shade100,
                                    borderRadius: BorderRadius.circular(4),
                                  ),
                                  alignment: Alignment.center,
                                  child: Text(
                                    appState.isAuthRequested ? "03:00" : "재요청",
                                    style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w500),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ],


                        const Spacer(),
                      ],
                    ),
                  ),
                ),
              ],
            ),

            // 하단 버튼 영역 고정
              // 인증 버튼
              AnimatedBuilder(
                animation: Listenable.merge([appState.authController]),
                builder: (context, _) {
                // 여기서 버튼 활성화 여부 계산
                bool isButtonEnabled = false;

                if (appState.loginMethod == "phone") {
                  String phoneText = appState.phoneController.text.replaceAll('-', '');
                  isButtonEnabled =
                      phoneText.length >= 11 && appState.selectedCarrier != null;
                } else {
                  String domainText = isCustomDomain
                      ? customDomainController.text
                      : (selectedDomain ?? "");
                  isButtonEnabled = appState.phoneController.text.isNotEmpty &&
                      domainText.isNotEmpty;
                }
                  return Positioned(
                    left: 0,
                    right: 0,
                    top: topPosition,
                    child: AnimatedSwitcher(
                      duration: const Duration(milliseconds: 300),
                      transitionBuilder: (child, animation) {
                        final offsetAnimation = Tween<Offset>(
                          begin: const Offset(0, 0.5),
                          end: Offset.zero,
                        ).animate(animation);
                        return SlideTransition(position: offsetAnimation, child: child);
                      },
                      child: showAuthField
                          ? SizedBox(
                              key: const ValueKey('authButton'),
                              width: MediaQuery.of(context).size.width,
                              child: Builder(
                                builder: (context) {
                                  bool isButtonEnabled = false;

                                  if (appState.loginMethod == "phone") {
                                    String phoneText =
                                        appState.phoneController.text.replaceAll('-', '');
                                    isButtonEnabled =
                                        phoneText.length >= 11 && appState.selectedCarrier != null;
                                  } else {
                                    String domainText = isCustomDomain
                                        ? customDomainController.text
                                        : (selectedDomain ?? "");
                                    isButtonEnabled = appState.phoneController.text.isNotEmpty &&
                                        domainText.isNotEmpty;
                                  }

                                  return ElevatedButton(
                                    onPressed: isButtonEnabled ? appState.onRequestAuth : null,
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: isButtonEnabled
                                          ? AppColors.buttonActiveColor
                                          : AppColors.buttonDisabledColor,
                                      foregroundColor: Colors.white,
                                      padding: const EdgeInsets.symmetric(vertical: 16),
                                      shape: const RoundedRectangleBorder(
                                        borderRadius: BorderRadius.zero,
                                      ),
                                    ),
                                    child: Text(
                                      appState.isAuthRequested ? "로그인하기" : "인증하기",
                                      style: const TextStyle(fontSize: 16),
                                    ),
                                  );
                                },
                              ),
                            )
                          : const SizedBox.shrink(),
                    ),
                  );
                },
              ),

        // 하단 UX 버튼 (항상 고정)
        Positioned(
          left: 0,
          right: 0,
          bottom: 0,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const SizedBox(height: 10),
              SizedBox(
                width: MediaQuery.of(context).size.width,
                child: TextButton.icon(
                  onPressed: () {
                    appState.onSwitchMethod();
                    setState(() {
                      isCustomDomain = false;
                      selectedDomain = null;
                      customDomainController.clear();
                      // TextField가 나타나면 버튼 위치 업데이트
                      if (showAuthField) {
                        // 렌더 후 위치 계산
                        WidgetsBinding.instance.addPostFrameCallback((_) {
                          _updateAuthButtonPosition();
                        });
                      }
                    });
                  },
                  icon: const Icon(Icons.autorenew, size: 18),
                  label: Text(
                    appState.loginMethod == "phone" ? "이메일 로그인" : "휴대폰 로그인",
                  ),
                ),
              ),
              const SizedBox(height: 20),
            ],
          ),
        ),
          ],
        ),
      ),
    );

  }
}

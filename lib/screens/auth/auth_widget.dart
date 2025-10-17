// screens > auth > auth_widget.dart
import 'package:flutter/material.dart';
import '../../theme/app_colors.dart';
import '../../theme/text_styles.dart';
import '../../states/app_state.dart';
import '../../utils/ui_helper.dart';

import 'package:flutter/services.dart';

class AuthHeader extends StatelessWidget {
  final String loginMethod; // "phone" 또는 "email"
  final bool isPhoneEmpty; // 휴대폰 입력값이 비어있는지
  final VoidCallback onSwitchMethod; // 로그인 방식 전환 콜백

  const AuthHeader({
    super.key,
    required this.loginMethod,
    required this.isPhoneEmpty,
    required this.onSwitchMethod,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          loginMethod == "phone" ? "휴대폰 로그인" : "이메일 로그인",
          style: TextStyles.title,
        ),
        ElevatedButton(
          onPressed: isPhoneEmpty ? onSwitchMethod : null,
          style: ElevatedButton.styleFrom(
            backgroundColor:
                isPhoneEmpty ? AppColors.buttonActiveColor : AppColors.buttonDisabledColor,
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
                loginMethod == "phone" ? "이메일" : "휴대폰",
                style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
              ),
              const SizedBox(width: 2),
              const Icon(Icons.autorenew, size: 18, color: Colors.white),
            ],
          ),
        ),
      ],
    );
  }
}

class AuthInputField extends StatelessWidget {
  final AppState appState;
  final bool isCustomDomain;
  final TextEditingController customDomainController;
  final FocusNode idFocus;
  final FocusNode customDomainFocus;
  final String? selectedDomain; // 선택된 도메인
  final Function(String?) setSelectedDomain; // 선택값 변경 콜백
  final Function(bool) setCustomDomain; // isCustomDomain 변경 콜백
  final Function(bool) setShowAuthField; // showauthfield 변경 콜백


  const AuthInputField({
    super.key,
    required this.appState,
    required this.isCustomDomain,
    required this.customDomainController,
    required this.idFocus,
    required this.customDomainFocus,
    required this.setCustomDomain,
    required this.selectedDomain,
    required this.setSelectedDomain,
    required this.setShowAuthField,
  });

  @override
  Widget build(BuildContext context) {
    if (appState.loginMethod == "email") {
      // 이메일 모드 입력
      return Row(
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
                        setCustomDomain(false);
                        Future.microtask(() => idFocus.requestFocus());
                      }

                      // 👉 입력값 바뀔 때마다 버튼 노출 조건 확인
                      String domainText = isCustomDomain
                          ? customDomainController.text
                          : (selectedDomain ?? "");
                      if (appState.phoneController.text.isNotEmpty && domainText.isNotEmpty) {
                        setShowAuthField(true);
                      } else {
                        setShowAuthField(false);
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
                      "gmail.com", "naver.com", "daum.net",
                      "hanmail.net", "kakao.com", "hotmail.com",
                      "outlook.com", "yahoo.com", "icloud.com",
                      "직접입력"
                    ].map((e) => DropdownMenuItem(
                          value: e,
                          child: Text(e),
                        )).toList(),
                    onChanged: (val) {
                      if (val == "직접입력") {
                        setCustomDomain(true);
                        Future.microtask(() => customDomainFocus.requestFocus());
                      } else {
                        setCustomDomain(false);
                        setSelectedDomain(val);
                      }
                    },
                  ),
          ),
        ],
      );
    } else {
      // 핸드폰 모드 입력
      return Column(
        children: [
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
          if (appState.phoneController.text.isNotEmpty) ...[
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
              },
            ),
          ],
        ],
      );
    }
  }
}

class AuthCodeField extends StatefulWidget {
  final AppState appState;
  final GlobalKey authFieldKey;
  final VoidCallback updateButtonPosition;

  const AuthCodeField({
    super.key,
    required this.appState,
    required this.authFieldKey,
    required this.updateButtonPosition,
  });

  @override
  _AuthCodeFieldState createState() => _AuthCodeFieldState();
}

class _AuthCodeFieldState extends State<AuthCodeField> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      widget.updateButtonPosition();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const SizedBox(height: 10),
        Stack(
          children: [
            TextField(
              key: widget.authFieldKey,
              controller: widget.appState.authController,
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
                  widget.updateButtonPosition();
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
                  widget.appState.isAuthRequested ? "03:00" : "재요청",
                  style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w500),
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }
}

class AuthActionButton extends StatelessWidget {
  final AppState appState;
  final bool showAuthField;
  final bool isCustomDomain;
  final String? selectedDomain;
  final TextEditingController customDomainController;
  final double topPosition;

  const AuthActionButton({
    super.key,
    required this.appState,
    required this.showAuthField,
    required this.isCustomDomain,
    required this.selectedDomain,
    required this.customDomainController,
    required this.topPosition,
  });

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: Listenable.merge([appState.authController]),
      builder: (context, _) {
        // 버튼 활성화 여부 계산
        bool isButtonEnabled = false;

        if (appState.loginMethod == "phone") {
          String phoneText = appState.phoneController.text.replaceAll('-', '');
          isButtonEnabled =
              phoneText.length >= 11 && appState.selectedCarrier != null;
        } else {
          String domainText =
              isCustomDomain ? customDomainController.text : (selectedDomain ?? "");
          isButtonEnabled =
              appState.phoneController.text.isNotEmpty && domainText.isNotEmpty;
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
                    child: ElevatedButton(
                      onPressed: isButtonEnabled
                          ? () {
                              appState.onRequestAuth(
                                selectedDomain: selectedDomain,
                                isCustomDomain: isCustomDomain,
                                customDomainController: customDomainController,
                              );
                            }
                          : null,
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
                    ),
                  )
                : const SizedBox.shrink(),
          ),
        );
      },
    );
  }
}

class AuthSwitchButton extends StatelessWidget {
  final AppState appState;
  final VoidCallback onResetFields;

  const AuthSwitchButton({
    super.key,
    required this.appState,
    required this.onResetFields,
  });

  @override
  Widget build(BuildContext context) {
    return Positioned(
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
                onResetFields(); // 화면 상태 초기화 콜백 실행
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
    );
  }
}

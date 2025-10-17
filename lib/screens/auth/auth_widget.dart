// screens > auth > auth_widget.dart
import 'dart:async';
import 'package:flutter/material.dart';
import '../../theme/app_colors.dart';
import '../../theme/text_styles.dart';
import '../../states/app_state.dart';
import '../../utils/ui_helper.dart';
import '../../widgets/app_button.dart';
import '../../widgets/app_input.dart';

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
        AppButton(
          text: loginMethod == "phone" ? "이메일" : "휴대폰",
          icon: Icons.autorenew,
          iconPosition: ButtonIconPosition.right,
          onPressed: isPhoneEmpty ? onSwitchMethod : () {},
          color: isPhoneEmpty 
            ? AppColors.buttonActiveColor 
            : AppColors.buttonDisabledColor.withOpacity(0.4), // 연하게
          pressedColor: AppColors.buttonActiveColor.withOpacity(0.8),
          width: 80,
          height: 30,
          textSize: 14,
          borderRadius: 5,
          elevation: 2,
          // ───────────── 내부 패딩 커스터마이징 ─────────────
          contentPadding: const EdgeInsets.symmetric(horizontal: 8), // 좌우 안쪽 여백 축소
          iconSpacing: 4, // 텍스트와 아이콘 간격 줄임
        )
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
  final String? selectedDomain;
  final Function(String?) setSelectedDomain;
  final Function(bool) setCustomDomain;
  final Function(bool) setShowAuthField;

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
      return Row(
        children: [
          Expanded(
            child: AppInput(
              focusNode: idFocus,
              controller: appState.phoneController,
              labelText: "아이디",
              hintText: "example",
            ),
          ),
          const SizedBox(width: 8),
          Expanded(
            child: isCustomDomain
                ? AppInput(
                    focusNode: customDomainFocus,
                    controller: customDomainController,
                    labelText: "도메인 입력",
                    hintText: "example.com",
                    onChanged: (val) {
                      if (val.isEmpty && !customDomainFocus.hasFocus) return;
                      if (val.isEmpty) {
                        setCustomDomain(false);
                        Future.microtask(() => idFocus.requestFocus());
                      }

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
      return Column(
        children: [
          AppInput(
            controller: appState.phoneController,
            keyboardType: TextInputType.phone,
            inputFormatters: [PhoneNumberFormatter()],
            labelText: "휴대폰 번호",
            hintText: "000-0000-0000",
            prefixIcon: Icon(Icons.phone, color: Colors.grey.shade600), // 여기에 아이콘 추가
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


  void _onResend() {
    // 🔹 인증번호 재요청 로그
    print("인증번호 재요청");

    // 🔹 AppState 타이머 시작
    widget.appState.startAuthTimer();

    // 🔹 인증 요청
    widget.appState.onRequestAuth(
      selectedDomain: null,
      isCustomDomain: false,
      customDomainController: TextEditingController(),
    );
  }


  String _formatTime(int seconds) {
    final m = (seconds ~/ 60).toString().padLeft(2, '0');
    final s = (seconds % 60).toString().padLeft(2, '0');
    return "$m:$s";
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const SizedBox(height: 10),
        AppInput(
          key: widget.authFieldKey,
          controller: widget.appState.authController,
          labelText: "인증번호 입력",
          hintText: "6자리 숫자를 입력하세요",
          borderRadius: 12,
          fillColor: Colors.grey.shade100,
          prefixIcon: Icon(Icons.confirmation_number, color: Colors.grey.shade600),
          maxLength: 6,
          counterText: "",
          keyboardType: TextInputType.number,
          contentPadding: const EdgeInsets.symmetric(vertical: 16, horizontal: 12),
          suffixIcon: SizedBox(
            width: 100,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                  decoration: BoxDecoration(
                    color: widget.appState.isTimerActive
                        ? Colors.grey.shade300  // 타이머 진행 중 회색
                        : Colors.orange.shade100, // 재요청 가능 시 주황
                    borderRadius: BorderRadius.circular(6),
                  ),
                  child: Text(
                    widget.appState.isTimerActive
                        ? "${(widget.appState.authSeconds ~/ 60).toString().padLeft(2,'0')}:${(widget.appState.authSeconds % 60).toString().padLeft(2,'0')}"
                        : "재요청",
                    style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w500),
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.refresh, size: 16),
                  padding: EdgeInsets.zero,
                  constraints: const BoxConstraints(),
                  onPressed: widget.appState.canResend ? _onResend : null, // 🔹 타이머 중이면 비활성
                ),
              ],
            ),
          ),
          onChanged: (_) {
            WidgetsBinding.instance.addPostFrameCallback((_) {
              widget.updateButtonPosition();
            });
          },
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
        bool isButtonEnabled = false;

        if (appState.loginMethod == "phone") {
          String phoneText = appState.phoneController.text.replaceAll('-', '');
          isButtonEnabled = phoneText.length >= 11 && appState.selectedCarrier != null;
        } else {
          String domainText =
              isCustomDomain ? customDomainController.text : (selectedDomain ?? "");
          isButtonEnabled = appState.phoneController.text.isNotEmpty && domainText.isNotEmpty;
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
                    child: AppButton(
                      text: appState.isAuthRequested ? "로그인하기" : "인증하기",
                      onPressed: isButtonEnabled
                        ? () {
                            // 인증 요청
                            appState.onRequestAuth(
                              selectedDomain: selectedDomain,
                              isCustomDomain: isCustomDomain,
                              customDomainController: customDomainController,
                            );

                            // 타이머 시작
                            appState.startAuthTimer();
                        }
                        : () {},
                      color: isButtonEnabled ? AppColors.buttonActiveColor : AppColors.buttonDisabledColor,
                      pressedColor: AppColors.buttonActiveColor.withOpacity(0.8),
                      width: MediaQuery.of(context).size.width,
                      height: 50,
                      textSize: 16,
                      borderRadius: 0,
                      elevation: 0,
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
                onResetFields();
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

// 03
// screens > auth > auth_screen.dart

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../theme/app_colors.dart';
import '../../theme/text_styles.dart';
import '../../states/app_state.dart';
import 'auth_widget.dart';

import 'package:flutter/services.dart';

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

  bool showAuthField = false;// 인증번호 입력창 (조건별 표시)
  void setShowAuthField(bool val) {
    setState(() { showAuthField = val; // showAuthField가 true로 바뀌었을 때만 버튼 위치 재계산
      final appState = Provider.of<AppState>(context, listen: false);
      if (showAuthField) { WidgetsBinding.instance.addPostFrameCallback((_) { _updateAuthButtonPosition(); }); } else { appState.isAuthRequested = false; }
    });
  }

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
      if ((appState.phoneController.text.replaceAll('-', '').length >= 11) && appState.selectedCarrier != null) { setShowAuthField(true); }
    } else {
      // 이메일 모드: 아이디 1자 이상 + 도메인 1자 이상
      String domainText = isCustomDomain
          ? customDomainController.text
          : (selectedDomain ?? "");
      if (appState.phoneController.text.isNotEmpty && domainText.isNotEmpty) { setShowAuthField(true); } else { setShowAuthField(false);}
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
                        AuthHeader(
                          loginMethod: appState.loginMethod,
                          isPhoneEmpty: appState.phoneController.text.isEmpty,
                          onSwitchMethod: () {
                            appState.onSwitchMethod();
                            setState(() {
                              isCustomDomain = false;
                              selectedDomain = null;
                              customDomainController.clear();
                              setShowAuthField(false);
                            });
                          },
                        ),

                        const SizedBox(height: 20),

                        // 인증 수단 입력창
                        AuthInputField(
                          appState: appState,
                          isCustomDomain: isCustomDomain,
                          customDomainController: customDomainController,
                          idFocus: idFocus,
                          customDomainFocus: customDomainFocus,
                          setCustomDomain: (val) {
                            setState(() {
                              isCustomDomain = val;
                              if (!val) selectedDomain = appState.selectedDomain;
                            });
                          },
                          selectedDomain: selectedDomain,
                          setSelectedDomain: (val) => setState(() { selectedDomain = val; }),
                          setShowAuthField: (val) => setState(() { showAuthField = val; }),
                        ),

                        // 인증 번호 입력창
                        if (showAuthField)
                          AuthCodeField(
                            appState: appState,
                            authFieldKey: _authFieldKey,
                            updateButtonPosition: _updateAuthButtonPosition,
                          ),

                        const Spacer(),
                      ],
                    ),
                  ),
                ),
              ],
            ),

            // 하단 버튼 영역 고정
            // 인증 버튼
            AuthActionButton(
              appState: appState,
              showAuthField: showAuthField,
              isCustomDomain: isCustomDomain,
              selectedDomain: selectedDomain,
              customDomainController: customDomainController,
              topPosition: topPosition,
            ),

            // 하단 토글 버튼 (항상 고정)
            AuthSwitchButton(
              appState: appState,
              onResetFields: () {
                setState(() {
                  isCustomDomain = false;
                  selectedDomain = null;
                  customDomainController.clear();
                  showAuthField = false;
                });
              },
            ),

          ],
        ),
      ),
    );

  }
}

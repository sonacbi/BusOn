// lib/states/app_state.dart
// 앱 전반에서 공통으로 관리되는 상태(State)를 정의한 파일
// (예: 로그인 여부, 사용자 정보, 테마 모드, 언어 설정 등)

import 'dart:async';
import 'package:flutter/material.dart';

class AppState extends ChangeNotifier {
  // 🔹 상태 변수들
  final TextEditingController phoneController = TextEditingController();
  final TextEditingController authController = TextEditingController();
  
  String? selectedCarrier; // 통신사 선택 값
  String loginMethod = "phone"; // 현재 로그인 방식 ("phone" 또는 "email")

  bool get canResend => !isTimerActive; // 🔹 재요청 가능 여부

  // 인증 타이머 관련
  Timer? _authTimer;
  int authSeconds = 180;
  bool isTimerActive = false;

  // 인증 요청 여부
  bool isAuthRequested = false;

  String? selectedDomain; // 선택된 도메인


  // 휴대폰/이메일 입력 변경 시 상태 갱신
  void onPhoneChanged(String value) {
    notifyListeners();
  }

  // 통신사 선택 시
  void onCarrierSelected(String carrier) {
    selectedCarrier = carrier;
    notifyListeners();
  }

  // 로그인 방식(phone <-> email) 전환
  void onSwitchMethod() {
    loginMethod = loginMethod == "phone" ? "email" : "phone";
    phoneController.clear();
    authController.clear();
    selectedCarrier = null;
    isAuthRequested = false;

    // 🔹 로그인 방식 전환 시 타이머 초기화
    stopAuthTimer();
    authSeconds = 180;

    notifyListeners();
  }

void startAuthTimer() {
    if (_authTimer != null) {
      _authTimer!.cancel();
    }

    authSeconds = 180; // 3분 제한
    isTimerActive = true;
    notifyListeners();

    _authTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (authSeconds <= 0) {
        timer.cancel();
        isTimerActive = false;
        notifyListeners();
      } else {
        authSeconds--;
        notifyListeners();
      }
    });
  }

  void stopAuthTimer() {
    _authTimer?.cancel();
    isTimerActive = false;
    notifyListeners();
  }


  // 👉 인증 요청 함수 (백엔드로 전송)
  Future<void> onRequestAuth({
    String? selectedDomain,
    bool isCustomDomain = false,
    TextEditingController? customDomainController,
  }) async {
    Map<String, dynamic> payload = {};

    if (loginMethod == "phone") {
      // 전화번호 모드
      String phoneText = phoneController.text.replaceAll("-", "");
      if (phoneText.length < 10 || selectedCarrier == null) {
        debugPrint("❌ 전화번호/통신사 입력 오류");
        return;
      }

      payload = {
        "type": "phone",
        "phone": phoneText,
        "carrier": selectedCarrier,
      };
    } else {
      // 이메일 모드
      String id = phoneController.text.trim();
      String domain = isCustomDomain
          ? customDomainController?.text.trim() ?? ""
          : (selectedDomain ?? "");

      if (id.isEmpty || domain.isEmpty) {
        debugPrint("❌ 이메일 입력 오류");
        return;
      }

      payload = {
        "type": "email",
        "email": "$id@$domain",
      };
    }

    debugPrint("📤 서버 전송 데이터: $payload");

    try {
      // 예: http 요청
      // final response = await http.post(
      //   Uri.parse("https://example.com/auth/request"),
      //   headers: {"Content-Type": "application/json"},
      //   body: jsonEncode(payload),
      // );
      // debugPrint("✅ 서버 응답: ${response.body}");

      isAuthRequested = true;
      notifyListeners();
    } catch (e) {
      debugPrint("❌ 서버 요청 실패: $e");
    }
  }

  @override
  void dispose() {
    phoneController.dispose();
    authController.dispose();
    super.dispose();
  }
}

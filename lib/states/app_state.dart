// lib/states/app_state.dart
// 앱 전반에서 공통으로 관리되는 상태(State)를 정의한 파일
// (예: 로그인 여부, 사용자 정보, 테마 모드, 언어 설정 등)

import 'package:flutter/material.dart';

class AppState extends ChangeNotifier {
  String loginMethod = "phone"; // 현재 로그인 방식 ("phone" 또는 "email")
  String? selectedCarrier; // 통신사 선택 값
  bool isAuthRequested = false; // 인증 요청 여부

  final TextEditingController phoneController = TextEditingController();
  final TextEditingController authController = TextEditingController();

  // 휴대폰/이메일 입력 변경 시 상태 갱신
  void onPhoneChanged(String value) {
    notifyListeners();
  }

  // 통신사 선택 시
  void onCarrierSelected(String carrier) {
    selectedCarrier = carrier;
    notifyListeners();
  }

  // 인증 요청 버튼 클릭 시
  void onRequestAuth() {
    isAuthRequested = true;
    notifyListeners();
  }

  // 로그인 방식(phone <-> email) 전환
  void onSwitchMethod() {
    loginMethod = loginMethod == "phone" ? "email" : "phone";
    phoneController.clear();
    authController.clear();
    selectedCarrier = null;
    isAuthRequested = false;
    notifyListeners();
  }

  @override
  void dispose() {
    phoneController.dispose();
    authController.dispose();
    super.dispose();
  }
}

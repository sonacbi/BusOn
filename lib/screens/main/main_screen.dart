// 04
// screens > main > main_screen.dart
// 로그인 이후 표시되는 메인 화면
// (예: 홈, 주요 기능 진입점)

// 상태 관리 관련 함수는 작성하다가 길어지면 state > app_state 로 분리하시오.
import 'package:flutter/material.dart';
import '../../widgets/app_button.dart';
import '../../theme/app_colors.dart';
import '../../widgets/buson_logo.dart';

class MainScreen extends StatelessWidget {
  final String userName;
  final String? profileImage;
  final String? bankName;
  final int chargeAmount;

  const MainScreen({
    super.key,
    required this.userName,
    this.profileImage,
    this.bankName,
    required this.chargeAmount,
  });

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      backgroundColor: Colors.grey.shade100,
      appBar: AppBar(
        backgroundColor: AppColors.primaryColor,
        elevation: 0,
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: const [
            BusOnLogo(fontSize: 24, color: Colors.white),
            Icon(Icons.menu, color: Colors.white, size: 28),
          ],
        ),
      ),
body: Column(
  children: [
    Spacer(), // 위쪽 남는 공간
    // 🔹 사용자 정보 + 카드 영역
    Column(
      mainAxisSize: MainAxisSize.min, // 내용물만큼만
      children: [
        SizedBox(
          width: cardWidth,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                "$userName님의\n교통카드",
                style: const TextStyle(
                    fontSize: 22, fontWeight: FontWeight.w600),
              ),
              CircleAvatar(
                radius: 30,
                backgroundImage: profileImage != null
                    ? AssetImage(profileImage!)
                    : const AssetImage(
                        'assets/images/default_profile.png'),
              ),
            ],
          ),
        ),
        const SizedBox(height: 16),
        SizedBox(
          width: cardWidth,
          height: cardHeight,
          child: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20),
              border: Border.all(color: Colors.grey.shade400, width: 2),
              color: Colors.white,
            ),
            child: Row(
              children: [
                // 왼쪽 영역
                Expanded(
                  flex: 3,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                        height: cardHeight * 0.6,
                        decoration: BoxDecoration(
                          color: Colors.orange.shade200,
                          borderRadius: const BorderRadius.only(
                              topLeft: Radius.circular(20)),
                        ),
                      ),
                      Container(
                        height: cardHeight * 0.4,
                        decoration: BoxDecoration(
                          color: Colors.orange.shade100,
                          borderRadius: const BorderRadius.only(
                              bottomLeft: Radius.circular(20)),
                        ),
                        child: Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(bankName ?? "빛가람은행",
                                  style: const TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.w600)),
                              Text("$chargeAmount원",
                                  style: const TextStyle(
                                      fontSize: 14,
                                      fontWeight: FontWeight.w400)),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                // 오른쪽 영역
                Expanded(
                  flex: 2,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Expanded(
                        flex: 3,
                        child: Container(
                          alignment: Alignment.center,
                          decoration: const BoxDecoration(
                            color: Colors.orange,
                            borderRadius: BorderRadius.only(
                                topRight: Radius.circular(20)),
                          ),
                          child: Transform.rotate(
                            angle: 90 * 3.141592 / 180,
                            child: const Text(
                              "BUSONCARD",
                              style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white),
                            ),
                          ),
                        ),
                      ),
                      Expanded(
                        flex: 2,
                        child: Container(
                          alignment: Alignment.center,
                          decoration: const BoxDecoration(
                            color: Colors.orangeAccent,
                            borderRadius: BorderRadius.only(
                                bottomRight: Radius.circular(20)),
                          ),
                          child: Transform.rotate(
                            angle: 90 * 3.141592 / 180,
                            child: const Text(
                              "polarlis",
                              style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    ),
    Spacer(), // 아래쪽 남는 공간
  ],
),

      bottomNavigationBar: Container(
        color: Colors.white,
        padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 16),
        child: Row(
          children: [
            Expanded(
              child: AppButton(
                text: "충전하기",
                onPressed: () => print("충전하기 클릭"),
                color: AppColors.primaryColor,
                pressedColor: AppColors.primaryColor.withOpacity(0.8),
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: AppButton(
                text: "결제하기",
                onPressed: () => print("결제하기 클릭"),
                color: Colors.orange.shade600,
                pressedColor: Colors.orange.shade700,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

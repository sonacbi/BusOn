// 04
// screens > main > main_screen.dart
// 로그인 이후 표시되는 메인 화면
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

    const double horizontalPadding = 40;
    double cardWidth = screenWidth - horizontalPadding * 2;
    double cardHeight = cardWidth * 3 / 2;
    final maxHeight = screenHeight - kToolbarHeight - 100;
    if (cardHeight > maxHeight) {
      cardHeight = maxHeight;
      cardWidth = cardHeight * 2 / 3;
    }

    // IC칩 위치
    final double icTop = cardHeight * 0.08;
    final double icRight = cardWidth * 0.30;
    final double icWidth = cardWidth * 0.15;
    final double icHeight = icWidth * 1.3;

    // 오른쪽 수직 텍스트 패딩
    final double rightEdgePadding = cardWidth * 0.02;

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
          const Spacer(),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: horizontalPadding),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // 사용자 정보
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    SizedBox(
                      width: cardWidth * 0.6,
                      child: Text(
                        "$userName님의\n교통카드",
                        style: const TextStyle(
                            fontSize: 22, fontWeight: FontWeight.w600),
                      ),
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
                const SizedBox(height: 16),

                // 카드 영역
                SizedBox(
                  width: cardWidth,
                  height: cardHeight,
                  child: Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(20),
                      border:
                      Border.all(color: Colors.grey.shade400, width: 2),
                      color: Colors.white,
                    ),
                    child: Stack(
                      children: [
                        // 카드 배경
                        Row(
                          children: [
                            Expanded(
                              flex: 8,
                              child: Container(
                                decoration: BoxDecoration(
                                  color: Colors.orange.shade200,
                                  borderRadius: const BorderRadius.only(
                                      topLeft: Radius.circular(20),
                                      bottomLeft: Radius.circular(20)),
                                ),
                              ),
                            ),
                            Expanded(
                              flex: 2,
                              child: Column(
                                children: [
                                  Expanded(
                                    flex: 3,
                                    child: Container(
                                      decoration: const BoxDecoration(
                                        color: Colors.orange,
                                        borderRadius: BorderRadius.only(
                                            topRight: Radius.circular(20)),
                                      ),
                                    ),
                                  ),
                                  Expanded(
                                    flex: 2,
                                    child: Container(
                                      decoration: const BoxDecoration(
                                        color: Colors.orangeAccent,
                                        borderRadius: BorderRadius.only(
                                            bottomRight: Radius.circular(20)),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),

                        // 카드 긁는 방향 표시 아이콘
                        Positioned(
                          right: icRight - 12,           // IC칩 right 기준, 살짝 안쪽으로 조정
                          top: icTop - 40,              // IC칩 위쪽에서 살짝 여유
                          child: Transform.rotate(
                            angle: 3.14159 / 2,         // 90도 회전 (세로)
                            child: Transform.scale(
                              scaleY: 2.8,              // 세로로 늘려서 긁는 느낌
                              alignment: Alignment.topCenter,
                              child: const Text(
                                '<',
                                style: TextStyle(
                                  fontSize: 24,
                                  fontWeight: FontWeight.w600, // 굵게
                                  color: Colors.white70,
                                ),
                              ),
                            ),
                          ),
                        ),

                        // IC칩
                        Positioned(
                          top: icTop,
                          right: icRight,
                          child: Container(
                            width: icWidth,
                            height: icHeight,
                            decoration: BoxDecoration(
                              color: Colors.yellow.shade700,
                              borderRadius: BorderRadius.circular(4),
                              border:
                              Border.all(color: Colors.grey, width: 1),
                            ),
                            child: Table(
                              // Table로 셀 테두리 제어 (원본 그대로)
                              children: [
                                // 1행
                                TableRow(
                                  children: [
                                    Container(
                                      height: icHeight / 3,
                                      decoration: const BoxDecoration(
                                        border: Border(
                                          top: BorderSide(
                                              color: Colors.grey, width: 1),
                                          left: BorderSide(
                                              color: Colors.grey, width: 1),
                                          right: BorderSide(
                                              color: Colors.grey, width: 1),
                                          bottom: BorderSide(
                                              color: Colors.grey, width: 1),
                                        ),
                                      ),
                                    ),
                                    Container(
                                      height: icHeight / 3,
                                      decoration: const BoxDecoration(
                                        border: Border(
                                          top: BorderSide(
                                              color: Colors.grey, width: 1),
                                          bottom: BorderSide(
                                              color: Colors.grey, width: 1),
                                        ),
                                      ),
                                    ),
                                    Container(
                                      height: icHeight / 3,
                                      decoration: const BoxDecoration(
                                        border: Border(
                                          top: BorderSide(
                                              color: Colors.grey, width: 1),
                                          left: BorderSide(
                                              color: Colors.grey, width: 1),
                                          right: BorderSide(
                                              color: Colors.grey, width: 1),
                                          bottom: BorderSide(
                                              color: Colors.grey, width: 1),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                                // 2행
                                TableRow(
                                  children: [
                                    Container(
                                      height: icHeight / 3,
                                      decoration: const BoxDecoration(
                                        border: Border(
                                          left: BorderSide(
                                              color: Colors.grey, width: 1),

                                        ),
                                      ),
                                    ),
                                    Container(
                                      height: icHeight / 3,
                                    ),
                                    Container(
                                      height: icHeight / 3,
                                      decoration: const BoxDecoration(
                                        border: Border(
                                          right: BorderSide(
                                              color: Colors.grey, width: 1),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                                // 3행
                                TableRow(
                                  children: [
                                    Container(
                                      height: icHeight / 3,
                                      decoration: const BoxDecoration(
                                        border: Border(
                                          top: BorderSide(
                                              color: Colors.grey, width: 1),
                                          left: BorderSide(
                                              color: Colors.grey, width: 1),
                                          right: BorderSide(
                                              color: Colors.grey, width: 1),
                                          bottom: BorderSide(
                                              color: Colors.grey, width: 1),
                                        ),
                                      ),
                                    ),
                                    Container(
                                      height: icHeight / 3,
                                      decoration: const BoxDecoration(
                                        border: Border(
                                          top: BorderSide(
                                              color: Colors.grey, width: 1),
                                          bottom: BorderSide(
                                              color: Colors.grey, width: 1),
                                        ),
                                      ),
                                    ),
                                    Container(
                                      height: icHeight / 3,
                                      decoration: const BoxDecoration(
                                        border: Border(
                                          left: BorderSide(
                                              color: Colors.grey, width: 1),
                                          right: BorderSide(
                                              color: Colors.grey, width: 1),
                                          bottom: BorderSide(
                                              color: Colors.grey, width: 1),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ),

                        // 카드 내부 우측 수직 텍스트
                        Positioned(
                          top: cardHeight * 0.08,
                          bottom: cardHeight * 0.08,
                          right: rightEdgePadding,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: const [
                              RotatedBox(
                                quarterTurns: 1, // 90도 회전
                                child: Text(
                                  "BUSONCARD",
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white,
                                    fontSize: 14,
                                    letterSpacing: 1.2,
                                  ),
                                ),
                              ),
                              RotatedBox(
                                quarterTurns: 1,
                                child: Text(
                                  "polaris",
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white,
                                    fontSize: 12,
                                    letterSpacing: 1.1,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),

                        // 은행 + 금액 (왼쪽 하단)
                        Positioned(
                          bottom: cardHeight * 0.08,
                          left: cardWidth * 0.05,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
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
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
          const Spacer(),
        ],
      ),
      bottomNavigationBar: SafeArea(
        top: false, // 상단은 건드리지 않음
        child: Container(
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
      ),

    );
  }
}

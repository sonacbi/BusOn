// 04
// screens > main > main_screen.dart
// 로그인 이후 표시되는 메인 화면
import 'package:flutter/material.dart';
import '../../widgets/app_button.dart';
import '../../theme/app_colors.dart';
import '../../widgets/buson_logo.dart';
import '../../theme/app_theme.dart';

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
    const double horizontalPadding = 40;

    return Scaffold(
      backgroundColor: Colors.grey.shade100,
      // 상단바 교체
      appBar: AppBar(
        backgroundColor: AppColors.primaryColor,
        toolbarHeight: 70, // 내부 컨텐츠 높이
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: const [
            BusOnLogo(fontSize: 24, color: Colors.white),
            Icon(Icons.menu, color: Colors.white, size: 28),
          ],
        ),
        automaticallyImplyLeading: false, // 기본 뒤로가기 버튼 제거
      ),



      body: LayoutBuilder(
        builder: (context, constraints) {
          final double screenWidth = constraints.maxWidth;
          final double screenHeight = constraints.maxHeight;

          // 기준 가로폭 계산
          double cardWidth = screenWidth - horizontalPadding * 2;
          double cardHeight = cardWidth * 3 / 2;

          // 세로 공간이 부족할 경우 자동 축소
          final double maxCardAreaRatio = 0.75;
          final double maxAllowedCardHeight = screenHeight * maxCardAreaRatio;
          if (cardHeight > maxAllowedCardHeight) {
            cardHeight = maxAllowedCardHeight;
            cardWidth = cardHeight * 2 / 3; // 비율 유지
          }

          final double contentWidth = cardWidth;

          // IC칩 위치
          final double icTop = cardHeight * 0.08;
          final double icRight = cardWidth * 0.30;
          final double icWidth = cardWidth * 0.15;
          final double icHeight = icWidth * 1.3;
          final double rightEdgePadding = cardWidth * 0.02;

          // 아이콘 크기
          final double iconBaseWidth = 24;
          final double iconBaseHeight = 24;

          // IC칩 중심
          final double icCenterX = icRight + icWidth / 2;
          final double icCenterY = icTop + icHeight / 2;

          // 하드코딩 오프셋 (원래 기준)
          final double offsetTop = -30 / cardHeight;
          final double offsetRight = -12 / cardWidth;

          // 스케일 적용 전 위치 계산
          final double preTransformTop = icCenterY + cardHeight * offsetTop;
          final double preTransformRight = icCenterX + cardWidth * offsetRight;

          // Transform.scale(1.0, 2.8) 후 중앙 맞춤
          final double iconTop =
              preTransformTop - (iconBaseHeight * 2.8) / 2 + iconBaseHeight / 2;
          final double iconRight = preTransformRight - iconBaseWidth / 2;

          return Center(
            child: Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: horizontalPadding,
                vertical: 12,
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  // 사용자 영역
                  SizedBox(
                    width: contentWidth,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Flexible(
                          flex: 6,
                          child: Text(
                            "$userName님의\n교통카드",
                            style: const TextStyle(
                              fontSize: 22,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                        CircleAvatar(
                          radius: 30,
                          backgroundImage: profileImage != null
                              ? AssetImage(profileImage!)
                              : const AssetImage(
                                  'assets/images/default_profile.png',
                                ),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 16),

                  // 카드 영역
                  SizedBox(
                    width: contentWidth,
                    height: cardHeight,
                    child: Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(
                          color: Colors.grey.shade400,
                          width: 2,
                        ),
                        color: Colors.white,
                      ),
                      child: Stack(
                        children: [
                          // 배경
                          Row(
                            children: [
                              Expanded(
                                flex: 8,
                                child: Container(
                                  decoration: BoxDecoration(
                                    color: Colors.orange.shade200,
                                    borderRadius: const BorderRadius.only(
                                      topLeft: Radius.circular(20),
                                      bottomLeft: Radius.circular(20),
                                    ),
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
                                            topRight: Radius.circular(20),
                                          ),
                                        ),
                                      ),
                                    ),
                                    Expanded(
                                      flex: 2,
                                      child: Container(
                                        decoration: const BoxDecoration(
                                          color: Colors.orangeAccent,
                                          borderRadius: BorderRadius.only(
                                            bottomRight: Radius.circular(20),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),

                          // IC칩 오른쪽 중앙에 아이콘 배치
                          Positioned(
                            top: iconTop,
                            right: iconRight,
                            child: Transform(
                              alignment: Alignment.center,
                              transform: Matrix4.identity()
                                ..rotateZ(3.14159 / 2) // 90도 회전
                                ..scale(1.0, 2.8), // 세로로 늘리기
                              child: SizedBox(
                                width: iconBaseWidth,
                                height: iconBaseHeight,
                                child: Center(
                                  child: Text(
                                    '<',
                                    style: TextStyle(
                                      fontSize: 24,
                                      fontWeight: FontWeight.w600,
                                      color: Colors.white70,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ),

                          // IC칩 (내부 구조 완전히 유지)
                          Positioned(
                            top: icTop,
                            right: icRight,
                            child: Container(
                              width: icWidth,
                              height: icHeight,
                              decoration: BoxDecoration(
                                color: Colors.yellow.shade700,
                                borderRadius: BorderRadius.circular(4),
                                border: Border.all(
                                  color: Colors.grey,
                                  width: 1,
                                ),
                              ),
                              child: Table(
                                children: [
                                  TableRow(
                                    children: [
                                      Container(
                                        height: icHeight / 3,
                                        decoration: const BoxDecoration(
                                          border: Border(
                                            top: BorderSide(
                                              color: Colors.grey,
                                              width: 1,
                                            ),
                                            left: BorderSide(
                                              color: Colors.grey,
                                              width: 1,
                                            ),
                                            right: BorderSide(
                                              color: Colors.grey,
                                              width: 1,
                                            ),
                                            bottom: BorderSide(
                                              color: Colors.grey,
                                              width: 1,
                                            ),
                                          ),
                                        ),
                                      ),
                                      Container(
                                        height: icHeight / 3,
                                        decoration: const BoxDecoration(
                                          border: Border(
                                            top: BorderSide(
                                              color: Colors.grey,
                                              width: 1,
                                            ),
                                            bottom: BorderSide(
                                              color: Colors.grey,
                                              width: 1,
                                            ),
                                          ),
                                        ),
                                      ),
                                      Container(
                                        height: icHeight / 3,
                                        decoration: const BoxDecoration(
                                          border: Border(
                                            top: BorderSide(
                                              color: Colors.grey,
                                              width: 1,
                                            ),
                                            left: BorderSide(
                                              color: Colors.grey,
                                              width: 1,
                                            ),
                                            right: BorderSide(
                                              color: Colors.grey,
                                              width: 1,
                                            ),
                                            bottom: BorderSide(
                                              color: Colors.grey,
                                              width: 1,
                                            ),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                  TableRow(
                                    children: [
                                      Container(
                                        height: icHeight / 3,
                                        decoration: const BoxDecoration(
                                          border: Border(
                                            left: BorderSide(
                                              color: Colors.grey,
                                              width: 1,
                                            ),
                                          ),
                                        ),
                                      ),
                                      Container(height: icHeight / 3),
                                      Container(
                                        height: icHeight / 3,
                                        decoration: const BoxDecoration(
                                          border: Border(
                                            right: BorderSide(
                                              color: Colors.grey,
                                              width: 1,
                                            ),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                  TableRow(
                                    children: [
                                      Container(
                                        height: icHeight / 3,
                                        decoration: const BoxDecoration(
                                          border: Border(
                                            top: BorderSide(
                                              color: Colors.grey,
                                              width: 1,
                                            ),
                                            left: BorderSide(
                                              color: Colors.grey,
                                              width: 1,
                                            ),
                                            right: BorderSide(
                                              color: Colors.grey,
                                              width: 1,
                                            ),
                                            bottom: BorderSide(
                                              color: Colors.grey,
                                              width: 1,
                                            ),
                                          ),
                                        ),
                                      ),
                                      Container(
                                        height: icHeight / 3,
                                        decoration: const BoxDecoration(
                                          border: Border(
                                            top: BorderSide(
                                              color: Colors.grey,
                                              width: 1,
                                            ),
                                            bottom: BorderSide(
                                              color: Colors.grey,
                                              width: 1,
                                            ),
                                          ),
                                        ),
                                      ),
                                      Container(
                                        height: icHeight / 3,
                                        decoration: const BoxDecoration(
                                          border: Border(
                                            left: BorderSide(
                                              color: Colors.grey,
                                              width: 1,
                                            ),
                                            right: BorderSide(
                                              color: Colors.grey,
                                              width: 1,
                                            ),
                                            bottom: BorderSide(
                                              color: Colors.grey,
                                              width: 1,
                                            ),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ),

                          // 수직 텍스트
                          Positioned(
                            top: cardHeight * 0.08,
                            bottom: cardHeight * 0.08,
                            right: rightEdgePadding,
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              crossAxisAlignment: CrossAxisAlignment.end,
                              children: const [
                                RotatedBox(
                                  quarterTurns: 1,
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

                          // 은행명 + 금액
                          Positioned(
                            bottom: cardHeight * 0.08,
                            left: cardWidth * 0.05,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  bankName ?? "빛가람은행",
                                  style: const TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                                Text(
                                  "$chargeAmount원",
                                  style: const TextStyle(
                                    fontSize: 14,
                                    fontWeight: FontWeight.w400,
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
            ),
          );
        },
      ),

      bottomNavigationBar: SafeArea(
        top: false,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // 충전/결제 버튼
            Container(
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

            const SizedBox(height: 8),

            // 하단바 아이콘
            Container(
              height: 60,
              color: AppColors.primaryColor,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  IconButton(
                    icon: const Icon(Icons.home, color: Colors.white),
                    onPressed: () {},
                  ),
                  IconButton(
                    icon: const Icon(Icons.search, color: Colors.white),
                    onPressed: () {},
                  ),
                  IconButton(
                    icon: const Icon(Icons.settings, color: Colors.white),
                    onPressed: () {},
                  ),
                ],
              ),
            ),
          ],
        ),
      ),

    );
  }
}

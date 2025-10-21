// lib > theme > App_theme.dart 
// 앱 전체 테마(ThemeData)와 관련된 설정을 모아둔 파일
// (예: 라이트/다크 테마, 버튼 스타일, 기본 위젯 스타일 등)


import 'package:flutter/material.dart';

class AppThemeLayout extends StatelessWidget {
  final String topBarTitle;
  final Widget body;
  final Widget? bottomBar;
  final Color topBarColor;
  final double topBarHeight;
  final Color bottomBarColor;
  final double bottomBarHeight;

  const AppThemeLayout({
    super.key,
    required this.topBarTitle,
    required this.body,
    this.bottomBar,
    this.topBarColor = Colors.blue,
    this.topBarHeight = 60,
    this.bottomBarColor = Colors.blue,
    this.bottomBarHeight = 60,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // 상단바
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(topBarHeight),
        child: AppBar(
          title: Text(topBarTitle),
          backgroundColor: topBarColor,
          centerTitle: true,
        ),
      ),
      // 바디
      body: body,
      // 하단바
      bottomNavigationBar: bottomBar != null
          ? Container(
        height: bottomBarHeight,
        color: bottomBarColor,
        child: bottomBar,
      )
          : null,
    );
  }
}

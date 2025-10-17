// widgets/buson_logo.dart

import 'package:flutter/material.dart';

class BusOnLogo extends StatelessWidget {
  final double fontSize; // 글씨 크기
  final Color color;     // 글자 색상

  const BusOnLogo({
    super.key,
    this.fontSize = 48,
    this.color = Colors.black,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.baseline,
      textBaseline: TextBaseline.alphabetic,
      children: [
        Text(
          'Bu',
          style: TextStyle(
            fontSize: fontSize,
            fontWeight: FontWeight.bold,
            color: color,
            fontFamily: 'Bauhaus',
          ),
        ),
        Text(
          's',
          style: TextStyle(
            fontSize: fontSize,
            fontWeight: FontWeight.bold,
            color: color,
            fontFamily: 'Bauhaus_93',
          ),
        ),
        Text(
          'On',
          style: TextStyle(
            fontSize: fontSize,
            fontWeight: FontWeight.bold,
            color: color,
            fontFamily: 'Bauhaus',
          ),
        ),
      ],
    );
  }
}

class BusOnLogo_A extends StatelessWidget {
  final double fontSize; // 글씨 크기
  final Color color;     // 글자 색상
  final VoidCallback? onOAnimationComplete; // 애니메이션 종료시점

  const BusOnLogo_A({
    super.key,
    this.fontSize = 48,
    this.color = Colors.black,
    this.onOAnimationComplete,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.baseline,
      textBaseline: TextBaseline.alphabetic,
      children: [
        Text(
          'Bu',
          style: TextStyle(
            fontSize: fontSize,
            fontWeight: FontWeight.bold,
            color: color,
            fontFamily: 'Bauhaus',
          ),
        ),
        Text(
          's',
          style: TextStyle(
            fontSize: fontSize,
            fontWeight: FontWeight.bold,
            color: color,
            fontFamily: 'Bauhaus_93',
          ),
        ),
        AnimatedO(fontSize: fontSize, color: color,
          onAnimationComplete: onOAnimationComplete, // 전달
        ),
        Text(
          'n',
          style: TextStyle(
            fontSize: fontSize,
            fontWeight: FontWeight.bold,
            color: color,
            fontFamily: 'Bauhaus',
          ),
        ),
      ],
    );
  }
}

class AnimatedO extends StatefulWidget {
  final double fontSize;
  final Color color;
  final VoidCallback? onAnimationComplete; // 추가

  const AnimatedO({super.key, this.fontSize = 48, this.color = Colors.black, 
    this.onAnimationComplete, // 추가
  });

  @override
  State<AnimatedO> createState() => _AnimatedOState();
}

class _AnimatedOState extends State<AnimatedO>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  late final Animation<double> _rotationAnimation;
  late final Animation<double> _fadeOutMarker;
  late final Animation<double> _fadeInO;

  double? _oWidth;

  @override
  void initState() {
    super.initState();

    // TextPainter로 글자 'O' 폭 계산
    final tp = TextPainter(
      text: TextSpan(
        text: 'O',
        style: TextStyle(
          fontSize: widget.fontSize,
          fontWeight: FontWeight.bold,
          fontFamily: 'Bauhaus',
        ),
      ),
      textDirection: TextDirection.ltr,
    )..layout();
    _oWidth = tp.width;

    _controller = AnimationController(
      duration: const Duration(seconds: 3),
      vsync: this,
    );

    _rotationAnimation = Tween<double>(begin: 0, end: 2 * 3.1415).animate(
      CurvedAnimation(
        parent: _controller,
        curve: const Interval(0.0, 0.5, curve: Curves.easeInOut),
      ),
    );

    _fadeOutMarker = Tween<double>(begin: 1.0, end: 0.0).animate(
      CurvedAnimation(
        parent: _controller,
        curve: const Interval(0.4, 0.7, curve: Curves.easeIn),
      ),
    );

    _fadeInO = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _controller,
        curve: const Interval(0.6, 1.0, curve: Curves.easeOut),
      ),
    );

    _controller.forward();

    _controller.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        widget.onAnimationComplete?.call();
      }
    });

  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final width = _oWidth ?? widget.fontSize;
    return SizedBox(
      width: width,
      child: AnimatedBuilder(
        animation: _controller,
        builder: (_, __) {
          return Stack(
            alignment: Alignment.center,
            children: [
              // 마커 회전
              Opacity(
                opacity: _fadeOutMarker.value,
                child: SizedBox(
                  width: width,
                  height: widget.fontSize,
                  child: Transform.rotate(
                    angle: _rotationAnimation.value,
                    alignment: Alignment.center,
                    child: Transform.translate(
                      offset: Offset(-widget.fontSize * 0.07, 0), // 살짝 왼쪽으로 보정
                      child: Icon(
                        Icons.location_on,
                        size: widget.fontSize,
                        color: widget.color,
                      ),
                    ),
                  ),

                ),
              ),

              // O 글자
              Opacity(
                opacity: _fadeInO.value,
                child: Text(
                  'O',
                  style: TextStyle(
                    fontSize: widget.fontSize,
                    fontWeight: FontWeight.bold,
                    color: widget.color,
                    fontFamily: 'Bauhaus',
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
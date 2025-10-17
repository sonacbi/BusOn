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
  final double fontSize;
  final Color color;
  final VoidCallback? onOAnimationComplete;

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
      crossAxisAlignment: CrossAxisAlignment.center,
      textBaseline: TextBaseline.alphabetic,
      children: [
        Text('Bu', style: TextStyle(fontSize: fontSize, fontWeight: FontWeight.bold, color: color, fontFamily: 'Bauhaus')),
        Text('s', style: TextStyle(fontSize: fontSize, fontWeight: FontWeight.bold, color: color, fontFamily: 'Bauhaus_93')),
        // 폭 고정 + 애니메이션 글자 오버플로우 허용
        SizedBox(
          width: fontSize * 0.8, // 기존보다 조금 좁게, 
          height: fontSize,
          child: OverflowBox(
            maxWidth: double.infinity,
            maxHeight: double.infinity,
            alignment: Alignment.center,
            child: AnimatedOWithMarker(fontSize: fontSize, color: color, onAnimationComplete: onOAnimationComplete),
          ),
        ),
        Text('n', style: TextStyle(fontSize: fontSize, fontWeight: FontWeight.bold, color: color, fontFamily: 'Bauhaus')),
      ],
    );
  }
}

class AnimatedOWithMarker extends StatefulWidget {
  final double fontSize;
  final Color color;
  final VoidCallback? onAnimationComplete;

  const AnimatedOWithMarker({super.key, this.fontSize = 48, this.color = Colors.black, this.onAnimationComplete});

  @override
  State<AnimatedOWithMarker> createState() => _AnimatedOWithMarkerState();
}

class _AnimatedOWithMarkerState extends State<AnimatedOWithMarker> with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  late final Animation<double> _bounceY;
  late final Animation<double> _fadeMarker;
  late final Animation<double> _fadeO;
  late final Animation<double> _scaleO;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(vsync: this, duration: const Duration(seconds: 2));

    // 마커 깡총 뛰기 (여러 번 튀는 바운스)
    _bounceY = TweenSequence<double>([
      TweenSequenceItem(tween: Tween(begin: -60.0, end: 0.0).chain(CurveTween(curve: Curves.easeOut)), weight: 40),
      TweenSequenceItem(tween: Tween(begin: 0.0, end: -40.0).chain(CurveTween(curve: Curves.easeInOut)), weight: 20),
      TweenSequenceItem(tween: Tween(begin: -40.0, end: 0.0).chain(CurveTween(curve: Curves.easeOut)), weight: 10),
      TweenSequenceItem(tween: Tween(begin: 0.0, end: -10.0).chain(CurveTween(curve: Curves.easeInOut)), weight: 10),
      TweenSequenceItem(tween: Tween(begin: -10.0, end: 0.0).chain(CurveTween(curve: Curves.easeOut)), weight: 8),
      TweenSequenceItem(tween: Tween(begin: 0.0, end: -1.0).chain(CurveTween(curve: Curves.easeInOut)), weight: 2),
      TweenSequenceItem(tween: Tween(begin: -1.0, end: 0.0).chain(CurveTween(curve: Curves.easeOut)), weight: 2),
    ]).animate(_controller);


    // 마커 페이드 아웃
    _fadeMarker = Tween<double>(begin: 1.0, end: 0.0).animate(
        CurvedAnimation(parent: _controller, curve: const Interval(0.5, 0.8, curve: Curves.easeIn)));

    // O 글자 Fade + Scale
    _fadeO = Tween<double>(begin: 0.0, end: 1.0).animate(
        CurvedAnimation(parent: _controller, curve: const Interval(0.7, 1.0, curve: Curves.easeOut)));
    _scaleO = Tween<double>(begin: 0.0, end: 1.0).animate(
        CurvedAnimation(parent: _controller, curve: const Interval(0.7, 1.0, curve: Curves.elasticOut)));

    _controller.forward();

    _controller.addStatusListener((status) {
      if (status == AnimationStatus.completed) widget.onAnimationComplete?.call();
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (_, __) {
        return Stack(
          alignment: Alignment.center,
          clipBehavior: Clip.none, // 글자 밖으로도 튀어나오도록
          children: [
            Transform.translate(
              offset: Offset(0, _bounceY.value),
              child: Opacity(
                opacity: _fadeMarker.value,
                child: Icon(Icons.location_on, size: widget.fontSize, color: widget.color),
              ),
            ),
            Opacity(
              opacity: _fadeO.value,
              child: Transform.scale(
                scale: _scaleO.value,
                child: Text('O',
                    style: TextStyle(
                        fontSize: widget.fontSize,
                        fontWeight: FontWeight.bold,
                        color: widget.color,
                        fontFamily: 'Bauhaus')),
              ),
            ),
          ],
        );
      },
    );
  }
}

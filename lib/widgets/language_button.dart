// 📂 lib/widgets/language_button.dart
// ---------------------------------------------
// ✅ LanguageButton : 언어 선택 시 사용할 버튼 위젯
// ---------------------------------------------
// ▶ 주요 특징
//  - 국기 이미지 + 언어 텍스트
//  - 선택 상태 표시
//  - 터치 & 드래그 시 리플 애니메이션
// ---------------------------------------------

import 'dart:async';
import 'package:flutter/material.dart';
import 'package:bus_on/theme/app_colors.dart';

class LanguageButton extends StatefulWidget {
  final String lang;
  final String flagPath;
  final bool isSelected;
  final VoidCallback onSelect;

  const LanguageButton({
    super.key,
    required this.lang,
    required this.flagPath,
    required this.isSelected,
    required this.onSelect,
  });

  @override
  State<LanguageButton> createState() => _LanguageButtonState();
}

/// 리플 상태
class _Ripple {
  final AnimationController controller;
  final Animation<double> animation;
  final Offset origin;
  _Ripple({required this.controller, required this.animation, required this.origin});
}

/// 여러 개의 확산 원을 그려주는 Painter
class MultiRipplePainter extends CustomPainter {
  final List<_Ripple> ripples;
  final bool isSelected;

  MultiRipplePainter(this.ripples, this.isSelected);

  @override
  void paint(Canvas canvas, Size size) {
    for (final ripple in ripples) {
      final progress = ripple.animation.value;
      final radius = size.width * 0.8 * progress;
      final opacity = (1 - progress).clamp(0.0, 1.0);

      final color = isSelected
          ? Colors.white.withOpacity(0.25 * opacity)
          : AppColors.primaryColor.withOpacity(0.25 * opacity);

      final paint = Paint()
        ..color = color
        ..style = PaintingStyle.stroke
        ..strokeWidth = 3 * (1 - progress);

      canvas.drawCircle(ripple.origin, radius, paint);
    }
  }

  @override
  bool shouldRepaint(covariant MultiRipplePainter old) => true;
}

class _LanguageButtonState extends State<LanguageButton> with TickerProviderStateMixin {
  final List<_Ripple> _ripples = [];
  Offset? _tapPosition;
  Timer? _rippleTimer;

  void _addRipple() {
    final controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1800),
    );

    final animation = CurvedAnimation(parent: controller, curve: Curves.easeOut);
    final ripple = _Ripple(controller: controller, animation: animation, origin: _tapPosition ?? const Offset(75, 55));
    _ripples.add(ripple);

    animation.addListener(() {
      if (mounted) setState(() {});
    });

    controller.forward();
    controller.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        controller.dispose();
        _ripples.remove(ripple);
        if (mounted) setState(() {});
      }
    });
  }

  void _startRipples() {
    _addRipple(); // 첫 리플
    _rippleTimer = Timer.periodic(const Duration(milliseconds: 500), (_) {
      _addRipple();
    });
  }

  void _stopRipples() {
    _rippleTimer?.cancel();
    _rippleTimer = null;
  }

  void _onPointerDown(PointerDownEvent event) {
    _tapPosition = event.localPosition;
    if (_rippleTimer == null) _startRipples();
    widget.onSelect();
  }

  void _onPointerMove(PointerMoveEvent event) {
    _tapPosition = event.localPosition; // 드래그 위치 갱신
  }

  void _onPointerUp(PointerUpEvent event) => _stopRipples();
  void _onPointerCancel(PointerCancelEvent event) => _stopRipples();

  @override
  void dispose() {
    _stopRipples();
    for (final ripple in _ripples) {
      ripple.controller.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final bool isSelected = widget.isSelected;

    return Listener(
      onPointerDown: _onPointerDown,
      onPointerMove: _onPointerMove,
      onPointerUp: _onPointerUp,
      onPointerCancel: _onPointerCancel,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 350),
        curve: Curves.easeOutCubic,
        width: 150,
        height: 110,
        margin: const EdgeInsets.all(4),
        decoration: BoxDecoration(
          color: isSelected ? AppColors.primaryColor : Colors.white,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: AppColors.primaryColor, width: 2),
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(14),
          child: Stack(
            children: [
              CustomPaint(
                painter: MultiRipplePainter(_ripples, isSelected),
                size: const Size(150, 110),
              ),
              Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      decoration: BoxDecoration(
                        border: isSelected
                            ? null
                            : Border.all(color: Colors.grey.shade300, width: 1.2),
                        borderRadius: BorderRadius.circular(6),
                      ),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(6),
                        child: Image.asset(
                          widget.flagPath,
                          width: 50,
                          height: 35,
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      widget.lang,
                      style: TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.w600,
                        color: isSelected ? Colors.white : Colors.black87,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

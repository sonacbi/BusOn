// 📂 lib/widgets/language_button.dart
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

class _Ripple {
  final AnimationController controller;
  final Animation<double> animation;
  Offset origin;

  _Ripple({required this.controller, required this.animation, required this.origin});
}

class MultiRipplePainter extends CustomPainter {
  final List<_Ripple> ripples;
  final bool isSelected;

  MultiRipplePainter(this.ripples, this.isSelected)
      : super(repaint: Listenable.merge(ripples.map((r) => r.animation)));

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
  Offset _tapPosition = Offset.zero;
  bool _isInside = false;
  bool _isSelectedConfirmed = false;

  Timer? _rippleTimer;

  late AnimationController _pressedController;
  late Animation<Color?> _pressedColorAnimation;

  late AnimationController _selectedBgController;
  late Animation<Color?> _selectedBgAnimation;

  late AnimationController _selectedBorderController;
  late Animation<Color?> _selectedBorderAnimation;

  late AnimationController _textColorController;
  late Animation<Color?> _textColorAnimation;

  @override
  void initState() {
    super.initState();

    // 눌림 밝기 애니메이션
    _pressedController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 200),
    );
    _pressedColorAnimation = ColorTween(
      begin: Colors.white,
      end: AppColors.primaryColor.withOpacity(0.4),
    ).animate(_pressedController);

    // 선택 후 배경 반짝임
    _selectedBgController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 400),
    );
    _selectedBgAnimation = ColorTween(
      begin: Colors.white,
      end: AppColors.primaryColor,
    ).animate(CurvedAnimation(
      parent: _selectedBgController,
      curve: Curves.easeInOut,
    ));

    // 내부 국기 테두리 색상
    _selectedBorderController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 400),
    );
    _selectedBorderAnimation = ColorTween(
      begin: Colors.grey.shade300,
      end: Colors.transparent,
    ).animate(_selectedBorderController);

    // 글씨 색상
    _textColorController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 400),
    );

    // CurvedAnimation으로 변화를 부드럽게 조정
    _textColorAnimation = ColorTween(
      begin: Colors.black87,
      end: Colors.white,
    ).animate(
      CurvedAnimation(
        parent: _textColorController,
        curve: const Interval(0.1, 1.0, curve: Curves.easeInOut),
      ),
    );

    _pressedController.addStatusListener((status) {
      if (status == AnimationStatus.completed && !_isSelectedConfirmed) {
        _pressedController.reverse();
      }
    });

    _selectedBgController.addListener(() {
      if (mounted) setState(() {});
    });
    _selectedBorderController.addListener(() {
      if (mounted) setState(() {});
    });
    _textColorController.addListener(() {
      if (mounted) setState(() {});
    });
  }

  void _addRipple() {
    if (_isSelectedConfirmed) return;
    final controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1800),
    );
    final animation = CurvedAnimation(parent: controller, curve: Curves.easeOut);

    final ripple = _Ripple(controller: controller, animation: animation, origin: _tapPosition);
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
    _addRipple();
    _rippleTimer ??= Timer.periodic(const Duration(milliseconds: 500), (_) => _addRipple());
  }

  void _stopRipples() {
    _rippleTimer?.cancel();
    _rippleTimer = null;
  }

  void _onPointerDown(PointerDownEvent event) {
    if (_isSelectedConfirmed) return;
    _tapPosition = event.localPosition;
    _isInside = true;
    _startRipples();
    _pressedController.forward();
  }

  void _onPointerMove(PointerMoveEvent event) {
    _tapPosition = event.localPosition;
    _isInside = (event.localPosition.dx >= 0 &&
        event.localPosition.dy >= 0 &&
        event.localPosition.dx <= context.size!.width &&
        event.localPosition.dy <= context.size!.height);
  }

  void _onPointerUp(PointerUpEvent event) {
    _stopRipples();
    if (!_isInside) return;

    _isSelectedConfirmed = true;

    // 선택 시 모든 애니메이션 실행
    _selectedBgController.forward();
    _selectedBorderController.forward();
    _textColorController.forward();
    widget.onSelect();
  }

  void _onPointerCancel(PointerCancelEvent event) {
    _stopRipples();
    _isInside = false;
  }

  @override
  void dispose() {
    _stopRipples();
    for (final ripple in _ripples) {
      ripple.controller.dispose();
    }
    _pressedController.dispose();
    _selectedBgController.dispose();
    _selectedBorderController.dispose();
    _textColorController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    Color bgColor;
    Color borderColor;
    Color textColor;

    if (_isSelectedConfirmed) {
      bgColor = _selectedBgAnimation.value ?? AppColors.primaryColor;
      borderColor = _selectedBorderAnimation.value ?? Colors.transparent;
      textColor = _textColorAnimation.value ?? Colors.white;
    } else if (_pressedController.isAnimating) {
      bgColor = _pressedColorAnimation.value!;
      borderColor = Colors.grey.shade300;
      textColor = Colors.black87;
    } else {
      bgColor = Colors.white;
      borderColor = Colors.grey.shade300;
      textColor = Colors.black87;
    }

    return Listener(
      onPointerDown: _onPointerDown,
      onPointerMove: _onPointerMove,
      onPointerUp: _onPointerUp,
      onPointerCancel: _onPointerCancel,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
        width: 150,
        height: 110,
        margin: const EdgeInsets.all(4),
        decoration: BoxDecoration(
          color: bgColor,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: AppColors.primaryColor, width: 2), // 외곽 테두리 고정
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(14),
          child: Stack(
            children: [
              CustomPaint(
                painter: MultiRipplePainter(_ripples, widget.isSelected),
                size: const Size(150, 110),
              ),
              Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      decoration: BoxDecoration(
                        border: Border.all(color: borderColor, width: 1.2),
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
                        color: textColor,
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

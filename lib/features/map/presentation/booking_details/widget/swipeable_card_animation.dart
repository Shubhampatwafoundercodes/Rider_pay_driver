import 'package:flutter/material.dart';

/// 🔹 Animator Class (handles gestures, swipe animation + overlay text)
class SwipeableCardAnimator extends StatefulWidget {
  final Widget child;
  final VoidCallback onAccept;
  final VoidCallback onReject;
  final VoidCallback onClear;
  final bool isMissed;

  const SwipeableCardAnimator({
    super.key,
    required this.child,
    required this.onAccept,
    required this.onReject,
    required this.onClear,
    required this.isMissed,
  });

  @override
  State<SwipeableCardAnimator> createState() => _SwipeableCardAnimatorState();
}

class _SwipeableCardAnimatorState extends State<SwipeableCardAnimator> {
  double _dragOffsetX = 0.0;
  double _dragOffsetY = 0.0;
  bool _isSwiping = false;
  double _opacity = 1.0;

  static const double _maxDrag = 100.0;
  static const double _swipeThreshold = 80.0;
  static const double _maxRotation = 0.1; // ~6°

  void _onHorizontalDragUpdate(DragUpdateDetails details) {
    if (widget.isMissed) return;
    setState(() {
      _isSwiping = true;
      _dragOffsetX =
          (_dragOffsetX + details.delta.dx).clamp(-_maxDrag, _maxDrag);
      _dragOffsetY = (_dragOffsetX.abs() * 0.16).clamp(0.0, 20.0);
    });
  }

  void _onHorizontalDragEnd(DragEndDetails details) {
    if (widget.isMissed) return;
    if (_dragOffsetX > _swipeThreshold) {
      _performAction(widget.onAccept);
    } else if (_dragOffsetX < -_swipeThreshold) {
      _performAction(widget.onReject);
    } else {
      _resetPosition();
    }
  }

  void _performAction(VoidCallback action) {
    action();
    setState(() => _opacity = 0.0);
    Future.delayed(const Duration(milliseconds: 300), () {
      _resetPosition();
      setState(() => _opacity = 1.0);
    });
  }

  void _resetPosition() {
    setState(() {
      _dragOffsetX = 0.0;
      _dragOffsetY = 0.0;
      _isSwiping = false;
    });
  }

  double get _rotationAngle =>
      (_dragOffsetX * -0.002).clamp(-_maxRotation, _maxRotation);

  // ✅ Overlay text & color
  String get _swipeText {
    if (_dragOffsetX > 60) return "ACCEPT →";
    if (_dragOffsetX < -60) return "← REJECT";
    return "";
  }

  Color get _swipeColor {
    if (_dragOffsetX > 60) return Colors.green;
    if (_dragOffsetX < -60) return Colors.red;
    return Colors.transparent;
  }

  Alignment get _swipeTextAlignment {
    if (_dragOffsetX > 60) return Alignment.centerRight;
    if (_dragOffsetX < -60) return Alignment.centerLeft;
    return Alignment.center;
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onHorizontalDragUpdate: _onHorizontalDragUpdate,
      onHorizontalDragEnd: _onHorizontalDragEnd,
      child: AnimatedOpacity(
        duration: const Duration(milliseconds: 300),
        opacity: _opacity,
        child: Container(
          margin: EdgeInsets.only(
            top: _dragOffsetY,
            left: 16,
            right: 16,
            bottom: 16,
          ),
          child: Transform(
            alignment: Alignment.topCenter,
            transform: Matrix4.identity()
              ..translate(_dragOffsetX)
              ..rotateZ(_rotationAngle),
            child: Stack(
              children: [
                widget.child,

                // 🔹 Swipe background color overlay
                if (_dragOffsetX.abs() > 0 && !widget.isMissed)
                  Positioned.fill(
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(16),
                      child: Container(
                        color: _swipeColor.withOpacity(
                          (_dragOffsetX.abs() * 0.005).clamp(0.0, 0.4),
                        ),
                      ),
                    ),
                  ),

                // 🔹 Swipe text overlay
                if (_dragOffsetX.abs() > 60 && !widget.isMissed)
                  Positioned.fill(
                    child: Align(
                      alignment: _swipeTextAlignment,
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 20),
                        child: Text(
                          _swipeText,
                          style: TextStyle(
                            color: _swipeColor,
                            fontSize: 22,
                            fontWeight: FontWeight.bold,
                            fontFamily: "Poppins",
                            shadows: [
                              Shadow(
                                blurRadius: 10,
                                color: _swipeColor.withOpacity(0.5),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

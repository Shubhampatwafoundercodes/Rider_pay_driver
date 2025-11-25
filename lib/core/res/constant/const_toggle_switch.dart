import 'package:flutter/material.dart';

class ConstToggleSwitch extends StatelessWidget {
  final bool value;
  final VoidCallback onTap;

  const ConstToggleSwitch({
    super.key,
    required this.value,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: SizedBox(
        width: 45,
        height: 22,
        child: Stack(
          alignment: Alignment.center,
          children: [
            /// Background track
            AnimatedContainer(
              duration: const Duration(milliseconds: 250),
              width: 26,
              height: 15,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20),
                color: value
                    ? Colors.green.withAlpha(100)
                    : Colors.grey.shade400,
              ),
            ),

            /// Toggle knob
            AnimatedAlign(
              duration: const Duration(milliseconds: 250),
              curve: Curves.easeInOut,
              alignment: value
                  ? Alignment.centerRight
                  : Alignment.centerLeft,
              child: Container(
                width: 18,
                height: 18,
                margin: const EdgeInsets.symmetric(horizontal: 2),
                decoration: BoxDecoration(
                  color: value ? Colors.green : Colors.grey.shade200,
                  shape: BoxShape.circle,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black26,
                      blurRadius: 2,
                      offset: const Offset(0, 1),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

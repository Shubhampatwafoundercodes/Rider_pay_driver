import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:rider_pay_driver/core/res/app_color.dart';
import 'package:rider_pay_driver/main.dart';

class CommonTopBar extends StatelessWidget {
  final Widget child;
  final Color? background;
  final bool showShadow; // new flag
  final double? width; // new flag
  final double? height; // new flag
  const CommonTopBar({
    super.key,
    required this.child,
    this.background,
    this.showShadow = true, this.width, this.height,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: height,
      width: width??screenWidth,
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
      decoration: BoxDecoration(
        color: background ?? context.greyLight,
        boxShadow: showShadow
            ? [
          BoxShadow(
            color: Colors.black.withAlpha(60),
            blurRadius: 3,
            spreadRadius: 0,
            offset: const Offset(0, 2),
          ),
        ] : null, // no shadow if false
      ),
      child: child,
    );
  }
}

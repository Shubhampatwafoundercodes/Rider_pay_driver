import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:rider_pay_driver/core/res/app_color.dart';

class CommonBox extends StatelessWidget {
  final Widget? child;
  final EdgeInsetsGeometry? padding;
  final EdgeInsetsGeometry? margin;
  final Color? color;
  final Color? borderColor;
  final double? borderWidth;
  final double? borderRadius;
  final double? height;
  final double? width;
 final  List<BoxShadow>? boxShadow;
 final void Function()? onTap;

  const CommonBox({
    super.key,
    this.child,
    this.padding,
    this.margin,
    this.color,
    this.borderColor,
    this.borderWidth,
    this.borderRadius,
    this.height,
    this.width,
    this.boxShadow, this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap:onTap,
      child: Container(
        alignment: Alignment.center,
        height: height,
        width: width,
        margin: margin,
        padding: padding ??  EdgeInsets.all(12.r),
        decoration: BoxDecoration(
          color: color ?? context.greyLight,
          border: Border.all(
            color: borderColor ?? context.border,
            width: borderWidth ?? 1,
          ),
          boxShadow:boxShadow ,
          borderRadius: BorderRadius.circular(borderRadius ?? 8.r),
        ),
        child: child,
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:rider_pay_driver/core/res/constant/const_text.dart';
import 'package:rider_pay_driver/core/res/app_constant.dart';
import 'package:rider_pay_driver/core/res/app_color.dart';

class CommonIconTextButton extends StatelessWidget {
  final String? text;
  final Widget? child; // 🔹 New: custom widget instead of text
  final String? imagePath;
  final Color? imageColor;
  final VoidCallback? onTap;
  final double? horizontalPadding;
  final double? verticalPadding;
  final double? iconHeight;
  final double? spacing;
  final Color? backgroundColor;
  final Color? borderColor;
  final double? borderRadius;

  const CommonIconTextButton({
    super.key,
    this.text,
    this.child, // 🔹 optional widget
    this.imagePath,
    this.imageColor,
    this.onTap,
    this.horizontalPadding,
    this.verticalPadding,
    this.iconHeight,
    this.spacing,
    this.backgroundColor,
    this.borderColor,
    this.borderRadius,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.symmetric(
          horizontal: horizontalPadding ?? 12.w,
          vertical: verticalPadding ?? 6.h,
        ),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(borderRadius ?? 8.r),
          border: Border.all(color: borderColor ?? context.border, width: 1),
          color: backgroundColor ?? context.surface,
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (imagePath != null)
              Image.asset(
                imagePath!,
                height: iconHeight ?? 22.h,
                color: imageColor ?? context.black,
              ),
            if (imagePath != null) SizedBox(width: spacing ?? 6.w),

            /// 🔹 Custom child preferred over text
            if (child != null)
              child!
            else if (text != null)
              ConstText(
                text: text!,
                fontSize: 15,
                fontWeight: AppConstant.semiBold,
                color: context.textPrimary,
              ),
          ],
        ),
      ),
    );
  }
}

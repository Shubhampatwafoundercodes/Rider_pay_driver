import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:rider_pay_driver/core/res/app_color.dart';
import 'package:rider_pay_driver/generated/assets.dart';


class ConstAppBackBtn extends StatelessWidget {
  final Color? color;
  final double? scale;
  final double? topPadding;
  final double? leftPadding;
  final IconData? icon;
  final double? iconSize;
  final VoidCallback? onTap;

  const ConstAppBackBtn({
    super.key,
    this.color,
    this.scale,
    this.topPadding,
    this.leftPadding,
    this.icon,
    this.iconSize,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    // final t= AppLocalizations.of(context)!;
    return GestureDetector(
      onTap: onTap ?? () {
        Navigator.pop(context);
      } ,
      child: Row(
        children: [
          Image.asset(Assets.iconLeftArrowIc,height:iconSize ?? 22.h, color: color ??context.textPrimary, )


          // Icon(
          //   icon ?? Icons.arrow_back,
          //   color: color ??context.textPrimary,
          //   size: iconSize ?? 24.h,
          // ),
          // SizedBox(width: 05,),
          // ConstText(text:t.back, color: context.textPrimary,


        ],
      ),
    );
  }
}

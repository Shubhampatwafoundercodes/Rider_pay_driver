
import 'package:flutter/material.dart';
// ignore: unused_import
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:rider_pay_driver/core/res/app_color.dart';
import 'package:rider_pay_driver/core/res/app_constant.dart';



class ConstText extends StatelessWidget {
  final String text;
  final String? fontFamily;
  final int? maxLine;
  final double? fontSize;
  final bool? strikethrough;
  final FontWeight? fontWeight;
  final double? wordSpacing;
  final double? letterSpacing;
  final double? letterHeight;
  final TextDecoration? decoration;
  final Color? color;
  final TextOverflow? overflow;
  final TextAlign? textAlign;
  final Paint? foreground;
  final Color? decorationColor;
  final FontStyle? fontStyle;
  final double? textScaleFactor;

  const ConstText({
    super.key,
    required this.text,
    this.fontSize,
    this.fontWeight,
    this.color,
    this.overflow,
    this.maxLine,
    this.textAlign,
    this.wordSpacing,
    this.letterSpacing,
    this.decoration,
    this.strikethrough,
    this.foreground,
    this.fontFamily,
    this.decorationColor, this.fontStyle, this.letterHeight, this.textScaleFactor,
  });

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      maxLines: maxLine,
      textAlign: textAlign ?? TextAlign.start,
      style: TextStyle(
        height:letterHeight ,
        fontSize: fontSize ?? AppConstant.fontSizeTwo,
        fontWeight: fontWeight ?? AppConstant.regular,
        color: color ?? context.textSecondary,
        wordSpacing: wordSpacing,
        foreground: foreground,
        fontStyle:fontStyle,
        letterSpacing: letterSpacing,
        decoration: decoration,
        decorationColor: decorationColor,
        fontFamily: fontFamily ?? 'Poppins',
        overflow: maxLine != null ? TextOverflow.ellipsis : null,
      ),
    );
  }
}


class DoubleText extends StatelessWidget {
  final String firstText;
  final String secondText;
  final VoidCallback onTap;
  final double? firstSize;
  final double? secondSize;
  final Color? firstColor;
  final Color? secondColor;
  final FontWeight? firstWeight;
  final FontWeight? secondWeight;

  const DoubleText({
    super.key,
    required this.firstText,
    required this.secondText,
    required this.onTap,
    this.firstSize,
    this.secondSize,
    this.firstColor,
    this.secondColor,
    this.firstWeight,
    this.secondWeight,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: RichText(
        text: TextSpan(
          children: [
            TextSpan(
              text: "$firstText ",
              style: TextStyle(
                fontSize: firstSize ?? AppConstant.fontSizeTwo,
                color: firstColor ?? context.textPrimary,
                fontWeight: firstWeight,
                fontFamily: 'Poppins',
              ),
            ),
            TextSpan(
              text: secondText,
              style: TextStyle(
                fontSize: secondSize ?? AppConstant.fontSizeOne,
                color: secondColor ?? context.primary,
                fontWeight: secondWeight ?? FontWeight.bold,
                fontFamily: 'Poppins',
              ),
            ),
          ],
        ),
      ),
    );
  }
}

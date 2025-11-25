import 'package:flutter/material.dart';
import 'package:rider_pay_driver/core/res/app_color.dart';
import 'package:rider_pay_driver/main.dart';
import 'app_constant.dart';
import 'constant/const_text.dart';

class AppBtn extends StatefulWidget {
  final String? title;
  final Color? titleColor;
  final Color? color;
  final Function()? onTap;
  final double? fontSize;
  final bool? loading;
  final Gradient? gradient;
  final bool hideBorder;
  final Widget? child;
  final FontWeight? fontWeight;
  final BoxBorder? border;
  final double borderRadius;
  final double? height;
  final BorderRadiusGeometry? radiusOnly;
  final double? width;
  final EdgeInsetsGeometry? margin;
  final bool isDisabled; // 👈 new property

  const AppBtn({
    super.key,
    this.title,
    this.titleColor,
    this.color,
    this.onTap,
    this.fontSize,
    this.loading = false,
    this.gradient,
    this.hideBorder = false,
    this.child,
    this.fontWeight,
    this.border,
    this.borderRadius = 35,
    this.height,
    this.radiusOnly,
    this.width,
    this.margin,
    this.isDisabled = false, // 👈 default false
  });

  @override
  State<AppBtn> createState() => _AppBtnState();
}

class _AppBtnState extends State<AppBtn> with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _scaleAnimation;
  bool _showBorder = false;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 300),
    );
    _scaleAnimation = Tween<double>(begin: 1, end: 0.98).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeOut),
    );
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  void _handleTap() async {
    if (widget.isDisabled) return; // 👈 agar disabled hai to kuch na kare
    if (_showBorder) return;

    setState(() {
      _showBorder = true;
    });

    Future.delayed(const Duration(milliseconds: 500), () {
      if (mounted) {
        setState(() {
          _showBorder = false;
        });
      }
    });

    await Future.delayed(const Duration(milliseconds: 300));
    widget.onTap?.call();
  }

  Widget buildButton() {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 600),
      padding: _showBorder ? const EdgeInsets.all(1) : EdgeInsets.zero,
      margin: widget.margin,
      height: widget.height ?? screenHeight * 0.056,
      width: widget.width ?? screenWidth,
      decoration: BoxDecoration(
        borderRadius:
        widget.radiusOnly ?? BorderRadius.circular(widget.borderRadius),
      ),
      child: Container(
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: widget.isDisabled
              ? context.disabled
              : widget.color ?? context.primary,
          gradient: widget.isDisabled ? null : widget.gradient,
          border: widget.border,
          borderRadius:
          widget.radiusOnly ?? BorderRadius.circular(widget.borderRadius),
        ),
        child: widget.child ??
            ConstText(
              text: (widget.title ?? 'BUTTON'),
              color: widget.isDisabled
                  ? context.greyMedium // 👈 only text shaded
                  : widget.titleColor ?? context.black,
              fontWeight: widget.fontWeight ?? AppConstant.semiBold,
              fontSize: widget.fontSize ?? AppConstant.fontSizeTwo,
            ),
      ),
    );
  }

  Widget buildCircle() {
    return Center(
      child: Container(
        height: widget.height ?? screenHeight * 0.055,
        width: widget.width ?? screenWidth,
        margin: widget.margin,
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: widget.isDisabled
              ? context.disabled
              : widget.color ?? context.primary,
          borderRadius: BorderRadius.circular(widget.borderRadius),
        ),
        padding: const EdgeInsets.all(3),
        child: SizedBox(
          width: 23,
          height: 23,
          child: CircularProgressIndicator(
            color: widget.titleColor ?? AppColor.black,
            strokeWidth: 3,
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: widget.isDisabled
          ? null
          : () {
        _handleTap();
        _animationController.forward().then((_) {
          _animationController.reverse();
        });
      },
      child: AnimatedBuilder(
        animation: _animationController,
        builder: (context, child) {
          return Transform.scale(
            scale: _scaleAnimation.value,
            child: widget.loading == false ? buildButton() : buildCircle(),
          );
        },
      ),
    );
  }
}

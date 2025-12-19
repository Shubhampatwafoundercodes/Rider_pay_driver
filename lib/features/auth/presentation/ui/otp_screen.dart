import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:pinput/pinput.dart';
import 'package:rider_pay_driver/core/res/app_color.dart';
import 'package:rider_pay_driver/core/res/app_constant.dart';
import 'package:rider_pay_driver/core/res/app_padding.dart';
import 'package:rider_pay_driver/core/res/app_size.dart';
import 'package:rider_pay_driver/core/res/constant/common_icon_text_btn.dart';
import 'package:rider_pay_driver/core/res/constant/common_top_bar.dart';
import 'package:rider_pay_driver/core/res/constant/const_back_btn.dart';
import 'package:rider_pay_driver/core/res/constant/const_text.dart';
import 'package:rider_pay_driver/core/utils/navigation_helper.dart';
import 'package:rider_pay_driver/core/utils/routes/routes_name.dart';
import 'package:rider_pay_driver/features/auth/presentation/notifier/auth_notifer.dart';
import 'package:rider_pay_driver/generated/assets.dart';
import 'package:rider_pay_driver/l10n/app_localizations.dart';

class OtpScreen extends ConsumerStatefulWidget {
  final String number;
  const OtpScreen({super.key, required this.number});

  @override
  ConsumerState<OtpScreen> createState() => _OtpScreenState();
}

class _OtpScreenState extends ConsumerState<OtpScreen> {
  final TextEditingController _otpController = TextEditingController();

  Timer? _timer;
  int _secondsRemaining = 60;
  bool _canResend = false;

  void _startTimer() {
    _timer?.cancel(); // reset previous timer
    setState(() {
      _secondsRemaining = 60;
      _canResend = false;
    });

    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (_secondsRemaining > 0) {
        setState(() {
          _secondsRemaining--;
        });
      } else {
        setState(() {
          _canResend = true;
        });
        timer.cancel();
      }
    });
  }


  Future<void> _sendOtpAgain() async {
    ref.read(authNotifierProvider.notifier).sendOtp(widget.number);
    _startTimer();
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      print(widget.number);
      if (widget.number.isNotEmpty) {
        ref.read(authNotifierProvider.notifier).sendOtp(widget.number);
        _startTimer();
      }
    });
  }

  @override
  void dispose() {
    _otpController.dispose();
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final tr = AppLocalizations.of(context)!;

    final defaultPinTheme = PinTheme(
      width: 40.w,
      height: 60.h,
      textStyle: TextStyle(
        fontSize: AppConstant.fontSizeThree,
        fontWeight: AppConstant.bold,
        color: context.textPrimary,
      ),
      decoration: BoxDecoration(
        border: Border.all(color: context.border),
        borderRadius: BorderRadius.circular(4.r),
        color: context.background,
      ),
    );

    return SafeArea(
      top: false,
      child: Scaffold(
        backgroundColor: context.background,
        body: Column(
          children: [
            AppSizes.spaceH(30),
            CommonTopBar(
              child: Row(
                children: [
                  const ConstAppBackBtn(),
                  const Spacer(),
                  CommonIconTextButton(
                    text: tr.help,
                    imagePath: Assets.iconHelpIc,
                    imageColor: context.black,
                    onTap: () => context.pushNamed(RoutesName.supportScreen),
                  ),
                ],
              ),
            ),
            Padding(
              padding: AppPadding.screenPadding,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Image.asset(Assets.iconOtpIc, height: 70.h),
                  AppSizes.spaceH(30),

                  /// 🔹 Title + Timer / Resend Button
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      ConstText(
                        text: tr.enterOtp,
                        fontSize: AppConstant.fontSizeLarge,
                        fontWeight: AppConstant.bold,
                        color: context.textPrimary,
                      ),
                      _canResend
                          ? GestureDetector(
                        onTap: _sendOtpAgain,
                        child: ConstText(
                          text: tr.resendOtp,
                          fontSize: AppConstant.fontSizeZero,
                          color: Colors.blue,
                          fontWeight: FontWeight.bold,
                        ),
                      )
                          : ConstText(
                        text:
                        "00:${_secondsRemaining.toString().padLeft(2, '0')}",
                        fontSize: AppConstant.fontSizeZero,
                        color: context.textSecondary,
                      ),
                    ],
                  ),
                  AppSizes.spaceH(15),

                  /// 🔹 OTP Input
                  Pinput(
                    controller: _otpController,
                    length: 6,
                    defaultPinTheme: defaultPinTheme,
                    focusedPinTheme: defaultPinTheme.copyWith(
                      decoration: defaultPinTheme.decoration!.copyWith(
                        border: Border.all(color: context.black, width: 2),
                      ),
                    ),
                    submittedPinTheme: defaultPinTheme,
                    onCompleted: (otp) async {
                      final otpText = _otpController.text.trim();
                      final verified = await ref
                          .read(authNotifierProvider.notifier)
                          .verifyOtp(widget.number.toString(), otpText);
                      if (verified) {
                        await NextRouteDecider.goNextAfterProfileCheck(context, ref);
                      } else {
                      }
                    },
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}


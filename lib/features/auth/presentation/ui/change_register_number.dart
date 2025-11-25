import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:rider_pay_driver/core/res/app_border.dart';
import 'package:rider_pay_driver/core/res/app_btn.dart';
import 'package:rider_pay_driver/core/res/app_color.dart';
import 'package:rider_pay_driver/core/res/app_constant.dart' show AppConstant;
import 'package:rider_pay_driver/core/res/app_padding.dart';
import 'package:rider_pay_driver/core/res/app_size.dart';
import 'package:rider_pay_driver/core/res/app_text_field.dart';
import 'package:rider_pay_driver/core/res/constant/common_icon_text_btn.dart'
    show CommonIconTextButton;
import 'package:rider_pay_driver/core/res/constant/common_top_bar.dart';
import 'package:rider_pay_driver/core/res/constant/const_back_btn.dart';
import 'package:rider_pay_driver/core/res/constant/const_text.dart';
import 'package:rider_pay_driver/core/utils/routes/routes_name.dart';
import 'package:rider_pay_driver/generated/assets.dart';
import 'package:rider_pay_driver/l10n/app_localizations.dart' show AppLocalizations;

class ChangeRegisterNumber extends ConsumerStatefulWidget {
  const ChangeRegisterNumber({super.key});

  @override
  ConsumerState<ChangeRegisterNumber> createState() => _LoginScreenState();
}

class _LoginScreenState extends ConsumerState<ChangeRegisterNumber> {
  final TextEditingController _phoneController = TextEditingController();
  bool isButtonEnabled = false;

  @override
  void initState() {
    super.initState();
    _phoneController.addListener(_validatePhone);
  }

  void _validatePhone() {
    if (_phoneController.text.length == 10) {
      FocusScope.of(context).unfocus();
      setState(() => isButtonEnabled = true);
    } else {
      setState(() => isButtonEnabled = false);
    }
  }

  @override
  void dispose() {
    _phoneController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final tr = AppLocalizations.of(context)!;

    return SafeArea(
      top: false,
      child: Scaffold(
        backgroundColor: context.background,
        body: Column(
          children: [
            AppSizes.spaceH(30),

            /// 🔹 Top Bar
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

            Expanded(
              child: SingleChildScrollView(
                padding: AppPadding.screenPadding,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    AppSizes.spaceH(20),

                    /// 🔹 Title
                    ConstText(
                      text: "Enter your New Phone Number",
                      fontSize: AppConstant.fontSizeLarge,
                      fontWeight: AppConstant.bold,
                      color: context.textPrimary,
                    ),

                    AppSizes.spaceH(10),

                    Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Container(
                          height: 50.h,
                          alignment: Alignment.center,
                          padding: const EdgeInsets.symmetric(horizontal: 12),
                          decoration: BoxDecoration(
                            borderRadius: AppBorders.btnRadius,
                            border: Border.all(color: context.border, width: 1),
                          ),
                          child: ConstText(
                            text: "+91",
                            color: context.textPrimary,
                            fontWeight: AppConstant.semiBold,
                            fontSize: AppConstant.fontSizeThree,
                          ),
                        ),
                        AppSizes.spaceW(12),
                        Expanded(
                          child: AppTextField(
                            height: 50,
                            controller: _phoneController,
                            showClearButton: false,
                            keyboardType: TextInputType.phone,
                            hintText: "",
                            maxLength: 10,
                          ),
                        ),
                      ],
                    ),
                    AppSizes.spaceH(10),
                    ConstText(
                      text: "By proceeding, you agree to get offers and other communication via calls and SMS",
                      fontSize: AppConstant.fontSizeZero,
                      color: context.textSecondary,

                    ),



                  ],
                ),
              ),
            ),
            AppBtn(

              title: "Send OTP",
              margin: AppPadding.screenPadding,
              isDisabled: _phoneController.text.length < 10,
              onTap: () {
                print("Proceed clicked!");
                context.push(RoutesName.otpScreen);
              },
            ),
            AppSizes.spaceH(10)

          ],
        ),
      ),
    );
  }
}

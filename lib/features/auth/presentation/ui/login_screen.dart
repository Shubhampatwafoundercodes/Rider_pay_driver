import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:rider_pay_driver/core/res/app_btn.dart';
import 'package:rider_pay_driver/core/res/app_color.dart';
import 'package:rider_pay_driver/core/res/app_constant.dart' show AppConstant;
import 'package:rider_pay_driver/core/res/app_padding.dart';
import 'package:rider_pay_driver/core/res/app_size.dart';
import 'package:rider_pay_driver/core/res/app_text_field.dart';
import 'package:rider_pay_driver/core/res/constant/common_icon_text_btn.dart' show CommonIconTextButton;
import 'package:rider_pay_driver/core/res/constant/common_top_bar.dart';
import 'package:rider_pay_driver/core/res/constant/const_text.dart';
import 'package:rider_pay_driver/core/res/exist_app_popup/exist_app_popup.dart';
import 'package:rider_pay_driver/core/res/validator/app_input_formatters.dart';
import 'package:rider_pay_driver/core/res/validator/app_validator.dart';
import 'package:rider_pay_driver/core/utils/routes/routes_name.dart';
import 'package:rider_pay_driver/features/auth/presentation/notifier/auth_notifer.dart';
import 'package:rider_pay_driver/generated/assets.dart';
import 'package:rider_pay_driver/l10n/app_localizations.dart' show AppLocalizations;



class LoginScreen extends ConsumerStatefulWidget {
  const LoginScreen({super.key});

  @override
  ConsumerState<LoginScreen> createState() => _LoginScreenState();
}

  class _LoginScreenState extends ConsumerState<LoginScreen> {
    final TextEditingController _phoneController = TextEditingController();
    bool isButtonEnabled = false;

    @override
    void initState() {
      super.initState();
      _phoneController.addListener(_validatePhone);
    }

    void _validatePhone() {
      final phone = _phoneController.text.trim();
      final validationMsg = AppValidator.validateMobile(phone);

      if (validationMsg == null) {
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
      final authState=ref.watch(authNotifierProvider);

      return PopScope(
        canPop: false,
        onPopInvokedWithResult: (didPop, result) async {
          if (didPop) return;

          await ExitPopup.exitApp(context, tr);
          // bool exit = await ExitPopup.show(context, tr);
          // if (exit) {
          //   SystemNavigator.pop();
          // }
        },
        child: SafeArea(
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
                      // const ConstAppBackBtn(),
                      const Spacer(),
                      CommonIconTextButton(
                        text: tr.help,
                        imagePath: Assets.iconHelpIc,
                        imageColor: context.black,
                        onTap: () => context.pushNamed(RoutesName.supportScreen),
                      )
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
        
                        Image.asset(
                          Assets.iconLoginIc,
                          height: 70.h,
                        ),
        
                        AppSizes.spaceH(30),
        
                        /// 🔹 Title
                        ConstText(
                          text: tr.enterYourPhone,
                          fontSize: AppConstant.fontSizeLarge,
                          fontWeight: AppConstant.bold,
                          color: context.textPrimary,
                        ),
        
                        AppSizes.spaceH(10),
        
                        /// 🔹 Phone Number Field
                        AppTextField(
                          controller: _phoneController,
                          showClearButton: false,
                          prefixIcon:  Padding(
                           padding: const EdgeInsets.only(left: 10, right: 8),
                           child: ConstText(text: "+91",fontWeight: AppConstant.semiBold,),),
                          keyboardType: TextInputType.phone,
                          inputFormatters: AppInputFormatters.digitsOnly,
                          hintText: tr.phoneHint,
                          validator: AppValidator.validateMobile,
                          maxLength: 10,
                        ),
                      ],
                    ),
                ),
              ),
        
              /// 🔹 Bottom Section (sticky)
              Padding(
                padding: AppPadding.screenPadding,
                child: Column(
                  children: [
                    AppBtn(
                      title: tr.proceed,
                      loading: authState.isLoading,
                      margin: AppPadding.screenPaddingV,
                      isDisabled: !isButtonEnabled,
                      onTap: authState.isLoading
                          ? null
                          : () async {
                        final loginState = await ref
                            .read(authNotifierProvider.notifier)
                            .login(_phoneController.text.trim());
                        if (loginState == 1 || loginState == 2) {
                          context.push(RoutesName.otpScreen, extra: _phoneController.text.trim());
                          _phoneController.clear();
                        } else {
        
                          // toastMsg("Invalid number")
                        }
                      },
                    ),
        
                  ],
                ),
              ),
              AppSizes.spaceH(20)
            ],
          ),
        ),
            ),
      );
  }
}


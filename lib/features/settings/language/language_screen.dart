import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:rider_pay_driver/core/res/app_btn.dart';
import 'package:rider_pay_driver/core/res/app_color.dart';
import 'package:rider_pay_driver/core/res/app_constant.dart';
import 'package:rider_pay_driver/core/res/app_padding.dart';
import 'package:rider_pay_driver/core/res/app_size.dart';
import 'package:rider_pay_driver/core/res/constant/common_icon_text_btn.dart';
import 'package:rider_pay_driver/core/res/constant/common_top_bar.dart';
import 'package:rider_pay_driver/core/res/constant/const_back_btn.dart';
import 'package:rider_pay_driver/core/res/constant/const_text.dart';
import 'package:rider_pay_driver/core/utils/routes/routes_name.dart';
import 'package:rider_pay_driver/features/settings/language/language_controller.dart';

import 'package:rider_pay_driver/generated/assets.dart';
import 'package:rider_pay_driver/l10n/app_localizations.dart';
import 'package:rider_pay_driver/main.dart';

class LanguageScreen extends ConsumerWidget {
  final bool showProceedButton;
  const LanguageScreen( {super.key,this.showProceedButton=true});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final tr = AppLocalizations.of(context)!;

    final languages = ref.watch(availableLanguagesProvider);
    final selectedLanguage = ref.watch(currentLanguageProvider);

    return SafeArea(
      top: false,
      child: Scaffold(
        backgroundColor: context.background,
        body: Column(
          children: [
            AppSizes.spaceH(30),
            /// 🔹 AppBar-like Top Section
            CommonTopBar(
              child: Row(
                children: [
                  const ConstAppBackBtn(),
                  const Spacer(),

                  /// Help Button
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
              child: Padding(
                padding: AppPadding.screenPadding,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    AppSizes.spaceH(10),
                    Image.asset(Assets.iconLanguagesIc,height: 70.h,),

                    AppSizes.spaceH(30),

                    /// Title
                    ConstText(
                      text: tr.selectYourLanguage,
                      fontSize: AppConstant.fontSizeHeading,
                      fontWeight: AppConstant.bold,
                      color: context.textPrimary,
                    ),
                    AppSizes.spaceH(20),

                    /// Language Grid
                    Expanded(
                      child: GridView.builder(
                        gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 2,
                          mainAxisSpacing: 16,
                          crossAxisSpacing: 16,
                          childAspectRatio: 2,
                        ),
                        itemCount: languages.length,
                        itemBuilder: (context, index) {
                          final lang = languages[index];
                          final isSelected = lang == selectedLanguage;

                          return GestureDetector(
                            onTap: () {
                              final code = ref
                                  .read(localeProvider.notifier)
                                  .getCodeFromName(lang);
                              ref
                                  .read(localeProvider.notifier)
                                  .changeLocale(code);
                            },
                            child: Container(
                              decoration: BoxDecoration(
                                border: Border.all(
                                  color: isSelected
                                      ? AppColor.primary
                                      : context.border,
                                  width: 1.5,
                                ),
                                borderRadius: BorderRadius.circular(12),
                                color: isSelected
                                    ? AppColor.primary.withOpacity(0.1)
                                    : context.surface,
                              ),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  ConstText(
                                    text:
                                    lang,
                                      fontWeight:AppConstant.semiBold,
                                      fontSize: AppConstant.fontSizeThree,
                                      color: isSelected
                                          ? AppColor.primary
                                          : context.textPrimary,

                                  ),
                                  const SizedBox(width: 8),
                                  if (isSelected)
                                    Icon(
                                      Icons.check_circle,
                                      color: AppColor.primary,
                                      size: 20,
                                    ),
                                ],
                              ),
                            ),
                          );
                        },
                      ),
                    ),

                    /// Proceed Button
                    if (showProceedButton)
                      AppBtn(
                      height: screenHeight*0.062,
                      fontSize: AppConstant.fontSizeLarge,
                      title: tr.proceed,
                      margin: AppPadding.screenPaddingV,
                      onTap: () {
                        context.push(RoutesName.loginScreen);
                      },
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

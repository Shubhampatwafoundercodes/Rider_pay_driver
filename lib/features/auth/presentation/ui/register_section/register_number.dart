import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:rider_pay_driver/core/res/app_btn.dart';
import 'package:rider_pay_driver/core/res/app_color.dart';
import 'package:rider_pay_driver/core/res/app_constant.dart' show AppConstant;
import 'package:rider_pay_driver/core/res/app_padding.dart';
import 'package:rider_pay_driver/core/res/app_size.dart';
import 'package:rider_pay_driver/core/res/constant/common_bottom_sheet.dart';
import 'package:rider_pay_driver/core/res/constant/common_box.dart';
import 'package:rider_pay_driver/core/res/constant/common_icon_text_btn.dart';
import 'package:rider_pay_driver/core/res/constant/common_top_bar.dart';
import 'package:rider_pay_driver/core/res/constant/const_text.dart';
import 'package:rider_pay_driver/core/utils/routes/routes_name.dart';
import 'package:rider_pay_driver/features/auth/presentation/notifier/auth_notifer.dart';
import 'package:rider_pay_driver/features/auth/presentation/notifier/service_city_notifier.dart';
import 'package:rider_pay_driver/features/drawer/presentation/ui/profile/my_profile.dart';
import 'package:rider_pay_driver/features/map/presentation/notifier/profile_notifier.dart';
import 'package:rider_pay_driver/generated/assets.dart' show Assets;
import 'package:rider_pay_driver/l10n/app_localizations.dart';
import 'package:rider_pay_driver/main.dart';

class RegisterNumber extends ConsumerStatefulWidget {
  const RegisterNumber({super.key});

  @override
  ConsumerState<RegisterNumber> createState() => _RegisterNumberState();
}

class _RegisterNumberState extends ConsumerState<RegisterNumber> {
  bool showReferralField = false;
  final TextEditingController _referralController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final tr = AppLocalizations.of(context)!;
    final authState = ref.watch(authNotifierProvider);
    final selectedCity = ref.watch(serviceCityProvider).selectedCityName;

    return SafeArea(
      top: false,
      child: Scaffold(
        backgroundColor: context.background,
        appBar: AppBar(
          automaticallyImplyLeading: false,
          actions: [
            CommonTopBar(
              child: Row(
                children: [
                  // const ConstAppBackBtn(),
                  const Spacer(),
                  CommonIconTextButton(
                    text: tr.help,
                    imagePath: Assets.iconHelpIc,
                    imageColor: context.black,
                    onTap: () {
                      openBottomSheet(tr,context,ref);
                    },
                  ),
                ],
              ),
            ),

          ],
        ),
        body: SingleChildScrollView(
          padding: AppPadding.screenPadding,
          child: Column(

            children: [
              /// 🔹 Top Bar
            Image.asset(Assets.iconRegNIc, height: 70.h),
            AppSizes.spaceH(30),
            ConstText(
              text:tr.helloUser,
              fontSize: AppConstant.fontSizeLarge,
              fontWeight: AppConstant.bold,
              color: context.textPrimary,
            ),
            ConstText(
              text: tr.registerAsCaption,
              fontWeight: AppConstant.medium,
              color: context.textThird,
            ),
            AppSizes.spaceH(15),
            CommonBox(
              padding: AppPadding.screenPadding,
              borderColor: Colors.transparent,
              color: context.greyLight,
              // decoration: BoxDecoration(
              //   border: Border.all(color: context.border, width: 1),
              //   borderRadius: AppBorders.btnRadius,
              //   color: context.greyLight,
              // ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  ConstText(
                    text: tr.receiveAccountUpdateOn,
                    fontWeight: AppConstant.bold,
                    color: context.textThird,
                  ),
                  AppSizes.spaceH(5),
                  CommonBox(
                    height: screenHeight * 0.08,
                    color: AppColor.white,
                    child: Align(
                      alignment: Alignment.centerLeft,
                      child: DoubleText(
                        firstText: "+91",
                        secondText: ref.read(profileProvider.notifier).phone,
                        secondColor: context.textPrimary,
                        secondSize: AppConstant.fontSizeThree,
                        firstSize: AppConstant.fontSizeThree,
                        onTap: () {},
                      ),
                    ),
                  ),
                ],
              ),
            ),
            AppSizes.spaceH(10),
            Divider(color: context.greyMedium, thickness: 0.3),
            AppSizes.spaceH(15),
            if (!showReferralField)
              Align(
                alignment: AlignmentGeometry.topLeft,
                child: GestureDetector(
                  onTap: () {
                    setState(() {
                      showReferralField = !showReferralField;
                    });
                  },
                  child: ConstText(
                    text:tr.haveReferralCode,
                    fontWeight: AppConstant.bold,
                    color: context.blue,
                  ),
                ),
              ),

            /// Show input box if tapped
            if (showReferralField) ...[
              AppSizes.spaceH(10),
              CommonBox(
                borderColor: Colors.transparent,
                padding: AppPadding.screenPadding,
                color: context.greyLight,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              ConstText(
                                text:tr.haveReferralCode,
                                fontWeight: AppConstant.bold,
                                color: context.textPrimary,
                              ),
                              ConstText(
                                text:
                                    tr.referralBonusText,
                                fontWeight: AppConstant.medium,
                                color: context.textThird,
                                maxLine: 1,
                              ),
                            ],
                          ),
                        ),
                        AppSizes.spaceW(10),
                        Image.asset(Assets.iconReferralIc, height: 50.h),
                      ],
                    ),
                    AppSizes.spaceH(10),
                    TextField(
                      controller: _referralController,
                      decoration: InputDecoration(
                        hintText:tr.enterReferralCodeHint,
                        border: InputBorder.none,
                      ),
                    ),
                  ],
                ),
              ),
            ],
              // Spacer(),

            ],
          ),
        ),
        bottomNavigationBar:Padding(
          padding:AppPadding.screenPadding,
          child: SizedBox(
            height: screenHeight*0.1,
            child: AppBtn(
              title: tr.registerTitle,
              fontWeight: AppConstant.semiBold,
              fontSize: AppConstant.fontSizeThree,
              height: 55.h,
              borderRadius: 7,
              margin: AppPadding.screenPadding,
              isDisabled: selectedCity == null,
              loading: authState.isLoading,
              onTap: () async {
                final success = await ref.read(authNotifierProvider.notifier).registerApi(
                  selectedCity.toString(),
                  _referralController.text.isNotEmpty ? _referralController.text : null);
                if (success) {
                  context.go(RoutesName.documentCenter);
                }
              },
            ),
          ),
        ) ,
      ),
    );
  }

}

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:rider_pay_driver/core/res/app_btn.dart';
import 'package:rider_pay_driver/core/res/app_color.dart';
import 'package:rider_pay_driver/core/res/app_constant.dart';
import 'package:rider_pay_driver/core/res/app_padding.dart';
import 'package:rider_pay_driver/core/res/app_size.dart';
import 'package:rider_pay_driver/core/res/constant/common_box.dart';
import 'package:rider_pay_driver/core/res/constant/common_icon_text_btn.dart';
import 'package:rider_pay_driver/core/res/constant/common_top_bar.dart';
import 'package:rider_pay_driver/core/res/constant/const_back_btn.dart';
import 'package:rider_pay_driver/core/res/constant/const_text.dart';
import 'package:rider_pay_driver/core/utils/routes/routes_name.dart';
import 'package:rider_pay_driver/features/auth/presentation/notifier/service_city_notifier.dart';
import 'package:rider_pay_driver/generated/assets.dart';
import 'package:rider_pay_driver/l10n/app_localizations.dart';

class CitySelection extends ConsumerWidget{
  const CitySelection({super.key});

  @override
  Widget build(BuildContext context,WidgetRef ref) {
    final tr = AppLocalizations.of(context)!;

    return SafeArea(
      top: false,
      child: Scaffold(
        backgroundColor: context.background,
        body: Column(
          children: [
            /// 🔹 Top Bar
            AppSizes.spaceH(30),
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
                      context.push(RoutesName.supportScreen);
                    },
                  ),
                ],
              ),
            ),
            Padding(
              padding: AppPadding.screenPadding,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Image.asset(Assets.iconComfirmCityIc, height: 70.h),
                  AppSizes.spaceH(30),
                  ConstText(
                    text: tr.whichCityRide,
                    fontSize: AppConstant.fontSizeLarge,
                    fontWeight: AppConstant.bold,
                    color: context.textPrimary,
                  ),
                  AppSizes.spaceH(15),
                  CommonBox(
                    padding: AppPadding.screenPadding,
                    // decoration: BoxDecoration(
                    //   border: Border.all(color: context.border, width: 1),
                    //   borderRadius: AppBorders.btnRadius,
                    //   color: context.greyLight,
                    // ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        ConstText(
                          text: tr.youWillRideIn,
                          fontWeight: AppConstant.bold,
                          color: context.textThird,
                        ),
                        ListTile(
                          contentPadding: EdgeInsets.symmetric(horizontal: 0),
                          minLeadingWidth: 0,
                          horizontalTitleGap: 3, // leading aur title ke beech ka gap (default 16)
                          minVerticalPadding: 0,
                          dense: true, // vertical space thoda kam kare
                          leading: Icon(
                            Icons.location_on,
                            color: context.primary,
                            size: 20,
                          ),
                          title: ConstText(
                            text:ref.watch(serviceCityProvider).selectedCityName ?? tr.noCitiesFound,
                            fontWeight: AppConstant.semiBold,
                            fontSize: AppConstant.fontSizeThree,
                          ),
                          trailing: GestureDetector(
                            onTap: () async {
                              // final selectedCity = await context.push<String>(RoutesName.selectSearchCity);
                              // if (selectedCity != null) {
                              //   print("Selected city: $selectedCity");
                                context.push(RoutesName.selectSearchCity);
                              } ,
                            child: ConstText(
                              text: tr.change,
                              color: Colors.blue,
                              fontSize: AppConstant.fontSizeThree,
                            ),
                          ),
                        ),

                      ],
                    ),
                  ),

                  /// OTP Input (Auto Verify)
                ],
              ),
            ),
            Spacer(),
            AppBtn(
              title: tr.confirmCity,
              fontWeight: AppConstant.semiBold,
              fontSize: AppConstant.fontSizeThree,
              height: 55.h,
              borderRadius: 7,
              isDisabled: ref.watch(serviceCityProvider).selectedCityName==null,
              margin: AppPadding.screenPadding,
              onTap: (){
                context.push(RoutesName.registerNumber);
              },

            )
          ],
        ),
      ),
    );
  }
}

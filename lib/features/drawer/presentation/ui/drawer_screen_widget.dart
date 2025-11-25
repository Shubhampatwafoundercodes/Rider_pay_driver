import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:rider_pay_driver/core/res/app_color.dart';
import 'package:rider_pay_driver/core/res/app_constant.dart';
import 'package:rider_pay_driver/core/res/app_size.dart';
import 'package:rider_pay_driver/core/res/constant/common_box.dart';
import 'package:rider_pay_driver/core/res/constant/common_network_img.dart';
import 'package:rider_pay_driver/core/res/constant/const_text.dart';
import 'package:rider_pay_driver/core/utils/routes/routes_name.dart';
import 'package:rider_pay_driver/features/drawer/presentation/ui/wallet/earning_screen.dart' show EarningsPage;
import 'package:rider_pay_driver/features/map/presentation/notifier/profile_notifier.dart';
import 'package:rider_pay_driver/l10n/app_localizations.dart';


class DrawerScreenWidget extends ConsumerWidget {
  const DrawerScreenWidget({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final tr =AppLocalizations.of(context)!;
    final profileS=ref.read(profileProvider.notifier);
    final referCode=profileS.referCode.toString();
    return SafeArea(
      child: Drawer(
        backgroundColor: context.surface,
        shape: const RoundedRectangleBorder(borderRadius: BorderRadius.zero),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header with Profile
            CommonBox(
              onTap: (){
                context.push(RoutesName.myProfileScreen);
              },
              borderRadius: 1,
              color: context.greyLight,
              child: Row(
                children: [
                  Container(
                    height: 50.h,
                    width: 50.h,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(color: context.primary, width: 2),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(2),
                      child: ClipOval(
                        child:  profileS.img.isNotEmpty
                            ? CommonNetworkImage(
                          height: 50.h,
                          width: 50.h,
                          imageUrl: profileS.img,
                          fit: BoxFit.cover,
                        )
                            : Icon(
                          Icons.person,
                          size: 30.h,
                          color: context.greyMedium,
                        ),
                      ),
                    ),
                  ),
                  AppSizes.spaceW(10),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      ConstText(
                        text: tr.myProfile,
                        color: context.textPrimary,
                        fontSize: AppConstant.fontSizeTwo,
                        fontWeight: AppConstant.semiBold,
                      ),
                      Row(
                        children: [
                          ConstText(
                            text: "--",
                            color: context.textPrimary,
                            fontSize: AppConstant.fontSizeTwo,
                            fontWeight: AppConstant.semiBold,
                          ),
                          Icon(Icons.star, color: context.black),
                        ],
                      ),
                    ],
                  ),
                ],
              ),
            ),
            AppSizes.spaceH(8),

            // Menu Items
            _buildMenuItem(
              context,
              icon: Icons.attach_money_rounded,
              title:tr.earnings,
              subtitle: tr.earningsSubtitle,
              onTap: () {

                Navigator.push(context, MaterialPageRoute(builder: (context)=>EarningsPage()));


              },
            ),


            Divider(thickness: 0.3, color: context.hintTextColor),

            _buildMenuItem(
              context,
              icon: Icons.help_rounded,
              title:tr.help,
              subtitle: tr.helpSubtitle,
              onTap: () {
                context.push(RoutesName.supportScreen);

              },
            ),

            AppSizes.spaceH(16),
             Spacer(),
            // Referral Section
            // Container(
            //   // padding: const EdgeInsets.all(20),
            //   decoration: BoxDecoration(
            //     color: context.textPrimary.withAlpha(20),
            //     // borderRadius: BorderRadius.circular(16),
            //   ),
            //   child: ListTile(
            //     leading: Container(
            //       height: 30.w,
            //       width: 30.w,
            //       padding: EdgeInsets.all(04),
            //       decoration: BoxDecoration(
            //         color: context.docBlue,
            //         shape: BoxShape.circle,
            //       ),
            //       child: Image.asset(Assets.iconReferEarnIc),
            //     ),
            //     title: ConstText(
            //       text: tr.referFriend,
            //       fontSize: AppConstant.fontSizeOne,
            //       color: context.textPrimary,
            //       fontWeight: AppConstant.medium,
            //     ),
            //     subtitle: ConstText(text: tr.earnUpto,
            //       fontSize: AppConstant.fontSizeOne,
            //       color: context.textPrimary,
            //       fontWeight: AppConstant.bold,
            //
            //
            //     ),
            //     trailing: GestureDetector(
            //       onTap: () {
            //         final String referMsg =
            //             "🚖 Join our Ride App and earn rewards!\n\n"
            //             "Use my referral code: **$referCode** 🎁\n\n"
            //             "Download the app here:\nhttps://play.google.com/store/apps/details?id=com.yourappname\n\n"
            //             "Let's ride and earn together! 💸";
            //
            //         Share.share(
            //           referMsg,
            //           subject: "Earn money by referring friends 🚗",
            //         );
            //       },
            //       child: Container(
            //         padding: EdgeInsets.symmetric(horizontal: 6, vertical: 3),
            //         decoration: BoxDecoration(
            //           borderRadius: AppBorders.mediumRadius,
            //           color: context.docBlue,
            //         ),
            //         child: ConstText(
            //           text: "Refer Now",
            //           color: context.white,
            //           fontSize: AppConstant.fontSizeSmall,
            //           fontWeight: AppConstant.semiBold,
            //         ),
            //       ),
            //     ),
            //   ),
            // ),
            AppSizes.spaceH(16),

          ],
        ),
      ),
    );
  }

  Widget _buildMenuItem(
    BuildContext context, {
    required IconData icon,
    required String title,
    required String subtitle,
    required VoidCallback onTap,
  }) {
    return ListTile(
      focusColor: context.primary,
      hoverColor: context.primary,
      minVerticalPadding: 5,

      minTileHeight: 5,
      leading: Container(
        width: 40.w,
        height: 40.w,
        decoration: BoxDecoration(
          color: context.primary.withAlpha(10),
          // borderRadius: BorderRadius.circular(8),
          shape: BoxShape.circle,
        ),
        child: Icon(icon, color: context.black, size: 20),
      ),
      title: ConstText(
        text: title,
        fontSize: AppConstant.fontSizeTwo,
        fontWeight: AppConstant.semiBold,
        color: context.textPrimary,
      ),
      subtitle: ConstText(
        text: subtitle,
        fontSize: AppConstant.fontSizeSmall,
        color: context.textThird,
      ),
      onTap: onTap,
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
    );
  }
}

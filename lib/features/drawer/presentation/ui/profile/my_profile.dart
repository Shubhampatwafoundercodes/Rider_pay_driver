import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:rider_pay_driver/core/res/app_btn.dart';
import 'package:rider_pay_driver/core/res/app_color.dart';
import 'package:rider_pay_driver/core/res/app_constant.dart';
import 'package:rider_pay_driver/core/res/app_size.dart';
import 'package:rider_pay_driver/core/res/constant/common_bottom_sheet.dart';
import 'package:rider_pay_driver/core/res/constant/common_icon_text_btn.dart';
import 'package:rider_pay_driver/core/res/constant/common_network_img.dart';
import 'package:rider_pay_driver/core/res/constant/common_top_bar.dart';
import 'package:rider_pay_driver/core/res/constant/const_back_btn.dart';
import 'package:rider_pay_driver/core/res/constant/const_pop_up.dart';
import 'package:rider_pay_driver/core/res/constant/const_text.dart';
import 'package:rider_pay_driver/core/res/constant/const_text_btn.dart';
import 'package:rider_pay_driver/core/res/constant/custom_slider_dialog.dart';
import 'package:rider_pay_driver/core/utils/routes/routes_name.dart';
import 'package:rider_pay_driver/features/drawer/presentation/notifier/get_performance_notifier.dart';
import 'package:rider_pay_driver/features/drawer/presentation/notifier/update_profile_notifier.dart';
import 'package:rider_pay_driver/features/firebase_service/ride/notifer/ride_notifer.dart';
import 'package:rider_pay_driver/features/map/presentation/notifier/driver_on_of_notifer.dart';
import 'package:rider_pay_driver/features/map/presentation/notifier/profile_notifier.dart';
import 'package:rider_pay_driver/generated/assets.dart';
import 'package:rider_pay_driver/l10n/app_localizations.dart';
import 'package:rider_pay_driver/main.dart';
import 'package:rider_pay_driver/share_pref/user_provider.dart';

import '../../../../map/presentation/notifier/location_provider.dart';

class MyProfile extends ConsumerWidget {
  const MyProfile({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
   final tr=AppLocalizations.of(context)!;
    final profileState= ref.watch(profileProvider.notifier);
    final totalB= ref.watch(getPerformanceProvider).data?.data?.performance?.totalBookings??0;
    final img = profileState.img;
    final profile= ref.watch(profileProvider.notifier);
    final yearsText = getExperienceText(profile.createdAt);
    final experienceValue = int.tryParse(yearsText) ?? 0;
    final isDays = experienceValue < 365;

    return SafeArea(
      top: false,
      child: Scaffold(
        appBar: AppBar(
          automaticallyImplyLeading: false,
          actions: [
            CommonTopBar(
              child: Row(
                children: [
                  const ConstAppBackBtn(),
                  AppSizes.spaceW(15),
                  ConstText(
                    text: tr.myProfile,
                    fontSize: AppConstant.fontSizeThree,
                    fontWeight: AppConstant.semiBold,
                    color: context.textPrimary,
                  ),
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
          ],
        ),
        body: Column(
          children: [
            /// Banner
            Container(
              height: screenHeight * 0.25,
              width: screenWidth,
              decoration: const BoxDecoration(
                borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(20),
                  bottomRight: Radius.circular(20),
                ),
                image: DecorationImage(
                  image: AssetImage(Assets.imagesGaneshJiBg),
                  fit: BoxFit.cover,
                ),
              ),
            ),

            /// Profile Image
            Stack(
              clipBehavior: Clip.none,
              alignment: Alignment.center,
              children: [
                SizedBox(height: screenHeight * 0.08),
                Positioned(
                  top: -40.h,
                  child: Container(
                    height: 90.h,
                    width: 90.h,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(color: context.blue, width: 2),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(4),
                      child: ClipOval(
                        child: img.isNotEmpty?
                        CommonNetworkImage(
                          height: 90.h,
                          width: 90.h,
                          imageUrl: img,
                          fit: BoxFit.cover,
                        ):Icon(
                          Icons.person,
                          size: 60,
                          color: Colors.grey,
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),

            /// Name
            ConstText(
              text: profile.name,
              fontSize: AppConstant.fontSizeThree,
              fontWeight: AppConstant.semiBold,
            ),

            AppSizes.spaceH(15),

            /// Rating / Orders / Years
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        ConstText(
                          text: "0.0",
                          fontSize: AppConstant.fontSizeHeading,
                          fontWeight: AppConstant.semiBold,
                          letterHeight: 0,
                        ),
                        SizedBox(width: 4),
                        Icon(Icons.star, color: Colors.amber, size: 18),
                      ],
                    ),
                    Padding(
                      padding: const EdgeInsets.only(left: 8.0),
                      child: ConstText(
                        text: tr.ratingLabel,
                        fontSize: AppConstant.fontSizeSmall,
                        color: context.hintTextColor,
                        letterHeight: 0,
                      ),
                    ),
                  ],
                ),
                Column(
                  children: [
                    ConstText(
                      text:totalB.toString(),
                      fontSize: AppConstant.fontSizeHeading,
                      fontWeight: AppConstant.semiBold,
                      letterHeight: 0,
                    ),
                    ConstText(
                      text: tr.ordersLabel,
                      fontSize: AppConstant.fontSizeSmall,
                      color: context.hintTextColor,
                      letterHeight: 0,
                    ),
                  ],
                ),
                Column(
                  children: [
                    ConstText(
                      text: yearsText,
                      fontSize: AppConstant.fontSizeHeading,
                      fontWeight: AppConstant.semiBold,
                      letterHeight: 0,
                    ),
                    ConstText(
                      text: isDays ? tr.daysLabel : tr.yearsLabel,
                      fontSize: AppConstant.fontSizeSmall,
                      color: context.hintTextColor,
                      letterHeight: 0,
                    ),
                  ],
                ),
              ],
            ),

            AppSizes.spaceH(20),

            /// Menu List + Logout / Delete
            Expanded(
              child: ListView(
                padding: EdgeInsets.symmetric(horizontal: 16.w),
                children: [
                  _buildMenuItem(context, Icons.speed, tr.performance, onTap: () {
                    context.push(RoutesName.performanceScreen);
                  }),
                  _buildMenuItem(context, Icons.person, tr.profileInfo, onTap: () {
                    context.push(RoutesName.profileInfoScreen);
                  }),
                  _buildMenuItem(context, Icons.badge, tr.driverIdCard, onTap: () {
                    context.push(RoutesName.driverIdCard);
                  }),
                  _buildMenuItem(context, Icons.insert_drive_file, tr.documents, onTap: () {
                    context.push(RoutesName.documentView);
                  }),
                  _buildMenuItem(context, Icons.language, tr.languageSettings, onTap: () {
                    context.push(RoutesName.language, extra: false);
                  }),

                  AppSizes.spaceH(20),

                  AppBtn(
                    height: screenHeight * 0.05,
                    color: Colors.transparent,
                    border: Border.all(color: context.error, width: 1),
                    title: tr.logoutDeleteAccount,
                    onTap: () {
                      // context.pop();
                      showLogoutDeleteSheet(context,ref,tr);
                    }
                  ),
                  AppSizes.spaceH(20),

                ],
              ),
            ),
          ],
        ),
      ),
    );
  }




  /// Menu Item Widget
  Widget _buildMenuItem(BuildContext context, IconData icon, String title,
      {VoidCallback? onTap}) {
    return Container(
      margin: EdgeInsets.only(bottom: 12.h),
      decoration: BoxDecoration(
          color: context.greyLight, borderRadius: BorderRadius.circular(8)),
      child: ListTile(
        minVerticalPadding: 8,
        leading: Icon(icon, color: context.textPrimary, size: 18),
        title: ConstText(
          text: title,
          fontWeight: AppConstant.semiBold,
          color: context.textPrimary,
        ),
        trailing: Icon(Icons.arrow_forward_ios,
            size: 16, color: context.hintTextColor),
        onTap: onTap,
      ),
    );
  }
  String getExperienceText(String? createdAt) {
    if (createdAt == null || createdAt.isEmpty) return "--";

    try {
      final createdDate = DateTime.parse(createdAt);
      final now = DateTime.now();

      final totalDays = now.difference(createdDate).inDays;

      if (totalDays < 365) {
        // 1 saal se kam ho to days show karo
        return "$totalDays";
      } else {
        // 1 saal ya zyada ho to years show karo
        final diffYears = totalDays ~/ 365;
        return "$diffYears";
      }
    } catch (e) {
      return "--";
    }
  }
}


/// Logout / Delete BottomSheet
void showLogoutDeleteSheet(BuildContext context ,WidgetRef ref,AppLocalizations tr) {
  final userNotifier = ref.read(userProvider.notifier);
  final updateNotifier = ref.read(updateProfileProvider.notifier);
  final rideNotifier = ref.read(driverRideNotifierProvider.notifier);
  final locationNotifier = ref.read(locationProvider.notifier);
  showModalBottomSheet(
    context: context,
    backgroundColor: Colors.transparent,
    useRootNavigator: true,
    builder: (context) => CommonBottomSheet(
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          ListTile(
            leading: const Icon(Icons.logout, color: Colors.black),
            title: ConstText(
              text: tr.logout,
              fontSize: AppConstant.fontSizeThree,
              fontWeight: AppConstant.semiBold,
            ),
                onTap: () async{
                  closeTopPopup(context); // close logout sheet

                  ref.read(driverOnOffNotifierProvider.notifier).forceOfflineOnLogout();
                  await userNotifier.clearUser();

                  if (context.mounted) {
                    closeAllPopupsAndNavigate(context, RoutesName.splash);
                  }
            },
          ),
          Divider(thickness: 0.3, color: AppColor.grey),
          ListTile(
            leading: const Icon(Icons.delete_forever, color: Colors.red),
            title: ConstText(
              text: tr.deleteAccount,
              fontSize: AppConstant.fontSizeThree,
              fontWeight: AppConstant.semiBold,
              color: Colors.red,
            ),
            onTap: () {
              // Navigator.pop(context);
              // context.pop();
              CustomSlideDialog.show(
                context: context,
                child: ConstPopUp(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      ConstText(
                        text: tr.deleteAccountConfirm,
                        fontSize: AppConstant.fontSizeTwo,
                        fontWeight: AppConstant.semiBold,
                        color: context.textPrimary,
                      ),
                      AppSizes.spaceH(20),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          Expanded(
                            child: ConstTextBtn(
                              text: "No",
                              onTap: () {
                               // context.pop();
                                // Navigator.pop(context);
                                // closeAllPopups(context);
                                closeTopPopup(context); // just close dialog


                              },
                            ),
                          ),
                          AppSizes.spaceW(10),
                          Expanded(
                            child: ConstTextBtn(
                              text: "Yes",
                              onTap: () async {
                                // closeAllPopups(context);

                                 await ref.read(driverOnOffNotifierProvider.notifier).forceOfflineOnLogout();
                                 ref.read(driverOnOffNotifierProvider.notifier).setInitialOnlineState(false);
                                   // context.pop();
                                await updateNotifier.deleteAccount();
                                await userNotifier.clearUser();
                                // context.pop();

                                closeAllPopupsAndNavigate(context, RoutesName.splash);
                              },
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        ],
      ),
    ),
  );
}

void openBottomSheet(AppLocalizations t,BuildContext context ,WidgetRef ref,) {
  showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    backgroundColor: Colors.transparent,
    builder: (context) {
      return CommonBottomSheet(
        // title: "Options", // optional
        content: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // First option: Get Support
            GestureDetector(
              onTap: () {
                context.pop();
                context.push(RoutesName.supportScreen);
                // Navigator.pop(context);
                // showLogoutDeleteSheet(context,ref,t);
                print("Support tapped");
              },
              child: Padding(
                padding: EdgeInsets.symmetric(vertical: 12.h),
                child: ConstText(
                  text:t.getSupport,
                  fontSize: AppConstant.fontSizeThree,
                  textAlign: TextAlign.center,
                  color: context.textPrimary,
                  fontWeight: AppConstant.semiBold,
                ),
              ),
            ),

            Divider(color: context.greyMedium, thickness: 0.3),

            // Second option: Logout
            GestureDetector(
              onTap: () {
                // context.pop();
                showLogoutDeleteSheet(context,ref,t);
              },
              child: Padding(
                padding: EdgeInsets.symmetric(vertical: 12.h),
                child: ConstText(
                  text: t.logoutDeleteAccount,
                  fontSize: AppConstant.fontSizeThree,
                  textAlign: TextAlign.center,
                  color: context.textPrimary,
                  fontWeight: AppConstant.semiBold,
                ),
              ),
            ),
          ],
        ),
      );
    },
  );
}


void closeTopPopup(BuildContext context) {
  if (Navigator.of(context).canPop()) {
    Navigator.of(context).pop();
  }



}

void closeAllPopupsAndNavigate(
    BuildContext context,
    String routeName,
    ) {
  // Close all dialogs / bottom sheets
  Navigator.of(context, rootNavigator: true)
      .popUntil((route) => route.isFirst);

  // Navigate after pop completes
  Future.microtask(() {
    if (context.mounted) {
      context.go(routeName);
    }
  });
}
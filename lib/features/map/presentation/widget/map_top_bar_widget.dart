import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:rider_pay_driver/core/res/app_border.dart';
import 'package:rider_pay_driver/core/res/app_color.dart';
import 'package:rider_pay_driver/core/res/app_constant.dart';
import 'package:rider_pay_driver/core/res/app_size.dart';
import 'package:rider_pay_driver/core/res/constant/common_top_bar.dart';
import 'package:rider_pay_driver/core/res/constant/const_text.dart';
import 'package:rider_pay_driver/core/res/constant/const_toggle_switch.dart';
import 'package:rider_pay_driver/core/utils/routes/routes_name.dart';
import 'package:rider_pay_driver/features/map/presentation/notifier/driver_on_of_notifer.dart';
import 'package:rider_pay_driver/features/map/presentation/notifier/profile_notifier.dart';
import 'package:rider_pay_driver/main.dart';


class MapTopBarWidget extends ConsumerWidget {
  final void Function()? onTap;

  const MapTopBarWidget({super.key, this.onTap});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final profileState = ref.watch(profileProvider);
    final driverState = ref.watch(driverOnOffNotifierProvider);
    final driverNotifier = ref.read(driverOnOffNotifierProvider.notifier);


    final isLoading = driverState.isLoading;
    final isOnline = profileState.profile?.data?.driver?.availability == "Online";
    return SizedBox(
      width: screenWidth,
      child: CommonTopBar(
        background: context.white,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            GestureDetector(
              onTap: onTap,
              child: const Icon(Icons.menu_rounded, size: 24),
            ),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 6),
              decoration: BoxDecoration(
                borderRadius: AppBorders.largeRadius,
                border: Border.all(
                  color: isOnline ? context.success : context.greyMedium,
                  width: 1,
                ),
                color:
                isOnline ? context.success.withAlpha(40) : context.white,
              ),
              child: Row(
                children: [
                  AppSizes.spaceW(6),
                  ConstText(
                    text: isOnline ? "ON DUTY" : "OFF DUTY",
                    color:
                    isOnline ? context.success : context.hintTextColor,
                    fontWeight: AppConstant.medium,
                  ),
                  AppSizes.spaceW(5),
                  AbsorbPointer(
                    absorbing: isLoading,
                    child: ConstToggleSwitch(
                      value: isOnline,
                      onTap: () async {
                        if (isLoading) return;
                     await driverNotifier.toggleOnlineStatus();
                      },
                    ),
                  ),
                ],
              ),
            ),
            GestureDetector(
              onTap: () {
                context.push(RoutesName.notificationScreen);
              },
              child: Stack(
                alignment: Alignment.topRight,
                clipBehavior: Clip.none,
                children: [
                  Icon(Icons.notifications_sharp,
                      color: context.textSecondary),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}

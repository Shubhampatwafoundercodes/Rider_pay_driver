import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:rider_pay_driver/core/res/app_btn.dart';
import 'package:rider_pay_driver/core/res/app_color.dart';
import 'package:rider_pay_driver/core/res/app_constant.dart';
import 'package:rider_pay_driver/core/res/app_size.dart' show AppSizes;
import 'package:rider_pay_driver/core/res/constant/const_pop_up.dart';
import 'package:rider_pay_driver/features/map/presentation/notifier/location_provider.dart';
import 'package:rider_pay_driver/generated/assets.dart';

class LocationOnPopup extends ConsumerWidget {
  final bool isBlocked;
  final bool isServiceOff;
  final VoidCallback onAction;

  const LocationOnPopup({
    super.key,
    required this.onAction,
    this.isBlocked = false,
    this.isServiceOff = false,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final notifier = ref.read(locationProvider.notifier);

    return ConstPopUp(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          AppSizes.spaceH(15),

          /// Icon (optional)
          Image.asset(
            Assets.iconCircleLocation,
            height: 70.h,
          ),

          AppSizes.spaceH(20),

          /// Title
          Text(
            isServiceOff
                ? "Location Off"
                : isBlocked
                ? "Location Blocked"
                : "Enable Location",
            style: TextStyle(
              fontWeight: FontWeight.w600,
              fontSize: AppConstant.fontSizeLarge,
              color: context.textPrimary,
            ),
          ),
          AppSizes.spaceH(10),

          /// Description
          Text(
            isServiceOff
                ? "Please turn on your device's location services."
                : isBlocked
                ? "Location permission is blocked.\nPlease enable it from app settings."
                : "Allow location access to find rides near you.",
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: AppConstant.fontSizeTwo,
              color: context.textSecondary,
            ),
          ),

          AppSizes.spaceH(40),

          /// Button
          AppBtn(
            title: isServiceOff
                ? "Turn On Location"
                : isBlocked
                ? "Open Settings"
                : "Allow Access",
            onTap: () async {
              // Don’t close manually — this popup is part of the stack
              if (isServiceOff) {
                /// Open system location settings
                await notifier.enableService();
              } else if (isBlocked) {
                /// Open app settings
                await notifier.openSettings();
              } else {
                /// Try permission & location init again
                await notifier.initLocation();
              }

              /// Callback to trigger parent refresh (optional)
              onAction();
            },
          ),

          AppSizes.spaceH(20),
        ],
      ),
    );
  }
}

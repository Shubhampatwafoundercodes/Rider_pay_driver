import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:rider_pay_driver/core/res/app_btn.dart';
import 'package:rider_pay_driver/core/res/app_color.dart';
import 'package:rider_pay_driver/core/res/app_constant.dart';
import 'package:rider_pay_driver/core/res/app_padding.dart';
import 'package:rider_pay_driver/core/res/app_size.dart';
import 'package:rider_pay_driver/core/res/constant/common_box.dart';
import 'package:rider_pay_driver/core/res/constant/const_text.dart';
import 'package:rider_pay_driver/features/map/presentation/booking_details/widget/swipeable_card_animation.dart';
import 'package:rider_pay_driver/generated/assets.dart';

/// 🔹 UI Class (handles how card looks)
class BookingCardUI extends StatelessWidget {
  final Map<String, dynamic> order;
  final VoidCallback onAccept;
  final VoidCallback onReject;
  final VoidCallback onClear;

  const BookingCardUI({
    super.key,
    required this.order,
    required this.onAccept,
    required this.onReject,
    required this.onClear,
  });

  bool get isMissed => order["status"] == "missed";

  @override
  Widget build(BuildContext context) {
    final String acceptTitle = order["acceptTitle"] ?? "Accept";
    final bool isButtonEnabled = acceptTitle == "Accept";
    final String vehicleType = (order["vehicleType"] ?? "").toLowerCase();
    final IconData vehicleIcon = vehicleType == "car"
        ? Icons.local_taxi
        : vehicleType == "auto"
        ? Icons.electric_rickshaw
        : Icons.two_wheeler;
    return SwipeableCardAnimator(
      isMissed: isMissed,
      onAccept: isButtonEnabled ? onAccept : () {},
      onReject: onReject,
      onClear: onClear,
      child: Column(
        children: [
          CommonBox(
            color: isMissed ? context.black.withAlpha(20) : context.white,
            padding: AppPadding.screenPadding,
            child: Stack(
              alignment: AlignmentGeometry.topCenter,
              children: [
                Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    if (isMissed) AppSizes.spaceH(50),
                    Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.all(4),
                          decoration: BoxDecoration(
                            color: context.black,
                            shape: BoxShape.circle,
                          ),
                          child: Icon(
                            vehicleIcon,
                            color: context.white,
                            size: 18,
                          ),
                        ),
                        SizedBox(width: 8.w),
                        ConstText(
                          text: vehicleType.toUpperCase()??"",
                          fontWeight: FontWeight.bold,
                          fontSize: AppConstant.fontSizeTwo,
                          color: isMissed ? Colors.grey.shade400 : Colors.black,
                        ),

                        ConstText(
                          text: order["title"] ?? "Order Title",
                          fontWeight: FontWeight.bold,
                          fontSize: AppConstant.fontSizeThree,
                          color: isMissed ? Colors.white : Colors.black,
                        ),
                      ],
                    ),
                    SizedBox(height: 16.h),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _buildLocationDetail(
                          context,
                          isPickup: true,
                          distance: order["pickupDistance"],
                          address: order["pickupAddress"],
                        ),
                        const SizedBox(height: 8),
                        _buildLocationDetail(
                          context,
                          isPickup: false,
                          distance: order["dropDistance"],
                          address: order["dropAddress"],
                        ),
                      ],
                    ),
                    SizedBox(height: 16.h),
                    if (!isMissed)
                      Row(
                        children: [
                          GestureDetector(
                            onTap: onReject,
                            child: Container(
                              padding: const EdgeInsets.all(12),
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                color: Colors.grey[300],
                              ),
                              child: Image.asset(
                                Assets.iconMinusIc,
                                height: 15,
                              ),
                            ),
                          ),
                          const SizedBox(width: 16),
                          Expanded(
                            child: AppBtn(
                              onTap: isButtonEnabled ? onAccept : null,
                              title: order["acceptTitle"],
                            ),
                          ),
                        ],
                      ),
                  ],
                ),
                if (isMissed) _buildMissedHeader(),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMissedHeader() => Container(
    width: double.infinity,
    padding: const EdgeInsets.all(12),
    margin: const EdgeInsets.only(bottom: 16),
    decoration: BoxDecoration(
      color: const Color(0xFFFCE8E7),
      borderRadius: BorderRadius.circular(8),
    ),
    child: Row(
      children: [
        Icon(Icons.error_outline, color: Colors.red.shade700),
        SizedBox(width: 8.w),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ConstText(
                text: "You missed the order",
                color: Colors.red.shade700,
                fontWeight: FontWeight.bold,
                fontSize: 14,
              ),
              SizedBox(height: 2.h),
              ConstText(
                text: "Sorry, this order was accepted by another captain.",
                color: Colors.red.shade700,
                fontSize: 12,
              ),
            ],
          ),
        ),
      ],
    ),
  );

  Widget _buildLocationDetail(
    BuildContext context, {
    required bool isPickup,
    required String? distance,
    required String? address,
  }) {
    final Color iconColor = isPickup ? context.success : context.error;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Icon(
              Icons.location_on,
              color: iconColor,
              size:20,
            ),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              decoration: BoxDecoration(
                color: isPickup
                    ? (isMissed
                          ? Colors.green.withAlpha(20)
                          : Colors.green.withAlpha(10))
                    : (isMissed
                          ? Colors.red.withAlpha(20)
                          : Colors.red.withAlpha(10)),
                borderRadius: BorderRadius.circular(4),
              ),
              child: ConstText(
                text: distance ?? "-",
                color: isPickup ? context.success : context.error,
                fontWeight: AppConstant.semiBold,
                fontSize: AppConstant.fontSizeTwo,
              ),
            ),
          ],
        ),
         SizedBox(height: 7.h),
         ConstText(
          text: address ?? "-",
          color: isMissed ? Colors.grey : Colors.black54,
          fontSize: 14,
        ),
      ],
    );
  }
}

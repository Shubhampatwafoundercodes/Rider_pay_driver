import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:rider_pay_driver/core/res/app_btn.dart';
import 'package:rider_pay_driver/core/res/app_color.dart';
import 'package:rider_pay_driver/core/res/app_padding.dart';
import 'package:rider_pay_driver/core/res/app_size.dart';
import 'package:rider_pay_driver/core/res/constant/common_box.dart';
import 'package:rider_pay_driver/core/res/constant/common_top_bar.dart';
import 'package:rider_pay_driver/core/res/constant/const_back_btn.dart';
import 'package:rider_pay_driver/core/res/constant/const_text.dart';

class RewardScreen extends StatelessWidget {
  const RewardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: context.background,
      body: SafeArea(
        child: Column(
          children: [
            AppSizes.spaceH(20),

            /// 🔹 Top Bar
            CommonTopBar(
              child: Row(
                children: const [
                  ConstAppBackBtn(),
                  Spacer(),
                ],
              ),
            ),

            AppSizes.spaceH(20),

            /// 🔹 Header with total points
            Container(
              width: double.infinity,
              padding: AppPadding.screenPadding,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    AppColor.primary,
                    AppColor.primary.withAlpha(10),
                  ],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: const BorderRadius.only(
                  bottomLeft: Radius.circular(24),
                  bottomRight: Radius.circular(24),
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  ConstText(
                    text: "My Rewards",
                    fontSize: 26.sp,
                    fontWeight: FontWeight.bold,
                    color: AppColor.white,
                  ),
                  AppSizes.spaceH(10),
                  Row(
                    children: const [
                      Icon(Icons.star, color: Colors.yellow, size: 28),
                      SizedBox(width: 8),
                      ConstText(
                        text: "1,250 Points",
                        fontSize: 20,
                        fontWeight: FontWeight.w600,
                        color: AppColor.white,
                      ),
                    ],
                  ),
                ],
              ),
            ),

            AppSizes.spaceH(16),

            /// 🔹 Reward cards list
            Expanded(
              child: ListView.builder(
                padding: AppPadding.screenPadding,
                itemCount: 5,
                itemBuilder: (context, index) {
                  return Padding(
                    padding: EdgeInsets.only(bottom: 16.h),
                    child: RewardCard(
                      title: "₹${(index + 1) * 50} Cashback",
                      description:
                      "Redeem on your next ride. Points will be deducted immediately upon claiming.",
                      pointsRequired: (index + 1) * 100,
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class RewardCard extends StatelessWidget {
  final String title;
  final String description;
  final int pointsRequired;

  const RewardCard({
    super.key,
    required this.title,
    required this.description,
    required this.pointsRequired,
  });

  @override
  Widget build(BuildContext context) {
    return CommonBox(
      padding: EdgeInsets.all(16.w),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          /// 🔹 Reward Icon
          Container(
            padding: EdgeInsets.all(14.w),
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: AppColor.primary.withOpacity(0.1),
            ),
            child: Icon(
              Icons.card_giftcard,
              color: AppColor.primary,
              size: 28,
            ),
          ),
          AppSizes.spaceW(16),

          /// 🔹 Reward Info
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                ConstText(
                  text: title,
                  fontSize: 16.sp,
                  fontWeight: FontWeight.w600,
                  color: context.textPrimary,
                ),
                AppSizes.spaceH(6),
                ConstText(
                  text: description,
                  fontSize: 13.sp,
                  color: context.textSecondary,
                ),
              ],
            ),
          ),

          /// 🔹 Redeem Button
          AppBtn(
            title: "$pointsRequired pts",
            width: 100.w,
            height: 38.h,
            onTap: () {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(
                    "Reward claimed! $pointsRequired points deducted",
                  ),
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:rider_pay_driver/core/res/app_color.dart';
import 'package:rider_pay_driver/core/res/app_constant.dart';
import 'package:rider_pay_driver/core/res/app_padding.dart';
import 'package:rider_pay_driver/core/res/app_size.dart' show AppSizes;
import 'package:rider_pay_driver/core/res/constant/common_box.dart';
import 'package:rider_pay_driver/core/res/constant/common_icon_text_btn.dart';
import 'package:rider_pay_driver/core/res/constant/const_text.dart';
import 'package:rider_pay_driver/core/utils/routes/routes_name.dart';
import 'package:rider_pay_driver/features/map/presentation/notifier/complete_ride_notifier.dart';
import 'package:rider_pay_driver/generated/assets.dart' show Assets;
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:rider_pay_driver/core/res/app_color.dart';
import 'package:rider_pay_driver/core/res/app_constant.dart';
import 'package:rider_pay_driver/core/res/app_padding.dart';
import 'package:rider_pay_driver/core/res/app_size.dart';
import 'package:rider_pay_driver/core/res/constant/common_box.dart';
import 'package:rider_pay_driver/core/res/constant/common_icon_text_btn.dart';
import 'package:rider_pay_driver/core/res/constant/const_text.dart';
import 'package:rider_pay_driver/core/utils/routes/routes_name.dart';
import 'package:rider_pay_driver/generated/assets.dart';
import 'package:rider_pay_driver/l10n/app_localizations.dart';

class TodayEarningsSectionWidget extends ConsumerStatefulWidget {
  const TodayEarningsSectionWidget({super.key});

  @override
  ConsumerState<TodayEarningsSectionWidget> createState() =>
      _TodayEarningsSectionWidgetState();
}

class _TodayEarningsSectionWidgetState
    extends ConsumerState<TodayEarningsSectionWidget> {
  bool earningsExpanded = false;


  @override
  Widget build(BuildContext context) {
    final state = ref.watch(completeRideProvider);
    final tr=AppLocalizations.of(context)!;
    final earnings = state.earnings;

    final List<Map<String, String>> earningsData = [
      {
        "title": tr.earnings_rapidoWalletBalance, "amount": "₹${earnings?.data?.wallet ?? 0}"
      },
      {"title": tr.earnings_todaysEarning, "amount": "₹${earnings?.data?.todayEarning ?? 0}"},
      {
        "title": tr.earnings_lastOrderEarning, "amount": "₹${earnings?.data?.lastBookingEarning ?? 0}"
      },
    ];

    return GestureDetector(
      onTap: () => setState(() => earningsExpanded = !earningsExpanded),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: context.blue.withAlpha(100),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            AppSizes.spaceH(3),

            // 🔹 COLLAPSED VIEW
            if (!earningsExpanded)
              Padding(
                padding: AppPadding.screenPadding,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    ConstText(
                      text: tr.earnings_todaysEarning,
                      fontSize: AppConstant.fontSizeLarge,
                      color: context.textPrimary,
                    ),
                    Row(
                      children: [
                        if (state.isFetchingEarning)
                          const SizedBox(
                            width: 16,
                            height: 16,
                            // child: ,
                            child: CircularProgressIndicator(strokeWidth: 2),
                          )
                        else
                          ConstText(
                            text: "${earnings?.data?.todayEarning ?? 0}",
                            fontSize: AppConstant.fontSizeLarge,
                            color: context.textPrimary,
                          ),
                        AppSizes.spaceW(5),
                        const Icon(Icons.keyboard_arrow_down, size: 25),
                      ],
                    ),
                  ],
                ),
              ),

            // 🔹 EXPANDED VIEW
            if (earningsExpanded) ...[
              AppSizes.spaceH(17),
              if (state.isFetchingEarning)
                const Padding(
                  padding: EdgeInsets.all(16),
                  child: CircularProgressIndicator(),
                )
              else
                SizedBox(
                  height: 150.h,
                  child: ListView.builder(
                    scrollDirection: Axis.horizontal,
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    itemCount: earningsData.length,
                    itemBuilder: (context, index) {
                      final data = earningsData[index];
                      return CommonBox(
                        margin: const EdgeInsets.symmetric(horizontal: 10),
                        color: context.white,
                        width: 200,
                        boxShadow: const [
                          BoxShadow(
                            color: Colors.black26,
                            blurRadius: 2,
                            offset: Offset(0, 1),
                          ),
                        ],
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Container(
                              alignment: Alignment.center,
                              padding: const EdgeInsets.all(5),
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                color: context.greyLight,
                              ),
                              child: Icon(
                                Icons.account_balance_wallet_outlined,
                                color: context.textSecondary,
                                size: 18,
                              ),
                            ),
                            AppSizes.spaceH(6),
                            ConstText(
                              text: data["title"] ?? "",
                              fontSize: AppConstant.fontSizeSmall,
                            ),
                            AppSizes.spaceH(10),
                            ConstText(
                              text: data["amount"] ?? "₹0",
                              fontSize: AppConstant.fontSizeLarge,
                              fontWeight: AppConstant.semiBold,
                              color: context.textPrimary,
                            ),
                          ],
                        ),
                      );
                    },
                  ),
                ),

              CommonIconTextButton(
                onTap: () => context.push(RoutesName.rateCardScreen),
                backgroundColor: Colors.transparent,
                borderColor: Colors.transparent,
                imagePath: Assets.iconRupeeCircle,
                imageColor: context.docBlue,
                iconHeight: 15,
                child: ConstText(
                  text:tr.viewRateCard,
                  fontWeight: AppConstant.semiBold,
                  color: context.docBlue,
                ),
              ),
              AppSizes.spaceH(10),

              Center(
                child: Container(
                  width: 50,
                  height: 3,
                  decoration: BoxDecoration(
                    color: context.white,
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
              ),
              AppSizes.spaceH(8),
            ],
          ],
        ),
      ),
    );
  }
}

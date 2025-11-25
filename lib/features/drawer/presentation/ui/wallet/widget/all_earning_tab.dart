import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:rider_pay_driver/core/res/app_color.dart';
import 'package:rider_pay_driver/core/res/app_constant.dart';
import 'package:rider_pay_driver/core/res/app_size.dart';
import 'package:rider_pay_driver/core/res/constant/common_box.dart';
import 'package:rider_pay_driver/core/res/constant/const_text.dart';
import 'package:rider_pay_driver/core/utils/routes/routes_name.dart';
import 'package:rider_pay_driver/features/drawer/presentation/ui/my_ride/my_ride_screen.dart';
import 'package:rider_pay_driver/features/map/presentation/notifier/complete_ride_notifier.dart';
import 'package:rider_pay_driver/l10n/app_localizations.dart';

class AllEarningsTab extends ConsumerWidget {
  const AllEarningsTab({super.key});

  @override
  Widget build(BuildContext context,WidgetRef ref) {
    final tr=AppLocalizations.of(context)!;
    final todayEarning =ref.read(completeRideProvider).earnings?.data?.todayEarning??0;

    return ListView(
      padding: EdgeInsets.all(16.w),
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            ConstText(
              text: tr.todayEarningsTitle,
              fontSize: AppConstant.fontSizeTwo,
              fontWeight: AppConstant.semiBold,
              color: context.textPrimary,
            ),
            AppSizes.spaceH(8),
            ConstText(
              text: "₹${todayEarning.toString()}",
              fontSize: AppConstant.fontSizeHeading * 1.2,
              fontWeight: AppConstant.bold,
              color: context.textPrimary,
            ),
            AppSizes.spaceH(20),
          ],
        ),
        _buildMenuItem(context, Icons.receipt_long,tr.allOrdersTitle,

            onTap: () {
             Navigator.push(context, CupertinoPageRoute(builder: (context)=>RideHistoryScreen()));
            },
               subTitle: tr.allOrdersSubtitle,
    ),
        _buildMenuItem(context, Icons.currency_rupee,tr.viewRateCard, onTap: (){
          context.push(RoutesName.rateCardScreen);
        }),
        AppSizes.spaceH(20),
      ],
    );
  }

  Widget _buildMenuItem(BuildContext context, IconData icon, String title,
      {String? subTitle, VoidCallback? onTap}) {
    return CommonBox(
      padding: EdgeInsets.zero,
      color: context.white,
      borderColor: Colors.transparent,
      margin: EdgeInsets.only(bottom: 12.h),
      // decoration: BoxDecoration(
      //   color: context.white,
      //   borderRadius: BorderRadius.circular(8),
      // ),
      child: ListTile(

        leading: Icon(icon, color: context.textPrimary),
        title: ConstText(
          text: title,
          fontWeight: AppConstant.semiBold,
          color: context.textPrimary,
        ),
        subtitle: subTitle != null
            ? ConstText(
          text: subTitle,
          fontSize: AppConstant.fontSizeSmall,
          color: context.textSecondary,
        )
            : null,
        trailing: Icon(Icons.arrow_forward_ios,
            size: 16, color: context.hintTextColor),
        onTap: onTap,
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:rider_pay_driver/core/res/app_color.dart';
import 'package:rider_pay_driver/core/res/app_constant.dart';
import 'package:rider_pay_driver/core/res/constant/common_top_bar.dart';
import 'package:rider_pay_driver/core/res/constant/const_text.dart';
import 'package:rider_pay_driver/features/drawer/data/model/support_fq_model.dart';
import 'package:rider_pay_driver/l10n/app_localizations.dart';

class SupportDetailsScreen extends StatelessWidget {
  final SupportFqModelData data;
  const SupportDetailsScreen({super.key, required this.data});

  @override
  Widget build(BuildContext context) {
    final tr = AppLocalizations.of(context)!;

    return Scaffold(
      body: Column(
        children: [
          SizedBox(height: 30.h),
          CommonTopBar(
            child: Row(
              children: [
                GestureDetector(
                  onTap: () => context.pop(),
                  child: Icon(Icons.arrow_back, color: context.textPrimary),
                ),
                const Spacer(),
                ConstText(
                  text: tr.support,
                  color: context.textPrimary,
                  fontWeight: FontWeight.w600,
                  fontSize: AppConstant.fontSizeThree,
                ),
                const Spacer(),
                const SizedBox(width: 48),
              ],
            ),
          ),
          Expanded(
            child: Padding(
              padding: EdgeInsets.all(16.w),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  ConstText(
                    text: data.question ?? '',
                    fontSize: AppConstant.fontSizeHeading,
                    fontWeight: FontWeight.bold,
                    color: context.textPrimary,
                  ),
                  SizedBox(height: 12.h),
                  ConstText(
                    text: data.answer ?? '',
                    fontSize: AppConstant.fontSizeThree,
                    fontWeight: FontWeight.normal,
                    color: context.textSecondary,
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

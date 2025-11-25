import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:rider_pay_driver/core/res/app_btn.dart' show AppBtn;
import 'package:rider_pay_driver/core/res/app_color.dart';
import 'package:rider_pay_driver/core/res/app_constant.dart';
import 'package:rider_pay_driver/core/res/app_size.dart';
import 'package:rider_pay_driver/core/res/constant/const_pop_up.dart' show ConstPopUp;
import 'package:rider_pay_driver/core/res/constant/const_text.dart';
import 'package:rider_pay_driver/generated/assets.dart' show Assets;


class SuccessRejectPopup extends StatelessWidget {
  final bool isReject;
  final String? btnTitle;
  final VoidCallback? onAction;
  final String? title;
  final String? subtitle;
  final Widget? customContent;

  const SuccessRejectPopup({
    super.key,
    this.isReject = false,
    this.btnTitle,
    this.onAction,
    this.title,
    this.subtitle,
    this.customContent,
  });

  @override
  Widget build(BuildContext context) {
    return ConstPopUp(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // AppSizes.spaceH(15),
          Align(
             alignment: Alignment.topRight,

              child: InkWell(
                  onTap: (){
                    Navigator.pop(context);
                  },

                  child: Image.asset(Assets.iconCancelIc,height: 15.h,))),
          AppSizes.spaceH(35),

          /// Icon
          Image.asset(
            !isReject ? Assets.imagesSuccess : Assets.imagesReject,
            height: 100.h,
          ),
          AppSizes.spaceH(20),

          /// Title
          if (title != null)
            ConstText(
              text: title!,
              fontWeight: AppConstant.semiBold,
              fontSize: AppConstant.fontSizeLarge,
              color: context.textSecondary,
            ),

          /// Subtitle
          if (subtitle != null) ...[
            AppSizes.spaceH(4),
            ConstText(
              text: subtitle!,
              color: context.textSecondary,
              fontSize: AppConstant.fontSizeOne,
              textAlign: TextAlign.center,
            ),
          ],

          /// Extra Custom Content
          if (customContent != null) ...[
            AppSizes.spaceH(12),
            customContent!,
          ],

          /// Action Button
          if (btnTitle != null && onAction != null) ...[
            AppSizes.spaceH(30),
            AppBtn(
              title: btnTitle!,
              onTap: onAction!,
            ),
          ],

          AppSizes.spaceH(20),
        ],
      ),
    );
  }
}

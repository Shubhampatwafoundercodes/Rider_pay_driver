import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:rider_pay_driver/core/res/app_color.dart';
import 'package:rider_pay_driver/core/res/app_constant.dart';
import 'package:rider_pay_driver/core/res/app_size.dart';
import 'package:rider_pay_driver/core/res/constant/common_box.dart';
import 'package:rider_pay_driver/core/res/constant/common_icon_text_btn.dart';
import 'package:rider_pay_driver/core/res/constant/common_network_img.dart';
import 'package:rider_pay_driver/core/res/constant/common_top_bar.dart';
import 'package:rider_pay_driver/core/res/constant/const_back_btn.dart';
import 'package:rider_pay_driver/core/res/constant/const_text.dart';
import 'package:rider_pay_driver/core/utils/routes/routes_name.dart';
import 'package:rider_pay_driver/features/map/presentation/notifier/profile_notifier.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:rider_pay_driver/generated/assets.dart';
import 'package:rider_pay_driver/l10n/app_localizations.dart';

class DocumentView extends ConsumerWidget {
  const DocumentView({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final profileState = ref.watch(profileProvider.notifier);
    final documents = profileState.allDocs;
    final tr =AppLocalizations.of(context)!;

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
                    text: tr.documentCenter,
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
        body: documents.isEmpty
            ? const Center(child: ConstText(text: "No documents found"))
            : ListView.builder(
          padding: EdgeInsets.all(16.w),
          itemCount: documents.length,
          itemBuilder: (context, index) {
            final doc = documents[index];
            final docType = doc.docType ?? "N/A";
            final docNumber = doc.docNumber ?? "N/A";
            final frontImg = doc.frontImg ?? "";

            return GestureDetector(
              onTap: () {
                context.push(
                  RoutesName.documentDetailsView,
                  extra: doc, // pass the document object
                );
              },
              child: CommonBox(
                margin: EdgeInsets.only(bottom: 12.h),
                padding: EdgeInsets.symmetric(
                    vertical: 16.h, horizontal: 16.w),
                borderRadius: 12.r,
                child: Row(
                  children: [
                    SizedBox(
                      height: 50.h,
                      width: 50.h,
                      child: frontImg.isNotEmpty
                          ? CommonNetworkImage(
                        imageUrl: frontImg,
                        fit: BoxFit.contain,
                        // height: ,
                      )
                          : const Icon(Icons.insert_drive_file),
                    ),
                    AppSizes.spaceW(12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          ConstText(
                            text: docType,
                            fontSize: AppConstant.fontSizeTwo,
                            fontWeight: AppConstant.semiBold,
                            color: context.textPrimary,
                          ),
                          ConstText(
                            text: docNumber,
                            fontSize: AppConstant.fontSizeOne,
                            color: context.textSecondary,
                          ),
                        ],
                      ),
                    ),
                    Icon(Icons.arrow_forward_ios,
                        size: 16.sp, color: context.textSecondary),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}

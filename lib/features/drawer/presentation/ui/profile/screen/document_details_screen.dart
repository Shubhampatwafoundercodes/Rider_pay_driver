import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:rider_pay_driver/core/res/app_color.dart';
import 'package:rider_pay_driver/core/res/app_constant.dart';
import 'package:rider_pay_driver/core/res/app_size.dart';
import 'package:rider_pay_driver/core/res/constant/common_network_img.dart';
import 'package:rider_pay_driver/core/res/constant/common_top_bar.dart';
import 'package:rider_pay_driver/core/res/constant/const_back_btn.dart';
import 'package:rider_pay_driver/core/res/constant/const_text.dart';
import 'package:intl/intl.dart';
import 'package:rider_pay_driver/l10n/app_localizations.dart';

class DocumentDetailScreen extends StatelessWidget {
  const DocumentDetailScreen({super.key, required this.document});
  final dynamic document;

  @override
  Widget build(BuildContext context) {
    final tr=AppLocalizations.of(context)!;
    final docType = document.docType ?? "N/A";
    final docNumber = document.docNumber ?? "N/A";
    final frontImg = document.frontImg ?? "";
    final verifiedStatus = document.verifiedStatus ?? "Pending";
    final uploadedAtRaw = document.uploadedAt as DateTime?;
    final uploadedAt = uploadedAtRaw != null
        ? DateFormat("dd/MM/yyyy").format(uploadedAtRaw)
        : "N/A";

    return SafeArea(
      top: false,
      child: Scaffold(
        backgroundColor: context.background,
        appBar: AppBar(
          automaticallyImplyLeading: false,
          actions: [
            CommonTopBar(
              child: Column(
                children: [
                  AppSizes.spaceH(5),
                  Row(
                    children: [
                      const ConstAppBackBtn(),
                      AppSizes.spaceW(15),
                      ConstText(
                        text: docType,
                        fontSize: AppConstant.fontSizeThree,
                        fontWeight: AppConstant.semiBold,
                        color: context.textPrimary,
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
        body: Padding(
          padding: EdgeInsets.all(16.w),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              frontImg.isNotEmpty
                  ? Expanded(
                child: InteractiveViewer(
                  panEnabled: true,
                  minScale: 0.5,
                  maxScale: 3.0,
                  child: CommonNetworkImage(
                    imageUrl: frontImg,
                  ),
                ),
              )
                  : const Icon(Icons.insert_drive_file, size: 100),
              AppSizes.spaceH(16),
              // Document Details
              Container(
                width: double.infinity,
                padding: EdgeInsets.all(12.w),
                decoration: BoxDecoration(
                  color: context.white,
                  borderRadius: BorderRadius.circular(12.r),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black12,
                      blurRadius: 4,
                      offset: const Offset(0, 2),
                    )
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildDetailRow(tr.documentType, docType, context),
                    _buildDetailRow(tr.documentNumber, docNumber, context),
                    _buildDetailRow(tr.verifiedStatus, verifiedStatus, context),
                    _buildDetailRow(tr.uploadedDate, uploadedAt, context),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildDetailRow(String label, String value, BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 6.h),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          ConstText(
            text: label,
            fontSize: AppConstant.fontSizeSmall,
            fontWeight: FontWeight.w500,
            color: context.textSecondary,
          ),
          ConstText(
            text: value,
            fontSize: AppConstant.fontSizeSmall,
            fontWeight: AppConstant.semiBold,
            color: context.textPrimary,
          ),
        ],
      ),
    );
  }
}

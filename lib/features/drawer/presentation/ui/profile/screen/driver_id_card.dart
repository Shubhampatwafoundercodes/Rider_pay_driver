import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:path_provider/path_provider.dart';
import 'package:screenshot/screenshot.dart';
import 'package:share_plus/share_plus.dart';
import 'package:rider_pay_driver/core/res/app_btn.dart';
import 'package:rider_pay_driver/core/res/app_color.dart';
import 'package:rider_pay_driver/core/res/app_constant.dart';
import 'package:rider_pay_driver/core/res/app_padding.dart';
import 'package:rider_pay_driver/core/res/app_size.dart';
import 'package:rider_pay_driver/core/res/constant/common_box.dart';
import 'package:rider_pay_driver/core/res/constant/common_icon_text_btn.dart';
import 'package:rider_pay_driver/core/res/constant/common_network_img.dart';
import 'package:rider_pay_driver/core/res/constant/common_top_bar.dart';
import 'package:rider_pay_driver/core/res/constant/const_back_btn.dart';
import 'package:rider_pay_driver/core/res/constant/const_text.dart';
import 'package:rider_pay_driver/core/res/constant/const_text_btn.dart';
import 'package:rider_pay_driver/core/utils/routes/routes_name.dart';
import 'package:rider_pay_driver/generated/assets.dart';
import 'package:rider_pay_driver/features/map/presentation/notifier/profile_notifier.dart';
import 'package:rider_pay_driver/l10n/app_localizations.dart';

class DriverIdCard extends ConsumerStatefulWidget {
  const DriverIdCard({super.key});

  @override
  ConsumerState<DriverIdCard> createState() => _DriverIdCardState();
}

class _DriverIdCardState extends ConsumerState<DriverIdCard> {
  final ScreenshotController screenshotController = ScreenshotController();

  @override
  Widget build(BuildContext context) {
    final profileState = ref.watch(profileProvider);
    final profileN = ref.watch(profileProvider.notifier);
    final driver = profileState.profile?.data?.driver;
    final documents = profileState.profile?.data?.documents ?? [];

    final licenseIndex = documents.indexWhere(
          (doc) => doc.docType?.toLowerCase() == "license",
    );
    final fallbackIndex = licenseIndex == -1
        ? documents.indexWhere((doc) => doc.docType?.toLowerCase() == "aadhar")
        : -1;
    final licenseDoc = licenseIndex != -1
        ? documents[licenseIndex]
        : fallbackIndex != -1
        ? documents[fallbackIndex]
        : null;

    final licenseNumber = licenseDoc?.docNumber ?? "N/A";
    final licenseStatus = licenseDoc?.verifiedStatus ?? "Pending";
    final address = driver?.address ?? "N/A";
final tr=AppLocalizations.of(context)!;
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
                    text: tr.myIDCard,
                    fontSize: AppConstant.fontSizeThree,
                    fontWeight: AppConstant.semiBold,
                    color: context.textPrimary,
                  ),
                  const Spacer(),
                  CommonIconTextButton(
                    text:tr.help,
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
        body: profileState.isLoadingProfile
            ? const Center(child: CircularProgressIndicator())
            : driver == null
            ?  Center(child: ConstText(text: tr.noProfileData))
            : ListView(
          padding: EdgeInsets.all(16.w),
          children: [
            Screenshot(
              controller: screenshotController,
              child: CommonBox(
                padding: EdgeInsets.zero,
                borderRadius: 15.r,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Header
                    Container(
                      height: 140.h,
                      width: double.infinity,
                      decoration: BoxDecoration(
                        color: context.primary.withAlpha(200),
                        borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(12.r),
                          topRight: Radius.circular(12.r),
                        ),
                      ),
                      child: Stack(
                        alignment: Alignment.center,
                        clipBehavior: Clip.none,
                        children: [
                          Positioned(
                            left: 16,
                            bottom: -30,
                            child:Padding(
                              padding: const EdgeInsets.all(4),
                              child: ClipOval(
                                child: profileN.img.isNotEmpty?
                                CommonNetworkImage(
                                  height: 50.w,
                                  width: 50.w,
                                  imageUrl: profileN.img,
                                  fit: BoxFit.cover,
                                ):CircleAvatar(
                                  radius: 30.r,
                                  backgroundImage:
                                  AssetImage(Assets.imagesOnboarding2),
                                ),
                              ),
                            )



                          ),
                          Positioned(
                            right: 16,
                            top: 16,
                            child: Container(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 12, vertical: 6),
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(20),
                              ),
                              child: Row(
                                children: [
                                  Icon(
                                    Icons.verified,
                                    color: licenseStatus == "Verified"
                                        ? Colors.green
                                        : Colors.orange,
                                    size: 18,
                                  ),
                                  AppSizes.spaceW(4),
                                  ConstText(
                                    text: licenseStatus,
                                    fontSize: AppConstant.fontSizeSmall,
                                    fontWeight: AppConstant.semiBold,
                                    color: licenseStatus == "Verified"
                                        ? Colors.green
                                        : Colors.orange,
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),

                    // Details
                    AppSizes.spaceH(25),
                    Padding(
                      padding: AppPadding.screenPadding,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          ConstText(
                            text: profileN.name,
                            fontSize: AppConstant.fontSizeThree,
                            fontWeight: AppConstant.semiBold,
                          ),
                          AppSizes.spaceH(5),
                          Divider(
                            thickness: 0.3,
                            color: context.hintTextColor,
                          ),
                          AppSizes.spaceH(5),
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment:
                            MainAxisAlignment.spaceBetween,
                            children: [
                              _buildInfoRow(
                                  context, tr.mobileNumber, "+91 ${profileN.phone}"),
                              _buildInfoRow(context, tr.address, address),
                            ],
                          ),
                          AppSizes.spaceH(35),
                          Row(
                            mainAxisAlignment:
                            MainAxisAlignment.spaceBetween,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              _buildInfoRow(
                                  context, tr.licenseNumber, licenseNumber),
                              _buildInfoRow(
                                  context, tr.licenseValidity, "---"),
                            ],
                          ),
                          AppSizes.spaceH(30),

                          // Share Button
                          AppBtn(
                            height: 40,
                            color: Colors.transparent,
                            border: Border.all(
                                color: context.docBlue, width: 1),
                            title: tr.share,
                            titleColor: context.docBlue,
                            onTap: () async {
                              final image =
                              await screenshotController.capture();
                              if (image == null) return;

                              final directory =
                              await getTemporaryDirectory();
                              final imagePath = '${directory.path}/driver_id_card.png';
                              final file = File(imagePath);
                              await file.writeAsBytes(image);

                              await Share.shareXFiles(
                                [XFile(imagePath)],
                                text: 'My Driver ID Card',
                              );
                            },
                          ),
                          AppSizes.spaceH(12),

                          // ConstTextBtn(
                          //   onTap: () {},
                          //   text: "View Declaration",
                          //   textColor: context.blue,
                          // ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoRow(BuildContext context, String label, String value) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        ConstText(
          text: label,
          fontSize: AppConstant.fontSizeThree,
          fontWeight: FontWeight.w500,
          color: context.textSecondary,
        ),
        AppSizes.spaceH(3),
        ConstText(
          text: value,
          fontSize: AppConstant.fontSizeZero,
          fontWeight: AppConstant.semiBold,
          color: context.textPrimary,
        ),
      ],
    );
  }
}


import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';

import 'package:rider_pay_driver/core/res/app_color.dart';
import 'package:rider_pay_driver/core/res/app_constant.dart';
import 'package:rider_pay_driver/core/res/app_padding.dart';
import 'package:rider_pay_driver/core/res/app_size.dart';
import 'package:rider_pay_driver/core/res/constant/common_box.dart' show CommonBox;
import 'package:rider_pay_driver/core/res/constant/common_icon_text_btn.dart';
import 'package:rider_pay_driver/core/res/constant/common_network_img.dart';
import 'package:rider_pay_driver/core/res/constant/const_text.dart';
import 'package:rider_pay_driver/core/res/exist_app_popup/exist_app_popup.dart';
import 'package:rider_pay_driver/core/utils/navigation_helper.dart' show NextRouteDecider;
import 'package:rider_pay_driver/core/utils/routes/routes_name.dart';
import 'package:rider_pay_driver/features/auth/presentation/ui/register_section/document_upload/permission_screen.dart';
import 'package:rider_pay_driver/features/drawer/presentation/ui/profile/my_profile.dart';
import 'package:rider_pay_driver/features/map/data/model/get_profile_model.dart';
import 'package:rider_pay_driver/features/map/presentation/notifier/profile_notifier.dart';
import 'package:rider_pay_driver/generated/assets.dart' show Assets;
import 'package:rider_pay_driver/l10n/app_localizations.dart';
import 'package:rider_pay_driver/main.dart';

class DocumentCenter extends ConsumerStatefulWidget {
  const DocumentCenter({super.key});

  @override
  ConsumerState<DocumentCenter> createState() => _DocumentCenterState();
}

class _DocumentCenterState extends ConsumerState<DocumentCenter> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_){
      ref.read(profileProvider.notifier).getProfile();
    });
  }


  @override
  Widget build(BuildContext context) {
    final tr = AppLocalizations.of(context)!;
    final profileState = ref.watch(profileProvider);
    final data = profileState.profile?.data;
    final isLoading = profileState.isLoadingProfile;

    if (isLoading) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }

    if (data == null) {
      return  Scaffold(
        body: Center(child: Text(tr.noProfileDataFound)),
      );
    }

    final docs = data.documents ;
    final vehicle = data.vehicleType;

    return PopScope(
        canPop: false,
        onPopInvokedWithResult: (didPop, result) async {
          if (didPop) return;
          await ExitPopup.exitApp(context, tr);
        },
          child: SafeArea(
        top: false,
        child: Scaffold(
          backgroundColor: context.surface,
          appBar: AppBar(
            automaticallyImplyLeading: false,
            title: Row(
              children: [
                AppSizes.spaceW(10),
                ConstText(
                  text: tr.documentCenter,
                  fontWeight: AppConstant.semiBold,
                  color: context.textPrimary,
                  fontSize: AppConstant.fontSizeThree,
                ),
                const Spacer(),
                CommonIconTextButton(
                  text: tr.help,
                  imagePath: Assets.iconHelpIc,
                  imageColor: context.black,
                  onTap: () {
                    openBottomSheet(tr,context,ref);
                  },
                ),

              ],
            ),
            backgroundColor: context.surface,
            elevation: 0,
          ),
          body: Column(
            children: [
              _header(tr),
              Expanded(
                child: RefreshIndicator(
                  onRefresh: () async {
                    await NextRouteDecider.goNextAfterProfileCheck(context, ref);
                  },
                child: ListView(
                  padding: AppPadding.screenPadding,
                  children: [
                    // Vehicle Tile
                    _commonTile(
                      icon: CommonNetworkImage(
                        imageUrl: vehicle?.icon ?? "",
                        height: 30,
                        width: 30,
                        fit: BoxFit.contain,
                      ),
                      title: "${tr.vehicleType}  - ${vehicle?.name ?? tr.notSelected}",
                      subtitle: vehicle?.name !=null ? tr.submited:tr.tapToSelectVehicle,
                      subtitleColor:vehicle?.name !=null ?  context.success:context.textPrimary,
                      trailing: const Icon(Icons.arrow_forward_ios, size: 18),
                      onTap: (){
                        context.push(RoutesName.vehicleSelection);
                      },
                    ),
                    ...docs.map((doc) => _buildDocTile(doc,tr)),
                    _personDetailsTile(tr),
                    _permissionsTile(tr),
                  ],
                ),
              )),
            ],
          ),
        ),
      ),
    );
  }

  // Header
  Widget _buildDocTile(Document doc,AppLocalizations tr) {
    final status = (doc.verifiedStatus ?? "").toLowerCase();
    final isTapable = status == "rejected" || status == "" || status == "not uploaded";

    return _commonTile(
      icon: _iconForDocType(doc.docType ?? "", status),
      title: doc.docType ?? "Unknown",
      subtitle: _subtitleForStatus(status,tr),
      subtitleColor: _subtitleColor(status),
      borderColor: status == "rejected" ? Colors.red : null,
      trailing: isTapable ? const Icon(Icons.arrow_forward_ios, size: 18) : null,
      color: isTapable && status == "" ? context.docBlue : null,
      titleColor: isTapable && status == "" ? context.white : null,
      onTap: isTapable
          ? () => context.push(RoutesName.documentUpload, extra: {"docType": doc.docType ?? ""})
          : null,
    );
  }


  Widget _personDetailsTile(AppLocalizations tr) {
    final profileState = ref.watch(profileProvider);
    final driver = profileState.profile?.data?.driver;
    final isProfileIncomplete = [driver?.name, driver?.gender, driver?.dob].any((e) => e == null || e.trim().isEmpty);
    return GestureDetector(
      onTap: () {
        context.push(RoutesName.profileInfoScreen);
      },
      child: _commonTile(
        icon: const Icon(Icons.person_outline, color: Colors.blue),
        title: tr.personalDetails,
        subtitle: isProfileIncomplete
            ? tr.pleaseCompleteProfile : tr.profileComplete,
        subtitleColor:
        isProfileIncomplete ? Colors.red : Colors.green,
        trailing: Icon(
          Icons.arrow_forward_ios,
          size: 18,
          color: isProfileIncomplete ? Colors.red : Colors.green,
        ),
        borderColor:
        isProfileIncomplete ? Colors.red : Colors.green,
      ),
    );
  }

  Widget _iconForDocType(String docType, String status) {
    switch (docType.toLowerCase()) {
      case "license":
        return status == "verified"
            ? const Icon(Icons.verified, color: Colors.green)
            : Image.asset(Assets.imagesDlImage, height: 22.h);
      case "aadhar":
        return status == "verified"
            ? const Icon(Icons.verified, color: Colors.green)
            : Image.asset(Assets.imagesAadhaarCard, height: 22.h);
      case "vehicle":
        return status == "verified"
            ? const Icon(Icons.verified, color: Colors.green)
            : Image.asset(Assets.imagesRcImage, height: 22.h);
      default:
        return const Icon(Icons.description, color: Colors.grey);
    }
  }

  String _subtitleForStatus(String status ,AppLocalizations tr) {
    switch (status) {
      case "verified":
        return tr.approved;
      case "pending":
        return tr.underVerification;
      case "rejected":
        return tr.rejectedTapToReupload;
      default:
        return tr.notUploadedTapToUpload;
    }
  }

  Color? _subtitleColor(String status) {
    switch (status) {
      case "verified":
        return Colors.green;
      case "pending":
        return Colors.orange;
      case "rejected":
        return Colors.red;
      default:
        return context.white;
    }
  }

  Widget _header(AppLocalizations tr) => Container(
    width: screenWidth,
    padding: AppPadding.screenPadding,
    decoration: BoxDecoration(
      gradient: LinearGradient(
        colors: [Colors.blue.shade100, context.surface],
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
      ),
    ),
    child: Row(
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ConstText(
                text: tr.uploadDocumentsStart,
                fontSize: AppConstant.fontSizeLarge,
                fontWeight: AppConstant.bold,
                color: context.docBlue,
              ),
              AppSizes.spaceH(4),
              ConstText(
                text: tr.completeAllSteps,
                color: context.docBlue,
              ),
            ],
          ),
        ),
        AppSizes.spaceW(10),
        Image.asset(
          Assets.iconDocumetCIc,
          height: screenHeight * 0.15,
          width: screenWidth * 0.25,
          color: context.docBlue,
        ),
      ],
    ),
  );

  Widget _permissionsTile(AppLocalizations tr) => GestureDetector(
    onTap: () {
      Navigator.push(
        context,
        CupertinoPageRoute(
          builder: (_) => const PermissionsScreen(),
        ),
      );
    },
    child: _commonTile(
      icon: const Icon(Icons.security, color: Colors.blue),
      title: tr.permissions,
      subtitle: tr.tapToManagePermissions,
      subtitleColor: context.docBlue,
      trailing: Icon(Icons.arrow_forward_ios, size: 18, color: context.docBlue),
      borderColor: context.docBlue,
    ),
  );

  Widget _commonTile({
    required Widget icon,
    required String title,
    String? subtitle,
    Color? subtitleColor,
    Widget? trailing,
    Color? borderColor,
    Color? color,
    Color? titleColor,
    VoidCallback? onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: CommonBox(
        margin: const EdgeInsets.only(bottom: 12),
        borderColor: borderColor,
        color: color ?? context.white,
        boxShadow: [
          BoxShadow(
            color: context.black.withAlpha(40),
            blurRadius: 6,
            offset: const Offset(0, 3),
          )
        ],
        child: Row(
          children: [
            icon,
            AppSizes.spaceW(10),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  ConstText(
                    text: title,
                    fontWeight: AppConstant.medium,
                    color: titleColor ?? context.textPrimary,
                  ),
                  if (subtitle != null)
                    ConstText(
                      text: subtitle,
                      fontWeight: AppConstant.medium,
                      fontSize: AppConstant.fontSizeZero,
                      color: subtitleColor ?? context.textPrimary,
                    ),
                ],
              ),
            ),
            if (trailing != null) trailing,
          ],
        ),
      ),
    );
  }


}

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:rider_pay_driver/core/permission_provider/location_permission.dart';
import 'package:rider_pay_driver/core/permission_provider/other_permission_provider.dart';
import 'package:rider_pay_driver/core/res/app_btn.dart';
import 'package:rider_pay_driver/core/res/app_color.dart';
import 'package:rider_pay_driver/core/res/app_constant.dart';
import 'package:rider_pay_driver/core/res/app_padding.dart';
import 'package:rider_pay_driver/core/res/app_size.dart';
import 'package:rider_pay_driver/core/res/constant/common_box.dart';
import 'package:rider_pay_driver/core/res/constant/common_icon_text_btn.dart';
import 'package:rider_pay_driver/core/res/constant/common_top_bar.dart';
import 'package:rider_pay_driver/core/res/constant/const_back_btn.dart' show ConstAppBackBtn;
import 'package:rider_pay_driver/core/res/constant/const_text.dart';
import 'package:rider_pay_driver/core/utils/routes/routes_name.dart';
import 'package:rider_pay_driver/generated/assets.dart';
import 'package:rider_pay_driver/l10n/app_localizations.dart';

class PermissionsScreen extends ConsumerWidget {
  const PermissionsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final locationGranted = ref.watch(locationPermissionProvider);
    final locationManager = ref.read(locationPermissionProvider.notifier);
    final tr = AppLocalizations.of(context)!;

    final otherPermissions = ref.watch(otherPermissionsProvider);
    final otherManager = ref.read(otherPermissionsProvider.notifier);


    return SafeArea(
      top: false,
      child: Scaffold(
        backgroundColor: context.surface,
        body: Column(
          children: [
            AppSizes.spaceH(30),

            /// 🔹 Top Bar
            CommonTopBar(
              background: context.surface,
              child: Row(
                children: [
                  const ConstAppBackBtn(),
                  AppSizes.spaceW(10),
                  ConstText(
                    text:tr.permissionCenter,
                    fontWeight: AppConstant.semiBold,
                    color: context.textPrimary,
                    fontSize: AppConstant.fontSizeThree,
                  ),
                  const Spacer(),
                  CommonIconTextButton(
                    text: tr.help,
                    imagePath: Assets.iconHelpIc,
                    imageColor: context.black,
                    onTap: () => context.pushNamed(RoutesName.supportScreen),
                  ),
                ],
              ),
            ),

            Expanded(
                child: SingleChildScrollView(
              padding: AppPadding.screenPadding,
              child: Column(
                children: [
                  // Location Permission
                  buildTile(
                    Permission.locationWhenInUse,
                    tr.locationAccess,
                    tr.locationAccessDesc,
                    Icons.location_on,
                    locationGranted,
                        () => locationManager.requestPermission(),
                  ),

                  // Other Permissions
                  ...otherPermissions.entries.map((entry) {
                    String title, desc;
                    IconData icon;

                    switch (entry.key) {
                      // case Permission.locationAlways:
                      //   title = tr.backgroundLocation;
                      //   desc = tr.backgroundLocationDesc;
                      //   icon = Icons.location_on;
                      //   break;

                      case Permission.notification:
                        title = tr.notification;
                        desc = tr.notificationsDesc;
                        icon = Icons.notifications;
                        break;
                      default:
                        title = tr.unknownPermission;
                        desc = tr.unknownPermissionDesc;
                        icon = Icons.help;

                    }

                    return buildTile(entry.key, title, desc, icon, entry.value, () async {
                      // Request permission with permanent denial check
                      await otherManager.request(entry.key);
                    });
                  }),


                 AppSizes.spaceH(30),
                  // AppBtn(
                  //   title: tr.grantAllOtherPermissions,
                  //   onTap: ()async {
                  //     await otherManager.grantAll();
                  //   },
                  // )



                ],
              ),
            ))


            ],
          ),
        ));
  }
  Widget buildTile(
      Permission permission,
      String title,
      String description,
      IconData icon,
      bool granted,
      Function() onTap,
      ) {
    return CommonBox(
      color: AppColor.white,
      boxShadow: [
        BoxShadow(
          color: AppColor.black.withAlpha(40),
          blurRadius: 6,
          offset: const Offset(0, 3),
        )
      ],
      borderColor: Colors.transparent,

      margin: const EdgeInsets.only(bottom: 12),
      child: ListTile(
        minTileHeight: 0,
        contentPadding: EdgeInsets.zero,
        leading: Container(
          alignment: Alignment.center,
          height: 40,
            width: 40,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: AppColor.docBlueLight.withAlpha(20)

            ),
            child: Icon(icon, color: granted ?AppColor.docBlueLight : Colors.grey)),
        title: ConstText(text: title,fontWeight: AppConstant.semiBold,),
        subtitle: ConstText(text:description,fontSize: AppConstant.fontSizeSmall,color: AppColor.textThirdLight,),
        trailing: granted
            ? const Icon(Icons.check_circle, color: Colors.green)
            :  Icon(Icons.radio_button_unchecked,color: AppColor.grey,),
        onTap: onTap,
      ),
    );
  }

}

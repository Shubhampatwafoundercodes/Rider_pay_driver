import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:rider_pay_driver/core/res/app_btn.dart' show AppBtn;
import 'package:rider_pay_driver/core/res/app_color.dart';
import 'package:rider_pay_driver/core/res/app_constant.dart' show AppConstant;
import 'package:rider_pay_driver/core/res/app_padding.dart';
import 'package:rider_pay_driver/core/res/app_size.dart';
import 'package:rider_pay_driver/core/res/constant/common_box.dart';
import 'package:rider_pay_driver/core/res/constant/common_icon_text_btn.dart';
import 'package:rider_pay_driver/core/res/constant/common_network_img.dart'
    show CommonNetworkImage;
import 'package:rider_pay_driver/core/res/constant/common_top_bar.dart';
import 'package:rider_pay_driver/core/res/constant/const_back_btn.dart'
    show ConstAppBackBtn;
import 'package:rider_pay_driver/core/res/constant/const_text.dart';
import 'package:rider_pay_driver/core/utils/navigation_helper.dart';
import 'package:rider_pay_driver/core/utils/routes/routes_name.dart';
import 'package:rider_pay_driver/features/auth/presentation/notifier/vehicle_type_notifier.dart';
import 'package:rider_pay_driver/generated/assets.dart' show Assets;
import 'package:rider_pay_driver/l10n/app_localizations.dart';

class VehicleSelectionScreen extends ConsumerStatefulWidget {
  const VehicleSelectionScreen({super.key});

  @override
  ConsumerState<VehicleSelectionScreen> createState() =>
      _VehicleSelectionScreenState();
}

class _VehicleSelectionScreenState
    extends ConsumerState<VehicleSelectionScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(vehicleTypeProvider.notifier).fetchVehicleTypes();
    });
  }

  @override
  Widget build(BuildContext context) {
    final tr = AppLocalizations.of(context)!;

    final vehicleState = ref.watch(vehicleTypeProvider);

    return SafeArea(
      top: false,
      child: Scaffold(
        backgroundColor: context.greyLight,
        appBar: AppBar(
          automaticallyImplyLeading: false,
          actions: [
            CommonTopBar(
              child: Row(
                children: [
                  const ConstAppBackBtn(),
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
        body: Padding(
          padding: AppPadding.screenPadding,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Image.asset(Assets.iconSelectVIc, height: 70.h),
              AppSizes.spaceH(15),
              ConstText(
                text: tr.selectYourVehicle,
                fontWeight: AppConstant.bold,
                fontSize: AppConstant.fontSizeLarge,
                color: context.textPrimary,
              ),
              AppSizes.spaceH(10),

              /// Loader
              if (vehicleState.isLoading)
                const Expanded(
                  child: Center(child: CircularProgressIndicator()),
                )
              /// Data
              else if (vehicleState.vehicleTypeModelData != null &&
                  vehicleState.vehicleTypeModelData!.data.isNotEmpty)
                Expanded(
                  child: ListView.builder(
                    itemCount: vehicleState.vehicleTypeModelData!.data.length,
                    itemBuilder: (context, index) {
                      final datum =
                          vehicleState.vehicleTypeModelData!.data[index];
                      final isSelected = vehicleState.selectedId == datum.id;

                      return GestureDetector(
                        onTap: () {
                          ref
                              .read(vehicleTypeProvider.notifier)
                              .selectVehicle(datum.id ?? 0);
                        },
                        child: CommonBox(
                          margin: EdgeInsets.only(bottom: 15.h),
                          padding: AppPadding.screenPadding,
                          color: context.surface,
                          borderRadius: 7.r,
                          borderColor: isSelected
                              ? context.primary
                              : context.border,
                          borderWidth: isSelected ? 1.5 : 1,
                          child: Row(
                            children: [
                              CommonNetworkImage(
                                imageUrl: datum.icon,
                                height: 50.h,
                                width: 50.w,
                                fit: BoxFit.contain,
                              ),
                              SizedBox(width: 12.w),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    ConstText(
                                      text: datum.name ?? "",
                                      fontWeight: AppConstant.semiBold,
                                      color: context.textPrimary,
                                      fontSize: AppConstant.fontSizeThree,
                                    ),
                                    ConstText(
                                      text: datum.description ?? "",
                                      fontWeight: AppConstant.medium,
                                      color: context.hintTextColor,
                                    ),
                                  ],
                                ),
                              ),

                              /// Radio
                              Container(
                                alignment: Alignment.center,
                                height: 20.h,
                                width: 20.w,
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  border: Border.all(
                                    color: isSelected
                                        ? context.primary
                                        : context.border,
                                    width: 2,
                                  ),
                                ),
                                child: isSelected
                                    ? Container(
                                        height: 10,
                                        width: 10,
                                        decoration: BoxDecoration(
                                          shape: BoxShape.circle,
                                          color: context.primary,
                                        ),
                                      )
                                    : null,
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                ),

              /// Confirm button
              AppBtn(
                title:tr.confirmVehicle,
                loading: vehicleState.isUploadLoading,
                margin: AppPadding.screenPadding,
                isDisabled: vehicleState.selectedId == null,
                color: vehicleState.selectedId != null
                    ? context.primary
                    : context.greyMedium,
                onTap:
                    vehicleState.selectedId != null &&
                        !vehicleState.isUploadLoading
                    ? () async {
                        final isUpload = await ref.read(vehicleTypeProvider.notifier)
                            .uploadVehicleApi(vehicleState.selectedId.toString());
                        if (isUpload) {
                          print("Is uploade $isUpload");
                          await NextRouteDecider.goNextAfterProfileCheck(context ,ref);
                        }
                      }
                    : null,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

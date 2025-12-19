import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:rider_pay_driver/core/res/app_color.dart';
import 'package:rider_pay_driver/core/res/app_constant.dart';
import 'package:rider_pay_driver/core/res/constant/common_network_img.dart';
import 'package:rider_pay_driver/core/res/constant/const_text.dart';
import 'package:rider_pay_driver/features/auth/presentation/notifier/vehicle_type_notifier.dart';
import 'package:rider_pay_driver/l10n/app_localizations.dart';

class RateCardScreen extends ConsumerStatefulWidget {
  const RateCardScreen({super.key});

  @override
  ConsumerState<RateCardScreen> createState() => _RateCardScreenState();
}

class _RateCardScreenState extends ConsumerState<RateCardScreen> {
  int selectedIndex = 0;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(vehicleTypeProvider.notifier).fetchVehicleTypes();
    });
  }

  @override
  Widget build(BuildContext context) {
    final vehicleState = ref.watch(vehicleTypeProvider);
    final l10n = AppLocalizations.of(context)!;


    return Scaffold(
      backgroundColor: context.background,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: context.white,
        title: ConstText(
          text: l10n.rateCardTitle,
          fontSize: AppConstant.fontSizeTwo,
          fontWeight: AppConstant.semiBold,
          color: context.textPrimary,
        ),
        leading: const BackButton(color: Colors.black),
      ),

      /// Loader / Error / Data
      body: vehicleState.isLoading
          ? const Center(child: CircularProgressIndicator())
          : vehicleState.vehicleTypeModelData == null ||
          vehicleState.vehicleTypeModelData!.data.isEmpty
          ? Center(child: Text(l10n.noRateDataFound))
          : Column(
        children: [
          /// --- Tabs for Vehicle Names ---
          Container(
            padding: EdgeInsets.symmetric(vertical: 12.h),
            height: 60.h,
            child: ListView.separated(
              scrollDirection: Axis.horizontal,
              padding: EdgeInsets.symmetric(horizontal: 16.w),
              itemCount:
              vehicleState.vehicleTypeModelData!.data.length,
              separatorBuilder: (_, __) => SizedBox(width: 10.w),
              itemBuilder: (context, index) {
                final item =
                vehicleState.vehicleTypeModelData!.data[index];
                final bool isActive = selectedIndex == index;

                return GestureDetector(
                  onTap: () {
                    setState(() {
                      selectedIndex = index;
                    });
                  },
                  child: Container(
                    padding: EdgeInsets.symmetric(
                        horizontal: 16.w, vertical: 8.h),
                    decoration: BoxDecoration(
                      color: isActive
                          ? context.docBlue
                          : context.greyLightest,
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Row(
                      children: [
                        CommonNetworkImage(
                          fit: BoxFit.contain,
                          imageUrl: item.icon ?? '',
                          height: 24,
                          width: 24,
                        ),
                        SizedBox(width: 6.w),
                        ConstText(
                          text: item.name ?? '',
                          fontWeight: AppConstant.semiBold,
                          color: isActive
                              ? Colors.white
                              : context.textSecondary,
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),

          /// --- Selected Vehicle Info ---
          Expanded(
            child: Padding(
              padding: EdgeInsets.all(16.w),
              child: _vehicleRateCard(
                  context,
                  vehicleState.vehicleTypeModelData!
                      .data[selectedIndex],l10n),
            ),
          ),
        ],
      ),
    );
  }

  /// --- Vehicle Rate Card Section ---
  Widget _vehicleRateCard(BuildContext context, dynamic item, AppLocalizations l10n,) {
    // handle missing API fields gracefully
    final baseFare = item.baseFare ??
        item.base_fare ??
        item.minFare ??
        "N/A"; // check different key styles
    final perKm = item.perKmRate ?? item.per_km ?? "N/A";
    final perMin = item.perMinuteRate ?? item.per_minute ?? "N/A";
    final admin = item.adminComission ?? item.commission ?? "N/A";
    final capacity = item.capacity ?? "N/A";
    final maxSpeed = item.maxSpeed ?? "N/A";

    return ListView(
      padding: EdgeInsets.only(bottom: 20.h),
      children: [
        /// Section Header
        Container(
          padding: EdgeInsets.all(12.w),
          margin: EdgeInsets.only(bottom: 8.h),
          decoration: BoxDecoration(
            color: Colors.green.shade50,
            borderRadius: BorderRadius.circular(8),
          ),
          child: ConstText(
            text: l10n.fareDetailsTitle(item.name ?? ''),
            fontSize: AppConstant.fontSizeTwo,
            fontWeight: AppConstant.semiBold,
            color: Colors.green.shade700,
          ),
        ),

        /// Vehicle Details Card
        Container(
          padding: EdgeInsets.all(16.w),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12),
            boxShadow: [
              BoxShadow(
                color: Colors.black12,
                blurRadius: 4,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              /// Header Row
              Row(
                children: [
                  CommonNetworkImage(
                    imageUrl: item.icon ?? '',
                    height: 40,
                    width: 40,
                    fit: BoxFit.contain,
                  ),
                  SizedBox(width: 10.w),
                  Expanded(
                    child: ConstText(
                      text: item.name ?? '',
                      fontSize: AppConstant.fontSizeTwo,
                      fontWeight: AppConstant.semiBold,
                      color: AppColor.black,
                    ),
                  ),
                ],
              ),
              if (item.description != null) ...[
                SizedBox(height: 10.h),
                ConstText(
                  text: item.description!,
                  color: context.textSecondary,
                  fontSize: AppConstant.fontSizeSmall,
                ),
              ],
              Divider(height: 20.h),

              /// Rate Rows

              _fareRow(l10n.baseFare, "₹$baseFare"),
              _fareRow(l10n.perKmRate, l10n.perKmUnit(perKm)),
              _fareRow(l10n.perMinuteRate, l10n.perMinuteUnit(perMin)),
              _fareRow(l10n.adminCommission, "$admin%"),
              _fareRow(l10n.capacity, l10n.capacityUnit(capacity)),
              _fareRow(l10n.maxSpeed, l10n.speedUnit(maxSpeed)),
            ],
          ),
        ),
      ],
    );
  }

  /// --- Row for Each Fare Item ---
  Widget _fareRow(String title, String value) {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 12.h, horizontal: 12.w),
      margin: EdgeInsets.only(bottom: 8.h),
      decoration: BoxDecoration(
        color: AppColor.white,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          ConstText(
            text: title,
            fontWeight: AppConstant.semiBold,
            color: AppColor.black,
          ),
          ConstText(
            text: value,
            fontWeight: AppConstant.semiBold,
            color: context.textPrimary,
          ),
        ],
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:rider_pay_driver/core/res/app_border.dart';
import 'package:rider_pay_driver/core/res/app_color.dart';
import 'package:rider_pay_driver/core/res/app_constant.dart';
import 'package:rider_pay_driver/core/res/app_size.dart';
import 'package:rider_pay_driver/core/res/constant/common_icon_text_btn.dart';
import 'package:rider_pay_driver/core/res/constant/common_top_bar.dart';
import 'package:rider_pay_driver/core/res/constant/const_back_btn.dart';
import 'package:rider_pay_driver/core/res/constant/const_text.dart';
import 'package:rider_pay_driver/core/res/format/date_time_formater.dart';
import 'package:rider_pay_driver/core/utils/routes/routes_name.dart';
import 'package:rider_pay_driver/features/drawer/data/model/ride_booking_history_model.dart';
import 'package:rider_pay_driver/generated/assets.dart';
import 'package:rider_pay_driver/l10n/app_localizations.dart';
import 'package:rider_pay_driver/main.dart';

class RideDetailsScreen extends StatefulWidget {
  final RideBookingHistoryModelDataSingle ride;

  const RideDetailsScreen({super.key, required this.ride});

  @override
  State<RideDetailsScreen> createState() => _RideDetailsScreenState();
}

class _RideDetailsScreenState extends State<RideDetailsScreen>
    with SingleTickerProviderStateMixin {
  bool _showBadge = false;
  double _scale = 1.4;

  @override
  void initState() {
    super.initState();
    // Start animation after small delay
    Future.delayed(const Duration(milliseconds: 400), () async {
      if (!mounted) return;
      setState(() {
        _showBadge = true; // show badge
      });
      await Future.delayed(const Duration(milliseconds: 100));
      setState(() {
        _scale = 1.0;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    final tr=AppLocalizations.of(context)!;
    final isCancelled = widget.ride.status?.toLowerCase() == "cancelled";

    return Scaffold(
      backgroundColor: const Color(0xFFF7F7F7),
      appBar: AppBar(
        automaticallyImplyLeading: false,
        elevation: 0,
        backgroundColor: Colors.white,
        actions: [
          CommonTopBar(
            child: Row(
              children: [
                const ConstAppBackBtn(),
                AppSizes.spaceW(10),
                ConstText(
                  text: tr.ride_rideDetails,
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
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
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16.w),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _rideHeader(context),
            AppSizes.spaceH(15),
            _earningCard( tr,isCancelled),
            AppSizes.spaceH(20),
            _pickupDropCard(tr),
            AppSizes.spaceH(20),
            _paymentInfoCard(tr),
            AppSizes.spaceH(25),
           GestureDetector(
          onTap: () {
            context.push(RoutesName.supportScreen);
          },
          child: Container(
            padding: EdgeInsets.all(14.w),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12.r),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.06),
                  blurRadius: 6,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: Row(
              children: [
                Icon(Icons.support_agent, color: context.textPrimary),
                AppSizes.spaceW(10),
                ConstText(
                  text: tr.support,
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: context.textPrimary,
                ),
              ],
            ),
          ),
        )          ],
        ),
      ),
    );
  }

  /// 🟩 Header
  Widget _rideHeader(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        ConstText(
          text: widget.ride.name ?? "Ride Type",
          fontSize: 16,
          fontWeight: FontWeight.w600,
          color: context.textPrimary,
        ),
        AppSizes.spaceH(4),
        ConstText(
          text: DateTimeFormat.formatFullDateTime(
            widget.ride.bookingTime,
          ),
          fontSize: 12,
          color: context.hintTextColor,
        ),
        AppSizes.spaceH(6),
        ConstText(
          text: l10n.orderIdLabel(widget.ride.rideId ?? "--"),
          fontSize: 12,
          color: context.hintTextColor,
        ),
        AppSizes.spaceH(4),
        ConstText(
          text: (widget.ride.status ?? "Completed"),
          fontSize: 13,
          fontWeight: FontWeight.w600,
          color: (widget.ride.status?.toLowerCase() == "completed")
              ? Colors.green
              : Colors.orange,
        ),
      ],
    );
  }

  /// 💸 Earning Card
  Widget _earningCard(AppLocalizations tr, bool isCancelled) {
    return Stack(
      children: [
        Container(
          padding: EdgeInsets.all(16.w),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12.r),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.06),
                blurRadius: 8,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ConstText(
                text: tr.ride_yourEarning,
                fontSize: 14,
                fontWeight: FontWeight.w500,
                color: context.hintTextColor,
              ),
              AppSizes.spaceH(8),
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  ConstText(
                    text: "₹${widget.ride.finalFare ?? '0.00'}",
                    fontSize: 28,
                    fontWeight: FontWeight.w700,
                    color: context.textPrimary,
                  ),
                  const Spacer(),
                ],
              ),
              AppSizes.spaceH(4),
              ConstText(
                text: "${widget.ride.distanceKm ?? '0.0'} km ",
                fontSize: 13,
                color: context.hintTextColor,
              ),
              AppSizes.spaceH(12),
              // _earningLineItem("₹10 Tip from customer", true),
              // AppSizes.spaceH(6),
              // _earningLineItem("₹1.99 Time Fare received", true),
              // AppSizes.spaceH(15),
              GestureDetector(
                onTap: (){
                  context.push(RoutesName.rateCardScreen);
                },
                child: Container(
                  width: screenWidth * 0.4,
                  padding: EdgeInsets.symmetric(horizontal: 15, vertical: 8),
                  decoration: BoxDecoration(
                    borderRadius: AppBorders.extraSmallRadius,
                    // color: context.blue,
                    border: Border.all(color: context.blue, width: 1),
                  ),
                  child: Row(
                    children: [
                      Icon(Icons.ramp_left_sharp, color: context.blue, size: 19),
                      AppSizes.spaceW(3),
                      ConstText(
                        text:tr.viewRateCard,
                        fontWeight: AppConstant.semiBold,
                        color: context.blue,
                        fontSize: AppConstant.fontSizeZero,
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
        Positioned(
          top: 20,
          right: 20,
          child: AnimatedOpacity(
            opacity: _showBadge ? 1 : 0,
            duration: const Duration(milliseconds: 350),
            curve: Curves.easeOut,
            child: AnimatedScale(
              scale: _scale,
              duration: const Duration(milliseconds: 700),
              curve: Curves.easeOutBack,
              child: Image.asset(
                Assets.imagesVerifyBatch,
                height: 120.h,
                width: 120.h,
                fit: BoxFit.contain,
              ),
            ),
          ),
        ),
      ],
    );
  }


  /// 📍 Pickup and Drop Card
  Widget _pickupDropCard(AppLocalizations tr) {
    return _cardContainer(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ConstText(
            text: tr.ride_pickupDropInfo,
            fontSize: 15,
            fontWeight: FontWeight.w600,
            color: context.textPrimary,
          ),
          AppSizes.spaceH(12),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Column(
                children: [
                  Icon(Icons.circle, color: Colors.green, size: 10),
                  Container(
                    height: 40.h,
                    width: 1,
                    color: Colors.grey.shade400,
                  ),
                  Icon(Icons.location_on, color: Colors.red, size: 18),
                ],
              ),
              AppSizes.spaceW(8),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // ConstText(
                    //   text: "Pickup ${widget.ride.distanceKm ?? '0.0'} km",
                    //   fontSize: 13,
                    //   fontWeight: FontWeight.w600,
                    //   color: context.textPrimary,
                    // ),
                    ConstText(
                      text: tr.ride_pickupLocation,
                      fontSize: 13,
                      fontWeight: FontWeight.w600,
                      color: context.textPrimary,
                    ),
                    ConstText(
                      text: widget.ride.pickupAddress ?? "--",
                      fontSize: 13,
                      color: context.hintTextColor,
                      maxLine: 3,
                    ),
                    AppSizes.spaceH(10),
                    // ConstText(
                    //   text: "Drop ${widget.ride.distanceKm ?? '0.0'} km",
                    //   fontSize: 13,
                    //   fontWeight: FontWeight.w600,
                    //   color: context.textPrimary,
                    // ),
                    ConstText(
                      text: tr.ride_dropLocation,
                      fontSize: 13,
                      fontWeight: FontWeight.w600,
                      color: context.textPrimary,
                    ),
                    ConstText(
                      text: widget.ride.dropAddress ?? "--",
                      fontSize: 13,
                      color: context.hintTextColor,
                      maxLine: 3,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  /// 💰 Payment Info
  Widget _paymentInfoCard(AppLocalizations tr) {
    return _cardContainer(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ConstText(
            text: tr.ride_paymentInfo,
            fontSize: 15,
            fontWeight: FontWeight.w600,
            color: context.textPrimary,
          ),
          AppSizes.spaceH(12),
          _paymentRow(tr.ride_customerFare, widget.ride.suggestFare??"--"),
          // _paymentRow("Customer Tip", "--"),
          // _paymentRow("Government Taxes and Other Fees", "--"),
          // _paymentRow("Commission (10.00%)", "--"),
          const Divider(height: 22),
          _paymentRow(
            tr.ride_totalEarning,
            "₹${widget.ride.finalFare ?? '0.00'}",
            isBold: true,
          ),
        ],
      ),
    );
  }

  Widget _paymentRow(String title, String value, {bool isBold = false}) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 4.h),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          ConstText(
            text: title,
            fontSize: 13,
            color: Colors.black87,
            fontWeight: isBold ? FontWeight.w600 : FontWeight.w400,
          ),
          ConstText(
            text: value,
            fontSize: 13,
            color: Colors.black87,
            fontWeight: isBold ? FontWeight.w600 : FontWeight.w400,
          ),
        ],
      ),
    );
  }

  /// 🔸 Common Card
  Widget _cardContainer({required Widget child}) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12.r),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.06),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: child,
    );
  }
}

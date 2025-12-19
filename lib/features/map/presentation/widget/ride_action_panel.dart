import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:pinput/pinput.dart';
import 'package:rider_pay_driver/core/res/app_btn.dart' show AppBtn;
import 'package:rider_pay_driver/core/res/app_color.dart';
import 'package:rider_pay_driver/core/res/app_constant.dart';
import 'package:rider_pay_driver/core/res/app_size.dart';
import 'package:rider_pay_driver/core/res/constant/common_bottom_sheet.dart'
    show CommonBottomSheet;
import 'package:rider_pay_driver/core/res/constant/const_text.dart';
import 'package:rider_pay_driver/core/utils/utils.dart';
import 'package:rider_pay_driver/features/firebase_service/ride/data/model/ride_booking_model.dart';
import 'package:rider_pay_driver/features/firebase_service/ride/notifer/ride_notifer.dart';
import 'package:rider_pay_driver/features/map/presentation/notifier/complete_payment_notifier.dart';
import 'package:rider_pay_driver/features/map/presentation/notifier/complete_ride_notifier.dart';
import 'package:rider_pay_driver/features/map/presentation/notifier/map_controller.dart';
import 'package:rider_pay_driver/l10n/app_localizations.dart';
import 'package:rider_pay_driver/main.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:pinput/pinput.dart';
import 'package:rider_pay_driver/core/res/app_btn.dart';
import 'package:rider_pay_driver/core/res/app_constant.dart';
import 'package:rider_pay_driver/core/res/app_size.dart';
import 'package:rider_pay_driver/core/res/constant/common_bottom_sheet.dart';
import 'package:rider_pay_driver/core/res/constant/const_text.dart';
import 'package:rider_pay_driver/core/utils/utils.dart';
import 'package:rider_pay_driver/features/firebase_service/ride/data/model/ride_booking_model.dart';
import 'package:rider_pay_driver/features/firebase_service/ride/notifer/ride_notifer.dart';
import 'package:rider_pay_driver/features/map/presentation/notifier/map_controller.dart';
import 'package:rider_pay_driver/main.dart';
import 'package:url_launcher/url_launcher.dart';

class RideActionPanel extends ConsumerStatefulWidget {
  final RideBookingModel ride;

  const RideActionPanel({super.key, required this.ride});

  @override
  ConsumerState<RideActionPanel> createState() => _RideActionPanelState();
}

class _RideActionPanelState extends ConsumerState<RideActionPanel> {
  @override
  Widget build(BuildContext context) {

    final t =AppLocalizations.of(context)!;
    final ride = widget.ride;
    final rideNotifier = ref.watch(driverRideNotifierProvider.notifier);
    String currentBtnText = _getButtonText(ride);
    Color btnColor = _getButtonColor(ride);
    final mapCtrl = ref.read(mapControllerProvider.notifier);
    final isOtpVerified = ride.statusText?.toLowerCase() == "otp verified";
    final navigationButtonText =
    isOtpVerified ? t.goToDropOff : t.goToMap;
    return Align(
      alignment: Alignment.bottomCenter,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          AppBtn(
            width: screenWidth * 0.4,
            height: 35,
            borderRadius: 30,
            onTap: () => _launchMapsNavigation(ride, isOtpVerified),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.navigation, color: Colors.black, size: 18),
                SizedBox(width: 5),
                ConstText(
                  text: navigationButtonText,
                  color: context.textPrimary,
                  fontWeight: AppConstant.semiBold,
                ),
              ],
            ),
          ),
          AppSizes.spaceH(10),
          Container(
            width: double.infinity,
            padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.vertical(top: Radius.circular(16.r)),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withAlpha(40),
                  blurRadius: 8,
                  offset: Offset(0, -2),
                ),
              ],
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.verified_rounded, color: Colors.green, size: 20),
                    SizedBox(width: 6),
                    ConstText(
                      text:t.customerVerifiedLocation ,
                      color: context.textPrimary,
                      fontWeight: AppConstant.semiBold,
                    ),
                  ],
                ),
                SizedBox(height: 20.h),
                // ✅ Pickup Location
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Icon(Icons.my_location, color: Colors.green, size: 20),
                    const SizedBox(width: 8),
                    Expanded(
                      child: ConstText(
                        text: ride.pickupLocation["address"] ?? "Pickup address not available",
                        color: context.textPrimary,
                        fontWeight: AppConstant.medium,
                      ),
                    ),
                  ],
                ),

                SizedBox(height: 10.h),

                // ✅ Drop Location
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Icon(Icons.location_on, color: Colors.redAccent, size: 20),
                    const SizedBox(width: 8),
                    Expanded(
                      child: ConstText(
                        text: ride.dropLocation["address"] ?? "Drop address not available",
                        color: context.textPrimary,
                        fontWeight: AppConstant.medium,
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 14.h),
                // ConstText(
                //   text: isOtpVerified
                //       ? ride.dropLocation["address"]
                //       : ride.pickupLocation["address"] ?? "Pickup address",
                // ),
                SizedBox(height: 20.h),

                AppBtn(
                  title: currentBtnText,
                  color: btnColor,
                  titleColor: Colors.white,
                  // loading: ride.paymentStatus == "processing",
                  // onTap: (ride.paymentStatus == "processing")
                  //     ? null:
                  onTap: () async {
                    await _handleButtonTap(
                      context,
                      rideNotifier,
                      mapCtrl,
                      ride,
                      // currentBtnText,
                    );
                  },
                ),
                SizedBox(height: 30.h),
              ],
            ),
          ),
        ],
      ),
    );
  }
  String _getButtonText(RideBookingModel ride) {
    final status = ride.statusText?.toLowerCase() ?? "";
    final mode = ride.paymentMode?.toLowerCase() ?? "cash";
    final payStatus = ride.paymentStatus?.toLowerCase() ?? "pending";
    final fare = ride.fare.toString();

    final t = AppLocalizations.of(context)!;


    switch (status) {
      case "start":
      case "start ride":
      return t.startRide;

      case "started":
        return t.arrivedAtPickup;

      case "arrived pickup":
        return t.verifyOtp;

      case "otp verified":
        return t.arrivedAtDrop;

      case "arrived drop":
        if (mode == "online") {
          return (payStatus == "completed")
              ? t.completeRide
              : t.collectPayment(fare);
        } else {
          return (payStatus == "completed")
              ? t.completeRide
              : t.collectCash(fare);
        }

      case "complete ride":
      case "completed":
      return t.rideCompleted;

      default:
        return t.someIssue;
    }
  }

  Color _getButtonColor(RideBookingModel ride) {
    final status = ride.statusText?.toLowerCase() ?? "";
    final mode = ride.paymentMode?.toLowerCase() ?? "cash";
    final payStatus = ride.paymentStatus?.toLowerCase() ?? "pending";

    switch (status) {
      case "start":
      case "start ride":
        return Colors.green;

      case "started":
        return Colors.deepPurple;

      case "arrived pickup":
        return Colors.orange;

      case "otp verified":
        return Colors.yellow.shade700;

      case "arrived drop":
        if (payStatus != "completed") {
          return Colors.blue;
        }
        return Colors.orange;

      case "complete ride":
      case "completed":
        return Colors.purple;

      default:
        return Colors.grey;
    }
  }
  Future<void> _handleButtonTap(
      BuildContext context,
      DriverRideNotifier rideNotifier,
      MapController mapCtrl,
      RideBookingModel ride,
      ) async {
    final status = ride.statusText?.toLowerCase() ?? "";
    final mode = ride.paymentMode?.toLowerCase() ?? "cash";
    final payStatus = ride.paymentStatus?.toLowerCase() ?? "pending";

    final driverLatLng = ride.requestedDrivers?.first["location"];
    if (driverLatLng == null) {
      toastMsg("Driver location not found");
      return;
    }

    final driverLat = driverLatLng["latitude"];
    final driverLng = driverLatLng["longitude"];

    final completeRideNotifier = ref.read(completeRideProvider.notifier);
    final completePaymentNotifier =
    ref.read(completePaymentProvider.notifier);

    print("🔘 Button tapped for status: $status");

    switch (status) {

    /// 1️⃣ START RIDE
      case "start":
      case "start ride":
        await rideNotifier.updateRide(ride.rideId, {
          "statusText": "Started",
        });
        await mapCtrl.drawRoute(
          LatLng(driverLat, driverLng),
          LatLng(
            ride.pickupLocation["lat"],
            ride.pickupLocation["lng"],
          ),
        );
        break;

    /// 2️⃣ ARRIVED AT PICKUP
      case "started":
        await rideNotifier.updateRide(ride.rideId, {
          "statusText": "Arrived Pickup",
        });
        toastMsg("Driver arrived at pickup");
        break;

    /// 3️⃣ VERIFY OTP
      case "arrived pickup":
        bool? otpVerified = await _showOtpSheet(context, ride);
        if (otpVerified == true) {
          await rideNotifier.updateRide(ride.rideId, {
            "status": "otp_verified",
            "statusText": "OTP Verified",
          });
          mapCtrl.clearPolylines();
          await mapCtrl.drawRoute(
            LatLng(driverLat, driverLng),
            LatLng(
              ride.dropLocation["lat"],
              ride.dropLocation["lng"],
            ),
          );
        }
        break;

    /// 4️⃣ ARRIVED DROP
      case "otp verified":
        await rideNotifier.updateRide(ride.rideId, {
          "statusText": "Arrived Drop",
          "paymentStatus": "processing",
        });
        toastMsg("Arrived at drop location");
        break;

    /// 5️⃣ PAYMENT / COMPLETE
      case "arrived drop":
        if (payStatus != "completed") {
          if (mode == "online") {
            _showPaymentBottomSheet(ride);
          } else {
            toastMsg("Collecting cash from customer...");
            bool paymentSuccess =
            await completePaymentNotifier.completePaymentApi(
              ride.rideId,
              ride.fare.toString(),
            );

            if (paymentSuccess) {
              await _completeRide(
                ride,
                rideNotifier,
                mapCtrl,
              );
            } else {
              toastMsg("Cash collection failed");
            }
          }
        } else {
          await _completeRide(
            ride,
            rideNotifier,
            mapCtrl,
          );
        }
        break;

      default:
        toastMsg("Some issue occurred");
    }
  }


  //
  // Future<void> _handleButtonTap(
  //     BuildContext context,
  //     DriverRideNotifier rideNotifier,
  //     MapController mapCtrl,
  //     RideBookingModel ride,
  //     String btnText,
  //     ) async
  // {
  //   final driverLatLng = ride.requestedDrivers?.first["location"];
  //   if (driverLatLng == null) {
  //     toastMsg("Driver location not found");
  //     return;
  //   }
  //
  //   final driverLat = driverLatLng["latitude"];
  //   final driverLng = driverLatLng["longitude"];
  //   final completeRideNotifier = ref.read(completeRideProvider.notifier);
  //   final completePaymentNotifier = ref.read(completePaymentProvider.notifier);
  //
  //   final mode = ride.paymentMode?.toLowerCase() ?? "cash";
  //   final payStatus = ride.paymentStatus?.toLowerCase() ?? "pending";
  //
  //   print("🔘 Button Tapped: $btnText");
  //
  //   switch (btnText) {
  //   // 1️⃣ START RIDE
  //     case "START RIDE":
  //       await rideNotifier.updateRide(ride.rideId, {
  //         "statusText": "Started",
  //       });
  //       await mapCtrl.drawRoute(
  //         LatLng(driverLat, driverLng),
  //         LatLng(ride.pickupLocation["lat"], ride.pickupLocation["lng"]),
  //       );
  //       break;
  //
  //   // 2️⃣ ARRIVED AT PICKUP
  //     case "ARRIVED AT PICKUP":
  //       await rideNotifier.updateRide(ride.rideId, {
  //         "statusText": "Arrived Pickup",
  //       });
  //       toastMsg("Driver arrived at pickup");
  //       break;
  //
  //   // 3️⃣ VERIFY OTP
  //     case "VERIFY OTP":
  //       bool? otpVerified = await _showOtpSheet(context, ride);
  //       if (otpVerified == true) {
  //         await rideNotifier.updateRide(ride.rideId, {
  //           "status": "otp_verified",
  //           "statusText": "OTP Verified",
  //         });
  //         mapCtrl.clearPolylines();
  //         await mapCtrl.drawRoute(
  //           LatLng(driverLat, driverLng),
  //           LatLng(ride.dropLocation["lat"], ride.dropLocation["lng"]),
  //         );
  //       }
  //       break;
  //
  //   // 4️⃣ ARRIVED DROP
  //     case "ARRIVED DROP":
  //       await rideNotifier.updateRide(ride.rideId, {
  //         "statusText": "Arrived Drop",
  //         "paymentStatus":"processing"
  //       });
  //
  //       toastMsg("Arrived at drop location");
  //       break;
  //
  //     default:
  //       if (btnText.contains("Collect Payment")) {
  //         _showPaymentBottomSheet(ride);
  //       }
  //
  //       else if (btnText.contains("Collect Cash")) {
  //         toastMsg("Collecting cash from customer...");
  //         bool paymentSuccess = await completePaymentNotifier.completePaymentApi(ride.rideId, ride.fare.toString());
  //        print("paymentSuccess$paymentSuccess");
  //         if (paymentSuccess) {
  //           bool completeSuccess = await completeRideNotifier.completeRideApi(ride.rideId);
  //           print("paymentSuccess11$completeSuccess");
  //
  //           if (completeSuccess) {
  //             await rideNotifier.updateRide(ride.rideId, {
  //               "paymentStatus": "completed",
  //               "status": "completed",
  //               "statusText": "Completed",
  //             });
  //             mapCtrl.clearAll();
  //             toastMsg("Ride Completed (Cash)");
  //           } else {
  //             toastMsg("Ride completion failed after payment");
  //           }
  //         } else {
  //           toastMsg("Cash collection failed, please retry");
  //         }
  //       }
  //
  //       else if (btnText == "COMPLETE RIDE") {
  //         toastMsg("Completing ride... please wait");
  //         bool apiSuccess = await completeRideNotifier.completeRideApi(
  //           ride.rideId,
  //         );
  //
  //         if (apiSuccess) {
  //           await rideNotifier.updateRide(ride.rideId, {
  //             "status": "completed",
  //             "statusText": "Completed",
  //           });
  //           mapCtrl.clearAll();
  //           toastMsg("Ride Completed");
  //         } else {
  //           toastMsg("Failed to complete ride");
  //         }
  //       }
  //   }
  // }


  Future<void> _completeRide(
      RideBookingModel ride,
      DriverRideNotifier rideNotifier,
      MapController mapCtrl,
      ) async {
    final completeRideNotifier =
    ref.read(completeRideProvider.notifier);

    bool success =
    await completeRideNotifier.completeRideApi(ride.rideId);

    if (success) {
      await rideNotifier.updateRide(ride.rideId, {
        "status": "completed",
        "statusText": "Completed",
        "paymentStatus": "completed",
      });
      mapCtrl.clearAll();
      toastMsg("Ride Completed");
    } else {
      toastMsg("Failed to complete ride");
    }
  }

  Future<bool?> _showOtpSheet(
      BuildContext context,
      RideBookingModel ride,
      ) async
  {
    TextEditingController otpCtrl = TextEditingController();
    final t = AppLocalizations.of(context)!;

    return await showModalBottomSheet<bool>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) {
        return CommonBottomSheet(
          title: t.enterOtpTitle,
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ConstText(
                text: t.enterOtpDesc,
              ),
              SizedBox(height: 16.h),
              Pinput(controller: otpCtrl, length: 4),
              SizedBox(height: 20.h),
              AppBtn(
                title: t.verifyOtp,
                onTap: () {
                  if (otpCtrl.text.trim() == ride.otp.toString()) {
                    Navigator.pop(context, true);
                    toastMsg('OTP Verified');
                  } else {
                    toastMsg("Invalid OTP");
                  }
                },
              ),
            ],
          ),
        );
      },
    );
  }


  void _showPaymentBottomSheet(RideBookingModel ride) {

    final t = AppLocalizations.of(context)!;

    showModalBottomSheet(
      context: context,
      isDismissible: false,
      enableDrag: false,
      backgroundColor: Colors.transparent,
      builder: (ctx) {
        return Consumer(
          builder: (context, ref, _) {
            final liveRide = ref
                .watch(driverRideNotifierProvider)
                .rides
                .firstWhere((r) => r.rideId == ride.rideId, orElse: () => ride);

            final paymentStatus = liveRide.paymentStatus?.toLowerCase() ?? "pending";
            print("💳 Payment Status Changed => $paymentStatus");

            Widget content;

            switch (paymentStatus) {
              case "pending":
              case "waiting":
              case "processing":
                content = Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    const CircularProgressIndicator(color: Colors.blueAccent),
                    SizedBox(height: 15.h),
                    ConstText(
                      text: t.waitingForPayment,
                      textAlign: TextAlign.center,
                    ),
                    SizedBox(height: 8.h),
                    ConstText(
                      text: t.paymentAutoUpdateMsg,
                      fontSize: 12.sp,
                      color: Colors.grey,
                      textAlign: TextAlign.center,
                    ),
                    SizedBox(height: 20.h),
                  ],
                );
                break;

              case "completed":
                content = _buildPaymentSuccessUI(liveRide.fare.toString(), ride, ref);

                break;

              case "failed":
                content = Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(Icons.error_outline, color: Colors.red, size: 70),
                    SizedBox(height: 15.h),
                    ConstText(
                      text: t.paymentFailed,
                      color: Colors.red,
                      fontWeight: AppConstant.bold,
                      textAlign: TextAlign.center,
                    ),
                    SizedBox(height: 10.h),
                    AppBtn(
                      title: t.retry,
                      color: Colors.orange,
                      onTap: () {
                        Navigator.pop(context);
                        toastMsg(t.askCustomerRetry);
                      },
                    ),
                    SizedBox(height: 10.h),
                    AppBtn(
                      title: t.close,
                      color: Colors.grey,
                      onTap: () => Navigator.pop(context),
                    ),
                  ],
                );
                break;

              default:
                content = ConstText(
                  text: t.unknownPaymentStatus(paymentStatus),
                  textAlign: TextAlign.center,
                );
            }

            return CommonBottomSheet(
              title: t.paymentStatusTitle,
              content: AnimatedSwitcher(
                duration: const Duration(milliseconds: 500),
                child: content,
              ),
            );
          },
        );
      },
    );
  }

  Widget _buildPaymentSuccessUI(String amount, RideBookingModel ride, WidgetRef ref) {
    final t = AppLocalizations.of(context)!;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisSize: MainAxisSize.min,
      children: [
        // Success Icon
        Container(
          width: 50.w,
          height: 50.w,
          decoration: BoxDecoration(
            color: Colors.green.withOpacity(0.1),
            shape: BoxShape.circle,
          ),
          child: Icon(
            Icons.check_rounded,
            color: Colors.green,
            size: 30.sp,
          ),
        ),

        SizedBox(height: 20.h),

        // Success Message
        ConstText(
          text: t.paymentSuccessful,
          fontWeight: FontWeight.bold,
          fontSize: 20.sp,
          color: Colors.green,
        ),

        SizedBox(height: 5.h),

        // Amount
        ConstText(
          text: "₹$amount",
          fontSize: 22.sp,
          fontWeight: FontWeight.bold,
          color: Colors.black,
        ),

        SizedBox(height: 8.h),

        ConstText(
          text: t.amountReceived,
          fontSize: 14.sp,
          color: Colors.grey.shade600,
        ),

        SizedBox(height: 15.h),
        AppBtn(
          title: t.continues,
          onTap: () async {
            toastMsg("Payment received successfully!");
            final completeRideNotifier = ref.read(completeRideProvider.notifier);
            final rideNotifier = ref.read(driverRideNotifierProvider.notifier);
            final mapCtrl = ref.read(mapControllerProvider.notifier);
            bool apiSuccess = await completeRideNotifier.completeRideApi(ride.rideId);
            Navigator.pop(context);
            if (apiSuccess) {
              await rideNotifier.updateRide(ride.rideId, {
                "status": "completed",
                "statusText": "Completed",
                "paymentStatus": "completed",
              });
              mapCtrl.clearAll();
              toastMsg("✅ Ride Completed Successfully");
            } else {
              toastMsg("❌ Ride completion failed");
            }

          },
        ),
        SizedBox(height: 10.h),

      ],
    );
  }

  void _launchMapsNavigation(RideBookingModel ride, bool isOtpVerified) async {
    final driverLatLng = ride.requestedDrivers?.first["location"];
    if (driverLatLng == null) {
      toastMsg("Driver location not found");
      return;
    }

    double destinationLat;
    double destinationLng;

    if (isOtpVerified) {
      destinationLat = ride.dropLocation['lat'];
      destinationLng = ride.dropLocation['lng'];
    } else {
      destinationLat = ride.pickupLocation['lat'];
      destinationLng = ride.pickupLocation['lng'];
    }

    final driverLat = driverLatLng["latitude"];
    final driverLng = driverLatLng["longitude"];

    final url = Uri.parse(
        "https://www.google.com/maps/dir/?api=1&origin=$driverLat,$driverLng&destination=$destinationLat,$destinationLng&travelmode=driving"
    );

    if (await canLaunchUrl(url)) {
      await launchUrl(url, mode: LaunchMode.externalApplication);
    } else {
      toastMsg("Could not open Google Maps");
    }
  }
}

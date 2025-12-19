import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:rider_pay_driver/core/res/app_color.dart';
import 'package:rider_pay_driver/core/res/app_constant.dart';
import 'package:rider_pay_driver/core/res/app_padding.dart';
import 'package:rider_pay_driver/core/res/app_size.dart';
import 'package:rider_pay_driver/core/res/constant/const_text.dart';
import 'package:rider_pay_driver/core/res/exist_app_popup/exist_app_popup.dart';
import 'package:rider_pay_driver/core/widget/location_on_popup.dart';
import 'package:rider_pay_driver/features/drawer/presentation/ui/drawer_screen_widget.dart';
import 'package:rider_pay_driver/features/firebase_service/notification/notification_service.dart';
import 'package:rider_pay_driver/features/firebase_service/ride/notifer/ride_notifer.dart';
import 'package:rider_pay_driver/features/map/presentation/notifier/complete_ride_notifier.dart';
import 'package:rider_pay_driver/features/map/presentation/notifier/driver_on_of_notifer.dart';
import 'package:rider_pay_driver/features/map/presentation/notifier/location_provider.dart';
import 'package:rider_pay_driver/features/map/presentation/notifier/profile_notifier.dart';
import 'package:rider_pay_driver/features/map/presentation/widget/map_draggable_sheet_widget.dart';
import 'package:rider_pay_driver/features/map/presentation/widget/map_top_bar_widget.dart';
import 'package:rider_pay_driver/features/map/presentation/widget/ride_action_panel.dart';
import 'package:rider_pay_driver/features/map/presentation/widget/today_earnings_section_widget.dart' show TodayEarningsSectionWidget;
import 'package:rider_pay_driver/l10n/app_localizations.dart';
import 'package:rider_pay_driver/main.dart';
import 'package:rider_pay_driver/share_pref/user_provider.dart';
import 'package:url_launcher/url_launcher.dart';
import 'notifier/map_controller.dart' show mapControllerProvider;


class MapScreen extends ConsumerStatefulWidget {
  const MapScreen({super.key});

  @override
  ConsumerState<MapScreen> createState() => _MapScreenState();
}

class _MapScreenState extends ConsumerState<MapScreen> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  NotificationService notificationService = NotificationService();


  final CameraPosition _initialCameraPosition = const CameraPosition(
    target: LatLng(28.6139, 77.2090),
    zoom: 14.0,
  );


  @override
  void initState() {
    super.initState();
    notificationService.requestedNotificationPermission();
    notificationService.firebaseInit(context);
    notificationService.getDeviceToken();
    notificationService.setupInteractMassage(context);
    WidgetsBinding.instance.addPostFrameCallback((_)async{
      final profileNotifier = ref.read(profileProvider.notifier);
      final mapCon = ref.read(mapControllerProvider.notifier);
      final rideNotifier = ref.read(driverRideNotifierProvider.notifier);
      final locationNotifier = ref.read(locationProvider.notifier);
      final driverId= ref.read(userProvider.notifier).userId;
      ref.read(completeRideProvider.notifier).getDriverEarningApi(driverId.toString());
      final currentAvailability=profileNotifier.availability;
      if(currentAvailability=="Online"){
         rideNotifier.startAllRidesStream(driverId.toString());
         locationNotifier.startDriverOnlineUpdates(driverId.toString());

         await Future.delayed(Duration(seconds: 3));
         rideNotifier.restoreActiveRideRoute(mapCon);
      }else{
        rideNotifier.stopStream();
        locationNotifier.stopDriverOnlineUpdates();
        ref.read(driverOnOffNotifierProvider.notifier).setInitialOnlineState(false);
      }
       await  ref.read(locationProvider.notifier).initLocation();
      final pos = ref.read(locationProvider).currentPosition;
      if (pos != null) {
        await ref.read(mapControllerProvider.notifier).moveCamera(pos.latitude, pos.longitude);
      }






    });
  }


  @override
  Widget build(BuildContext context) {
    final tr=AppLocalizations.of(context)!;
    final rideState = ref.watch(driverRideNotifierProvider);
    final mapCtrlState = ref.watch(mapControllerProvider);
    final locationState = ref.watch(locationProvider);
    final driverState = ref.watch(driverOnOffNotifierProvider);

    final driverId = ref.watch(userProvider.notifier).userId.toString();
    final isBookingOngoing =
        rideState.rides.isNotEmpty &&
        rideState.rides.first.acceptedByDriver == true &&
        rideState.rides.first.driverId == driverId;

    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, result) async {
        if (didPop) return;
        await ExitPopup.exitApp(context, tr);

        // final shouldExit = await _showExitConfirmationPopUp(tr);
        // if (shouldExit) {
        //   SystemNavigator.pop();
        // }
      },
      child: SafeArea(
        top: false,
        child: Scaffold(
          extendBodyBehindAppBar: true,
          backgroundColor: context.surface,
          key: _scaffoldKey,
          drawer: DrawerScreenWidget(),
          appBar: AppBar(
            automaticallyImplyLeading: false,
            actions: [
              if(isBookingOngoing)
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Center(
                    child: ConstText(text: tr.meet_customer),
                  ),
                  AppSizes.spaceW(70.w),
                  GestureDetector(
                    onTap: () async {
                      final userNumber = rideState.rides.first.userNumber??"+9167812";
                      _callUser(userNumber);
                    },
                    child: Container(
                      height: 30.w,
                      width: 30.w,
                      margin: AppPadding.screenPaddingH,
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: context.black,
                      ),
                      child: Icon(Icons.add_ic_call_outlined, color: context.primary, size: 18.h),
                    ),
                  )


                ],
              )
              else
              MapTopBarWidget(
                onTap: () {
                  _scaffoldKey.currentState?.openDrawer();
                },
              ),
            ],
          ),
          body: Stack(
            children: [
              GoogleMap(
                initialCameraPosition: _initialCameraPosition,
                myLocationEnabled: true,
                rotateGesturesEnabled: false,
                myLocationButtonEnabled: false,
                // zoomGesturesEnabled: false,
                tiltGesturesEnabled: false,
                markers: mapCtrlState.markers,
                polylines: mapCtrlState.polyline,
                onMapCreated: (controller) {
                  ref.read(mapControllerProvider.notifier).setMapController(controller);
                  final pos = locationState.currentPosition;
                  if (pos != null) {
                     ref.read(mapControllerProvider.notifier)
                        .moveCamera(pos.latitude, pos.longitude);
                  }

                },
                zoomControlsEnabled: false,
              ),
              Positioned(
                bottom: screenHeight*0.42,
                right: 14,
                child: FloatingActionButton(
                  backgroundColor: Colors.white,
                  elevation: 5,
                  child: const Icon(Icons.my_location, color: Colors.black),
                  onPressed: () async {
                    final pos = ref.read(locationProvider).currentPosition;
                    if (pos != null) {
                      await ref
                          .read(mapControllerProvider.notifier)
                          .moveCamera(pos.latitude, pos.longitude, zoom: 16);
                    } else {
                      await ref.read(locationProvider.notifier).fetchCurrentPosition();
                      final newPos = ref.read(locationProvider).currentPosition;
                      if (newPos != null) {
                        await ref
                            .read(mapControllerProvider.notifier)
                            .moveCamera(newPos.latitude, newPos.longitude, zoom: 16);
                      }
                    }
                  },
                ),
              ),
              Positioned(
                top: kToolbarHeight+30.h,
                left: 0,
                right: 0,
                child: IntrinsicHeight(
                  child: Container(
                    width: double.infinity,
                    color: context.white,
                    child: const TodayEarningsSectionWidget(),
                  ),
                ),
              ),
              if(isBookingOngoing)
               RideActionPanel(
                 ride: rideState.rides.firstWhere((r) => r.driverId == driverId, orElse: () => rideState.rides.first,),
               )
              else
                MapDraggableSheetWidget(),

              //  Positioned.fill(
              //   // alignment: Alignment.center,
              //   child: MapBookingDetailsOverlay(
              //     rides: rideState.rides,
              //     driverId: driverId,
              //   ),
              // ),
              if (driverState.isLoading)
                Positioned.fill(
                  child: Container(
                    color: Colors.black.withOpacity(0.4), // full screen semi-transparent
                    alignment: Alignment.center,
                    child: Container(
                      padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 25.h),
                      decoration: BoxDecoration(
                        color: context.white, // popup background color
                        borderRadius: BorderRadius.circular(12.r),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black26,
                            blurRadius: 10,
                            offset: Offset(0, 4),
                          ),
                        ],
                      ),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          CircularProgressIndicator(color: context.primary),
                          AppSizes.spaceH(15),
                          ConstText(
                            text: tr.updating_status,
                            color: context.textPrimary,
                            fontSize: AppConstant.fontSizeThree,
                            fontWeight: AppConstant.medium,
                          ),
                        ],
                      ),
                    ),
                  ),
                ),




              if (!locationState.isServiceOn || !locationState.isPermissionGranted)
                Positioned.fill(
                  child: Container(
                    color: Colors.black.withOpacity(0.5),
                    alignment: Alignment.center,
                    child: LocationOnPopup(
                      isBlocked: !locationState.isPermissionGranted,
                      isServiceOff: !locationState.isServiceOn,
                      onAction: () async {
                        await Future.delayed(const Duration(milliseconds: 300));
                        await ref.read(locationProvider.notifier).initLocation();
                      },
                    ),
                  ),
                ),

            ],
          ),
        ),
      ),
    );
  }
  Future<void> _callUser(String phoneNumber) async {
    final Uri launchUri = Uri(
      scheme: 'tel',
      path: phoneNumber,
    );

    if (await canLaunchUrl(launchUri)) {
      await launchUrl(launchUri);
    } else {
      print("Could not launch dialer for $phoneNumber");
    }
  }


  // Future<bool> _showExitConfirmationPopUp(AppLocalizations tr) async {
  //   final result = await showDialog<bool>(
  //     context: context,
  //     barrierDismissible: true,
  //     builder: (BuildContext context) {
  //       return ConstPopUp(
  //         padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 25),
  //         borderRadius: 12.0,
  //         child: Column(
  //           mainAxisSize: MainAxisSize.min,
  //           children: [
  //             Icon(
  //               Icons.warning_amber_rounded,
  //               color: Colors.orange.shade700,
  //               size: 40,
  //             ),
  //             const SizedBox(height: 15),
  //             ConstText(
  //               text: tr.exit_app_title,
  //               fontSize: 18,
  //               fontWeight: AppConstant.bold,
  //               color: context.textPrimary,
  //             ),
  //             const SizedBox(height: 10),
  //             ConstText(
  //               text:
  //               tr.exit_app_message,
  //               fontSize: 14,
  //               textAlign: TextAlign.center,
  //               color: context.hintTextColor,
  //             ),
  //             const SizedBox(height: 25),
  //             Row(
  //               children: [
  //                 Expanded(
  //                   child: ConstTextBtn(
  //                     text: tr.cancel,
  //                     onTap: () => Navigator.of(context).pop(false),
  //                     textColor: Colors.blue,
  //                   ),
  //                 ),
  //                 const SizedBox(width: 15),
  //                 Expanded(
  //                   child: ConstTextBtn(
  //                     text: tr.ok_exit_button,
  //                     onTap: () => Navigator.of(context).pop(true),
  //                     textColor: Colors.red,
  //                   ),
  //                 ),
  //               ],
  //             ),
  //           ],
  //         ),
  //       );
  //     },
  //   );
  //
  //   return result ?? false;
  // }

}

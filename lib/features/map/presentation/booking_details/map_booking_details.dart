import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:just_audio/just_audio.dart';
import 'package:rider_pay_driver/core/res/app_color.dart';
import 'package:rider_pay_driver/core/res/constant/common_top_bar.dart';
import 'package:rider_pay_driver/core/res/constant/const_text.dart';
import 'package:rider_pay_driver/features/firebase_service/ride/notifer/ride_notifer.dart';
import 'package:rider_pay_driver/features/map/presentation/booking_details/widget/booking_card_widget.dart';
import 'package:rider_pay_driver/features/map/presentation/notifier/profile_notifier.dart';
import 'package:rider_pay_driver/main.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:rider_pay_driver/core/res/app_color.dart';
import 'package:rider_pay_driver/features/firebase_service/ride/data/model/ride_booking_model.dart';
import 'package:rider_pay_driver/features/map/presentation/booking_details/widget/booking_card_widget.dart';
import 'package:rider_pay_driver/main.dart';
import 'package:rider_pay_driver/share_pref/user_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:rider_pay_driver/core/res/app_color.dart';
import 'package:rider_pay_driver/core/res/constant/common_top_bar.dart';
import 'package:rider_pay_driver/core/res/constant/const_text.dart';
import 'package:rider_pay_driver/features/firebase_service/ride/data/model/ride_booking_model.dart';
import 'package:rider_pay_driver/features/firebase_service/ride/notifer/ride_notifer.dart';
import 'package:rider_pay_driver/features/map/presentation/booking_details/widget/booking_card_widget.dart';
import 'package:rider_pay_driver/features/map/presentation/notifier/profile_notifier.dart';
import 'package:rider_pay_driver/main.dart';
import 'package:rider_pay_driver/share_pref/user_provider.dart';
import 'package:vibration/vibration.dart';

class MapBookingDetailsOverlay extends ConsumerStatefulWidget {
  final List<RideBookingModel> rides;
  final String driverId;

  const MapBookingDetailsOverlay({
    super.key,
    required this.rides,
    required this.driverId,
  });

  @override
  ConsumerState<MapBookingDetailsOverlay> createState() => _MapBookingDetailsOverlayState();
}

class _MapBookingDetailsOverlayState extends ConsumerState<MapBookingDetailsOverlay>   with WidgetsBindingObserver {
  int _selectedIndex = 0;
  bool _hasPlayedSound = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      WidgetsBinding.instance.addObserver(this);

      if (_shouldPlaySoundOnInit() && !_hasPlayedSound) {
        SoundVibrationService.startRingtone();
        _hasPlayedSound = true;
        debugPrint("🎵 Initial pending ride detected — playing ringtone");
      } else {
        SoundVibrationService.stopRingtone();
        debugPrint("✅ No pending ride at init — no sound");
      }
    });
  }

  bool _shouldPlaySoundOnInit() {
    if (widget.rides.isEmpty) return false;

    for (var ride in widget.rides) {
      final List<dynamic> requestedDrivers = ride.requestedDrivers ?? [];

      final alreadyRequested = requestedDrivers.any((d) {
        if (d is Map<String, dynamic>) {
          return d['id']?.toString() == widget.driverId.toString();
        }
        return false;
      });

      if (alreadyRequested) {
        debugPrint("🚫 Driver already in requestedDrivers for ride ${ride.rideId} — skip sound");
        continue;
      }

      final isPending = (ride.status.toLowerCase() == 'pending' &&
          (ride.acceptedByDriver == false || ride.driverId.isEmpty));

      if (isPending) {
        debugPrint("🎵 Pending ride found (no request yet) — can play sound");
        return true;
      }
    }

    return false;
  }
  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.paused ||
        state == AppLifecycleState.detached ||
        state == AppLifecycleState.inactive) {
      SoundVibrationService.stopRingtone();
      _hasPlayedSound = false;
      debugPrint("🔕 App backgrounded → sound stopped");
    }
  }
  @override
  void didUpdateWidget(covariant MapBookingDetailsOverlay oldWidget)  {
    super.didUpdateWidget(oldWidget);
    if (widget.rides != oldWidget.rides && widget.rides.isNotEmpty) {
      setState(() {
        _selectedIndex = widget.rides.isNotEmpty ? 0 : -1;
      });
      WidgetsBinding.instance.addPostFrameCallback((_) {
        _handleNewRides(oldWidget);
      });

    }
  }
  void _handleNewRides(MapBookingDetailsOverlay oldWidget) async {
    final hasNewRide = widget.rides.isNotEmpty &&
        (oldWidget.rides.isEmpty || widget.rides.length > oldWidget.rides.length);

    final hasAcceptedRide = widget.rides.any(
          (r) => r.acceptedByDriver == true && r.driverId == widget.driverId,
    );

    // 🧠 Driver already in requestedDrivers
    final alreadyRequested = widget.rides.any((r) {
      final requested = r.requestedDrivers ?? [];
      return requested.any((d) {
        return d['id']?.toString() == widget.driverId.toString();
              return false;
      });
    });

    // 🧠 Check for pending rides
    final hasPendingRide = widget.rides.any(
          (r) =>
      r.status.toLowerCase() == 'pending' &&
          (r.acceptedByDriver == false  || r.driverId.isEmpty),
    );

    // if (hasNewRide && hasPendingRide && !_hasPlayedSound && !alreadyRequested) {
    //   SoundVibrationService.startRingtone();
    //   _hasPlayedSound = true;
    //   debugPrint("🎵 New pending ride (no driver request yet) — ringtone started");
    // }

    if (hasAcceptedRide || alreadyRequested || !hasPendingRide) {
      if (SoundVibrationService.isPlaying) {
        SoundVibrationService.stopRingtone();
        debugPrint("🔇 Sound stopped (driver requested/accepted/no pending rides)");
      }
      _hasPlayedSound = false;
    }

    debugPrint(
        "🎵 hasNewRide=$hasNewRide | hasAcceptedRide=$hasAcceptedRide | alreadyRequested=$alreadyRequested | hasPendingRide=$hasPendingRide | _hasPlayedSound=$_hasPlayedSound");
  }



  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    SoundVibrationService.stopRingtone();
    _hasPlayedSound = false;

    super.dispose();
  }
  @override
  Widget build(BuildContext context) {
    final rides = widget.rides;

    final shouldHideOverlay =
        rides.isEmpty ||
            rides.any((r) =>
            r.acceptedByDriver == true &&
                r.driverId == widget.driverId);

    if (shouldHideOverlay) {
      if (SoundVibrationService.isPlaying) {
        WidgetsBinding.instance.addPostFrameCallback((_) {
          SoundVibrationService.stopRingtone();
          _hasPlayedSound = false;
          debugPrint("🔇 Overlay hidden → sound stopped");
        });
      }
      return const SizedBox.shrink();
    }

    final notifier = ref.read(driverRideNotifierProvider.notifier);

    final rideMap = (_selectedIndex >= 0 && _selectedIndex < rides.length)
        ? _convertRideToMap(rides[_selectedIndex])
        : null;

    return SafeArea(
      child: Container(
        height: screenHeight,
        width: screenWidth,
        color: context.greyLightest,
        child: Column(
          children: [
            CommonTopBar(
              child: ConstText(
                text: "${rides.length} Order${rides.length > 1 ? 's' : ''}",
              ),
            ),
            Expanded(
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    width: 70.w,
                    color: context.greyLight,
                    child: ListView.builder(
                      itemCount: rides.length,
                      itemBuilder: (context, index) {
                        final ride = rides[index];
                        final isActive = _selectedIndex == index;
                        final status = ride.status;
                        return GestureDetector(
                          onTap: () {
                            if (index < rides.length) {
                              setState(() => _selectedIndex = index);
                            }
                          },
                          child: _buildSidebarIcon(status, isActive),
                        );
                      },
                    ),
                  ),

                  // Main ride details card
                  Expanded(
                    child: Padding(
                      padding: EdgeInsets.only(top: 10.h),
                      child: rideMap != null
                          ? BookingCardUI(
                        order: rideMap,
                        onAccept: () async {
                          SoundVibrationService.stopRingtone();
                          _hasPlayedSound=false;

                          final profileN = ref.read(
                            profileProvider.notifier,
                          );
                          final userId = ref
                              .read(userProvider.notifier)
                              .userId
                              .toString();
                          final selectedRide = rides[_selectedIndex];
                          final rideId = selectedRide.rideId;
                          await notifier.sendRideRequestToUser(
                            rideId: rideId,
                            driverId: userId,
                            name: profileN.name,
                            mobile: profileN.phone,
                            img: profileN.img,
                            vehicleName: profileN.vehicleName,
                          );

                        },
                        onReject: () async {
                          final userId = ref.read(userProvider.notifier).userId.toString();
                          final selectedRide = rides[_selectedIndex];
                          final rideId = selectedRide.rideId;
                          notifier.rejectRide(rideId, userId);
                          SoundVibrationService.stopRingtone();
                          _hasPlayedSound=false;


                        },
                        onClear: () {
                          final userId = ref.read(userProvider.notifier).userId.toString();
                          final selectedRide = rides[_selectedIndex];
                          final rideId = selectedRide.rideId;
                          notifier.rejectRide(rideId, userId);
                          SoundVibrationService.stopRingtone();
                          _hasPlayedSound=false;


                        },
                      )
                          : const SizedBox.shrink(),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  /// Helper: convert RideBookingModel → map for BookingCardUI
  Map<String, dynamic> _convertRideToMap(RideBookingModel ride) {
    final userId = ref.read(userProvider.notifier).userId.toString();
    final requestedDrivers = ride.requestedDrivers ?? [];
    String acceptTitle = "Accept";
    final bool hasRequested = requestedDrivers.any(
          (d) => d['id'].toString() == userId.toString(),
    );

    if (hasRequested) {
      acceptTitle = "Waiting for Approval";
    }

    return {
      "status": ride.status,
      "title": "Ride Request",
      "pickupDistance":
      "${ride.distanceBtDriverAndPickupKm?.toStringAsFixed(1) ?? 0} Km",
      "pickupAddress": ride.pickupLocation["address"] ?? "Unknown pickup",
      "dropDistance": "${ride.distanceKm.toStringAsFixed(1)} Km",
      "dropAddress": ride.dropLocation["address"] ?? "Unknown drop",
      "acceptTitle": acceptTitle,
    };
  }

  /// Helper: sidebar icon builder

  Widget _buildSidebarIcon(String status, bool isActive) {
    final isMissed = status == 'missed';
    final isWaiting = status == 'waiting_for_user_approval';

    Color color;
    String label;

    if (isMissed) {
      color = Colors.red.shade700;
      label = "Missed";
    } else if (isWaiting) {
      color = Colors.blue.shade700;
      label = "Waiting";
    } else {
      color = isActive ? Colors.green : Colors.grey.shade400;
      label = "Ride";
    }

    return Container(
      height: 70,
      alignment: Alignment.center,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: const BorderRadius.only(
          topRight: Radius.circular(8),
          bottomRight: Radius.circular(8),
        ),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            isMissed ? Icons.error_outline : Icons.two_wheeler,
            color: color,
            size: 26,
          ),
          const SizedBox(height: 2),
          ConstText(text: label, color: color,),
        ],
      ),
    );
  }
}

class SoundVibrationService {
  static final AudioPlayer _player = AudioPlayer();
  static bool _isPlaying = false;
  static Timer? _vibrationTimer;

  static Future<void> startRingtone() async {
    if (_isPlaying) return;

    try {
      await _player.setAsset('assets/sound/booking_sound.mp3');
      await _player.setLoopMode(LoopMode.all);
      await _player.play();
      _isPlaying = true;

    } catch (e) {
      print('Error playing ringtone: $e');
    }
  }

  static void _startVibration() async {
    if (await Vibration.hasVibrator() ?? false) {
      // ✅ Option 1: Simple vibration (reliable)
      _vibrationTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
        if (!_isPlaying) {
          timer.cancel();
          return;
        }
        Vibration.vibrate(duration: 500);
      });


    } else {
      // Fallback: Flutter's HapticFeedback
      _vibrationTimer = Timer.periodic(const Duration(seconds: 2), (timer) {
        if (!_isPlaying) {
          timer.cancel();
          return;
        }
        HapticFeedback.mediumImpact();
      });
    }
  }

  static Future<void> stopRingtone() async {
    try {
      await _player.stop();
      _isPlaying = false;
      _vibrationTimer?.cancel();
      _vibrationTimer = null;
      if (await Vibration.hasVibrator() ) {
        Vibration.cancel();
      }
      print("✅ Booking sound + vibration stopped");
    } catch (e) {
      print('Error stopping ringtone: $e');
    }
  }
  static bool get isPlaying => _isPlaying;
}








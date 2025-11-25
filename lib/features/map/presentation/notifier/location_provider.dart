import 'dart:async';
import 'package:flutter_riverpod/legacy.dart';
import 'package:geolocator/geolocator.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

final locationProvider =
StateNotifierProvider<LocationNotifier, LocationState>((ref) {
  return LocationNotifier();
});

class LocationState {
  final bool isServiceOn;
  final bool isPermissionGranted;
  final bool isFetching;
  final Position? currentPosition;

  bool get isReady => isServiceOn && isPermissionGranted && currentPosition != null;

  const LocationState({
    this.isServiceOn = false,
    this.isPermissionGranted = false,
    this.isFetching = false,
    this.currentPosition,
  });

  LocationState copyWith({
    bool? isServiceOn,
    bool? isPermissionGranted,
    bool? isFetching,
    Position? currentPosition,
  }) {
    return LocationState(
      isServiceOn: isServiceOn ?? this.isServiceOn,
      isPermissionGranted: isPermissionGranted ?? this.isPermissionGranted,
      isFetching: isFetching ?? this.isFetching,
      currentPosition: currentPosition ?? this.currentPosition,
    );
  }
}

class LocationNotifier extends StateNotifier<LocationState> {
  LocationNotifier() : super(const LocationState());

  StreamSubscription<Position>? _positionSub;
  Timer? _driverUpdateTimer;

  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<void> initLocation() async {
    final serviceEnabled = await Geolocator.isLocationServiceEnabled();
    state = state.copyWith(isServiceOn: serviceEnabled);

    if (!serviceEnabled) {
      print("Location service is OFF — opening settings...");
      await Geolocator.openLocationSettings();
      return;
    }

    var permission = await Permission.location.status;
    if (permission.isDenied) {
      permission = await Permission.location.request();
    }

    if (permission.isPermanentlyDenied) {
      print(" Permission permanently denied — opening app settings...");
      await openAppSettings();
      return;
    }

    final granted = permission.isGranted;
    state = state.copyWith(isPermissionGranted: granted);

    if (!granted) {
      print("❌ Location permission not granted");
      return;
    }

    await fetchCurrentPosition();
  }

  Future<void> fetchCurrentPosition() async {
    final serviceEnabled = await Geolocator.isLocationServiceEnabled();
    var permission = await Permission.location.status;

    if (!serviceEnabled) {
      print("Location service OFF — can't fetch location");
      await Geolocator.openLocationSettings();
      return;
    }

    if (!permission.isGranted) {
      print("Permission not granted — requesting...");
      permission = await Permission.location.request();
      if (!permission.isGranted) {
        print("❌ Still no permission — aborting location fetch");
        return;
      }
    }

    try {
      state = state.copyWith(isFetching: true);
      final pos = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.best,
      );
      state = state.copyWith(currentPosition: pos, isFetching: false);
      print("📍 Current position: ${pos.latitude}, ${pos.longitude}");
    } catch (e) {
      state = state.copyWith(isFetching: false);
      print("❌ Location fetch failed: $e");
    }
  }


  // Future<void> startLiveRideTracking(String rideId) async {
  //   await initLocation();
  //
  //   if (!state.isReady) {
  //     print("⚠️ Location not ready — skipping live tracking");
  //     return;
  //   }
  //
  //   print("🚗 Starting live ride tracking for $rideId");
  //   _positionSub?.cancel();
  //   _positionSub = Geolocator.getPositionStream(
  //     locationSettings: const LocationSettings(
  //       accuracy: LocationAccuracy.best,
  //       distanceFilter: 5,
  //     ),
  //   ).listen((pos) async {
  //     state = state.copyWith(currentPosition: pos);
  //     try {
  //       await _firestore.collection('rides').doc(rideId).update({
  //         'driverDetails.location': {
  //           'latitude': pos.latitude,
  //           'longitude': pos.longitude,
  //           'updatedAt': DateTime.now().toIso8601String(),
  //         },
  //       });
  //       state = state.copyWith(currentPosition: pos, isFetching: false);
  //       print("📍 Updated Firestore: ${pos.latitude}, ${pos.longitude}");
  //     } catch (e) {
  //       print("❌ Firestore update failed: $e");
  //     }
  //   });
  // }
  //
  // Future<void> stopLiveRideTracking() async {
  //   await _positionSub?.cancel();
  //   _positionSub = null;
  //   print("🛑 Live ride tracking stopped.");
  //
  // }

  ///update driver table location update

  Future<void> startDriverOnlineUpdates(String driverId) async {
    await initLocation();
    if (!state.isReady) {
      print("⚠️ Location not ready — skipping driver updates");
      return;
    }
    print("🟢 Starting driver online updates for driverId: $driverId");
    _driverUpdateTimer?.cancel();
    _driverUpdateTimer = Timer.periodic(const Duration(seconds: 15), (_) async {
      try {
        final pos = await Geolocator.getCurrentPosition(
          locationSettings: const LocationSettings(
            accuracy: LocationAccuracy.bestForNavigation,
          ),
        );

        state = state.copyWith(currentPosition: pos, isFetching: false);
        final now = DateTime.now();

        await _firestore.collection("drivers").doc(driverId).update({
          "location": {
            "latitude": pos.latitude,
            "longitude": pos.longitude,
          },
          // "last_active": now.toIso8601String(),
        });


        print(
          "📍 Driver location updated @ ${now.toIso8601String()} → "
              "${pos.latitude}, ${pos.longitude}",
        );
      } catch (e) {
        print("❌ Firestore driver update failed: $e");
      }
    });
  }
// ⛔ Stop updates when driver goes Offline
  Future<void> stopDriverOnlineUpdates() async {
    if (_driverUpdateTimer != null) {
      _driverUpdateTimer?.cancel();
      _driverUpdateTimer = null;
      print("🔴 Driver went OFFLINE → stopped location updates.");
    }
  }


  Future<void> openSettings() async => await openAppSettings();

  Future<void> enableService() async => await Geolocator.openLocationSettings();
}

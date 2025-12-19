import 'dart:async';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/legacy.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:rider_pay_driver/features/firebase_service/ride/data/model/ride_booking_model.dart';
import 'package:rider_pay_driver/features/firebase_service/ride/data/repo_impl/ride_repo_impl.dart';
import 'package:rider_pay_driver/features/firebase_service/ride/domain/ride_repo.dart';
import 'package:rider_pay_driver/features/map/presentation/notifier/location_provider.dart';
import 'package:rider_pay_driver/features/map/presentation/notifier/map_controller.dart';
import 'package:rider_pay_driver/features/map/presentation/notifier/profile_notifier.dart';

class DriverRideState {
  final bool isLoading;
  final List<RideBookingModel> rides;

  final bool isStreaming;

  DriverRideState({
    required this.isLoading,
    required this.rides,
    required this.isStreaming,

  });

  factory DriverRideState.initial() =>
      DriverRideState(isLoading: false, rides: [], isStreaming: false);

  DriverRideState copyWith({
    bool? isLoading,
    List<RideBookingModel>? rides,
    RideBookingModel? activeRide,
    bool? isStreaming,
  }) {
    return DriverRideState(
      isLoading: isLoading ?? this.isLoading,
      rides: rides ?? this.rides,
      isStreaming: isStreaming ?? this.isStreaming,
    );
  }
}

class DriverRideNotifier extends StateNotifier<DriverRideState> {
  final DriverRideRepo _repo;
  final Ref ref;
  StreamSubscription<List<RideBookingModel>>? _allRidesSub;
  String? _currentTrackingRideId;
  DriverRideNotifier(this._repo,this.ref) : super(DriverRideState.initial());

  Future<void> startAllRidesStream(String driverId) async {
    
    final  vehicleId= ref.read(profileProvider.notifier).vehicleId;

    _allRidesSub?.cancel();
    // _singleRideSub?.cancel();
    state = state.copyWith(isStreaming: true, activeRide: null);
    _allRidesSub = _repo.listenAllRides(driverId,vehicleId).listen((rides) async {
      state = state.copyWith(rides: rides);
      final acceptedRides = rides
          .where((ride) => ride.acceptedByDriver == true &&
                ride.driverId == driverId &&
                ride.status != 'completed' &&
                ride.status != 'pending' &&
                ride.status != 'canceled',)
          .toList();
      final RideBookingModel? acceptedRide = acceptedRides.isNotEmpty
          ? acceptedRides.first
          : null;
      // final locationNotifier = ref.read(locationProvider.notifier);

      if (acceptedRide != null) {
        if (_currentTrackingRideId != acceptedRide.rideId) {
          print("🚗 Starting tracking for ride ${acceptedRide.rideId}");
          _currentTrackingRideId = acceptedRide.rideId;
          // await locationNotifier.startLiveRideTracking(acceptedRide.rideId);
        }
      } else {
        if (_currentTrackingRideId != null) {
          print("🛑 Stopping live tracking (no active ride)");
          _currentTrackingRideId = null;
          // await locationNotifier.stopLiveRideTracking();
        }
      }


    });
  }

  Future<void> updateRide(String rideId, Map<String, dynamic> data) async {
    try {
      await _repo.updateRideFields(rideId, data);
      print("✅ Ride $rideId updated with $data");
    } catch (e) {
      print("❌ updateRide error: $e");
    }
  }

  Future<void> updateRideField(String rideId, String key, dynamic value) async {
    await updateRide(rideId, {key: value});
  }

  /// Stop listening to Firebase stream
  void stopStream() {
    _allRidesSub?.cancel();
    state = state.copyWith(isStreaming: false, rides: []);
     // ref.read(locationProvider.notifier).stopLiveRideTracking();

  }

  Future<void> sendRideRequestToUser({
    required String rideId,
    required String driverId,
    required String name,
    required String mobile,
    required String img,
    required String vehicleName

  }) async
  {
    await _repo.sendRideRequestToUser(
      rideId: rideId,
      driverId: driverId,
      name: name,
      mobile: mobile,
      img: img,
      vehicleName: vehicleName
    );
  }


  Future<void> restoreActiveRideRoute(MapController mapCtrl) async {
    print("🚀 restoreActiveRideRoute() called — checking for active ride...");

    try {
      // STEP 1️⃣ — Find Active Ride
      RideBookingModel? activeRide;
      try {
        activeRide = state.rides.firstWhere(
              (r) =>
          r.acceptedByDriver == true &&
              (r.status.toLowerCase() != 'completed' &&
                  r.status.toLowerCase() != 'canceled' &&
                  r.status.toLowerCase() != 'pending'),
        );
        print("✅ Active ride found: ${activeRide.rideId}");
      } catch (_) {
        activeRide = null;
        print("🚫 No active ride found in list");
      }

      if (activeRide == null) {
        print("❌ No ride qualifies for polyline restore.");
        return;
      }

      print("🟢 Ride status: ${activeRide.status}, statusText: ${activeRide.statusText}");
      print("👤 Driver ID: ${activeRide.driverId}");
      print("📍 Requested Drivers: ${activeRide.requestedDrivers?.length ?? 0}");

      // STEP 2️⃣ — Find Driver’s last location
      final requestedDrivers = activeRide.requestedDrivers ?? [];
      Map<String, dynamic>? driverLoc;

      if (requestedDrivers.isNotEmpty) {
        driverLoc = requestedDrivers.firstWhere(
              (d) =>
          d["id"].toString() == activeRide?.driverId.toString() ||
              (activeRide?.driverId.isEmpty ?? true),
          orElse: () {
            print("⚠️ Driver not found in requestedDrivers list! Using first driver instead.");
            return requestedDrivers.first;
          },
        );
      }

      if (driverLoc == null || driverLoc.isEmpty) {
        print("⚠️ Driver location not found in requestedDrivers list.");
        return;
      }

      print("📍 DriverLoc raw: $driverLoc");

      final driverLat = driverLoc["location"]?["latitude"];
      final driverLng = driverLoc["location"]?["longitude"];

      print("🧭 DriverLat: $driverLat, DriverLng: $driverLng");

      if (driverLat == null || driverLng == null) {
        print("⚠️ Driver latitude/longitude missing in driverLoc.");
        return;
      }

      // STEP 3️⃣ — Prepare to draw
      print("🧹 Clearing old polylines...");
      mapCtrl.clearPolylines();

      final status = activeRide.statusText?.toLowerCase();
      print("🧩 Status Text for polyline check: $status");

      if (status == "started" || status == "arrived_pickup") {
        print("🗺️ Drawing route: driver → pickup");
        await mapCtrl.drawRoute(
          LatLng(driverLat, driverLng),
          LatLng(activeRide.pickupLocation["lat"], activeRide.pickupLocation["lng"]),
        );
        print("✅ Route driver → pickup drawn successfully!");
      } else if (status?.contains("otp") == true || status?.contains("verified") == true || status == "arrived_drop") {
        print("🗺️ Drawing route: driver → drop");
        await mapCtrl.drawRoute(
          LatLng(driverLat, driverLng),
          LatLng(activeRide.dropLocation["lat"], activeRide.dropLocation["lng"]),
        );
        print("✅ Route driver → drop drawn successfully!");
      } else {
        print("ℹ️ Ride status '${activeRide.status}' — no route to restore for this statusText '$status'.");
      }
    } catch (e, st) {
      print("❌ restoreActiveRideRoute() crashed: $e");
      print("📄 Stacktrace:\n$st");
    }
  }

  Future<void> rejectRide(String rideId, String driverId) async {
    await _repo.rejectRide(rideId, driverId);
  }



  // Future<void> updateDriverStatus(
  //     String driverId,
  //     String status)
  // async
  // {
  //   try {
  //     print("🚗 Updating driver $driverId status to '$status' for ride",);
  //     await _repo.updateDriverStatus(driverId, status);
  //     print("✅ Driver $driverId status updated to '$status'");
  //
  //   } catch (e) {
  //     print("$e");
  //   }
  // }

  @override
  void dispose() {
    _allRidesSub?.cancel();
    // _singleRideSub?.cancel();
    super.dispose();
  }
}

final driverRideRepoProvider = Provider<DriverRideRepo>(
  (ref) => DriverRideRepoImpl(),
);

final driverRideNotifierProvider = StateNotifierProvider<DriverRideNotifier, DriverRideState>((ref) {
  final repo = ref.read(driverRideRepoProvider);
  return DriverRideNotifier(repo, ref);
});

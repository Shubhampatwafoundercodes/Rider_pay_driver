import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/legacy.dart' show StateNotifierProvider, StateNotifier;
import 'package:rider_pay_driver/core/helper/network/network_api_service_dio.dart';
import 'package:rider_pay_driver/features/firebase_service/ride/notifer/ride_notifer.dart';
import 'package:rider_pay_driver/features/map/data/repo_impl/driver_on_of_repo_impl.dart';
import 'package:rider_pay_driver/features/map/domain/repo/driver_online_of_repo.dart';
import 'package:rider_pay_driver/features/map/presentation/notifier/location_provider.dart';
import 'package:rider_pay_driver/features/map/presentation/notifier/profile_notifier.dart' show profileProvider;
import 'package:rider_pay_driver/share_pref/user_provider.dart';

/// 🔹 STATE CLASS
class DriverOnOfState {
  final bool isLoading;
  DriverOnOfState({
    required this.isLoading,
  });

  factory DriverOnOfState.initial() => DriverOnOfState(
    isLoading: false,
  );

  DriverOnOfState copyWith({
    bool? isLoading,
    bool? isOnline,
  }) {
    return DriverOnOfState(
      isLoading: isLoading ?? this.isLoading,
    );
  }
}

/// 🔹 PROVIDER
final driverOnOffNotifierProvider =
StateNotifierProvider<DriverOnOffNotifier, DriverOnOfState>((ref) {
  final repo = DriverOnOfRepoImpl(NetworkApiServicesDio(ref));
  return DriverOnOffNotifier(repo,ref);
});

/// 🔹 NOTIFIER CLASS
class DriverOnOffNotifier extends StateNotifier<DriverOnOfState> {
  final DriverOnlineOfRepo repo;
  final Ref ref;
  DriverOnOffNotifier(this.repo, this.ref) : super(DriverOnOfState.initial());


  void setInitialOnlineState(bool value) {
    state = state.copyWith(isOnline: value);
  }

  Future<bool> toggleOnlineStatus() async {
    if (state.isLoading) return false;
    state = state.copyWith(isLoading: true);
    final rideNotifier = ref.read(driverRideNotifierProvider.notifier);
    final profileNotifier = ref.read(profileProvider.notifier);
    final locationNotifier = ref.read(locationProvider.notifier);

    final currentAvailability=profileNotifier.availability;
    final newStatus = currentAvailability == "Offline" ? "Online" : "Offline";
    final userId = ref.read(userProvider)?.id ?? 0;
    try {
      final driverL = ref.read(locationProvider).currentPosition;
      Map<String, dynamic> data = {
        "driverId": userId,
        "availability": newStatus,
        "latitude": driverL?.latitude ?? 0,
        "longitude": driverL?.longitude ?? 0,
      };
      print("onOf data $data");
      final res = await repo.driverOnlineOfRepo(data);
      if (res["code"] == 200) {
        await profileNotifier.getProfile();
        final currentA=profileNotifier.availability;
        WidgetsBinding.instance.addPostFrameCallback((_) {
          if (currentA=="Online") {
            rideNotifier.startAllRidesStream(userId.toString());
             locationNotifier.startDriverOnlineUpdates(userId.toString());

          } else {
            rideNotifier.stopStream();
             locationNotifier.stopDriverOnlineUpdates();


          }
        });
        state = state.copyWith(isLoading: false);

        return true;
      } else {
        state = state.copyWith(isLoading: false);
        return false;
      }
    } catch (e) {
      print("❌ Error updating status: $e");
      state = state.copyWith(isLoading: false);
      return false;
    }
  }

  Future<void> forceOfflineOnLogout() async {
    try {
      final profileNotifier = ref.read(profileProvider.notifier);
      final locationNotifier = ref.read(locationProvider.notifier);
      final rideNotifier = ref.read(driverRideNotifierProvider.notifier);

      final userId = ref.read(userProvider)?.id;
      if (userId == null) return;

      final driverL = ref.read(locationProvider).currentPosition;

      Map<String, dynamic> data = {
        "driverId": userId,
        "availability": "Offline",  // 🔥 Force Offline
        "latitude": driverL?.latitude ?? 0,
        "longitude": driverL?.longitude ?? 0,
      };

      print("Force Offline Data: $data");

      await repo.driverOnlineOfRepo(data);

      // Stop all streams
      rideNotifier.stopStream();
      locationNotifier.stopDriverOnlineUpdates();

      // Update locally
      WidgetsBinding.instance.addPostFrameCallback((_) {
        profileNotifier.getProfile();
      });

    } catch (e) {
      print("❌ Error force offline on logout: $e");
    }
  }

}

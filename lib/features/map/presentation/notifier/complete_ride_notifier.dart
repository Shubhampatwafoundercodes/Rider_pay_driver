import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/legacy.dart'
    show StateNotifierProvider, StateNotifier;
import 'package:rider_pay_driver/core/helper/network/network_api_service_dio.dart';
import 'package:rider_pay_driver/features/firebase_service/ride/notifer/ride_notifer.dart';
import 'package:rider_pay_driver/features/map/data/repo_impl/complete_ride_repo_impl.dart';
import 'package:rider_pay_driver/features/map/domain/repo/complete_ride_repo.dart';
import 'package:rider_pay_driver/features/map/data/model/get_driver_earning_model.dart';
import 'package:rider_pay_driver/share_pref/user_provider.dart';

/// 🔹 STATE CLASS
class CompleteRideState {
  final bool isCompletingRide;
  final bool isFetchingEarning;
  final GetDriverEarningsModel? earnings;

  const CompleteRideState({
    required this.isCompletingRide,
    required this.isFetchingEarning,
    this.earnings,
  });

  factory CompleteRideState.initial() => const CompleteRideState(
    isCompletingRide: false,
    isFetchingEarning: false,
    earnings: null,
  );

  CompleteRideState copyWith({
    bool? isCompletingRide,
    bool? isFetchingEarning,
    GetDriverEarningsModel? earnings,
  }) {
    return CompleteRideState(
      isCompletingRide: isCompletingRide ?? this.isCompletingRide,
      isFetchingEarning: isFetchingEarning ?? this.isFetchingEarning,
      earnings: earnings ?? this.earnings,
    );
  }
}

/// 🔹 PROVIDER
final completeRideProvider =
    StateNotifierProvider<CompleteRideNotifier, CompleteRideState>((ref) {
      final repo = CompleteRideRepoImpl(NetworkApiServicesDio(ref));
      return CompleteRideNotifier(repo, ref);
    });

/// 🔹 NOTIFIER CLASS
class CompleteRideNotifier extends StateNotifier<CompleteRideState> {
  final CompleteRideRepo repo;
  final Ref _ref;

  CompleteRideNotifier(this.repo, this._ref)
    : super(CompleteRideState.initial());

  /// 🚘 COMPLETE RIDE API
  Future<bool> completeRideApi(String rideId) async {
    if (state.isCompletingRide) return false;
    state = state.copyWith(isCompletingRide: true);

    final driverId = _ref.read(userProvider.notifier).userId;
    try {
      final res = await repo.completeRideApi(rideId, driverId.toString());
      print("✅ Complete ride API response: $res");
      state = state.copyWith(isCompletingRide: false);
      if (res["code"] == 200) {
        _ref.read(driverRideRepoProvider).updateDriverStatus(driverId.toString(), "Online");
        getDriverEarningApi(driverId.toString());
        return true;
      } else {
        return false;
      }
    } catch (e) {
      print("❌ Error completing ride: $e");
      state = state.copyWith(isCompletingRide: false);
      return false;
    }
  }

  /// 💰 GET DRIVER EARNING API
  Future<bool> getDriverEarningApi(String driverId) async {
    if (state.isFetchingEarning) return false;
    state = state.copyWith(isFetchingEarning: true, earnings: null);

    try {
      print("💸 Fetching driver earnings...");
      final res = await repo.getDriverEarningApi(driverId);
      if (res.code == 200) {
        state = state.copyWith(isFetchingEarning: false, earnings: res);
        print("✅ Earnings fetched: ${res.data?.todayEarning}");
        return true;
      } else {
        state = state.copyWith(isFetchingEarning: false);
        return false;
      }
    } catch (e) {
      print("❌ Error fetching earnings: $e");
      state = state.copyWith(isFetchingEarning: false);
      return false;
    }
  }
}

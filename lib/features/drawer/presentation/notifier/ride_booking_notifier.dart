import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/legacy.dart' show StateNotifier, StateNotifierProvider;
import 'package:rider_pay_driver/core/helper/network/network_api_service_dio.dart';
import 'package:rider_pay_driver/features/drawer/data/model/ride_booking_history_model.dart';
import 'package:rider_pay_driver/features/drawer/data/repo_impl/ride_booking_repo_imp.dart';
import 'package:rider_pay_driver/features/drawer/domain/repo/ride_booking_repo.dart' show RideBookingRepo;

/// 🧩 STATE CLASS
class RideBookingState {
  final bool isRideHistoryLoading;
  final RideBookingHistoryModel? bookingHistoryModelData;

  const RideBookingState({
    this.isRideHistoryLoading = false,
    this.bookingHistoryModelData,
  });

  RideBookingState copyWith({
    bool? isRideHistoryLoading,
    RideBookingHistoryModel? bookingHistoryModelData,
  }) {
    return RideBookingState(
      isRideHistoryLoading: isRideHistoryLoading ?? this.isRideHistoryLoading,
      bookingHistoryModelData:
      bookingHistoryModelData ?? this.bookingHistoryModelData,
    );
  }
}

/// 🧩 NOTIFIER — only handles ride history API
class RideBookingNotifier extends StateNotifier<RideBookingState> {
  final RideBookingRepo repo;

  RideBookingNotifier(this.repo,)
      : super(const RideBookingState());

  /// 🚗 Fetch Ride History API
  Future<void> rideHistoryApi(String userId) async {
    debugPrint("🚀 rideHistoryApi() called for userId: $userId");
    state = state.copyWith(isRideHistoryLoading: true, bookingHistoryModelData: null);

    try {
      final res = await repo.rideBookingHistoryApi(userId);
      debugPrint("📥 API RESPONSE: $res");

      if (res.code == 200) {
        debugPrint("✅ Ride history fetched successfully!");
        state = state.copyWith(
          isRideHistoryLoading: false,
          bookingHistoryModelData: res,
        );
      } else {
        debugPrint("⚠️ Ride history failed: code ${res.code}");
        state = state.copyWith(isRideHistoryLoading: false);
      }
    } catch (e, st) {
      debugPrint("❌ rideHistoryApi() ERROR: $e\n$st");
      state = state.copyWith(isRideHistoryLoading: false);
    }
  }
}



final rideBookingHistoryProvider =
StateNotifierProvider<RideBookingNotifier, RideBookingState>((ref) {
  return RideBookingNotifier(RideBookingImp(NetworkApiServicesDio(ref)));
});
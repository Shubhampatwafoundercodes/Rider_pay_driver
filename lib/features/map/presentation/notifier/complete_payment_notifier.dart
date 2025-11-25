import 'package:flutter_riverpod/legacy.dart' show StateNotifierProvider, StateNotifier;
import 'package:rider_pay_driver/core/helper/network/network_api_service_dio.dart';
import 'package:rider_pay_driver/features/map/data/repo_impl/complete_payment_repo_impl.dart';
import 'package:rider_pay_driver/features/map/domain/repo/complete_payment_repo.dart';

/// 🔹 STATE CLASS
class CompletePaymentState {
  final bool isLoading;

  CompletePaymentState({
    required this.isLoading,
  });

  factory CompletePaymentState.initial() => CompletePaymentState(
    isLoading: false,
  );

  CompletePaymentState copyWith({
    bool? isLoading,
  }) {
    return CompletePaymentState(
      isLoading: isLoading ?? this.isLoading,
    );
  }
}

/// 🔹 PROVIDER
final completePaymentProvider =
StateNotifierProvider<CompletePaymentNotifier, CompletePaymentState>((ref) {
  final repo = CompletePaymentRepoImpl(NetworkApiServicesDio(ref));
  return CompletePaymentNotifier(repo);
});

/// 🔹 NOTIFIER CLASS
class CompletePaymentNotifier extends StateNotifier<CompletePaymentState> {
  final CompletePaymentRepo repo;
  CompletePaymentNotifier(this.repo) : super(CompletePaymentState.initial());

  Future<bool> completePaymentApi(String rideId,String finalFare) async {
    if (state.isLoading) return false;
    state = state.copyWith(isLoading: true);
    Map<String,dynamic>data={
      "ride_id": rideId, // Ride ID (string) - required
      "payment_method": "Cash", // Options: "Cash", "Wallet", "UPI", "Card"
      "payment_status": "Paid",
      "final_fare":finalFare,

    };
    try {
      final res = await repo.completePaymentApi(data);
      print("hdhehdhehjd $res");
      if (res["code"] == 200) {
        state = state.copyWith(isLoading: false,);
        return true;
      } else {
        state = state.copyWith(isLoading: false);
        return false;
      }
    } catch (e) {
      print("❌ Error completing payment: $e");
      state = state.copyWith(isLoading: false);
      return false;
    }
  }
}

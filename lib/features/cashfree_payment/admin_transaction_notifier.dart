import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/legacy.dart';
import 'package:rider_pay_driver/core/helper/network/network_api_service_dio.dart';
import 'package:rider_pay_driver/core/utils/utils.dart';
import 'package:rider_pay_driver/features/cashfree_payment/data/model/admin_transaction_model.dart';
import 'package:rider_pay_driver/features/cashfree_payment/data/repo_impl/admin_transation_repo_impl.dart';
import 'package:rider_pay_driver/features/cashfree_payment/domain/repo/admin_tra_history_repo.dart';


/// ✅ State class
class AdminTransactionState {
  final bool isLoading;
  final AdminTransactionModel? history;

  const AdminTransactionState({
    this.isLoading = false,
    this.history,
  });

  AdminTransactionState copyWith({
    bool? isLoading,
    AdminTransactionModel? history,
  }) {
    return AdminTransactionState(
      isLoading: isLoading ?? this.isLoading,
      history: history ?? this.history,
    );
  }
}

/// ✅ Notifier
class AdminTransactionNotifier extends StateNotifier<AdminTransactionState> {
  final AdminTraHistoryRepo repo;

  AdminTransactionNotifier(this.repo)
      : super(const AdminTransactionState());

  /// Fetch withdraw history
  Future<void> adminTransactionApi(String userId) async {
    state = state.copyWith(isLoading: true);
    print("📡 Calling Admin Transaction API for userId: $userId");

    try {
      final data = await repo.adminTransactionApi(userId);
      print("✅ Admin Transaction API success, data: ${data.toString()}");
      if(data.code==200){
        state = state.copyWith(isLoading: false, history: data);

      }else{

        state = state.copyWith(isLoading: false, history: null);


      }

    } catch (e,stack) {
      print("❌ Admin Transaction API error: $e");
      debugPrintStack(label: "STACK TRACE", stackTrace: stack);
      toastMsg("Error loading Admin Transaction Api");
      debugPrint("Error loading Admin Transaction Api $e");
      state = state.copyWith(isLoading: false, );
    }
  }

  /// Clear state (optional)
  void clearState() {
    state = const AdminTransactionState();
  }
}

final adminTransactionProvider = StateNotifierProvider<
    AdminTransactionNotifier, AdminTransactionState>((ref) {
  return AdminTransactionNotifier(AdminTransactionRepoImpl(NetworkApiServicesDio(ref)),
  );
});

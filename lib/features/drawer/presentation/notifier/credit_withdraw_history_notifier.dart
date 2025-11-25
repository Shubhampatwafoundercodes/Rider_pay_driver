import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/legacy.dart';
import 'package:rider_pay_driver/core/helper/network/network_api_service_dio.dart';
import 'package:rider_pay_driver/core/utils/utils.dart';
import 'package:rider_pay_driver/features/drawer/data/model/credit_withdraw_history_model.dart';
import 'package:rider_pay_driver/features/drawer/data/repo_impl/credit_withdraw_history_repo_Impl.dart' show CreditWithdrawHistoryRepoImpl;
import 'package:rider_pay_driver/features/drawer/domain/repo/credit_withdraw_repo.dart';

/// ✅ State class
class CreditWithdrawHistoryState {
  final bool isLoading;
  final CreditWithdrawHistoryModel? history;

  const CreditWithdrawHistoryState({
    this.isLoading = false,
    this.history,
  });

  CreditWithdrawHistoryState copyWith({
    bool? isLoading,
    CreditWithdrawHistoryModel? history,
  }) {
    return CreditWithdrawHistoryState(
      isLoading: isLoading ?? this.isLoading,
      history: history ?? this.history,
    );
  }
}

/// ✅ Notifier
class CreditWithdrawHistoryNotifier extends StateNotifier<CreditWithdrawHistoryState> {
  final CreditWithdrawHistoryRepo repo;

  CreditWithdrawHistoryNotifier(this.repo)
      : super(const CreditWithdrawHistoryState());

  /// Fetch withdraw history
  Future<void> fetchCreditWithdrawHistory(String userId) async {
    state = state.copyWith(isLoading: true);
    try {
      final data = await repo.creditWithdrawHistoryApi(userId);
      if(data.code==200){
        state = state.copyWith(isLoading: false, history: data);

      }else{

        state = state.copyWith(isLoading: false, history: null);

      }
    } catch (e) {
      toastMsg("Error loading withdraw history");
      state = state.copyWith(isLoading: false, );
    }
  }

  /// Clear state (optional)
  void clearState() {
    state = const CreditWithdrawHistoryState();
  }
}

/// ✅ Provider
final creditWithdrawHistoryProvider = StateNotifierProvider<
    CreditWithdrawHistoryNotifier, CreditWithdrawHistoryState>((ref) {
  return CreditWithdrawHistoryNotifier(
    CreditWithdrawHistoryRepoImpl(NetworkApiServicesDio(ref)),
  );
});

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/legacy.dart';
import 'package:rider_pay_driver/core/helper/network/network_api_service_dio.dart';
import 'package:rider_pay_driver/core/utils/utils.dart';
import 'package:rider_pay_driver/features/drawer/data/model/get_bank_details_model.dart';
import 'package:rider_pay_driver/features/drawer/data/repo_impl/bank_details_repo_impl.dart';
import 'package:rider_pay_driver/features/drawer/domain/repo/bank_details_repo.dart';

// ✅ State class
class BankDetailsState {
  final bool isLoading;
  final BankDetailsModel? bankDetails;

  const BankDetailsState({
    this.isLoading = false,
    this.bankDetails,
  });

  BankDetailsState copyWith({
    bool? isLoading,
    dynamic bankDetails,
  }) {
    return BankDetailsState(
      isLoading: isLoading ?? this.isLoading,
      bankDetails: bankDetails ?? this.bankDetails,
    );
  }
}

// ✅ Notifier
class BankDetailsNotifier extends StateNotifier<BankDetailsState> {
  final BankDetailsRepo repo;

  BankDetailsNotifier(this.repo) : super(const BankDetailsState());

  /// Fetch bank details
  Future<void> fetchBankDetails(String userId) async {
    state = state.copyWith(isLoading: true, );
    state = state.copyWith(isLoading: false, bankDetails: null);
    try {
      final data = await repo.getBankDetailsApi(userId);
      if(data.code==200){
        state = state.copyWith(isLoading: false, bankDetails: data);

      }else{
        state = state.copyWith(isLoading: false, bankDetails: null);
      }
    } catch (e) {
      state = state.copyWith(isLoading: false,bankDetails: null);
    }
  }

  /// Add/update bank details
  Future<void> addBankDetails(dynamic data,String userId) async {
    state = state.copyWith(isLoading: true,);
    try {
      final res = await repo.addBankDetailsApi(data);
      if(res["code"]==200){
         await   fetchBankDetails(userId);
         toastMsg(res["msg"]);
        state = state.copyWith(isLoading: false,);

      }else{
        state = state.copyWith(isLoading: false);

      }
    } catch (e) {
      state = state.copyWith(isLoading: false,);
    }
  }

  ///delete account api
  Future<bool> deleteAccountApi(String listId,String userId) async {
    state = state.copyWith(isLoading: true, );
    try {
      final data = await repo.deleteBankAccountApi(listId);
      if(data["code"]==200){
          await fetchBankDetails(userId);
        state = state.copyWith(isLoading: false);
        return true;

      }else{
        state = state.copyWith(isLoading: false);
        return false;

      }
    } catch (e) {
      state = state.copyWith(isLoading: false,);
      return false;

    }
  }

  Future<bool> withdrawAmount({
    required String driverId,
    required String amount,
    required String type, // "upi" or "bank"
    required String accountRefId,
  }) async {
    state = state.copyWith(isLoading: true);
    final data = {
      "driver_id": driverId,
      "amount": amount,
      "type": type,
      "account_ref_id": accountRefId,
    };
    print("reswwdw $data");

    try {
      final res = await repo.withdrawAmountApi(data);
      print("reswwdw $res");
      if (res["code"] == 200) {
        toastMsg(res["msg"] ?? "Withdrawal successful");
        state = state.copyWith(isLoading: false);
        return true;
      } else {
        toastMsg(res["msg"] ?? "Withdrawal failed");
        state = state.copyWith(isLoading: false);
        return false;
      }
    } catch (e) {
      state = state.copyWith(isLoading: false);
      return false;
    }
  }






  /// Clear state if needed
  void clearState() {
    state = const BankDetailsState();
  }
}

final bankDetailsNotifierProvider =
StateNotifierProvider<BankDetailsNotifier, BankDetailsState>((ref) {
  return BankDetailsNotifier(BankDetailsRepoImpl(NetworkApiServicesDio(ref)));
});

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/legacy.dart';
import 'package:rider_pay_driver/core/helper/network/network_api_service_dio.dart';
import 'package:rider_pay_driver/core/utils/utils.dart';
import 'package:rider_pay_driver/features/drawer/data/repo_impl/update_profile_repo_impl.dart';
import 'package:rider_pay_driver/features/drawer/domain/repo/update_profile_repo.dart';
import 'package:rider_pay_driver/features/map/presentation/notifier/profile_notifier.dart';
import 'package:rider_pay_driver/share_pref/user_provider.dart';


class UpdateProfileState {
  final bool isLoading;
  final bool isDeletingAccount;

  UpdateProfileState( {required this.isLoading, required this.isDeletingAccount,});

  factory UpdateProfileState.initial() => UpdateProfileState(isLoading: false,isDeletingAccount: false);

  UpdateProfileState copyWith({bool? isLoading,    bool? isDeletingAccount,}) =>
      UpdateProfileState(isLoading: isLoading ?? this.isLoading,isDeletingAccount: isDeletingAccount ?? this.isDeletingAccount,
      );
}

final updateProfileProvider =
StateNotifierProvider<UpdateProfileNotifier, UpdateProfileState>((ref) {
  return UpdateProfileNotifier(UpdateProfileRepoImpl(NetworkApiServicesDio(ref)), ref);
});

class UpdateProfileNotifier extends StateNotifier<UpdateProfileState> {
  final UpdateProfileRepo repo;
  final Ref ref;
  UpdateProfileNotifier(this.repo, this.ref)
      : super(UpdateProfileState.initial());

  Future<bool> updateProfile({
    required String field,
    required dynamic value,
  }) async
  {
    state = state.copyWith(isLoading: true);
    try {
      final userId= ref.read(userProvider)?.id??"0";
      final profile=ref.read(profileProvider.notifier);

      final res = await repo.updateProfile(
        driverId: userId.toString(),
        field: field,
        value: value,
      );

      if (res["code"] == 200) {
        profile.getProfile();
        toastMsg(res["msg"]);
        state = state.copyWith(isLoading: false);
        return true;
      } else {
        toastMsg(res["msg"] ?? "Update failed");
        state = state.copyWith(isLoading: false);
        return false;
      }
    } catch (e) {
      toastMsg("Error: $e");
      state = state.copyWith(isLoading: false);
      return false;
    }
  }



  Future<void> deleteAccount() async {
    state = state.copyWith(isDeletingAccount: true, );
    try {
      final userId = ref.read(userProvider)?.id;
      if (userId == null) {
        state = state.copyWith(isDeletingAccount: false,);
        return;
      }
      await repo.deleteAccountApi(userId);
      state = state.copyWith(isDeletingAccount: false,);
    } catch (e) {
      state = state.copyWith(isDeletingAccount: false,);
    }
  }

}

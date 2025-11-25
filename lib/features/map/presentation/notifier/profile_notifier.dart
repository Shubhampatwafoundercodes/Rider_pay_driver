import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/legacy.dart';
import 'package:rider_pay_driver/core/helper/network/network_api_service_dio.dart';
import 'package:rider_pay_driver/features/map/data/model/get_profile_model.dart';
import 'package:rider_pay_driver/features/map/data/repo_impl/get_profile_impl.dart';
import 'package:rider_pay_driver/features/map/domain/repo/get_profile_repo.dart';
import 'package:rider_pay_driver/share_pref/user_provider.dart';

class ProfileState {
  final bool isLoadingProfile;
  final bool isUpdatingProfile;
  final bool isDeletingAccount;
  final GetProfileModel? profile;

  ProfileState({
    this.isLoadingProfile = false,
    this.isUpdatingProfile = false,
    this.isDeletingAccount = false,
    this.profile,
  });

  ProfileState copyWith({
    bool? isLoadingProfile,
    bool? isUpdatingProfile,
    bool? isDeletingAccount,
    GetProfileModel? profile,
  }) {
    return ProfileState(
      isLoadingProfile: isLoadingProfile ?? this.isLoadingProfile,
      isUpdatingProfile: isUpdatingProfile ?? this.isUpdatingProfile,
      isDeletingAccount: isDeletingAccount ?? this.isDeletingAccount,
      profile: profile,
    );
  }

  factory ProfileState.initial() => ProfileState();
}



final profileProvider =
StateNotifierProvider<ProfileNotifier, ProfileState>((ref) {
  return ProfileNotifier(GetProfileImpl(NetworkApiServicesDio(ref)), ref);
});


class ProfileNotifier extends StateNotifier<ProfileState> {
  final GetProfileRepo _repo;
  final Ref ref;

  ProfileNotifier(this._repo, this.ref) : super(ProfileState.initial());

  /// 🔹 Get Profile

  Future<void> getProfile() async {
    state = state.copyWith(isLoadingProfile: true, profile: null);
    try {
      final userId = ref.read(userProvider)?.id;
      if (userId == null) {
        state = state.copyWith(isLoadingProfile: false);
        return;
      }
      final res = await _repo.getProfileApi(userId);
      if (res.code == 200) {
        state = state.copyWith(isLoadingProfile: false, profile: res);
      } else {
        state = state.copyWith(isLoadingProfile: false, );
      }
    } catch (e) {
      state = state.copyWith(isLoadingProfile: false, );
    }
  }


  /// 🔹 Safe getters
  String get availability => state.profile?.data?.driver?.availability ?? "Offline";
  String get img => state.profile?.data?.driver?.img ?? "";
  dynamic get wallet => state.profile?.data?.driver?.wallet ?? 0;
  String get name => state.profile?.data?.driver?.name ?? "N/A";
  String get phone => state.profile?.data?.driver?.phone?? "N/A";
  String get email => state.profile?.data?.driver?.email ?? "N/A";
  String get gender => state.profile?.data?.driver?.gender ?? "N/A";
  String get referCode => state.profile?.data?.driver?.referrId ?? "N/A";
  dynamic get adminDue => state.profile?.data?.driver?.adminDue ?? "0";
  int get vehicleId => state.profile?.data?.vehicleType?.id ?? 0;
  String get vehicleName => state.profile?.data?.vehicleType?.name ?? "car";
  String? get createdAt => (state.profile?.data?.driver?.createdAt)?.toString() ?? "0";
  List<dynamic> get allDocs => state.profile?.data?.documents ?? [];



}

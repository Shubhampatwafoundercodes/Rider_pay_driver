import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/legacy.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:rider_pay_driver/core/helper/network/network_api_service_dio.dart';
import 'package:rider_pay_driver/core/utils/utils.dart';
import 'package:rider_pay_driver/features/auth/data/repo_impl/auth_repo_impl.dart';
import 'package:rider_pay_driver/features/auth/domain/repo/auth_repo.dart';
import 'package:rider_pay_driver/features/auth/presentation/state/auth_state.dart';
import 'package:rider_pay_driver/features/firebase_service/fcm_token/fcm_token_provider.dart';
import 'package:rider_pay_driver/share_pref/user_provider.dart' show userProvider;

// final authNotifierProvider = StateNotifierProvider<AuthNotifier, AuthState>(
//       (ref) => AuthNotifier(AuthRepositoryImpl((NetworkApiServicesDio(ref))),ref));

final authNotifierProvider = StateNotifierProvider<AuthNotifier, AuthState>((ref) {
  final api = AuthRepositoryImpl(NetworkApiServicesDio(ref));
  return AuthNotifier(api, ref);
});


class AuthNotifier extends StateNotifier<AuthState> {
  final AuthRepository _repo;
  final Ref ref;

  AuthNotifier(this._repo, this.ref) : super(AuthState.initial());


  Future<int> login(String phone) async {
    state = state.copyWith(isLoading: true,  response: null);
    final fcmToken = await ref.read(fcmTokenProvider.notifier).generateFCMToken();
    print("Generated FCM Token for registration: $fcmToken");
    try {
      final res = await _repo.login(phone,fcmToken.toString());
      if (res.code == 200) {
        state = state.copyWith(isLoading: false, response: res);
        if (res.data!.isRegister == false) return 1;
        if (res.data!.id != null && res.data!.token != null) return 2;
      }
      state = state.copyWith(isLoading: false, response: null);

      return 3;
    } catch (e) {
      state = state.copyWith(isLoading: false,response: null);
      return 3;
    }
  }

  Future<void> sendOtp(String phone) async {
    print("hgvhhhhhhhhhhhhhhh $phone");
    // state = state.copyWith(isLoading: true,);
    try {
      final res = await _repo.sendOtp(phone);
      print("otppppppppp $res");
      // toastMsg(res["msg"].toString());
      // state = state.copyWith(isLoading: false);
    } catch (e) {
      // state = state.copyWith(isLoading: false, );
      debugPrint(e.toString());
    }
  }


  Future<bool> verifyOtp(String phone, String otp) async {
    state = state.copyWith(isLoading: true, error: null,);
    try {
      print("📩 Sending verifyOtp request => phone: $phone, otp: $otp");
      final res = await _repo.verifyOtp(phone, otp);
      state = state.copyWith(isLoading: false);

      final errorCode = res['error'].toString();
      if (errorCode == "200") {
        toastMsg("OTP Verified");
        print("🔍 state.response => ${state.response?.toJson()}");
        if (state.response?.data?.id != null && state.response?.data?.token != null) {
          final userId = state.response!.data!.id!;
          final token = state.response!.data!.token!;
          print("🆔 userId => $userId");
          print("🔑 token => $token");
          await ref.read(userProvider.notifier).saveUser(
            id: userId.toString(),
            token: token,
          );

          final prefs = await SharedPreferences.getInstance();
          print("📦 Saved in SharedPrefs => userId: ${prefs.getString("userID")}, token: ${prefs.getString("token")}");
        } else {
          print("User Not Register");
        }
        state = state.copyWith(isLoading: false);

        return true;
      } else {
        toastMsg(res["msg"] ?? "OTP Verification Failed");
        state = state.copyWith(isLoading: false);
        return false;
      }

    } catch (e) {
      state = state.copyWith(isLoading: false,);
      toastMsg("OTP Verification Error: $e");
      return false;
    }
  }

  Future<bool> registerApi(String city,String? refId) async {
    state = state.copyWith(isLoading: true,);
    final driverId= ref.read(userProvider.notifier).userId ??0;
    final Map<String,dynamic> data={
      "driverId":driverId.toString(),
      "refferId":refId,
      "city":city,
      // "fcmToken":fcmToken
    };
    try {
      final res = await _repo.registerApi(data);
      if (res['code'] == 200 ) {
        print("Shubham $res");
        state = state.copyWith(isLoading: false);
        return true;
      }
      return false;
    } catch (e) {
      state = state.copyWith(isLoading: false,);
      return false;
    }
  }




}

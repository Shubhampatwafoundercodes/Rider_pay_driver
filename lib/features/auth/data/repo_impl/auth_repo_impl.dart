

import 'package:rider_pay_driver/core/helper/network/base_api_service.dart';
import 'package:rider_pay_driver/core/res/api_urls.dart' show ApiUrls;
import 'package:rider_pay_driver/features/auth/data/model/auth_responce.dart';
import 'package:rider_pay_driver/features/auth/domain/repo/auth_repo.dart';

class AuthRepositoryImpl implements AuthRepository {
  final BaseApiServices api;
  AuthRepositoryImpl(this.api);

  @override
  Future<AuthResponse> login(String phone, String fcmToken) async {
    final url = ApiUrls.loginUrl;
    final body = {"phone": phone,"fcmToken":fcmToken};
    final data = await api.getPostApiResponse(url, body);
    return AuthResponse.fromJson(data);
  }

  @override
  Future<dynamic> sendOtp(String phone) async {
    final url = ApiUrls.sendOtpUrl;
    final data = await api.getGetApiResponse(url + phone);
    return data;
  }

  @override
  Future<dynamic> verifyOtp(String phone, String otp) async {
    final url = '${ApiUrls.verifyOtpUrl}$phone&otp=$otp';
    final data = await api.getGetApiResponse(url);
    return data;
  }

  @override
  Future<dynamic> registerApi(Map<String, dynamic> data) async {
    final res = await api.getPostApiResponse(ApiUrls.registerUrl, data);
    return res;
  }
}


// @override
// Future<dynamic> register(Map<String, dynamic> data) async {
//   final url = ApiUrls.registerUrl;
//
//   // normal text + image upload
//   final formData = await AppFormData.withFile(
//     fields: {
//       "name": data["name"],
//       "email": data["email"],
//       "phone": data["phone"],
//     },
//     fileKey: "profile_image",
//     filePath: data["profile_image"],
//   );
//
//   final res = await api.getFormDataApiResponse(url, formData);
//   return res;
// }
// final formData = AppFormData.fromMap({
//   "phone": phone,
//   "otp": otp,
// });
// await api.getFormDataApiResponse(ApiUrls.verifyOtpUrl, formData);

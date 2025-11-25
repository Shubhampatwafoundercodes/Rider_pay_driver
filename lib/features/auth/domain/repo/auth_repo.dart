
import 'package:rider_pay_driver/features/auth/data/model/auth_responce.dart';

abstract class AuthRepository {
  Future<AuthResponse> login(String phone,String fcmToken);
  Future<dynamic> sendOtp(String phone);
  Future<dynamic> verifyOtp(String phone, String otp);
  Future<dynamic> registerApi(Map<String, dynamic> data);
}
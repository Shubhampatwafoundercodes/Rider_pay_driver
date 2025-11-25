
// class AuthUseCases {
//   final AuthRepository repo;
//
//   AuthUseCases(this.repo);
//
//   Future<dynamic> login(String phone) async {
//     return await repo.login(phone);
//   }
//
//   Future<dynamic> sendOtp(String phone) async {
//     return await repo.sendOtp(phone);
//   }
//
//   Future<dynamic> verifyOtp(String phone, String otp) async {
//     return await repo.verifyOtp(phone, otp);
//   }
//
//   Future<dynamic> register(Map<String, dynamic> data) async {
//     return await repo.register(data);
//   }
// }
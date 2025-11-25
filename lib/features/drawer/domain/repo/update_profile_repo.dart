abstract class UpdateProfileRepo {
  Future<dynamic> updateProfile({
    required String driverId,
    required String field,
    required dynamic value,
  });


  Future<dynamic> deleteAccountApi(String userId);

}

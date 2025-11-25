import 'package:dio/dio.dart';
import 'package:rider_pay_driver/core/helper/network/api_exception.dart';
import 'package:rider_pay_driver/core/helper/network/base_api_service.dart';
import 'package:rider_pay_driver/core/res/api_urls.dart';
import 'package:rider_pay_driver/core/helper/network/app_form_data.dart';
import 'package:rider_pay_driver/features/drawer/domain/repo/update_profile_repo.dart' show UpdateProfileRepo;

class UpdateProfileRepoImpl implements UpdateProfileRepo {
  final BaseApiServices api;
  UpdateProfileRepoImpl(this.api);

  @override
  Future<dynamic> updateProfile({
    required String driverId,
    required String field,
    required dynamic value,
  }) async {
    try {
      final fields = {
        "id": driverId,
        field: value,
      };

      FormData formData;

      if (value is String && value.endsWith(".jpg") || value.endsWith(".png")) {
        formData = await AppFormData.withFile(
          fields: {"id": driverId},
          fileKey: field,
          filePath: value,
        );
      } else {
        formData = AppFormData.fromMap(fields);
      }

      final response = await api.getFormDataApiResponse(
        ApiUrls.updateProfileUrl,
        formData,
      );

      return response;
    } catch (e) {
      throw AppException("Failed to update profile: $e");
    }
  }

  @override
  Future <dynamic> deleteAccountApi(String userId) async{
    try {
      final res = await api.getGetApiResponse(ApiUrls.deleteProfile+userId);
      return res;
    } catch (e) {
      throw Exception("Failed to load deleteAccountApi: $e");
    }
  }
}

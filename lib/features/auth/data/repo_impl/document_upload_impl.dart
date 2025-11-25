import 'package:dio/dio.dart';
import 'package:rider_pay_driver/core/helper/network/api_exception.dart';
import 'package:rider_pay_driver/core/helper/network/base_api_service.dart';
import 'package:rider_pay_driver/core/res/api_urls.dart';
import 'package:rider_pay_driver/core/helper/network/app_form_data.dart';
import 'package:rider_pay_driver/features/auth/domain/repo/document_upload_repo.dart';

class DocumentUploadRepoImpl implements DocumentUploadRepo {
  final BaseApiServices api;

  DocumentUploadRepoImpl(this.api);

  @override
  Future<dynamic> uploadDocument({
    required String driverId,
    required String docType,
    required String docNumber,
    required String frontImgPath,
    String? backImgPath, // optional
  }) async {
    try {
      final fields = {
        "driver_id": driverId,
        "doc_type": docType,
        "doc_number": docNumber,
      };

      final formData = await AppFormData.withFile(
        fields: fields,
        fileKey: "front_img",
        filePath: frontImgPath,
      );

      if (backImgPath != null && backImgPath.isNotEmpty) {
        formData.files.add(
          MapEntry(
            "back_img",
            await MultipartFile.fromFile(backImgPath),
          ),
        );
      }

      final response = await api.getFormDataApiResponse(ApiUrls.driverUploadUrl, formData);

      return response;
    } catch (e) {
      throw AppException("Failed to upload document: $e");
    }
  }
}

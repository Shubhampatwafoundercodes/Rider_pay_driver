
abstract class DocumentUploadRepo {

  Future<dynamic> uploadDocument({
    required String driverId,
    required String docType,
    required String docNumber,
    required String frontImgPath,
     String? backImgPath,
  });


}
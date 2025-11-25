import 'package:rider_pay_driver/core/helper/network/api_exception.dart';
import 'package:rider_pay_driver/core/helper/network/base_api_service.dart';
import 'package:rider_pay_driver/core/res/api_urls.dart';
import 'package:rider_pay_driver/features/drawer/data/model/get_language_model.dart';
import 'package:rider_pay_driver/features/drawer/domain/repo/get_language_repo.dart';

class GetLanguageRepoImpl implements GetLanguageRepo {
  final BaseApiServices api;

  GetLanguageRepoImpl(this.api);


  @override
  Future<GetLanguageModel> getLanguageApi() async{
    try {
      final res = await api.getGetApiResponse(ApiUrls.getLanguageSpeakUrl);
      return GetLanguageModel.fromJson(res);
    } catch (e) {
      throw AppException("Failed to load getLanguageApi $e");
    }
  }

}

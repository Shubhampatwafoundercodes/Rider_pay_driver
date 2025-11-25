import 'package:rider_pay_driver/core/helper/network/api_exception.dart';
import 'package:rider_pay_driver/core/helper/network/base_api_service.dart';
import 'package:rider_pay_driver/core/res/api_urls.dart';
import 'package:rider_pay_driver/features/onboarding/domain/repo/user_app_url_repo.dart';

class UserAppUrlRepoImpl implements UserAppUrlRepo {
  final BaseApiServices api;

  UserAppUrlRepoImpl(this.api);


  @override
  Future<dynamic> userAppUrl() async{
    try {
      final res = await api.getGetApiResponse(ApiUrls.userAppUrl);
      return res;
    } catch (e) {
      throw AppException("Failed to load userAppUrl $e");
    }  }

}

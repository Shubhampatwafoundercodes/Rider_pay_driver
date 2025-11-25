import 'package:rider_pay_driver/core/helper/network/api_exception.dart';
import 'package:rider_pay_driver/core/helper/network/base_api_service.dart';
import 'package:rider_pay_driver/core/res/api_urls.dart';
import 'package:rider_pay_driver/features/auth/data/model/get_service_city_model.dart';
import 'package:rider_pay_driver/features/auth/domain/repo/service_get_city_repo.dart';

class GetServiceCityImpl implements ServiceGetCityRepo {
  final BaseApiServices api;

  GetServiceCityImpl(this.api);

  @override
  Future<GetServiceCityModel> getServiceCityApi() async{
    try {
      final res = await api.getGetApiResponse(ApiUrls.getServiceCityUrl);
      return GetServiceCityModel.fromJson(res);
    } catch (e) {
      throw AppException("Failed to load getServiceCityApi $e");
    }
  }

}

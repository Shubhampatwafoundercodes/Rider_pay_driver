import 'package:rider_pay_driver/core/helper/network/api_exception.dart';
import 'package:rider_pay_driver/core/helper/network/base_api_service.dart';
import 'package:rider_pay_driver/core/res/api_urls.dart';
import 'package:rider_pay_driver/features/drawer/data/model/get_performace_model.dart';
import 'package:rider_pay_driver/features/drawer/domain/repo/get_performance_repo.dart';

class GetPerformanceRepoImpl implements GetPerformanceRepo {
  final BaseApiServices api;

  GetPerformanceRepoImpl(this.api);


  @override
  Future<GetPerformanceModel> getPerformanceApi(String userId) async{
    try {
      final res = await api.getGetApiResponse(ApiUrls.getPerformanceUrl+userId);
      return GetPerformanceModel.fromJson(res);
    } catch (e) {
      throw AppException("Failed to load getPerformanceApi $e");
    }
  }

}

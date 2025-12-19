import 'package:rider_pay_driver/core/helper/network/base_api_service.dart';
import 'package:rider_pay_driver/core/res/api_urls.dart' show ApiUrls;
import 'package:rider_pay_driver/features/map/data/model/get_profile_model.dart';
import 'package:rider_pay_driver/features/map/domain/repo/get_profile_repo.dart';

class GetProfileImpl implements GetProfileRepo {
  final BaseApiServices api;

  GetProfileImpl(this.api);

  @override
  Future<GetProfileModel> getProfileApi(String userid) async {
    try {
      final res = await api.getGetApiResponse(ApiUrls.getProfile+userid);

      return GetProfileModel.fromJson(res);
    } catch (e) {
      throw Exception("Failed to load getProfileApi: $e");
    }
  }


}

import 'package:rider_pay_driver/core/helper/network/base_api_service.dart';
import 'package:rider_pay_driver/core/res/api_urls.dart';
import 'package:rider_pay_driver/features/map/domain/repo/driver_online_of_repo.dart';

class DriverOnOfRepoImpl implements DriverOnlineOfRepo {
  final BaseApiServices api;

  DriverOnOfRepoImpl(this.api);

  @override
  Future<dynamic> driverOnlineOfRepo(dynamic data) async{
    try {
      final res = await api.getPostApiResponse(ApiUrls.driverOnOfStatusUrl,data);
      return res;
    } catch (e) {
      throw Exception("Failed to load driverOnlineOfRepo: $e");
    }  }


}
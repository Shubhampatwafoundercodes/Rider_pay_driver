import 'package:rider_pay_driver/core/helper/network/base_api_service.dart';
import 'package:rider_pay_driver/core/res/api_urls.dart';
import 'package:rider_pay_driver/features/map/data/model/get_driver_earning_model.dart';
import 'package:rider_pay_driver/features/map/domain/repo/complete_ride_repo.dart';

class CompleteRideRepoImpl implements CompleteRideRepo {
  final BaseApiServices api;

  CompleteRideRepoImpl(this.api);


  @override
  Future<dynamic> completeRideApi(String rideId,String driverId) async {
    final url = "${ApiUrls.completeBookingRide+rideId}&driverId=$driverId";
    print("jhfdddddddd$url");

    try {
      final res = await api.getGetApiResponse(url);
      print("jhfdddddddd$res");
      return res;
    } catch (e) {
      throw Exception("Failed to load completeRideApi: $e");
    }
  }


  @override
  Future<GetDriverEarningsModel> getDriverEarningApi(String driverId) async{
    try {
      final res = await api.getGetApiResponse(ApiUrls.getDriverEarningUrl+driverId);
      print("getDriverEarningApi $res");
      return GetDriverEarningsModel.fromJson(res);
    } catch (e) {
      throw Exception("Failed to load getDriverEarningApi: $e");
    }
  }

}
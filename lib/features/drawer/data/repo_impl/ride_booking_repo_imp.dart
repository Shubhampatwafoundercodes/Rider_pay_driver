
import 'package:rider_pay_driver/core/helper/network/api_exception.dart';
import 'package:rider_pay_driver/core/helper/network/base_api_service.dart';
import 'package:rider_pay_driver/core/res/api_urls.dart' show ApiUrls;
import 'package:rider_pay_driver/features/drawer/data/model/ride_booking_history_model.dart';
import 'package:rider_pay_driver/features/drawer/domain/repo/ride_booking_repo.dart' show RideBookingRepo;

class RideBookingImp implements RideBookingRepo {
  final BaseApiServices api;

  RideBookingImp(this.api);

  @override
  Future<RideBookingHistoryModel> rideBookingHistoryApi(String userId) async {
    try {
      final res = await api.getGetApiResponse(ApiUrls.rideBookingHistoryUrl+userId);
      return RideBookingHistoryModel.fromJson(res);
    } catch (e) {
      throw AppException("Failed to rideBookingHistoryApi: $e");
    }  }
}

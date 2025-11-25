import 'package:rider_pay_driver/features/map/data/model/get_driver_earning_model.dart';

abstract class CompleteRideRepo{

  Future<dynamic> completeRideApi(String rideId,String driverId);

  Future<GetDriverEarningsModel> getDriverEarningApi(String driverId);





}
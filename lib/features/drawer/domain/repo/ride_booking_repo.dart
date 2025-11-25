
import 'package:rider_pay_driver/features/drawer/data/model/ride_booking_history_model.dart';

abstract class RideBookingRepo {

 Future<RideBookingHistoryModel> rideBookingHistoryApi(String userId);


}
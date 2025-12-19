import 'package:rider_pay_driver/features/firebase_service/ride/data/model/ride_booking_model.dart';

abstract class DriverRideRepo {
  /// Ek hi stream se sab rides milengi (pending + assigned to this driver)
  Stream<List<RideBookingModel>> listenAllRides(String driverId,int vehicleId);
  // Stream<RideBookingModel> listenSingleRide(String rideId);

  /// Ride actions
  Future<void> sendRideRequestToUser({
    required String rideId,
    required String driverId,
    required String name,
    required String mobile,
    required String img,
    required String vehicleName

  });


  Future<void> updateRideFields(String rideId, Map<String, dynamic> data);


  Future<void> rejectRide(String rideId, String driverId);



  Future<void> updateDriverStatus(String driverId,String driverStatus);

  /// Driver updates
  Future<void> updateDriverLocation(String driverId, double lat, double lng);







}

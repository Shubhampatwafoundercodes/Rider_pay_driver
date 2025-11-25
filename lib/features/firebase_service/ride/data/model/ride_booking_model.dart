import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:rider_pay_driver/features/firebase_service/ride/firebase_ride_key.dart';

  class RideBookingModel {
    final String rideId;
    final String userId;
    final String driverId;
    final int vehicleType;
    final Map<String, dynamic> pickupLocation;
    final Map<String, dynamic> dropLocation;
    final double distanceKm;
    final double? distanceBtDriverAndPickupKm;
    final double fare;
    final String status;
    final String? statusText;
    final int? otp;
    final String? userNumber;
    final String? paymentMode;
    final String? paymentStatus;



    final List<Map<String, dynamic>>? requestedDrivers;
    final List<String> rejectedDrivers;

    // Driver-specific
    final bool acceptedByDriver;

    RideBookingModel({
      required this.rideId,
      required this.userId,
      required this.driverId,
      required this.vehicleType,
      required this.pickupLocation,
      required this.dropLocation,
      required this.distanceKm,
      required this.fare,
      required this.status,
      this.otp,
      this.statusText,
      this.acceptedByDriver = false,
      this.requestedDrivers = const [],
      this.rejectedDrivers = const [],
      this.distanceBtDriverAndPickupKm,
      this.userNumber,
      this.paymentMode= "Cash",
      this.paymentStatus="Pending"
    });

    Map<String, dynamic> toMap() => {
      FirebaseRideKeys.rideId: rideId,
      FirebaseRideKeys.userId: userId,
      FirebaseRideKeys.driverId: driverId,
      FirebaseRideKeys.vehicleType: vehicleType,
      FirebaseRideKeys.pickupLocation: pickupLocation,
      FirebaseRideKeys.dropLocation: dropLocation,
      FirebaseRideKeys.distanceKm: distanceKm,
      FirebaseRideKeys.fare: fare,
      FirebaseRideKeys.otp: otp,

      FirebaseRideKeys.status: status,
      FirebaseRideKeys.paymentMode: paymentMode,
      FirebaseRideKeys.paymentStatus: paymentStatus,

      FirebaseRideKeys.userNumber: userNumber,
      FirebaseRideKeys.statusText: statusText,
      FirebaseRideKeys.requestedDriverList: requestedDrivers,
      FirebaseRideKeys.rejectedDriversList: rejectedDrivers,
      FirebaseRideKeys.distanceBtDriverAndPickupKm: distanceBtDriverAndPickupKm,
      FirebaseRideKeys.acceptedByDriver: acceptedByDriver,
    };

    factory RideBookingModel.fromMap(Map<String, dynamic> map) {
      // dynamic rawAcceptedDrivers = map[FirebaseRideKeys.requestedDriverList];
      List<Map<String, dynamic>> parsedRequestedDrivers = [];
      final rawRequested = map[FirebaseRideKeys.requestedDriverList];
      if (rawRequested is List) {
        parsedRequestedDrivers = rawRequested
            .whereType<Map>() // filter out invalid types
            .map((e) => Map<String, dynamic>.from(e))
            .toList();
      }

      // ✅ rejectedDrivers → List<String>
      List<String> parsedRejectedDrivers = [];
      final rawRejected = map[FirebaseRideKeys.rejectedDriversList];
      if (rawRejected is List) {
        parsedRejectedDrivers =
            rawRejected.map((e) => e.toString()).toList(); // ["3","4","5"]
      } else if (rawRejected is String) {
        parsedRejectedDrivers = [rawRejected];
      }

      return RideBookingModel(
        rideId: map[FirebaseRideKeys.rideId] ?? '',
        userId: map[FirebaseRideKeys.userId] ?? '',
        driverId: map[FirebaseRideKeys.driverId] ?? '',
        vehicleType: map[FirebaseRideKeys.vehicleType] ?? 0,
        userNumber: map[FirebaseRideKeys.userNumber] ?? '',
        paymentMode: map[FirebaseRideKeys.paymentMode] ?? "",
        paymentStatus: map[FirebaseRideKeys.paymentStatus] ?? "",
        otp: map[FirebaseRideKeys.otp] ?? 0,
        pickupLocation:
        Map<String, dynamic>.from(map[FirebaseRideKeys.pickupLocation] ?? {}),
        dropLocation:
        Map<String, dynamic>.from(map[FirebaseRideKeys.dropLocation] ?? {}),
        distanceKm: (map[FirebaseRideKeys.distanceKm] ?? 0).toDouble(),
        fare: (map[FirebaseRideKeys.fare] ?? 0).toDouble(),
        status: map[FirebaseRideKeys.status] ?? 'pending',
        statusText: map[FirebaseRideKeys.statusText] ?? 'Searching',
        acceptedByDriver: map[FirebaseRideKeys.acceptedByDriver] ?? false,
        requestedDrivers: parsedRequestedDrivers,
        rejectedDrivers: parsedRejectedDrivers,
        distanceBtDriverAndPickupKm:
        (map[FirebaseRideKeys.distanceBtDriverAndPickupKm] as num?)?.toDouble(),
      );
    }
  }

import 'dart:math';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:rider_pay_driver/features/firebase_service/ride/data/model/ride_booking_model.dart';
import 'package:rider_pay_driver/features/firebase_service/ride/domain/ride_repo.dart';
import 'package:rider_pay_driver/features/firebase_service/ride/firebase_ride_key.dart';

class DriverRideRepoImpl implements DriverRideRepo {
  final _firestore = FirebaseFirestore.instance;



  @override
  Stream<List<RideBookingModel>> listenAllRides(String driverId, int vehicleId) async* {
    final driverRef = _firestore.collection('drivers').doc(driverId);
    print(" Listening for driver [$driverId] document changes...");
    await for (final driverSnap in driverRef.snapshots()) {
      if (!driverSnap.exists) {
        print(" No such driver found for ID: $driverId");
        yield [];
        continue;
      }
      final driverData = driverSnap.data()!;
      final availability = driverData['availability'] ?? 'Offline';
      print("🛰 Driver status changed → $availability");
      if (availability != 'Online') {
        print("🛑 Driver is $availability — stopping ride stream.");
        yield [];
        continue;
      }
      final driverLat = driverData['location']?['latitude']?.toDouble();
      final driverLng = driverData['location']?['longitude']?.toDouble();

      if (driverLat == null || driverLng == null) {
        print("⚠️ Driver location missing in Firestore for [$driverId]");
        yield [];
        continue;
      }
      print("vehicleType $vehicleId");

      print("📍 Driver location: lat=$driverLat, lng=$driverLng");

      final ridesRef = _firestore.collection(FirebaseRideKeys.collectionRides)
          .where('vehicleType', isEqualTo: vehicleId);
          print("vehicleType $vehicleId");

      yield* ridesRef.snapshots().asyncMap((snapshot) async {
        print("🚗 Ride snapshot update → total: ${snapshot.docs.length}");
        final List<RideBookingModel> nearbyRides = [];
        for (final doc in snapshot.docs) {
          final data = doc.data();
          final acceptedByDriver = data['acceptedByDriver'] ?? false;
          if (data['driverId'] != null && data['driverId'] == driverId && acceptedByDriver && data['status'] != 'pending' &&
              data['status'] != 'completed' &&
              data['status'] != 'canceled') {
            // final pickupLat = data['pickupLocation']?['lat']?.toDouble();
            // final pickupLng = data['pickupLocation']?['lng']?.toDouble();

            // final distance = calculateDistance(
            //   driverLat,
            //   driverLng,
            //   pickupLat,
            //   pickupLng,
            // );
            final ride = RideBookingModel.fromMap({
              ...data,
              FirebaseRideKeys.rideId: doc.id,
            });
            nearbyRides.add(ride);
            /// jb issh wale condition me aaye tb check hogaa ki  driver stremer on ho jaye live location update ka samjhe

            break;
            // return nearbyRides;
          }



          if (data['status'] == 'pending' && !acceptedByDriver) {
            final rejected = List<String>.from(data['rejectedDrivers'] ?? []);
            if (rejected.contains(driverId)) continue;
            final pickupLat = data['pickupLocation']?['lat']?.toDouble();
            final pickupLng = data['pickupLocation']?['lng']?.toDouble();
            if (pickupLat == null || pickupLng == null) continue;
            print("pickup $pickupLat $pickupLng");
            final distance = calculateDistance(
              driverLat,
              driverLng,
              pickupLat,
              pickupLng,
            );
            print("➡️ Ride ${doc.id} distance from driver: ${distance.toStringAsFixed(2)} km",);
            if (distance <= 5) {
              print("✅ Ride ${doc.id} is nearby (within 5.0 km)");
              data[FirebaseRideKeys.distanceBtDriverAndPickupKm] = distance;
              final ride = RideBookingModel.fromMap({
                ...data,
                FirebaseRideKeys.rideId: doc.id,
              });
              nearbyRides.add(ride);
            } else {
              print("❌ Ride ${doc.id} ignored (too far: ${distance.toStringAsFixed(2)} km)",);
            }
          }
        }
        print("🎯 Found ${nearbyRides.length} nearby rides within 5.0 km.");
        return nearbyRides;
      });
    }
  }

  double calculateDistance(double lat1, double lon1, double lat2, double lon2) {
    const R = 6371; // Earth's radius in km
    final dLat = _degToRad(lat2 - lat1);
    final dLon = _degToRad(lon2 - lon1);

    final a =
        sin(dLat / 2) * sin(dLat / 2) +
            cos(_degToRad(lat1)) *
                cos(_degToRad(lat2)) *
                sin(dLon / 2) *
                sin(dLon / 2);

    final c = 2 * atan2(sqrt(a), sqrt(1 - a));
    final distance = R * c; // in km
    return distance;
  }

  double _degToRad(double deg) => deg * (pi / 180);

  /// 🔹 Accept ride
  @override
  Future<void> sendRideRequestToUser({
    required String rideId,
    required String driverId,
    required String name,
    required String mobile,
    required String img,
    required String vehicleName

  }) async
  {
    final ref = _firestore
        .collection(FirebaseRideKeys.collectionRides)
        .doc(rideId);
    try {
      await _firestore.runTransaction((tx) async {
        final doc = await tx.get(ref);
        print("refff: ${ref.id}");
        if (!doc.exists) {
          print("❌ Ride document does not exist for id: $rideId");
          return;
        }
        final data = doc.data() ?? {};
        final List<dynamic> currentList = List.from(
          data['requestedDrivers'] ?? [],
        );

        final existingIndex = currentList.indexWhere(
              (d) => d['id'] == driverId,
        );
        if (existingIndex == -1) {
          currentList.add({
            'id': driverId,
            'name': name,
            'mobile': mobile,
            "img":img,
            'driverStatus': 0,
            'vehicleType':vehicleName
            // 0 driver send Request User 1 accept buy user
          });
        }

        tx.update(ref, {'requestedDrivers': currentList});
      });
      print("✅ Ride request sent successfully for driver $driverId");
    } catch (e, st) {
      print("❌ Failed to send ride request: $e");
      print(st);
    }
  }

  @override
  Future<void> rejectRide(String rideId, String driverId) async {
    final ref = _firestore
        .collection(FirebaseRideKeys.collectionRides)
        .doc(rideId);
    await _firestore.runTransaction((tx) async {
      final doc = await tx.get(ref);
      if (!doc.exists) return;
      final data = doc.data() ?? {};
      final List<dynamic> requested = List.from(data['requestedDrivers'] ?? []);
      final List<dynamic> rejected = List.from(data['rejectedDrivers'] ?? []);
      requested.removeWhere((d) {
        if (d is Map<String, dynamic>) {
          return d['id'].toString() == driverId.toString();
        }
        return d.toString() == driverId.toString();
      });

      if (!rejected.contains(driverId)) {
        rejected.add(driverId);
      }

      // 🔹 Update Firestore
      tx.update(ref, {
        'requestedDrivers': requested,
        'rejectedDrivers': rejected,
      });
    });

    print("🚫 Driver $driverId rejected for ride $rideId");
  }

  @override
  Future<void> updateRideFields(
      String rideId,
      Map<String, dynamic> data,
      ) async {
    await _firestore
        .collection(FirebaseRideKeys.collectionRides)
        .doc(rideId)
        .update(data);
  }

  @override
  Future<void> updateDriverLocation(String driverId, double lat, double lng) async {
   await _firestore.collection("drivers").doc(driverId).update({
    "location.latitude":lat,
    "location.longitude":lng,
   });
  }



}

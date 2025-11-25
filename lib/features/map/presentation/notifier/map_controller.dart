import 'dart:async';
import 'dart:ui' as ui;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/legacy.dart';
import 'package:geocoding/geocoding.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:rider_pay_driver/features/map/data/repo_impl/map_repo_impl.dart';
import 'package:rider_pay_driver/generated/assets.dart';

// ✅ Provider
final mapControllerProvider =
    StateNotifierProvider<MapController, MapControllerState>((ref) {
      return MapController(ref);
    });

// ✅ State class
class MapControllerState {
  final GoogleMapController? controller;
  final bool isMapReady;
  final LatLng? pickupLocation;
  final LatLng? destinationLocation;
  final Set<Marker> markers;
  final Set<Polyline> polyline;
  final double? totalDistancePolyline;
  final int? routeDurationInSec;

  const MapControllerState({
    this.controller,
    this.isMapReady = false,
    this.pickupLocation,
    this.destinationLocation,
    this.markers = const {},
    this.polyline = const {},
    this.totalDistancePolyline,
    this.routeDurationInSec,
  });

  MapControllerState copyWith({
    GoogleMapController? controller,
    bool? isMapReady,
    LatLng? pickupLocation,
    LatLng? destinationLocation,
    Set<Marker>? markers,
    Set<Polyline>? polyline,
    double? totalDistancePolyline,
    int? routeDurationInSec,
  }) {
    return MapControllerState(
      controller: controller ?? this.controller,
      isMapReady: isMapReady ?? this.isMapReady,
      pickupLocation: pickupLocation ?? this.pickupLocation,
      destinationLocation: destinationLocation ?? this.destinationLocation,
      markers: markers ?? this.markers,
      polyline: polyline ?? this.polyline,
      totalDistancePolyline:
          totalDistancePolyline ?? this.totalDistancePolyline,
      routeDurationInSec: routeDurationInSec ?? this.routeDurationInSec,
    );
  }
}

// ✅ Controller
class MapController extends StateNotifier<MapControllerState> {
  final Ref ref;
  final Completer<GoogleMapController> _controllerCompleter = Completer();

  MapController(this.ref) : super(const MapControllerState());

  // 🗺️ Set Google Map Controller
  void setMapController(GoogleMapController controller) {
    if (!_controllerCompleter.isCompleted) {
      _controllerCompleter.complete(controller);
    }
    state = state.copyWith(controller: controller, isMapReady: true);
    debugPrint("🗺️ MapController initialized");
  }

  // 📍 Set Pickup / Destination
  void setPickupLatLng(LatLng value) {
    state = state.copyWith(pickupLocation: value);
  }

  void setDestLatLng(LatLng value) {
    state = state.copyWith(destinationLocation: value);
  }

  Future<String> getAddressFromLatLng(LatLng latLng) async {
    try {
      final placeMarks = await placemarkFromCoordinates(
        latLng.latitude,
        latLng.longitude,
      );
      final place = placeMarks.first;
      return "${place.name}, ${place.locality}, ${place.postalCode}";
    } catch (e) {
      debugPrint("Reverse geocode failed: $e");
      return "${latLng.latitude},${latLng.longitude}";
    }
  }

  // 🛣️ Draw Route Polyline
  Future<void> drawRoute(LatLng origin, LatLng destination, {bool shouldUpdateDistance = true,}) async {
    try {
      final originAddress = await getAddressFromLatLng(origin);
      final destinationAddress = await getAddressFromLatLng(destination);
      await addMarker(origin, "pickup_marker", Assets.iconMapMarker, title: originAddress,);
      await addMarker(destination, "destination_marker", Assets.iconSquareMarker, title: destinationAddress,);
      final data = await ref.read(mapRepositoryProvider).drawRoutePolyline(origin, destination);
      final decoded = await _getAccuratePolyline(data);

      final polyline = Polyline(
        polylineId: const PolylineId("route"),
        color: Colors.black,
        width: 3,
        points: decoded,
      );

      state = state.copyWith(polyline: {polyline});
      final legs = data['routes'][0]['legs'][0];
      final distanceMeters = double.parse(legs['distance']['value'].toString());
      final durationSeconds = legs['duration']['value'];
      if (shouldUpdateDistance) {
        state = state.copyWith(
          totalDistancePolyline: distanceMeters,
          routeDurationInSec: durationSeconds,
        );
      }
      debugPrint("📏 Distance: $distanceMeters m | ⏱ Duration: $durationSeconds sec",
      );

      await moveCameraOnPolyline(decoded);
    } catch (e) {
      debugPrint("❌ Error drawing polyline: $e");
    }
  }

  // 🎯 Move Camera
  Future<void> moveCamera(double lat, double lng, {double zoom = 14}) async {
    final controller = state.controller ?? await _controllerCompleter.future;
    await controller.animateCamera(
      CameraUpdate.newCameraPosition(
        CameraPosition(target: LatLng(lat, lng), zoom: zoom),
      ),
    );
  }

  // 📍 Move Camera to Show Full Polyline
  Future<void> moveCameraOnPolyline(List<LatLng> points) async {
    if (points.isEmpty) return;

    final controller = state.controller ?? await _controllerCompleter.future;

    double minLat = points.first.latitude;
    double maxLat = points.first.latitude;
    double minLng = points.first.longitude;
    double maxLng = points.first.longitude;

    for (var p in points) {
      if (p.latitude < minLat) minLat = p.latitude;
      if (p.latitude > maxLat) maxLat = p.latitude;
      if (p.longitude < minLng) minLng = p.longitude;
      if (p.longitude > maxLng) maxLng = p.longitude;
    }

    final bounds = LatLngBounds(
      southwest: LatLng(minLat, minLng),
      northeast: LatLng(maxLat, maxLng),
    );

    try {
      await controller.animateCamera(CameraUpdate.newLatLngBounds(bounds, 50));
    } catch (e) {
      debugPrint("⚠️ Error moving camera: $e");
      await controller.animateCamera(
        CameraUpdate.newLatLngZoom(points.first, 14),
      );
    }
  }


  // 🖼️ Resize Marker Icon
  Future<BitmapDescriptor> _resizeImage(String assetPath, int width) async {
    final byteData = await rootBundle.load(assetPath);
    final codec = await ui.instantiateImageCodec(
      byteData.buffer.asUint8List(),
      targetWidth: width,
    );
    final frame = await codec.getNextFrame();
    final data = await frame.image.toByteData(format: ui.ImageByteFormat.png);
    return BitmapDescriptor.fromBytes(data!.buffer.asUint8List());
  }

  // 📍 Add Marker

  Future<void> addMarker(
    LatLng position,
    String markerId,
    String assetPath, {
    int? markerHeight,
    String? title, // Address or label
    String? snippet, // Optional extra info
  }) async {
    try {
      final icon = await _resizeImage(assetPath, markerHeight ?? 60);
      final marker = Marker(
        markerId: MarkerId(markerId),
        position: position,
        icon: icon,
        infoWindow: InfoWindow(
          title: title ?? "", // Show address
          snippet: snippet ?? "",
        ),
      );

      final updated = {...state.markers}
        ..removeWhere((m) => m.markerId.value == markerId);
      updated.add(marker);
      state = state.copyWith(markers: updated);
    } catch (e) {
      debugPrint("Marker error: $e");
    }
  }

  // 🔍 Decode Polyline
  List<LatLng> _decodePolyline(String encoded) {
    List<LatLng> polyline = [];
    int index = 0, len = encoded.length;
    int lat = 0, lng = 0;

    while (index < len) {
      int b, shift = 0, result = 0;
      do {
        b = encoded.codeUnitAt(index++) - 63;
        result |= (b & 0x1f) << shift;
        shift += 5;
      } while (b >= 0x20);
      int dlat = (result & 1) != 0 ? ~(result >> 1) : (result >> 1);
      lat += dlat;

      shift = 0;
      result = 0;
      do {
        b = encoded.codeUnitAt(index++) - 63;
        result |= (b & 0x1f) << shift;
        shift += 5;
      } while (b >= 0x20);
      int dlng = (result & 1) != 0 ? ~(result >> 1) : (result >> 1);
      lng += dlng;

      polyline.add(LatLng(lat / 1E5, lng / 1E5));
    }

    return polyline;
  }

  // 🎯 Accurate Polyline Decode
  Future<List<LatLng>> _getAccuratePolyline(dynamic data) async {
    List<LatLng> polylinePoints = [];

    final routes = data["routes"] as List?;
    if (routes == null || routes.isEmpty) return [];

    final legs = routes[0]["legs"] as List?;
    if (legs == null || legs.isEmpty) return [];

    for (var leg in legs) {
      final steps = leg["steps"] as List?;
      if (steps == null) continue;

      for (var step in steps) {
        final polyline = step["polyline"]["points"];
        polylinePoints.addAll(_decodePolyline(polyline));
      }
    }

    return polylinePoints;
  }


  void clearAll() {
    state = state.copyWith(
      markers: {},
      polyline: {},
      pickupLocation: null,
      destinationLocation: null,
      totalDistancePolyline: 0,
      routeDurationInSec: 0,
    );
    debugPrint("🧼 Map fully cleared");
  }

  // 🗑️ Clear All Markers
  void clearMarkers() {
    state = state.copyWith(markers: {});
    debugPrint("🧹 All markers cleared");
  }

  // 🗑️ Clear All Polylines
  void clearPolylines() {
    state = state.copyWith(polyline: {}, totalDistancePolyline: 0);
    debugPrint("🧹 All polylines cleared");
  }
}

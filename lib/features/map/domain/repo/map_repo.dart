import 'package:google_maps_flutter/google_maps_flutter.dart';

abstract class MapRepository {

  Future<Map<String, dynamic>> placeDetails(String placeId);

  Future<Map<String, dynamic>> drawRoutePolyline(LatLng origin,LatLng destination);


}

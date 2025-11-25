import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:rider_pay_driver/core/helper/network/base_api_service.dart';
import 'package:rider_pay_driver/core/helper/network/network_api_service_dio.dart';
import 'package:rider_pay_driver/core/res/api_urls.dart';
import 'package:rider_pay_driver/features/map/domain/repo/map_repo.dart';

final mapRepositoryProvider = Provider<MapRepository>((ref) {
  return MapRepositoryImpl(NetworkApiServicesDio(ref));
});

class MapRepositoryImpl implements MapRepository {
  final BaseApiServices api;
  MapRepositoryImpl(this.api);


  @override
  Future<Map<String, dynamic>> placeDetails(String placeId) async {
    final url =
        "${MapUrls.baseUrl}${MapUrls.placeDetailsUrl}?placeid=$placeId&key=${MapUrls.mapKey}";
    final data = await api.getGetApiResponse(url);
    return data;
  }

  @override
  Future<Map<String, dynamic>> drawRoutePolyline(
      LatLng origin,
      LatLng destination,
      ) async {
    String url =
        "${MapUrls.baseUrl}${MapUrls.drawRouteUrl}?origin=${origin.latitude},${origin.longitude}&destination=${destination.latitude},${destination.longitude}&key=${MapUrls.mapKey}&mode=driving";
    final data = await api.getGetApiResponse(url);
    return data;
  }
}
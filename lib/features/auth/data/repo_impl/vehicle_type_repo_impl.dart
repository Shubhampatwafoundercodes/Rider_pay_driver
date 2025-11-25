

import 'package:rider_pay_driver/core/helper/network/api_exception.dart';
import 'package:rider_pay_driver/core/helper/network/base_api_service.dart';
import 'package:rider_pay_driver/core/res/api_urls.dart';
import 'package:rider_pay_driver/features/auth/data/model/vehicle_type_model.dart';
import 'package:rider_pay_driver/features/auth/domain/repo/vehicle_type_repo.dart';

class VehicleTypeRepoImpl implements VehicleTypeRepo {
  final BaseApiServices api;

  VehicleTypeRepoImpl(this.api);


  @override
  Future<VehicleTypeModel> vehicleTypeApi() async{
    try {
      final res = await api.getGetApiResponse(ApiUrls.vehicleTypeUrl);
      return VehicleTypeModel.fromJson(res);
    } catch (e) {
      throw AppException("Failed to load vehicleTypeApi $e");
    }  }

  @override
  Future <dynamic> selectedVehicleUpload(String vehicleId, String driverId) async{
    try {
      final url="${ApiUrls.vehicleTypeUpload}${"driverId=$driverId&vehicleId=$vehicleId"}";
      final res = await api.getGetApiResponse(url);
      return res;
    } catch (e) {
      throw AppException("Failed to load selectedVehicleUpload $e");
    }  }
}

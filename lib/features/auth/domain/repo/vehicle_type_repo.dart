
import 'package:rider_pay_driver/features/auth/data/model/vehicle_type_model.dart' show VehicleTypeModel;

abstract class VehicleTypeRepo{
  Future<VehicleTypeModel> vehicleTypeApi();

  Future<dynamic> selectedVehicleUpload(String vehicleId,String driverId);

}
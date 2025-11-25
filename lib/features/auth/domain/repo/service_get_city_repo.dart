import 'package:rider_pay_driver/features/auth/data/model/get_service_city_model.dart';

abstract class ServiceGetCityRepo{

  Future<GetServiceCityModel> getServiceCityApi();

}
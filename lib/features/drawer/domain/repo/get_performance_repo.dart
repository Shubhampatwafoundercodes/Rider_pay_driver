import 'package:rider_pay_driver/features/drawer/data/model/get_performace_model.dart';

abstract class GetPerformanceRepo{

  Future<GetPerformanceModel> getPerformanceApi(String userId);

}
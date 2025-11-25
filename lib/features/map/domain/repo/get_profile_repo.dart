
 import 'package:rider_pay_driver/features/map/data/model/get_profile_model.dart';

abstract class GetProfileRepo{

  Future<GetProfileModel> getProfileApi(String userId);

 }
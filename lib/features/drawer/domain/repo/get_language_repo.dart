import 'package:rider_pay_driver/features/drawer/data/model/get_language_model.dart';

abstract class GetLanguageRepo{

  Future<GetLanguageModel> getLanguageApi();

}
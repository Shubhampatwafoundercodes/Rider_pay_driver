

import 'package:rider_pay_driver/features/drawer/data/model/get_bank_details_model.dart';

abstract class BankDetailsRepo{

  Future<dynamic> addBankDetailsApi(dynamic data);
  Future<BankDetailsModel> getBankDetailsApi(String userId);
  Future<dynamic> deleteBankAccountApi(String userId);
  Future<dynamic> withdrawAmountApi(dynamic data);



}
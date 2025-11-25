

import 'package:rider_pay_driver/core/helper/network/base_api_service.dart';
import 'package:rider_pay_driver/core/res/api_urls.dart';
import 'package:rider_pay_driver/features/drawer/data/model/get_bank_details_model.dart';
import 'package:rider_pay_driver/features/drawer/domain/repo/bank_details_repo.dart';

class BankDetailsRepoImpl implements BankDetailsRepo{
  final BaseApiServices api;

  BankDetailsRepoImpl(this.api);
  @override
  Future<dynamic> addBankDetailsApi(dynamic data) async{
    try {
      final res = await api.getPostApiResponse(ApiUrls.addBankAccUrl,data);
      return res;
    } catch (e) {
      throw Exception("Failed to load deleteAccountApi: $e");
    }
  }


  @override
  Future<BankDetailsModel> getBankDetailsApi(String userId) async{
    try {
      final res = await api.getGetApiResponse(ApiUrls.getBankDetailsUrl+userId);
      return BankDetailsModel.fromJson(res);
    } catch (e) {
      throw Exception("Failed to load getBankDetailsApi: $e");
    }
  }

  @override
  Future<dynamic> deleteBankAccountApi(String userId)async {
    try {
      final res = await api.getGetApiResponse(ApiUrls.deleteBankDetailsUrl+userId);
      return res;
    } catch (e) {
      throw Exception("Failed to load deleteBankAccountApi: $e");
    }

  }

  @override
  Future <dynamic> withdrawAmountApi(dynamic data)async {
    try {
      final res = await api.getPostApiResponse(ApiUrls.withdrawUrl,data);
      return res;
    } catch (e) {
      throw Exception("Failed to load withdrawAmountApi: $e");
    }   }


}


import 'package:rider_pay_driver/core/helper/network/api_exception.dart';
import 'package:rider_pay_driver/core/helper/network/base_api_service.dart';
import 'package:rider_pay_driver/core/res/api_urls.dart';
import 'package:rider_pay_driver/features/cashfree_payment/data/model/admin_transaction_model.dart';
import 'package:rider_pay_driver/features/cashfree_payment/domain/repo/admin_tra_history_repo.dart';


class AdminTransactionRepoImpl implements AdminTraHistoryRepo {
  final BaseApiServices api;

  AdminTransactionRepoImpl(this.api);


  @override
  Future<AdminTransactionModel> adminTransactionApi(String userId) async{
    try {
      final res = await api.getGetApiResponse(ApiUrls.adminTransaction+userId);
      print("✅ Admin Transaction API success, data: ${res.toString()}");

      return AdminTransactionModel.fromJson(res);
    } catch (e) {
      throw AppException("Failed to load adminTransactionApi $e");
    }
  }

}

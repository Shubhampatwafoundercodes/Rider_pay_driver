import 'package:rider_pay_driver/features/cashfree_payment/data/model/admin_transaction_model.dart';

abstract class AdminTraHistoryRepo{

  Future<AdminTransactionModel> adminTransactionApi(String userId);

}
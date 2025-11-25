
import 'package:rider_pay_driver/features/drawer/data/model/credit_withdraw_history_model.dart';

abstract class CreditWithdrawHistoryRepo{

  Future<CreditWithdrawHistoryModel> creditWithdrawHistoryApi(String userId);

}
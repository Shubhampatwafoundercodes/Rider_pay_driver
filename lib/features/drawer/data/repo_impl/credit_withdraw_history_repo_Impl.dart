import 'package:rider_pay_driver/core/helper/network/api_exception.dart';
import 'package:rider_pay_driver/core/helper/network/base_api_service.dart';
import 'package:rider_pay_driver/core/res/api_urls.dart';
import 'package:rider_pay_driver/features/drawer/data/model/credit_withdraw_history_model.dart';
import 'package:rider_pay_driver/features/drawer/domain/repo/credit_withdraw_repo.dart';

class CreditWithdrawHistoryRepoImpl implements CreditWithdrawHistoryRepo {
  final BaseApiServices api;

  CreditWithdrawHistoryRepoImpl(this.api);


  @override
  Future <CreditWithdrawHistoryModel> creditWithdrawHistoryApi(String userId) async{
    try {
      final res = await api.getGetApiResponse(ApiUrls.creditWithdrawHistory+userId);
      print("dfghbjnkmn$res");
      return CreditWithdrawHistoryModel.fromJson(res);
    } catch (e) {
      throw AppException("Failed to load creditWithdrawHistoryApi $e");
    }
  }

}

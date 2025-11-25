import 'package:rider_pay_driver/core/helper/network/base_api_service.dart';
import 'package:rider_pay_driver/core/res/api_urls.dart';
import 'package:rider_pay_driver/features/map/domain/repo/complete_payment_repo.dart';

class CompletePaymentRepoImpl implements CompletePaymentRepo {
  final BaseApiServices api;

  CompletePaymentRepoImpl(this.api);

  @override
  Future<dynamic> completePaymentApi(dynamic data) async {
    try {
      final res = await api.getPostApiResponse(ApiUrls.completePaymentRide , data);
      return res;
    } catch (e) {
      throw Exception("Failed to load completePaymentApi: $e");
    }
  }
}

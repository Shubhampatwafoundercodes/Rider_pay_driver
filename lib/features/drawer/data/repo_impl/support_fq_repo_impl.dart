import 'package:rider_pay_driver/core/helper/network/api_exception.dart';
import 'package:rider_pay_driver/core/helper/network/base_api_service.dart';
import 'package:rider_pay_driver/core/res/api_urls.dart';
import 'package:rider_pay_driver/features/drawer/data/model/support_fq_model.dart';
import 'package:rider_pay_driver/features/drawer/domain/repo/support_fq_repo.dart';

class SupportFqRepoImpl implements SupportFqRepo {
  final BaseApiServices api;

  SupportFqRepoImpl(this.api);


  @override
  Future<SupportFQModel> supportFQApi() async{
    try {
      final res = await api.getGetApiResponse(ApiUrls.supportFqUrl);
      return SupportFQModel.fromJson(res);
    } catch (e) {
      throw AppException("Failed to load SupportFQModel $e");
    }
  }

}

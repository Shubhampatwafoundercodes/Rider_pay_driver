
import 'package:rider_pay_driver/features/drawer/data/model/notification_model.dart' show NotificationModel;

abstract class NotificationRepo{

  Future<NotificationModel> notificationApi(String userId,String type);


}
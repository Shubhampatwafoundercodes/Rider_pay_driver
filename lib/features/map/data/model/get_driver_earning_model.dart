class GetDriverEarningsModel {
  GetDriverEarningsModel({
    required this.code,
    required this.msg,
    required this.data,
  });

  final int? code;
  final String? msg;
  final Data? data;

  factory GetDriverEarningsModel.fromJson(Map<String, dynamic> json){
    return GetDriverEarningsModel(
      code: json["code"],
      msg: json["msg"],
      data: json["data"] == null ? null : Data.fromJson(json["data"]),
    );
  }

}

class Data {
  Data({
    required this.driverId,
    required this.wallet,
    required this.todayEarning,
    required this.lastBookingEarning,
  });

  final String? driverId;
  final dynamic wallet;
  final dynamic todayEarning;
  final dynamic lastBookingEarning;

  factory Data.fromJson(Map<String, dynamic> json){
    return Data(
      driverId: json["driver_id"],
      wallet: json["wallet"],
      todayEarning: json["todayEarning"],
      lastBookingEarning: json["lastBookingEarning"],
    );
  }

}

class GetPerformanceModel {
  GetPerformanceModel({
    required this.code,
    required this.msg,
    required this.data,
  });

  final int? code;
  final String? msg;
  final Data? data;

  factory GetPerformanceModel.fromJson(Map<String, dynamic> json){
    return GetPerformanceModel(
      code: json["code"],
      msg: json["msg"],
      data: json["data"] == null ? null : Data.fromJson(json["data"]),
    );
  }

}

class Data {
  Data({
    required this.performance,
  });

  final Performance? performance;

  factory Data.fromJson(Map<String, dynamic> json){
    return Data(
      performance: json["performance"] == null ? null : Performance.fromJson(json["performance"]),
    );
  }

}

class Performance {
  Performance({
    required this.driverId,
    required this.totalBookings,
    required this.completedBookings,
    required this.cancelledBookings,
    required this.ongoingBookings,
  });

  final dynamic driverId;
  final int? totalBookings;
  final dynamic completedBookings;
  final dynamic cancelledBookings;
  final dynamic ongoingBookings;

  factory Performance.fromJson(Map<String, dynamic> json){
    return Performance(
      driverId: json["driver_id"],
      totalBookings: json["total_bookings"],
      completedBookings: json["completed_bookings"],
      cancelledBookings: json["cancelled_bookings"],
      ongoingBookings: json["ongoing_bookings"],
    );
  }

}

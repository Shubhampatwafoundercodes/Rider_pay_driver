class CreditWithdrawHistoryModel {
  CreditWithdrawHistoryModel({
    required this.code,
    required this.msg,
    required this.data,
  });

  final int? code;
  final String? msg;
  final List<Datum> data;

  factory CreditWithdrawHistoryModel.fromJson(Map<String, dynamic> json){
    return CreditWithdrawHistoryModel(
      code: json["code"],
      msg: json["msg"],
      data: json["data"] == null ? [] : List<Datum>.from(json["data"]!.map((x) => Datum.fromJson(x))),
    );
  }

}

class Datum {
  Datum({
    required this.id,
    required this.driverId,
    required this.amount,
    required this.type,
    required this.description,
    required this.datetime,
    required this.status,
  });

  final int? id;
  final int? driverId;
  final dynamic amount;
  final String? type;
  final String? description;
  final DateTime? datetime;
  final String? status;

  factory Datum.fromJson(Map<String, dynamic> json){
    return Datum(
      id: json["id"],
      driverId: json["driverId"],
      amount: json["amount"],
      type: json["type"],
      description: json["description"],
      datetime: DateTime.tryParse(json["datetime"] ?? ""),
      status: json["status"],
    );
  }

}

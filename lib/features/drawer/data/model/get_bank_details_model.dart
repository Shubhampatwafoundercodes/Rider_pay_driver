import 'package:rider_pay_driver/features/drawer/presentation/ui/wallet/money_transfer_screen.dart';

class BankDetailsModel {
  BankDetailsModel({
    required this.code,
    required this.msg,
    required this.data,
  });

  final int? code;
  final String? msg;
  final List<BankDetailsOnlyOneData> data;

  factory BankDetailsModel.fromJson(Map<String, dynamic> json){
    return BankDetailsModel(
      code: json["code"],
      msg: json["msg"],
      data: json["data"] == null ? [] : List<BankDetailsOnlyOneData>.from(json["data"]!.map((x) => BankDetailsOnlyOneData.fromJson(x))),
    );
  }

}

class BankDetailsOnlyOneData {
  BankDetailsOnlyOneData({
    required this.id,
    required this.driverId,
    required this.accountHolder,
    required this.accountNumber,
    required this.ifsc,
    required this.bankName,
    required this.upiId,
    required this.status,
    required this.datetime,
  });

  final int? id;
  final String? driverId;
  final String? accountHolder;
  final String? accountNumber;
  final String? ifsc;
  final String? bankName;
  final String? upiId;
  final int? status;
  final DateTime? datetime;

  factory BankDetailsOnlyOneData.fromJson(Map<String, dynamic> json){
    return BankDetailsOnlyOneData(
      id: json["id"],
      driverId: json["driverId"],
      accountHolder: json["accountHolder"],
      accountNumber: json["accountNumber"],
      ifsc: json["ifsc"],
      bankName: json["bankName"],
      upiId: json["upiId"],
      status: json["status"],
      datetime: DateTime.tryParse(json["datetime"] ?? ""),
    );
  }


}

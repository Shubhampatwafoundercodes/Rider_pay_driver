class SupportFQModel {
  SupportFQModel({
    required this.code,
    required this.msg,
    required this.data,
  });

  final int? code;
  final String? msg;
  final List<SupportFqModelData> data;

  factory SupportFQModel.fromJson(Map<String, dynamic> json){
    return SupportFQModel(
      code: json["code"],
      msg: json["msg"],
      data: json["data"] == null ? [] : List<SupportFqModelData>.from(json["data"]!.map((x) => SupportFqModelData.fromJson(x))),
    );
  }

}

class SupportFqModelData {
  SupportFqModelData({
    required this.id,
    required this.question,
    required this.answer,
    required this.status,
    required this.createdAt,
    required this.updatedAt,
  });

  final int? id;
  final String? question;
  final String? answer;
  final int? status;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  factory SupportFqModelData.fromJson(Map<String, dynamic> json){
    return SupportFqModelData(
      id: json["id"],
      question: json["question"],
      answer: json["answer"],
      status: json["status"],
      createdAt: DateTime.tryParse(json["created_at"] ?? ""),
      updatedAt: DateTime.tryParse(json["updated_at"] ?? ""),
    );
  }

}

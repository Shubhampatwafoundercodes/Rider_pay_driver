class GetLanguageModel {
  GetLanguageModel({
    required this.code,
    required this.msg,
    required this.data,
  });

  final int? code;
  final String? msg;
  final List<Datum> data;

  factory GetLanguageModel.fromJson(Map<String, dynamic> json){
    return GetLanguageModel(
      code: json["code"],
      msg: json["msg"],
      data: json["data"] == null ? [] : List<Datum>.from(json["data"]!.map((x) => Datum.fromJson(x))),
    );
  }

}

class Datum {
  Datum({
    required this.id,
    required this.language,
    required this.status,
  });

  final int? id;
  final String? language;
  final int? status;

  factory Datum.fromJson(Map<String, dynamic> json){
    return Datum(
      id: json["id"],
      language: json["language"],
      status: json["status"],
    );
  }

}

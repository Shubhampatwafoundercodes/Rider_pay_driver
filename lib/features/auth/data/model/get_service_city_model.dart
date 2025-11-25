class GetServiceCityModel {
  GetServiceCityModel({
    required this.code,
    required this.msg,
    required this.data,
  });

  final int? code;
  final String? msg;
  final Data? data;

  factory GetServiceCityModel.fromJson(Map<String, dynamic> json){
    return GetServiceCityModel(
      code: json["code"],
      msg: json["msg"],
      data: json["data"] == null ? null : Data.fromJson(json["data"]),
    );
  }

}

class Data {
  Data({
    required this.cities,
  });

  final List<City> cities;

  factory Data.fromJson(Map<String, dynamic> json){
    return Data(
      cities: json["cities"] == null ? [] : List<City>.from(json["cities"]!.map((x) => City.fromJson(x))),
    );
  }

}

class City {
  City({
    required this.id,
    required this.name,
  });

  final int? id;
  final String? name;

  factory City.fromJson(Map<String, dynamic> json){
    return City(
      id: json["id"],
      name: json["name"],
    );
  }

}

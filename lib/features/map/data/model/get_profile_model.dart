class GetProfileModel {
  GetProfileModel({
    required this.code,
    required this.msg,
    required this.data,
  });

  final int? code;
  final String? msg;
  final Data? data;

  factory GetProfileModel.fromJson(Map<String, dynamic> json){
    return GetProfileModel(
      code: json["code"],
      msg: json["msg"],
      data: json["data"] == null ? null : Data.fromJson(json["data"]),
    );
  }

}

class Data {
  Data({
    required this.driver,
    required this.documents,
    required this.vehicleType,
  });

  final Driver? driver;
  final List<Document> documents;
  final VehicleType? vehicleType;

  factory Data.fromJson(Map<String, dynamic> json){
    return Data(
      driver: json["driver"] == null ? null : Driver.fromJson(json["driver"]),
      documents: json["documents"] == null ? [] : List<Document>.from(json["documents"]!.map((x) => Document.fromJson(x))),
      vehicleType: json["vehicleType"] == null ? null : VehicleType.fromJson(json["vehicleType"]),
    );
  }

}

class Document {
  Document({
    required this.docType,
    required this.docNumber,
    required this.frontImg,
    required this.backImg,
    required this.verifiedStatus,
    required this.uploadedAt,
  });

  final String? docType;
  final String? docNumber;
  final String? frontImg;
  final dynamic backImg;
  final String? verifiedStatus;
  final DateTime? uploadedAt;

  factory Document.fromJson(Map<String, dynamic> json){
    return Document(
      docType: json["doc_type"],
      docNumber: json["doc_number"],
      frontImg: json["front_img"],
      backImg: json["back_img"],
      verifiedStatus: json["verified_status"],
      uploadedAt: DateTime.tryParse(json["uploaded_at"] ?? ""),
    );
  }

}

class Driver {
  Driver(  {
    required this.id,
    required this.referrId,
    required this.name,
    required this.email,
    required this.phone,
    required this.gender,
    required this.dob,
    required this.address,
    required this.img,
    required this.wallet,
    required this.status,
    required this.createdAt,
    required this.updatedAt,
    required this.currentToken,
    required this.availability,
    required this.adminDue,
  });

  final int? id;
  final dynamic referrId;
  final dynamic name;
  final dynamic email;
  final String? phone;
  final dynamic gender;
  final dynamic dob;
  final String? address;
  final String? availability;
  final dynamic img;
  final dynamic wallet;
  final int? status;
  final DateTime? createdAt;
  final DateTime? updatedAt;
  final String? currentToken;
  final dynamic adminDue;

  factory Driver.fromJson(Map<String, dynamic> json){
    return Driver(
      id: json["id"],
      referrId: json["referrId"],
      name: json["name"],
      email: json["email"],
      phone: json["phone"],
      gender: json["gender"],
      dob: json["dob"],
      address: json["address"],
      img: json["img"],
      wallet: json["wallet"],
      status: json["status"],
      createdAt: DateTime.tryParse(json["created_at"] ?? ""),
      updatedAt: DateTime.tryParse(json["updated_at"] ?? ""),
      currentToken: json["current_token"],
      availability: json["availability"],
      adminDue: json["adminDue"],
    );
  }

}

class VehicleType {
  VehicleType({
    required this.id,
    required this.name,
    required this.description,
    required this.baseFare,
    required this.perKmRate,
    required this.perMinuteRate,
    required this.capacity,
    required this.maxSpeed,
    required this.icon,
    required this.blackWhiteIcon,
    required this.awayMinutes,
    required this.verifiedStatus,
    required this.createdAt,
    required this.updatedAt,
  });

  final int? id;
  final String? name;
  final String? description;
  final String? baseFare;
  final String? perKmRate;
  final String? perMinuteRate;
  final int? capacity;
  final String? maxSpeed;
  final String? icon;
  final String? blackWhiteIcon;
  final String? awayMinutes;
  final String? verifiedStatus;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  factory VehicleType.fromJson(Map<String, dynamic> json){
    return VehicleType(
      id: json["id"],
      name: json["name"],
      description: json["description"],
      baseFare: json["base_fare"],
      perKmRate: json["per_km_rate"],
      perMinuteRate: json["per_minute_rate"],
      capacity: json["capacity"],
      maxSpeed: json["max_speed"],
      icon: json["icon"],
      blackWhiteIcon: json["blackWhiteIcon"],
      awayMinutes: json["awayMinutes"],
      verifiedStatus: json["verified_status"],
      createdAt: DateTime.tryParse(json["created_at"] ?? ""),
      updatedAt: DateTime.tryParse(json["updated_at"] ?? ""),
    );
  }

}

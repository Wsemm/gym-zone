import 'dart:convert';

class IndividualGym {
  String? id;
  String? name;
  String? nameAr;
  String? description;
  String? descriptionAr;
  String? gender;
  bool? isMixed;
  String? gymType;
  int? provinceId;
  String? logoPath;
  String? phone;
  String? email;
  String? bankAcc;
  String? bankName;
  Location? location;
  String? locationUrl;
  int? basePrice;
  int? pointsPerVisit;
  int? totalPoints;
  String? createdAt;
  String? updatedAt;
  int? isDeleted;
  int? ownerId;
  List<Gallery>? gallery;
  Province? province;
  List<Branches>? branches;
  List<Schedules>? schedules;
  String? openingDay;
  String? openingDayAr;

  IndividualGym({
    this.id,
    this.name,
    this.nameAr,
    this.description,
    this.descriptionAr,
    this.gender,
    this.isMixed,
    this.gymType,
    this.provinceId,
    this.logoPath,
    this.phone,
    this.email,
    this.bankAcc,
    this.bankName,
    this.location,
    this.locationUrl,
    this.basePrice,
    this.pointsPerVisit,
    this.totalPoints,
    this.createdAt,
    this.updatedAt,
    this.isDeleted,
    this.ownerId,
    this.gallery,
    this.province,
    this.branches,
    this.schedules,
    this.openingDay,
    this.openingDayAr,
  });

  IndividualGym.fromJson(Map<String, dynamic> json) {
    id = json["id"];
    name = json["name"];
    nameAr = json["name_ar"];
    description = json["description"];
    descriptionAr = json["description_ar"];
    gender = json["gender"];
    isMixed = json["is_mixed"] == 1 ? true : false;
    gymType = json["gym_type"];
    provinceId = json["province_id"];
    logoPath = json["logo_path"];
    phone = json["phone"];
    email = json["email"];
    bankAcc = json["bank_acc"];
    bankName = json["bank_name"];
    location =
        json["location"] == null ? null : Location.fromJson(json["location"]);
    locationUrl = json["location_url"];
    basePrice = json["base_price"];
    pointsPerVisit = json["points_per_visit"];
    totalPoints = json["total_points"];
    createdAt = json["created_at"];
    updatedAt = json["updated_at"];
    isDeleted = json["is_deleted"];
    ownerId = json["owner_id"];
    gallery = json["gallery"] == null
        ? null
        : (json["gallery"] as List).map((e) => Gallery.fromJson(e)).toList();
    province =
        json["province"] == null ? null : Province.fromJson(json["province"]);
    branches = json["branches"] == null
        ? null
        : (json["branches"] as List).map((e) => Branches.fromJson(e)).toList();
    schedules = json["schedules"] == null
        ? null
        : (json["schedules"] as List)
            .map((e) => Schedules.fromJson(e))
            .toList();
    openingDay = json["opening_day"];
    openingDayAr = json["opening_day_ar"];
  }

  static List<IndividualGym> fromList(List<Map<String, dynamic>> list) {
    return list.map(IndividualGym.fromJson).toList();
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> _data = <String, dynamic>{};
    _data["id"] = id;
    _data["name"] = name;
    _data["name_ar"] = nameAr;
    _data["description"] = description;
    _data["description_ar"] = descriptionAr;
    _data["gender"] = gender;
    _data["is_mixed"] = isMixed;
    _data["gym_type"] = gymType;
    _data["province_id"] = provinceId;
    _data["logo_path"] = logoPath;
    _data["phone"] = phone;
    _data["email"] = email;
    _data["bank_acc"] = bankAcc;
    _data["bank_name"] = bankName;
    if (location != null) {
      _data["location"] = location?.toJson();
    }
    _data["location_url"] = locationUrl;
    _data["base_price"] = basePrice;
    _data["points_per_visit"] = pointsPerVisit;
    _data["total_points"] = totalPoints;
    _data["created_at"] = createdAt;
    _data["updated_at"] = updatedAt;
    _data["is_deleted"] = isDeleted;
    _data["owner_id"] = ownerId;
    if (gallery != null) {
      _data["gallery"] = gallery?.map((e) => e.toJson()).toList();
    }
    if (province != null) {
      _data["province"] = province?.toJson();
    }
    _data["opening_day"] = openingDay;
    _data["opening_day_ar"] = openingDayAr;
    return _data;
  }
}

class Province {
  int? id;
  int? governorateId;
  String? name;
  String? nameAr;
  String? createdAt;
  String? updatedAt;
  Governorate? governorate;

  Province(
      {this.id,
      this.governorateId,
      this.name,
      this.nameAr,
      this.createdAt,
      this.updatedAt,
      this.governorate});

  Province.fromJson(Map<String, dynamic> json) {
    id = json["id"];
    governorateId = json["governorate_id"];
    name = json["name"];
    nameAr = json["name_ar"];
    createdAt = json["created_at"];
    updatedAt = json["updated_at"];
    governorate = json["governorate"] == null
        ? null
        : Governorate.fromJson(json["governorate"]);
  }

  static List<Province> fromList(List<Map<String, dynamic>> list) {
    return list.map(Province.fromJson).toList();
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> _data = <String, dynamic>{};
    _data["id"] = id;
    _data["governorate_id"] = governorateId;
    _data["name"] = name;
    _data["name_ar"] = nameAr;
    _data["created_at"] = createdAt;
    _data["updated_at"] = updatedAt;
    if (governorate != null) {
      _data["governorate"] = governorate?.toJson();
    }
    return _data;
  }
}

class Governorate {
  int? id;
  String? name;
  String? nameAr;
  String? createdAt;
  String? updatedAt;

  Governorate(
      {this.id, this.name, this.nameAr, this.createdAt, this.updatedAt});

  Governorate.fromJson(Map<String, dynamic> json) {
    id = json["id"];
    name = json["name"];
    nameAr = json["name_ar"];
    createdAt = json["created_at"];
    updatedAt = json["updated_at"];
  }

  static List<Governorate> fromList(List<Map<String, dynamic>> list) {
    return list.map(Governorate.fromJson).toList();
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> _data = <String, dynamic>{};
    _data["id"] = id;
    _data["name"] = name;
    _data["name_ar"] = nameAr;
    _data["created_at"] = createdAt;
    _data["updated_at"] = updatedAt;
    return _data;
  }
}

class Gallery {
  int? id;
  String? imagePath;
  String? gymId;
  String? createdAt;
  String? updatedAt;

  Gallery(
      {this.id, this.imagePath, this.gymId, this.createdAt, this.updatedAt});

  Gallery.fromJson(Map<String, dynamic> json) {
    id = json["id"];
    imagePath = json["image_path"];
    gymId = json["gym_id"];
    createdAt = json["created_at"];
    updatedAt = json["updated_at"];
  }

  static List<Gallery> fromList(List<Map<String, dynamic>> list) {
    return list.map(Gallery.fromJson).toList();
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> _data = <String, dynamic>{};
    _data["id"] = id;
    _data["image_path"] = imagePath;
    _data["gym_id"] = gymId;
    _data["created_at"] = createdAt;
    _data["updated_at"] = updatedAt;
    return _data;
  }
}

class Location {
  double? lat;
  double? lng;

  Location({this.lat, this.lng});

  Location.fromJson(Map<String, dynamic> json) {
    lat = json["lat"];
    lng = json["lng"];
  }

  static List<Location> fromList(List<Map<String, dynamic>> list) {
    return list.map(Location.fromJson).toList();
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> _data = <String, dynamic>{};
    _data["lat"] = lat;
    _data["lng"] = lng;
    return _data;
  }
}

class Branches {
  int? id;
  String? gymId;
  String? name;
  String? nameAr;
  String? locationUrl;
  String? createdAt;
  String? updatedAt;

  Branches(
      {this.id,
      this.gymId,
      this.name,
      this.nameAr,
      this.locationUrl,
      this.createdAt,
      this.updatedAt});

  Branches.fromJson(Map<String, dynamic> json) {
    id = json["id"];
    gymId = json["gym_id"];
    name = json["name"];
    nameAr = json["name_ar"];
    locationUrl = json["location_url"];
    createdAt = json["created_at"];
    updatedAt = json["updated_at"];
  }

  static List<Branches> fromList(List<Map<String, dynamic>> list) {
    return list.map(Branches.fromJson).toList();
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> _data = <String, dynamic>{};
    _data["id"] = id;
    _data["gym_id"] = gymId;
    _data["name"] = name;
    _data["name_ar"] = nameAr;
    _data["location_url"] = locationUrl;
    _data["created_at"] = createdAt;
    _data["updated_at"] = updatedAt;
    return _data;
  }
}

class Schedules {
  int? id;
  String? gymId;
  String? dayOfWeek;
  String? dayOfWeekAr;

  List<String>? startTime;
  bool? isRecurring;
  String? createdAt;
  String? updatedAt;

  Schedules({
    this.id,
    this.gymId,
    this.dayOfWeek,
    this.dayOfWeekAr,
    this.startTime,
    this.isRecurring,
    this.createdAt,
    this.updatedAt,
  });

  Schedules.fromJson(Map<String, dynamic> json) {
    id = json["id"];
    gymId = json["gym_id"];
    dayOfWeek = json["day_of_week"];
    dayOfWeekAr = json["day_of_week_ar"];

    try {
      startTime = json["start_time"] == null
          ? null
          : (json["start_time"] as List).map((e) => e.toString()).toList();
    } catch (e) {
      startTime = json["start_time"] == null
          ? null
          : (jsonDecode(json["start_time"]) as List)
              .map((e) => e.toString())
              .toList();
    }

    isRecurring = json["is_recurring"];
    createdAt = json["created_at"];
    updatedAt = json["updated_at"];
  }

  static List<Schedules> fromList(List<Map<String, dynamic>> list) {
    return list.map(Schedules.fromJson).toList();
  }
}

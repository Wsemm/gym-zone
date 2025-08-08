
class Dart {
  String? message;
  List<Data>? data;

  Dart({this.message, this.data});

  Dart.fromJson(Map<String, dynamic> json) {
    message = json["message"];
    data = json["data"] == null ? null : (json["data"] as List).map((e) => Data.fromJson(e)).toList();
  }

  static List<Dart> fromList(List<Map<String, dynamic>> list) {
    return list.map(Dart.fromJson).toList();
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> _data = <String, dynamic>{};
    _data["message"] = message;
    if(data != null) {
      _data["data"] = data?.map((e) => e.toJson()).toList();
    }
    return _data;
  }
}

class Data {
  int? id;
  String? amount;
  int? days;
  String? hexColor;
  String? gender;
  String? gymId;
  String? createdAt;
  String? updatedAt;
  double? totalAmount;
  int? basePrice;

  Data({this.id, this.amount, this.days, this.hexColor, this.gender, this.gymId, this.createdAt, this.updatedAt, this.totalAmount, this.basePrice});

  Data.fromJson(Map<String, dynamic> json) {
    id = json["id"];
    amount = json["amount"];
    days = json["days"];
    hexColor = json["hex_color"];
    gender = json["gender"];
    gymId = json["gym_id"];
    createdAt = json["created_at"];
    updatedAt = json["updated_at"];
    totalAmount = json["total_amount"];
    basePrice = json["base_price"];
  }

  static List<Data> fromList(List<Map<String, dynamic>> list) {
    return list.map(Data.fromJson).toList();
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> _data = <String, dynamic>{};
    _data["id"] = id;
    _data["amount"] = amount;
    _data["days"] = days;
    _data["hex_color"] = hexColor;
    _data["gender"] = gender;
    _data["gym_id"] = gymId;
    _data["created_at"] = createdAt;
    _data["updated_at"] = updatedAt;
    _data["total_amount"] = totalAmount;
    _data["base_price"] = basePrice;
    return _data;
  }
}
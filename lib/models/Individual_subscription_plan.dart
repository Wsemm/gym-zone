class IndividualSubscriptionPlan {
  String? message;
  List<IndivdualGymData>? data;

  IndividualSubscriptionPlan({this.message, this.data});

  IndividualSubscriptionPlan.fromJson(Map<String, dynamic> json) {
    message = json["message"];
    data = json["data"] == null
        ? null
        : (json["data"] as List)
            .map((e) => IndivdualGymData.fromJson(e))
            .toList();
  }

  static List<IndividualSubscriptionPlan> fromList(
      List<Map<String, dynamic>> list) {
    return list.map(IndividualSubscriptionPlan.fromJson).toList();
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> _data = <String, dynamic>{};
    _data["message"] = message;
    if (data != null) {
      _data["data"] = data?.map((e) => e.toJson()).toList();
    }
    return _data;
  }
}

class IndivdualGymData {
  int? id;
  String? amount;
  int? days;
  String? hexColor;
  String? gender;
  String? gymId;
  String? createdAt;
  String? updatedAt;
  String? title;
  String? titleAr;
  double? totalAmount;
  int? basePrice;
  int? totalPrice;

  IndivdualGymData(
      {this.id,
      this.amount,
      this.days,
      this.hexColor,
      this.gender,
      this.gymId,
      this.createdAt,
      this.updatedAt,
      this.totalAmount,
      this.basePrice,
      this.totalPrice,
      this.title,
      this.titleAr});

  IndivdualGymData.fromJson(Map<String, dynamic> json) {
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
    totalPrice = json["total_price"];
    title = json["title"];
    titleAr = json["title_ar"];
  }

  static List<IndivdualGymData> fromList(List<Map<String, dynamic>> list) {
    return list.map(IndivdualGymData.fromJson).toList();
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
    _data["total_price"] = totalPrice;
    _data["title"] = title;
    _data["title_ar"] = titleAr;
    return _data;
  }

  factory IndivdualGymData.fake() {
    return IndivdualGymData(
        id: 1,
        amount: "50",
        days: 30,
        hexColor: "#FF5733",
        gender: "male",
        gymId: "gym123",
        createdAt: "2024-01-01T00:00:00Z",
        updatedAt: "2024-01-01T00:00:00Z",
        totalAmount: 29.99,
        basePrice: 25,
        totalPrice: 25,
        title: "title",
        titleAr: "titleAr");
  }
}

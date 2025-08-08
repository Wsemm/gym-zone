class OffersModel {
  OffersModel({
    required this.message,
    required this.offers,
  });

  final String? message;
  final List<Offer> offers;

  factory OffersModel.fromJson(Map<String, dynamic> json){
    return OffersModel(
      message: json["message"],
      offers: json["offers"] == null ? [] : List<Offer>.from(json["offers"]!.map((x) => Offer.fromJson(x))),
    );
  }

  Map<String, dynamic> toJson() => {
    "message": message,
    "offers": offers.map((x) => x?.toJson()).toList(),
  };

  @override
  String toString(){
    return "$message, $offers, ";
  }

}

class Offer {
  Offer({
    required this.id,
    required this.companyName,
    required this.description,
    required this.discount,
    required this.logoPath,
    required this.coverPath,
    required this.phoneNo,
    required this.qrType,
    required this.qrUrl,
    required this.latitude,
    required this.longitude,
    required this.distanceKm,
  });

  final int? id;
  final String? companyName;
  final String? description;
  final int? discount;
  final String? logoPath;
  final String? coverPath;
  final String? phoneNo;
  final String? qrType;
  final String? qrUrl;
  final double? latitude;
  final double? longitude;
  final double? distanceKm;

  factory Offer.fromJson(Map<String, dynamic> json){
    return Offer(
      id: json["id"],
      companyName: json["company_name"],
      description: json["description"],
      discount: json["discount"],
      logoPath: json["logo_path"],
      coverPath: json["cover_path"],
      phoneNo: json["phone_no"],
      qrType: json["qr_type"],
      qrUrl: json["qr_url"],
      latitude: json["latitude"],
      longitude: json["longitude"],
      distanceKm: json["distance_km"],
    );
  }

  Map<String, dynamic> toJson() => {
    "id": id,
    "company_name": companyName,
    "description": description,
    "discount": discount,
    "logo_path": logoPath,
    "cover_path": coverPath,
    "phone_no": phoneNo,
    "qr_type": qrType,
    "qr_url": qrUrl,
    "latitude": latitude,
    "longitude": longitude,
    "distance_km": distanceKm,
  };

  @override
  String toString(){
    return "$id, $companyName, $description, $discount, $logoPath, $coverPath, $phoneNo, $qrType, $qrUrl, $latitude, $longitude, $distanceKm, ";
  }

}

/*
{
	"message": "Offers fetched successfully",
	"offers": [
		{
			"id": 1,
			"company_name": "Storex",
			"description": "Our summer offer is still available",
			"discount": 4,
			"logo_path": "images/offer-company-logo/1724230453_66c5ab35c6631.png",
			"cover_path": "images/offer-company-cover/1724230453_66c5ab35d1d7d.png",
			"phone_no": "98123438",
			"qr_type": "link",
			"qr_url": "https://pixllmall.com",
			"latitude": 58.2886498,
			"longitude": 23.6012525,
			"distance_km": 4.73
		},
		{
			"id": 4,
			"company_name": "Pixel",
			"description": "uhu",
			"discount": 9,
			"logo_path": "images/offer-company-logo/1724315894_66c6f8f699315.png",
			"cover_path": "images/offer-company-cover/1724315894_66c6f8f69c1b0.png",
			"phone_no": "98675423",
			"qr_type": "image",
			"qr_url": "https://gym-zones.com/storage/app/public/images/offer-image/1724315894_66c6f8f6877ae.jpg",
			"latitude": 58.2886498,
			"longitude": 23.6012525,
			"distance_km": 4.73
		}
	]
}*/
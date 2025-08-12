import 'province.dart';

class Gym {
  final String id;
  final String logoPath;
  final String name;
  final String nameAr;
  final String gender;
  final bool isMixed;
  final String locationUrl;
  final Province province;
  final List<String>? gallery;
  final String? description;
  final String? descriptionAr;
  final String? gymType;

  Gym({
    required this.id,
    required this.logoPath,
    required this.name,
    required this.nameAr,
    required this.gender,
    required this.isMixed,
    required this.locationUrl,
    required this.province,
    this.gallery,
    this.description,
    this.descriptionAr,
    this.gymType,
  });

  factory Gym.fromJson(Map<String, dynamic> json) {
    return Gym(
      id: json['id'],
      name: json['name'],
      nameAr: json['name_ar'],
      gender: json['gender'],
      isMixed: json['is_mixed'] == 0 ? false : true,
      locationUrl: json['location_url'],
      province: Province.fromJson(json['province']),
      description: json['description'],
      descriptionAr: json['description_ar'],
      logoPath: json['logo_path'],
      gallery: json['gallery'] == null
          ? null
          : List<String>.from(
              json['gallery'].map((image) => image['image_path'])),
      gymType: json['gym_type'],
    );
  }
}

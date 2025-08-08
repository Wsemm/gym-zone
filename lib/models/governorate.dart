import 'province.dart';

class Governorate {
  final int id;
  final String name;
  final String nameAr;
  final List<Province>? provinces;

  Governorate({
    required this.id,
    required this.name,
    required this.nameAr,
    this.provinces,
  });

  factory Governorate.fromJson(Map<String, dynamic> json) {
    return Governorate(
      id: json['id'],
      name: json['name'],
      nameAr: json['name_ar'],
      provinces: json['provinces'] == null
          ? null
          : (json['provinces'] as List)
              .map((e) => Province.fromJson(e))
              .toList(),
    );
  }
}

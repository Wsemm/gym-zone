import 'governorate.dart';

class Province {
  final int id;
  final String name;
  final String nameAr;
  final Governorate? governorate;

  Province({
    required this.id,
    required this.name,
    required this.nameAr,
    this.governorate,
  });

  factory Province.fromJson(Map<String, dynamic> json) {
    return Province(
      id: json['id'],
      name: json['name'],
      nameAr: json['name_ar'],
      governorate: json['governorate'] == null
          ? null
          : Governorate.fromJson(json['governorate']),
    );
  }
}

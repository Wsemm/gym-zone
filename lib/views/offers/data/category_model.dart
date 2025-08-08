class CategoriesModel {
  CategoriesModel({
    required this.message,
    required this.categories,
  });

  final String? message;
  final List<Category> categories;

  factory CategoriesModel.fromJson(Map<String, dynamic> json){
    return CategoriesModel(
      message: json["message"],
      categories: json["categories"] == null ? [] : List<Category>.from(json["categories"]!.map((x) => Category.fromJson(x))),
    );
  }

  Map<String, dynamic> toJson() => {
    "message": message,
    "categories": categories.map((x) => x?.toJson()).toList(),
  };

  @override
  String toString(){
    return "$message, $categories, ";
  }

}

class Category {
  Category({
    required this.id,
    required this.name,
    required this.nameAr,
    required this.iconPath,
    required this.createdAt,
    required this.updatedAt,
  });

  final int? id;
  final String? name;
  final String? nameAr;
  final String? iconPath;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  factory Category.fromJson(Map<String, dynamic> json){
    return Category(
      id: json["id"],
      name: json["name"],
      nameAr: json["name_ar"],
      iconPath: json["icon_path"],
      createdAt: DateTime.tryParse(json["created_at"] ?? ""),
      updatedAt: DateTime.tryParse(json["updated_at"] ?? ""),
    );
  }

  Map<String, dynamic> toJson() => {
    "id": id,
    "name": name,
    "name_ar": nameAr,
    "icon_path": iconPath,
    "created_at": createdAt?.toIso8601String(),
    "updated_at": updatedAt?.toIso8601String(),
  };

  @override
  String toString(){
    return "$id, $name, $nameAr, $iconPath, $createdAt, $updatedAt, ";
  }

}

/*
{
	"message": "Categories fetched successfully",
	"categories": [
		{
			"id": 1,
			"name": "Shop",
			"name_ar": "محل",
			"icon_path": "images/offer-categories/1724307456_66c6d8006618f.png",
			"created_at": "2024-08-22 10:17:36",
			"updated_at": "2024-08-22 10:17:36"
		}
	]
}*/
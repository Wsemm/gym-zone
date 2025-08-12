import 'package:gym_zones/common/constants/my_enum.dart';

class User {
  final String id;
  final String firstname;
  final String lastname;
  final String gender;
  final String email;
  final String phoneNumber;
  final String countryCode;
  final DateTime? subscribedAt;
  final DateTime? subscribedAtIndividual;
  final DateTime? subscriptionExpiresAt;
  final DateTime? subscriptionExpiresAtIndividual;
  final String? gymIdIndividual;
  final int totalPoints;
  final int thisMonthPoints;
  final String? imagePath;
  final DateTime? imageUpdatedAt;
  final bool showImageToOthers;
  final String? bio;
  final String? height;
  final String? weight;
  final String? age;
  final String? subscriptionType;
  final String? subscriptionStatus;
  final String? gymName;
  final String? gymNameAr;
  final int? individualPlanDays;
  final String? gymImage;
  final String? individualPlanAmount;

  User({
    required this.id,
    required this.firstname,
    required this.lastname,
    required this.gender,
    required this.email,
    required this.phoneNumber,
    required this.countryCode,
    required this.subscribedAt,
    required this.subscribedAtIndividual,
    required this.subscriptionExpiresAt,
    required this.subscriptionExpiresAtIndividual,
    required this.gymIdIndividual,
    required this.totalPoints,
    required this.thisMonthPoints,
    required this.imagePath,
    required this.imageUpdatedAt,
    required this.showImageToOthers,
    this.bio,
    required this.height,
    required this.weight,
    required this.age,
    required this.subscriptionType,
    required this.subscriptionStatus,
    this.gymName,
    this.gymNameAr,
    this.individualPlanDays,
    this.gymImage,
    this.individualPlanAmount,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['id'],
      firstname: json['firstname'],
      lastname: json['lastname'],
      gender: json['gender'],
      email: json['email'],
      phoneNumber: json['phone'] ?? "",
      countryCode: json['country_code'],
      subscribedAt: json['subscribed_at'] == null
          ? null
          : DateTime.parse(json['subscribed_at']).toLocal(),
      subscriptionExpiresAt: json['subscription_expires_at'] == null
          ? null
          : DateTime.parse(json['subscription_expires_at']).toLocal(),
      subscribedAtIndividual: json['subscribed_at_invdiable'] == null
          ? null
          : DateTime.parse(json['subscribed_at_invdiable']).toLocal(),
      subscriptionExpiresAtIndividual:
          json['subscription_expires_at_invdiable'] == null
              ? null
              : DateTime.parse(json['subscription_expires_at_invdiable'])
                  .toLocal(),
      totalPoints: json['total_points'],
      gymIdIndividual: json['gym_id_invdiable'],
      thisMonthPoints: json['this_month_points'],
      imagePath: json['image_path'],
      imageUpdatedAt: json['image_updated_at'] == null
          ? null
          : DateTime.parse(json['image_updated_at']).toLocal(),
      showImageToOthers: json['show_image_to_others'],
      bio: json['bio'],
      height: json['height'],
      weight: json['weight'],
      age: json['age'],
      subscriptionType: json['subscription_type'],
      subscriptionStatus: json['subscription_state'],
      gymName: json['gym_name'],
      gymNameAr: json['gym_name_ar'],
      individualPlanDays: json['individual_plan_days'],
      gymImage: json['gym_image'],
      individualPlanAmount: json['individual_plan_amount'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'firstname': firstname,
      'lastname': lastname,
      'gender': gender,
      'email': email,
      'phone': phoneNumber,
      'country_code': countryCode,
      'subscribed_at': subscribedAt?.toIso8601String(),
      'subscription_expires_at': subscriptionExpiresAt?.toIso8601String(),
      'subscribed_at_invdiable': subscribedAtIndividual?.toIso8601String(),
      'subscription_expires_at_invdiable':
          subscriptionExpiresAtIndividual?.toIso8601String(),
      'gym_id_invdiable': gymIdIndividual,
      'total_points': totalPoints,
      'this_month_points': thisMonthPoints,
      'image_path': imagePath,
      'image_updated_at': imageUpdatedAt?.toIso8601String(),
      'show_image_to_others': showImageToOthers,
      'bio': bio,
      'height': height,
      'weight': weight,
      'age': age,
      'subscription_type': subscriptionType,
      'subscription_state': subscriptionStatus,
      'gym_name': gymName,
      'gym_name_ar': gymNameAr,
      'individual_plan_days': individualPlanDays,
      'gym_image': gymImage,
      'individual_plan_amount': individualPlanAmount,
    };
  }

  String get fullname => '$firstname $lastname';

  bool get hasSubscription =>
      subscribedAt != null && subscriptionExpiresAt != null;

  bool get hasIndividualSubscription =>
      subscriptionType == SubscriptionType.individual.name ||
      subscriptionType == SubscriptionType.both.name;

  bool get isSubscriptionExpired =>
      hasSubscription && subscriptionExpiresAt!.isBefore(DateTime.now());

  bool get isIndividualSubscriptionExpired =>
      hasIndividualSubscription &&
      subscriptionExpiresAtIndividual!.isBefore(DateTime.now());

  int get subscriptionValidityDaysLeft {
    if (!hasSubscription) return 0;

    final daysLeft = subscriptionExpiresAt!.difference(DateTime.now()).inDays;

    return daysLeft > 0 ? daysLeft : 0;
  }

  int get individualSubscriptionValidityDaysLeft {
    if (!hasIndividualSubscription) return 0;

    final daysLeft =
        subscriptionExpiresAtIndividual!.difference(DateTime.now()).inDays;

    return daysLeft > 0 ? daysLeft : 0;
  }

  double get subscriptionValidityPercentage {
    if (!hasSubscription) return 0.0;

    final totalDays = subscriptionExpiresAt!.difference(subscribedAt!).inDays;
    final passedDays = DateTime.now().difference(subscribedAt!).inDays;

    if (passedDays > totalDays) return 1.0;

    return passedDays / totalDays;
  }

  double get invdiableSubscriptionValidityPercentage {
    if (!hasIndividualSubscription) return 0.0;

    final totalDays = subscriptionExpiresAtIndividual!
        .difference(subscribedAtIndividual!)
        .inDays;
    final passedDays =
        DateTime.now().difference(subscribedAtIndividual!).inDays;

    if (passedDays > totalDays) return 1.0;

    return passedDays / totalDays;
  }

  String get individualSubscriptionPlanDays => hasIndividualSubscription
      ? subscriptionExpiresAtIndividual!
          .difference(subscribedAtIndividual!)
          .inDays
          .toString()
      : subscriptionValidityDaysLeft.toString();

  bool get canUpdateImage {
    final now = DateTime.now();
    final thirtyDaysAgo = now.subtract(const Duration(days: 30));

    return imageUpdatedAt == null || imageUpdatedAt!.isBefore(thirtyDaysAgo);
  }

  factory User.fake() {
    return User(
      id: "0",
      firstname: "",
      lastname: "",
      gender: "",
      email: "",
      phoneNumber: "",
      countryCode: "",
      subscribedAt: null,
      subscriptionExpiresAt: null,
      totalPoints: 0,
      thisMonthPoints: 0,
      imagePath: null,
      subscribedAtIndividual: null,
      subscriptionExpiresAtIndividual: null,
      gymIdIndividual: null,
      imageUpdatedAt: null,
      showImageToOthers: false,
      bio: "",
      height: "0",
      weight: "0",
      age: "0",
      subscriptionType: "",
      subscriptionStatus: "",
      gymName: "",
      gymNameAr: "",
      individualPlanDays: 0,
      gymImage: "",
      individualPlanAmount: "",
    );
  }
}

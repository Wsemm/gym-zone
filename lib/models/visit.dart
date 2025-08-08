import 'gym.dart';
import 'user.dart';
import 'province.dart';
import 'governorate.dart';

class Visit {
  final int id;
  final User user;
  final Gym gym;
  final DateTime timestamp;

  Visit({
    required this.id,
    required this.user,
    required this.gym,
    required this.timestamp,
  });

  factory Visit.fromJson(Map<String, dynamic> json) {
    return Visit(
      id: json['id'],
      user: User.fromJson(json['user']),
      gym: Gym.fromJson(json['gym']),
      timestamp: DateTime.parse(json['created_at']).toLocal(),
    );
  }

  // Generate fake visit data for testing
  static List<Visit> generateFakeVisits() {
    // Create fake users
    final fakeUsers = [
      User(
        id: '1',
        firstname: 'John',
        lastname: 'Doe',
        email: 'john@example.com',
        phoneNumber: '+1234567890',
        countryCode: '+1',
        gender: 'male',
        totalPoints: 150,
        thisMonthPoints: 25,
        imagePath: null,
        imageUpdatedAt: null,
        showImageToOthers: true,
        subscribedAt: DateTime.now().subtract(Duration(days: 30)),
        subscriptionExpiresAt: DateTime.now().add(Duration(days: 335)),
        height: '175',
        subscribedAtIndividual: DateTime.now().subtract(Duration(days: 30)),
        subscriptionExpiresAtIndividual:
            DateTime.now().add(Duration(days: 335)),
        gymIdIndividual: '1',
        weight: '70',
        age: '25',
        subscriptionType: 'premium',
        subscriptionStatus: 'active',
      ),
      User(
        id: '2',
        firstname: 'Jane',
        lastname: 'Smith',
        email: 'jane@example.com',
        phoneNumber: '+1234567891',
        countryCode: '+1',
        gender: 'female',
        totalPoints: 200,
        thisMonthPoints: 30,
        imagePath: null,
        imageUpdatedAt: null,
        showImageToOthers: true,
        subscribedAt: DateTime.now().subtract(Duration(days: 25)),
        subscriptionExpiresAt: DateTime.now().add(Duration(days: 340)),
        height: '165',
        subscribedAtIndividual: DateTime.now().subtract(Duration(days: 30)),
        subscriptionExpiresAtIndividual:
            DateTime.now().add(Duration(days: 335)),
        gymIdIndividual: '1',
        weight: '55',
        age: '28',
        subscriptionType: 'premium',
        subscriptionStatus: 'active',
      ),
      User(
        id: '3',
        firstname: 'Ahmed',
        lastname: 'Hassan',
        email: 'ahmed@example.com',
        phoneNumber: '+1234567892',
        countryCode: '+20',
        gender: 'male',
        totalPoints: 75,
        thisMonthPoints: 12,
        imagePath: null,
        imageUpdatedAt: null,
        showImageToOthers: true,
        subscribedAt: DateTime.now().subtract(Duration(days: 15)),
        subscriptionExpiresAt: DateTime.now().add(Duration(days: 350)),
        height: '180',
        subscribedAtIndividual: DateTime.now().subtract(Duration(days: 30)),
        subscriptionExpiresAtIndividual:
            DateTime.now().add(Duration(days: 335)),
        gymIdIndividual: '1',
        weight: '80',
        age: '30',
        subscriptionType: 'basic',
        subscriptionStatus: 'active',
      ),
    ];

    // Create fake provinces and governorates
    final fakeProvince1 = Province(
      id: 1,
      name: 'Cairo',
      nameAr: 'القاهرة',
      governorate: Governorate(
        id: 1,
        name: 'Cairo',
        nameAr: 'القاهرة',
        provinces: [],
      ),
    );

    final fakeProvince2 = Province(
      id: 2,
      name: 'Giza',
      nameAr: 'الجيزة',
      governorate: Governorate(
        id: 2,
        name: 'Giza',
        nameAr: 'الجيزة',
        provinces: [],
      ),
    );

    final fakeProvince3 = Province(
      id: 3,
      name: 'Alexandria',
      nameAr: 'الإسكندرية',
      governorate: Governorate(
        id: 3,
        name: 'Alexandria',
        nameAr: 'الإسكندرية',
        provinces: [],
      ),
    );

    // Create fake gyms
    final fakeGyms = [
      Gym(
        id: '1',
        name: 'Fitness First',
        nameAr: 'فيتنس فيرست',
        gender: 'male',
        isMixed: false,
        locationUrl: 'https://maps.google.com',
        province: fakeProvince1,
        logoPath: 'https://placehold.co/600x400/000000/FFFFFF.png',
        description: 'Premium fitness center',
        descriptionAr: 'مركز لياقة بدنية متميز',
        gallery: ['assets/images/gym1_1.jpg', 'assets/images/gym1_2.jpg'],
      ),
      Gym(
        id: '2',
        name: 'Ladies Gym',
        nameAr: 'صالة السيدات',
        gender: 'female',
        isMixed: false,
        locationUrl: 'https://maps.google.com',
        province: fakeProvince2,
        logoPath: 'https://placehold.co/600x400/000000/FFFFFF.png',
        description: 'Exclusive ladies fitness center',
        descriptionAr: 'مركز لياقة بدنية حصري للسيدات',
        gallery: ['assets/images/gym2_1.jpg', 'assets/images/gym2_2.jpg'],
      ),
      Gym(
        id: '3',
        name: 'Mixed Fitness',
        nameAr: 'لياقة مختلطة',
        gender: 'mixed',
        isMixed: true,
        locationUrl: 'https://maps.google.com',
        province: fakeProvince3,
        logoPath: 'https://placehold.co/600x400/000000/FFFFFF.png',
        description: 'Mixed gender fitness center',
        descriptionAr: 'مركز لياقة بدنية مختلط',
        gallery: ['assets/images/gym3_1.jpg', 'assets/images/gym3_2.jpg'],
      ),
      Gym(
        id: '4',
        name: 'Power Gym',
        nameAr: 'صالة القوة',
        gender: 'male',
        isMixed: false,
        locationUrl: 'https://maps.google.com',
        province: fakeProvince1,
        logoPath: 'https://placehold.co/600x400/000000/FFFFFF.png',
        description: 'Strength training focused gym',
        descriptionAr: 'صالة تركز على تدريب القوة',
        gallery: ['assets/images/gym4_1.jpg', 'assets/images/gym4_2.jpg'],
      ),
      Gym(
        id: '5',
        name: 'Elegance Ladies',
        nameAr: 'أناقة السيدات',
        gender: 'female',
        isMixed: false,
        locationUrl: 'https://maps.google.com',
        province: fakeProvince2,
        logoPath: 'https://placehold.co/600x400/000000/FFFFFF.png',
        description: 'Elegant ladies fitness center',
        descriptionAr: 'مركز لياقة بدنية أنيق للسيدات',
        gallery: ['assets/images/gym5_1.jpg', 'assets/images/gym5_2.jpg'],
      ),
    ];

    // Generate fake visits with different timestamps
    final now = DateTime.now();
    final fakeVisits = <Visit>[];

    // John's visits
    fakeVisits.add(Visit(
      id: 1,
      user: fakeUsers[0],
      gym: fakeGyms[0],
      timestamp: now.subtract(Duration(hours: 2)),
    ));

    fakeVisits.add(Visit(
      id: 2,
      user: fakeUsers[0],
      gym: fakeGyms[3],
      timestamp: now.subtract(Duration(days: 1)),
    ));

    fakeVisits.add(Visit(
      id: 3,
      user: fakeUsers[0],
      gym: fakeGyms[0],
      timestamp: now.subtract(Duration(days: 3)),
    ));

    // Jane's visits
    fakeVisits.add(Visit(
      id: 4,
      user: fakeUsers[1],
      gym: fakeGyms[1],
      timestamp: now.subtract(Duration(hours: 1)),
    ));

    fakeVisits.add(Visit(
      id: 5,
      user: fakeUsers[1],
      gym: fakeGyms[4],
      timestamp: now.subtract(Duration(days: 2)),
    ));

    fakeVisits.add(Visit(
      id: 6,
      user: fakeUsers[1],
      gym: fakeGyms[2],
      timestamp: now.subtract(Duration(days: 4)),
    ));

    fakeVisits.add(Visit(
      id: 7,
      user: fakeUsers[1],
      gym: fakeGyms[1],
      timestamp: now.subtract(Duration(days: 6)),
    ));

    // Ahmed's visits
    fakeVisits.add(Visit(
      id: 8,
      user: fakeUsers[2],
      gym: fakeGyms[0],
      timestamp: now.subtract(Duration(hours: 3)),
    ));

    fakeVisits.add(Visit(
      id: 9,
      user: fakeUsers[2],
      gym: fakeGyms[3],
      timestamp: now.subtract(Duration(days: 5)),
    ));

    fakeVisits.add(Visit(
      id: 10,
      user: fakeUsers[2],
      gym: fakeGyms[0],
      timestamp: now.subtract(Duration(days: 8)),
    ));

    // Add some older visits for variety
    fakeVisits.add(Visit(
      id: 11,
      user: fakeUsers[0],
      gym: fakeGyms[0],
      timestamp: now.subtract(Duration(days: 10)),
    ));

    fakeVisits.add(Visit(
      id: 12,
      user: fakeUsers[1],
      gym: fakeGyms[1],
      timestamp: now.subtract(Duration(days: 12)),
    ));

    fakeVisits.add(Visit(
      id: 13,
      user: fakeUsers[2],
      gym: fakeGyms[2],
      timestamp: now.subtract(Duration(days: 15)),
    ));

    return fakeVisits;
  }

  // Generate fake visits for a specific user
  static List<Visit> generateFakeVisitsForUser(User user) {
    final allVisits = generateFakeVisits();
    return allVisits.where((visit) => visit.user.id == user.id).toList();
  }

  // Generate fake visits for a specific gym
  static List<Visit> generateFakeVisitsForGym(String gymId) {
    final allVisits = generateFakeVisits();
    return allVisits.where((visit) => visit.gym.id == gymId).toList();
  }

  // Generate fake visits within a date range
  static List<Visit> generateFakeVisitsInDateRange(
      DateTime start, DateTime end) {
    final allVisits = generateFakeVisits();
    return allVisits
        .where((visit) =>
            visit.timestamp.isAfter(start) && visit.timestamp.isBefore(end))
        .toList();
  }
}

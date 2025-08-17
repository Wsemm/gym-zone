class Api {
  // static const BASE_URL = 'http://192.168.100.217:8000'; // Local (Android) => Office
  // static const BASE_URL = 'http://localhost:8000'; // Local (Android) => Office
  static const BASE_URL = 'https://gym-zones.com/test'; // Testing
  // static const BASE_URL = 'https://gym-zones.com'; // Production

  static const API_URL = '$BASE_URL/api/v3/';
  static const API_URLV2 = '$BASE_URL/api/v2/';
  static const ads = '${API_URL}ads';
  static const isEmailRegistered = '${API_URL}auth/isEmailRegistered';

  // static const IMAGE_PREFIX = '$BASE_URL/storage/'; // Local
  // static const IMAGE_PREFIX = '$BASE_URL/storage/app/public/'; // Testing
  static const IMAGE_PREFIX = '$BASE_URL/public/storage/'; // Production
  static const IMAGE_PREFIX_Test = '$BASE_URL/storage/app/public/'; // Testing
}

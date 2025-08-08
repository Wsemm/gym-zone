import 'package:firebase_auth/firebase_auth.dart';
import 'package:sign_in_with_apple/sign_in_with_apple.dart';
import 'package:get_storage/get_storage.dart';

class FireBaseAuthService {
  final FirebaseAuth _fireBaseAuth = FirebaseAuth.instance;

  Stream<User?> authStateChanges() => _fireBaseAuth.authStateChanges();

  String getUserEmail() => _fireBaseAuth.currentUser?.email ?? "User";

  dynamic _lastAppleCredential;

  Future<Map<String, dynamic>?> signInWithApple() async {
    try {
      print("Starting Apple Sign-In process...");
      final isAvailable = await SignInWithApple.isAvailable();
      if (!isAvailable) {
        print("Apple Sign-In is not available on this device");
        return null;
      }

      print("Apple Sign-In is available, getting credentials...");

      final appleCredential = await SignInWithApple.getAppleIDCredential(
        scopes: [
          AppleIDAuthorizationScopes.email,
          AppleIDAuthorizationScopes.fullName,
        ],
      );

      print("Apple credentials obtained: ${appleCredential.email}");

      _lastAppleCredential = appleCredential;

      if (appleCredential.identityToken == null) {
        print("Apple Sign-In failed: No identity token received");
        return null;
      }

      print("Creating Firebase credential...");

      final oAuthCredential = OAuthProvider("apple.com").credential(
        idToken: appleCredential.identityToken,
        accessToken: appleCredential.authorizationCode,
      );

      print("Signing in to Firebase...");
      final userCredential = await _fireBaseAuth.signInWithCredential(oAuthCredential);
      
      print("Firebase sign-in successful: ${userCredential.user?.email}");
      
      if (userCredential.user != null) {
        String? firstName = appleCredential.givenName;
        String? lastName = appleCredential.familyName;
        final box = GetStorage();
        final storageKey = 'apple_${appleCredential.userIdentifier ?? userCredential.user!.uid}';
        if (firstName != null || lastName != null) {
          box.write('${storageKey}_first', firstName ?? '');
          box.write('${storageKey}_last', lastName ?? '');
        } else {
          final savedFirst = box.read<String?>('${storageKey}_first');
          final savedLast = box.read<String?>('${storageKey}_last');
          if (savedFirst != null && savedFirst.isNotEmpty) firstName = savedFirst;
          if (savedLast != null && savedLast.isNotEmpty) lastName = savedLast;
        }
        return {
          'email': appleCredential.email ?? userCredential.user!.email,
          'firstName': firstName,
          'lastName': lastName,
          'user': userCredential.user,
        };
      }
      
      return null;
    } catch (e) {
      print("Error during sign in with apple: $e");
      if (e.toString().contains('AuthorizationErrorCode.unknown')) {
        print("Apple Sign-In error: User may have cancelled or there's a configuration issue");
      } else if (e.toString().contains('AuthorizationErrorCode.canceled')) {
        print("Apple Sign-In was cancelled by user");
      } else if (e.toString().contains('AuthorizationErrorCode.failed')) {
        print("Apple Sign-In failed due to system error");
      }
      
      return null;
    }
  }

  dynamic getLastAppleCredential() {
    return _lastAppleCredential;
  }

  Future<void> signOut() async {
    await _fireBaseAuth.signOut();
    _lastAppleCredential = null;
  }
}

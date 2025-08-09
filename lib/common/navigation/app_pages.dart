import 'package:get/get.dart';
import 'package:gym_zones/bindings/individual_gym_binding.dart';
import 'package:gym_zones/bindings/nav_bar_binding.dart';
import 'package:gym_zones/common/widgets/custom_bottom_nav_bar.dart';
import 'package:gym_zones/views/home/Individual_gym_details_screen.dart';
import 'package:gym_zones/views/offers/binding/offers_binding.dart';
import 'package:gym_zones/views/offers/screen/categories_screen.dart';
import 'package:gym_zones/views/offers/screen/offers_screen.dart';
import 'package:gym_zones/views/subscriptions/cart_screen.dart';
import 'package:gym_zones/views/subscriptions/confirm_gift_payment.dart';
import 'package:gym_zones/views/subscriptions/gift_subscription_view.dart';
import 'package:gym_zones/views/subscriptions/individual_subscriptions_view.dart';
import 'package:gym_zones/views/subscriptions/success_payment_view.dart';

import '../../bindings/home_binding.dart';
import '../../bindings/landing_binding.dart';
import '../../bindings/notifications_binding.dart';
import '../../bindings/qr_scan_binding.dart';
import '../../bindings/search_binding.dart';
import '../../bindings/settings_binding.dart';
import '../../bindings/subscriptions_binding.dart';
import '../../bindings/update_profile_binding.dart';
import '../../bindings/visits_binding.dart';
import '../../middlewares/gender_unknown_middleware.dart';
import '../../middlewares/onboarding_middleware.dart';
import '../../views/auth/forgot_password_view.dart';
import '../../views/auth/login_view.dart';
import '../../views/auth/register_view.dart';
import '../../views/auth/reset_password_view.dart';
import '../../views/auth/verify_email_view.dart';
import '../../views/gym_gallery/gym_gallery.dart';
import '../../views/home/home_view.dart';
import '../../views/landing/landing_view.dart';
import '../../views/new_visit/check_in_view.dart';
import '../../views/new_visit/qr_scan_view.dart';
import '../../views/notifications/notifications_view.dart';
import '../../views/onboarding/onboarding_view.dart';
import '../../views/search/search_view.dart';
import '../../views/select_gender/select_gender_view.dart';
import '../../views/settings/settings_view.dart';
import '../../views/subscriptions/subscriptions_view.dart';
import '../../views/update_app/update_app_view.dart';
import '../../views/update_profile/update_profile_view.dart';
import '../../views/visits/visits_view.dart';
import 'app_routes.dart';

class AppPages {
  static final List<GetPage> pages = [
    GetPage(
        name: AppRoutes.landing,
        page: () => const LandingView(),
        binding: LandingBinding()),
    GetPage(
      name: AppRoutes.updateApp,
      page: () => UpdateAppView(),
    ),
    GetPage(
      name: AppRoutes.onboarding,
      page: () => const OnboardingView(),
    ),
    GetPage(
      name: AppRoutes.selectedGender,
      page: () => const SelectGenderView(),
    ),
    GetPage(
      name: AppRoutes.home,
      page: () => const HomeView(),
      binding: HomeBinding(),
      middlewares: [
        OnboardingMiddleware(),
        GenderUnknownMiddleware(),
      ],
    ),
    GetPage(
      name: AppRoutes.login,
      page: () => const LoginView(),
    ),
    GetPage(
      name: AppRoutes.register,
      page: () => const RegisterView(),
    ),
    GetPage(
      name: AppRoutes.verifyEmail,
      page: () => VerifyEmailView(),
    ),
    GetPage(
      name: AppRoutes.forgotPassword,
      page: () => const ForgotPasswordView(),
    ),
    GetPage(
      name: AppRoutes.resetPassword,
      page: () => ResetPasswordView(),
    ),
    GetPage(
      name: AppRoutes.notifications,
      page: () => const NotificationsView(),
      binding: NotificationsBinding(),
    ),
    GetPage(
      name: AppRoutes.settings,
      page: () => SettingsView(),
      binding: SettingsBinding(),
    ),
    GetPage(
      name: AppRoutes.subscriptions,
      page: () => const SubscriptionsView(),
      binding: SubscriptionsBinding(),
    ),
    GetPage(
      name: AppRoutes.visits,
      page: () => const VisitsView(),
      binding: VisitsBinding(),
    ),
    GetPage(
      name: AppRoutes.qrScan,
      page: () => const QrScanView(),
      binding: QrScanBinding(),
    ),
    GetPage(
      name: AppRoutes.checkIn,
      page: () => const CheckInView(),
    ),
    GetPage(
      name: AppRoutes.updateProfile,
      page: () => UpdateProfileView(),
      binding: UpdateProfileBinding(),
    ),
    GetPage(
      name: AppRoutes.search,
      page: () => const SearchView(),
      binding: SearchBinding(),
    ),
    GetPage(
      name: AppRoutes.gymGallery,
      page: () => GymGallery(),
    ),
    GetPage(
      binding: OffersBinding(),
      name: AppRoutes.offerPage,
      page: () => const OffersScreen(),
    ),
    GetPage(
      binding: OffersBinding(),
      name: AppRoutes.categoriesPage,
      page: () => const CategoriesScreen(),
    ),
    GetPage(
      binding: SubscriptionsBinding(),
      name: AppRoutes.cartPage,
      page: () => const CartScreen(),
    ),
    GetPage(
      binding: NavBarBinding(),
      name: AppRoutes.navBarPage,
      page: () => const CustomBottomNavBar(),
    ),
    GetPage(
      binding: SubscriptionsBinding(),
      name: AppRoutes.individualSubscription,
      page: () => const IndividualSubscriptionsView(),
    ),
    GetPage(
      binding: SubscriptionsBinding(),
      name: AppRoutes.giftSubscription,
      page: () => GiftSubscriptionView(),
    ),
    GetPage(
      binding: SubscriptionsBinding(),
      name: AppRoutes.confirmGiftPayment,
      page: () => ConfirmGiftPayment(),
    ),
    GetPage(
      name: AppRoutes.individualGymDetails,
      binding: IndividualGymBinding(),
      page: () => const IndividualGymDetailsScreen(),
    ),
    GetPage(
      name: AppRoutes.successPayment,
      page: () => const SuccessPaymentView(),
    ),
  ];
}

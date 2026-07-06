import 'package:get/get.dart';
import '../services/db_helper.dart';
import '../views/onboarding/onboarding_view.dart';
import '../views/main_navigation_view.dart';

class SplashController extends GetxController {
  @override
  void onInit() {
    super.onInit();
    _navigateToNext();
  }

  Future<void> _navigateToNext() async {
    // Wait for 3 seconds of splash display
    await Future.delayed(const Duration(seconds: 3));

    // Check if user has already seen onboarding
    final hasSeenOnboarding = await DatabaseHelper.instance.getSetting('has_seen_onboarding');

    if (hasSeenOnboarding == 'true') {
      Get.off(() => const MainNavigationView());
    } else {
      Get.off(() => const OnboardingView());
    }
  }
}

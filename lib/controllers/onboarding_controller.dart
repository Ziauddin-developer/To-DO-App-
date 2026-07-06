import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../services/db_helper.dart';
import '../views/main_navigation_view.dart';

class OnboardingController extends GetxController {
  final PageController pageController = PageController();
  var currentPage = 0.obs;

  final List<Map<String, String>> onboardingData = [
    {
      'title': 'Organize Your Tasks',
      'description': 'Keep track of your daily activities, set priorities, and categorize tasks to stay productive.',
    },
    {
      'title': 'Set Reminders & Schedules',
      'description': 'Never miss a deadline. Set proper dates and times for your tasks and keep a clean timeline.',
    },
    {
      'title': 'Local Storage & Security',
      'description': 'Your tasks are securely stored on your local device using SQLite database. Fast, secure, and offline.',
    }
  ];

  bool get isLastPage => currentPage.value == onboardingData.length - 1;

  void onPageChanged(int index) {
    currentPage.value = index;
  }

  Future<void> completeOnboarding() async {
    // Save state to local database
    await DatabaseHelper.instance.setSetting('has_seen_onboarding', 'true');
    // Navigate to Main Navigation
    Get.off(() => const MainNavigationView());
  }

  void nextPage() {
    if (isLastPage) {
      completeOnboarding();
    } else {
      pageController.nextPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeIn,
      );
    }
  }

  @override
  void onClose() {
    pageController.dispose();
    super.onClose();
  }
}

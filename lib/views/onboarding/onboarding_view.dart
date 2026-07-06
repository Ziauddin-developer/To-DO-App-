import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../controllers/onboarding_controller.dart';
import '../../utils/theme.dart';

class OnboardingView extends StatelessWidget {
  const OnboardingView({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(OnboardingController());
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      body: SafeArea(
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
          child: Column(
            children: [
              // Header with Skip Button
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Obx(() {
                    return controller.isLastPage
                        ? const SizedBox(height: 48) // Space placeholder
                        : TextButton(
                            onPressed: controller.completeOnboarding,
                            child: Text(
                              'Skip',
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w600,
                                color: isDark ? AppTheme.textSecondaryDark : AppTheme.textSecondaryLight,
                              ),
                            ),
                          );
                  }),
                ],
              ),

              // Page Slider
              Expanded(
                child: PageView.builder(
                  controller: controller.pageController,
                  onPageChanged: controller.onPageChanged,
                  itemCount: controller.onboardingData.length,
                  itemBuilder: (context, index) {
                    final slide = controller.onboardingData[index];
                    return Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        // Programmatic Illustration
                        _buildIllustration(index, isDark),
                        const SizedBox(height: 40),
                        // Title
                        Text(
                          slide['title']!,
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: 28,
                            fontWeight: FontWeight.bold,
                            color: isDark ? AppTheme.textPrimaryDark : AppTheme.textPrimaryLight,
                          ),
                        ),
                        const SizedBox(height: 16),
                        // Description
                        Text(
                          slide['description']!,
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: 16,
                            color: isDark ? AppTheme.textSecondaryDark : AppTheme.textSecondaryLight,
                            height: 1.5,
                          ),
                        ),
                      ],
                    );
                  },
                ),
              ),

              // Footer: Dots Indicator & Next/GetStarted Button
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  // Dot Indicators
                  Row(
                    children: List.generate(
                      controller.onboardingData.length,
                      (index) => Obx(() {
                        final isSelected = controller.currentPage.value == index;
                        return AnimatedContainer(
                          duration: const Duration(milliseconds: 200),
                          margin: const EdgeInsets.only(right: 8),
                          height: 8,
                          width: isSelected ? 24 : 8,
                          decoration: BoxDecoration(
                            color: isSelected
                                ? AppTheme.primaryDark
                                : (isDark ? const Color(0xFF334155) : const Color(0xFFCBD5E1)),
                            borderRadius: BorderRadius.circular(4),
                          ),
                        );
                      }),
                    ),
                  ),

                  // Next / Get Started Button
                  Obx(() {
                    return ElevatedButton(
                      onPressed: controller.nextPage,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppTheme.primaryDark,
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        elevation: 0,
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            controller.isLastPage ? 'Get Started' : 'Next',
                            style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(width: 8),
                          const Icon(Icons.arrow_forward_rounded, size: 18),
                        ],
                      ),
                    );
                  }),
                ],
              ),
              const SizedBox(height: 16),
            ],
          ),
        ),
      ),
    );
  }

  // Draw programmatic vectors using standard widgets and icons to guarantee loading
  Widget _buildIllustration(int index, bool isDark) {
    String assetName;
    switch (index) {
      case 0:
        assetName = 'onboarding_task.png';
        break;
      case 1:
        assetName = 'onboarding_time.png';
        break;
      case 2:
      default:
        assetName = 'onboarding_db.png';
        break;
    }

    return Container(
      width: 220,
      height: 220,
      decoration: BoxDecoration(
        color: isDark ? AppTheme.cardDark : Colors.white,
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: AppTheme.primaryDark.withOpacity(isDark ? 0.1 : 0.05),
            blurRadius: 15,
            spreadRadius: 1,
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(16),
          child: Image.asset(
            'assets/images/$assetName',
            fit: BoxFit.contain,
          ),
        ),
      ),
    );
  }
}

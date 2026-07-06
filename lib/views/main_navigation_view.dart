import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/main_navigation_controller.dart';
import '../utils/theme.dart';
import 'home/home_view.dart';
import 'search/search_view.dart';
import 'about/about_view.dart';

class MainNavigationView extends StatelessWidget {
  const MainNavigationView({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(MainNavigationController());
    final isDark = Theme.of(context).brightness == Brightness.dark;

    final List<Widget> screens = [
      const HomeView(),
      const SearchView(),
      const AboutView(),
    ];

    return Scaffold(
      body: Obx(() => IndexedStack(
            index: controller.currentIndex.value,
            children: screens,
          )),
      bottomNavigationBar: Obx(() {
        return Container(
          decoration: BoxDecoration(
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(isDark ? 0.2 : 0.05),
                blurRadius: 10,
                offset: const Offset(0, -3),
              ),
            ],
          ),
          child: BottomNavigationBar(
            currentIndex: controller.currentIndex.value,
            onTap: controller.changeIndex,
            backgroundColor: isDark ? AppTheme.cardDark : Colors.white,
            selectedItemColor: AppTheme.primaryDark,
            unselectedItemColor: isDark ? AppTheme.textSecondaryDark : AppTheme.textSecondaryLight,
            showSelectedLabels: true,
            showUnselectedLabels: true,
            type: BottomNavigationBarType.fixed,
            elevation: 0,
            selectedLabelStyle: const TextStyle(fontWeight: FontWeight.bold, fontSize: 12),
            unselectedLabelStyle: const TextStyle(fontWeight: FontWeight.w500, fontSize: 12),
            items: const [
              BottomNavigationBarItem(
                icon: Icon(Icons.space_dashboard_rounded),
                activeIcon: Icon(Icons.space_dashboard_rounded, color: AppTheme.primaryDark),
                label: 'Dashboard',
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.search_rounded),
                activeIcon: Icon(Icons.search_rounded, color: AppTheme.primaryDark),
                label: 'Search',
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.info_outline_rounded),
                activeIcon: Icon(Icons.info_rounded, color: AppTheme.primaryDark),
                label: 'About',
              ),
            ],
          ),
        );
      }),
    );
  }
}

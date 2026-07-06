import 'package:flutter/material.dart';
import '../../utils/theme.dart';

class AboutView extends StatelessWidget {
  const AboutView({super.key});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      appBar: AppBar(
        title: const Text('About & Info'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // App Branding Section
            Center(
              child: Column(
                children: [
                  Container(
                    width: 90,
                    height: 90,
                    decoration: BoxDecoration(
                      gradient: const LinearGradient(
                        colors: [AppTheme.primaryDark, AppTheme.accentDark],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                      shape: BoxShape.circle,
                      boxShadow: [
                        BoxShadow(
                          color: AppTheme.primaryDark.withOpacity(0.3),
                          blurRadius: 15,
                          offset: const Offset(0, 4),
                        ),
                      ],
                    ),
                    child: const Icon(
                      Icons.check_circle_outline_rounded,
                      size: 50,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'TaskFlow v1.0.0',
                    style: TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                      color: isDark ? AppTheme.textPrimaryDark : AppTheme.textPrimaryLight,
                    ),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    'Your Premium Task Manager',
                    style: TextStyle(
                      fontSize: 14,
                      color: isDark ? AppTheme.textSecondaryDark : AppTheme.textSecondaryLight,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 32),

            // Developer Card
            const Text(
              'Developer Info',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: isDark ? AppTheme.cardDark : Colors.white,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(
                  color: isDark ? Colors.transparent : const Color(0xFFE2E8F0),
                ),
              ),
              child: Column(
                children: [
                  _buildProfileRow(
                    context,
                    Icons.person_outline_rounded,
                    'Name',
                    'Flutter Student Developer',
                    isDark,
                  ),
                  const Divider(height: 24, thickness: 0.5),
                  _buildProfileRow(
                    context,
                    Icons.assignment_ind_outlined,
                    'Assignment Task',
                    'Proper MVC To-Do Application',
                    isDark,
                  ),
                  const Divider(height: 24, thickness: 0.5),
                  _buildProfileRow(
                    context,
                    Icons.school_outlined,
                    'Platform',
                    'Flutter 3.x & Dart',
                    isDark,
                  ),
                ],
              ),
            ),
            const SizedBox(height: 32),

            // Tech Stack Architecture Section
            const Text(
              'App Architecture Stack',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            _buildArchitectureCard(
              Icons.dashboard_customize_outlined,
              'MVC Design Pattern',
              'Separates logic and data from views. Models define structural data, Views display layout, Controllers manage states and user events.',
              const Color(0xFF3B82F6),
              isDark,
            ),
            const SizedBox(height: 12),
            _buildArchitectureCard(
              Icons.loop_rounded,
              'GetX State Management',
              'Uses reactive observable streams (.obs) and Obx views to update widgets dynamically and handle routes without Context dependencies.',
              const Color(0xFFEC4899),
              isDark,
            ),
            const SizedBox(height: 12),
            _buildArchitectureCard(
              Icons.storage_rounded,
              'Sqflite SQLite Database',
              'Stores settings and todo items persistently on device storage using robust SQLite raw databases with full CRUD transactions.',
              const Color(0xFF10B981),
              isDark,
            ),
            const SizedBox(height: 32),

            // GUIDE.md Highlight Info
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: AppTheme.primaryDark.withOpacity(0.08),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                  color: AppTheme.primaryDark.withOpacity(0.25),
                ),
              ),
              child: Row(
                children: [
                  const Icon(Icons.menu_book_rounded, color: AppTheme.primaryDark, size: 24),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Need Help Presenting?',
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                            color: AppTheme.primaryDark,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          'Open GUIDE.md in the root directory for a full explanation of the codes, questions, and MVC answers to show your teacher!',
                          style: TextStyle(
                            fontSize: 12,
                            color: isDark ? AppTheme.textSecondaryDark : AppTheme.textSecondaryLight,
                            height: 1.4,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildProfileRow(
    BuildContext context,
    IconData icon,
    String label,
    String value,
    bool isDark,
  ) {
    return Row(
      children: [
        Icon(icon, color: AppTheme.primaryDark, size: 22),
        const SizedBox(width: 16),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              label,
              style: TextStyle(
                fontSize: 11,
                color: isDark ? AppTheme.textSecondaryDark : AppTheme.textSecondaryLight,
              ),
            ),
            const SizedBox(height: 3),
            Text(
              value,
              style: const TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildArchitectureCard(
    IconData icon,
    String title,
    String description,
    Color iconBgColor,
    bool isDark,
  ) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: isDark ? AppTheme.cardDark : Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: isDark ? Colors.transparent : const Color(0xFFE2E8F0),
        ),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: iconBgColor.withOpacity(0.12),
              shape: BoxShape.circle,
            ),
            child: Icon(icon, color: iconBgColor, size: 24),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  description,
                  style: TextStyle(
                    fontSize: 12,
                    color: isDark ? AppTheme.textSecondaryDark : AppTheme.textSecondaryLight,
                    height: 1.4,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

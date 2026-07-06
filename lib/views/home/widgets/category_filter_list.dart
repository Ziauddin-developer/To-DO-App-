import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../controllers/todo_controller.dart';
import '../../../utils/theme.dart';

class CategoryFilterList extends StatelessWidget {
  final TodoController controller;
  final bool isDark;

  const CategoryFilterList({
    super.key,
    required this.controller,
    required this.isDark,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 48,
      margin: const EdgeInsets.only(top: 8, bottom: 8),
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.only(left: 20, right: 12),
        itemCount: controller.categories.length,
        itemBuilder: (context, index) {
          final category = controller.categories[index];
          return Obx(() {
            final isSelected = controller.selectedCategory.value == category;
            final color = isSelected 
                ? AppTheme.primaryDark 
                : (isDark ? AppTheme.cardDark : Colors.white);
            final textColor = isSelected 
                ? Colors.white 
                : (isDark ? AppTheme.textSecondaryDark : AppTheme.textSecondaryLight);

            return GestureDetector(
              onTap: () => controller.selectedCategory.value = category,
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 200),
                margin: const EdgeInsets.only(right: 8),
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                decoration: BoxDecoration(
                  color: color,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                    color: isSelected 
                        ? Colors.transparent 
                        : (isDark ? Colors.transparent : const Color(0xFFE2E8F0)),
                  ),
                  boxShadow: isSelected
                      ? [
                          BoxShadow(
                            color: AppTheme.primaryDark.withOpacity(0.3),
                            blurRadius: 8,
                            offset: const Offset(0, 2),
                          )
                        ]
                      : null,
                ),
                child: Row(
                  children: [
                    if (category != 'All') ...[
                      Icon(
                        AppTheme.getCategoryIcon(category),
                        size: 16,
                        color: textColor,
                      ),
                      const SizedBox(width: 6),
                    ],
                    Text(
                      category,
                      style: TextStyle(
                        color: textColor,
                        fontWeight: FontWeight.bold,
                        fontSize: 14,
                      ),
                    ),
                  ],
                ),
              ),
            );
          });
        },
      ),
    );
  }
}

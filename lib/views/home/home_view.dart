import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../controllers/todo_controller.dart';
import '../../utils/theme.dart';
import '../todo/todo_detail_view.dart';
import 'widgets/category_filter_list.dart';
import 'widgets/progress_card.dart';
import 'widgets/task_card.dart';

class HomeView extends StatelessWidget {
  const HomeView({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(TodoController());
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      appBar: AppBar(
        title: const Text('TaskFlow'),
        actions: [
          // Sorting Dropdown Button
          Obx(() {
            final currentSort = controller.sortBy.value;
            return PopupMenuButton<String>(
              icon: const Icon(Icons.sort_rounded),
              tooltip: 'Sort Tasks',
              onSelected: (value) => controller.sortBy.value = value,
              itemBuilder: (BuildContext context) => <PopupMenuEntry<String>>[
                PopupMenuItem<String>(
                  value: 'date',
                  child: Row(
                    children: [
                      Icon(Icons.calendar_today_rounded, 
                           color: currentSort == 'date' ? AppTheme.primaryDark : null, 
                           size: 18),
                      const SizedBox(width: 10),
                      const Text('Sort by Date'),
                    ],
                  ),
                ),
                PopupMenuItem<String>(
                  value: 'priority',
                  child: Row(
                    children: [
                      Icon(Icons.priority_high_rounded, 
                           color: currentSort == 'priority' ? AppTheme.primaryDark : null, 
                           size: 18),
                      const SizedBox(width: 10),
                      const Text('Sort by Priority'),
                    ],
                  ),
                ),
                PopupMenuItem<String>(
                  value: 'status',
                  child: Row(
                    children: [
                      Icon(Icons.rule_rounded, 
                           color: currentSort == 'status' ? AppTheme.primaryDark : null, 
                           size: 18),
                      const SizedBox(width: 10),
                      const Text('Sort by Status'),
                    ],
                  ),
                ),
              ],
            );
          }),
        ],
      ),
      body: Column(
        children: [
          // Reusable Progress Card Component
          ProgressCard(controller: controller, isDark: isDark),

          // Search Bar
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
            child: TextField(
              onChanged: (val) => controller.searchQuery.value = val,
              style: TextStyle(color: isDark ? AppTheme.textPrimaryDark : AppTheme.textPrimaryLight),
              decoration: InputDecoration(
                hintText: 'Search tasks...',
                prefixIcon: const Icon(Icons.search_rounded, color: AppTheme.primaryDark),
                suffixIcon: Obx(() {
                  return controller.searchQuery.value.isNotEmpty
                      ? IconButton(
                          icon: const Icon(Icons.clear_rounded),
                          onPressed: () {
                            controller.searchQuery.value = '';
                            FocusScope.of(context).unfocus();
                          },
                        )
                      : const SizedBox.shrink();
                }),
              ),
            ),
          ),

          // Reusable Horizontal Categories Filter List Component
          CategoryFilterList(controller: controller, isDark: isDark),

          // Task List Section
          Expanded(
            child: Obx(() {
              if (controller.isLoading.value) {
                return const Center(child: CircularProgressIndicator());
              }

              final filteredList = controller.filteredTasks;

              if (filteredList.isEmpty) {
                return _buildEmptyState(controller, isDark);
              }

              return ListView.builder(
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                itemCount: filteredList.length,
                itemBuilder: (context, index) {
                  final task = filteredList[index];
                  // Reusable TaskCard Component
                  return TaskCard(task: task, controller: controller, isDark: isDark);
                },
              );
            }),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => Get.to(() => const TodoDetailView()),
        backgroundColor: AppTheme.primaryDark,
        foregroundColor: Colors.white,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        child: const Icon(Icons.add_rounded, size: 28),
      ),
    );
  }

  // Visual layout for empty task state
  Widget _buildEmptyState(TodoController controller, bool isDark) {
    final searchActive = controller.searchQuery.value.trim().isNotEmpty;
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(40),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: isDark ? AppTheme.cardDark : const Color(0xFFF1F5F9),
              shape: BoxShape.circle,
            ),
            child: Icon(
              searchActive ? Icons.search_off_rounded : Icons.assignment_turned_in_outlined,
              size: 60,
              color: isDark ? AppTheme.textSecondaryDark : AppTheme.textSecondaryLight,
            ),
          ),
          const SizedBox(height: 20),
          Text(
            searchActive ? 'No Search Results' : 'All Caught Up!',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: isDark ? AppTheme.textPrimaryDark : AppTheme.textPrimaryLight,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            searchActive
                ? "Try searching for another keyword or check spelling."
                : "No tasks to show. Click the '+' button below to create one.",
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 14,
              color: isDark ? AppTheme.textSecondaryDark : AppTheme.textSecondaryLight,
            ),
          ),
        ],
      ),
    );
  }
}

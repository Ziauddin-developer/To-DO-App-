import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../controllers/todo_controller.dart';
import '../../../models/todo_model.dart';
import '../../../utils/theme.dart';
import '../../todo/todo_detail_view.dart';

class TaskCard extends StatelessWidget {
  final TodoModel task;
  final TodoController controller;
  final bool isDark;

  const TaskCard({
    super.key,
    required this.task,
    required this.controller,
    required this.isDark,
  });

  String _formatDateTime(DateTime dt) {
    final day = dt.day.toString().padLeft(2, '0');
    final month = dt.month.toString().padLeft(2, '0');
    final year = dt.year;
    final hour = dt.hour.toString().padLeft(2, '0');
    final minute = dt.minute.toString().padLeft(2, '0');
    return '$day/$month/$year at $hour:$minute';
  }

  @override
  Widget build(BuildContext context) {
    Color priorityColor;
    switch (task.priority) {
      case 'High':
        priorityColor = AppTheme.priorityHigh;
        break;
      case 'Medium':
        priorityColor = AppTheme.priorityMedium;
        break;
      case 'Low':
      default:
        priorityColor = AppTheme.priorityLow;
        break;
    }

    final categoryColor = AppTheme.getCategoryColor(task.category);

    return Dismissible(
      key: Key(task.id.toString()),
      direction: DismissDirection.endToStart,
      background: Container(
        alignment: Alignment.centerRight,
        padding: const EdgeInsets.only(right: 20),
        margin: const EdgeInsets.symmetric(vertical: 8),
        decoration: BoxDecoration(
          color: AppTheme.priorityHigh,
          borderRadius: BorderRadius.circular(16),
        ),
        child: const Icon(Icons.delete_rounded, color: Colors.white, size: 28),
      ),
      onDismissed: (direction) {
        controller.deleteTask(task.id!);
        Get.snackbar(
          'Deleted',
          'Task deleted successfully',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: AppTheme.priorityHigh.withOpacity(0.9),
          colorText: Colors.white,
          margin: const EdgeInsets.all(16),
        );
      },
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 8),
        decoration: BoxDecoration(
          color: isDark ? AppTheme.cardDark : Colors.white,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: isDark ? Colors.transparent : const Color(0xFFE2E8F0),
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(isDark ? 0.05 : 0.02),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(16),
          child: IntrinsicHeight(
            child: Row(
              children: [
                // Priority color indicator strip on the left side
                Container(
                  width: 5,
                  color: priorityColor,
                ),
                const SizedBox(width: 8),
                // Toggle Checkbox
                IconButton(
                  onPressed: () => controller.toggleTaskCompletion(task),
                  icon: Icon(
                    task.isCompleted
                        ? Icons.check_box_rounded
                        : Icons.check_box_outline_blank_rounded,
                    color: task.isCompleted ? AppTheme.primaryDark : (isDark ? Colors.white60 : Colors.black45),
                    size: 24,
                  ),
                ),
                // Main Content
                Expanded(
                  child: GestureDetector(
                    onTap: () => Get.to(() => TodoDetailView(task: task)),
                    behavior: HitTestBehavior.opaque,
                    child: Padding(
                      padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 4),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Title
                          Text(
                            task.title,
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              decoration: task.isCompleted ? TextDecoration.lineThrough : null,
                              color: task.isCompleted
                                  ? (isDark ? AppTheme.textSecondaryDark : AppTheme.textSecondaryLight)
                                  : (isDark ? AppTheme.textPrimaryDark : AppTheme.textPrimaryLight),
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                          const SizedBox(height: 4),
                          // Description
                          if (task.description.isNotEmpty) ...[
                            Text(
                              task.description,
                              style: TextStyle(
                                fontSize: 13,
                                color: isDark ? AppTheme.textSecondaryDark : AppTheme.textSecondaryLight,
                              ),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                            const SizedBox(height: 8),
                          ],
                          // Bottom badges
                          Row(
                            children: [
                              // Category badge
                              Container(
                                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                                decoration: BoxDecoration(
                                  color: categoryColor.withOpacity(0.1),
                                  borderRadius: BorderRadius.circular(6),
                                ),
                                child: Row(
                                  children: [
                                    Icon(
                                      AppTheme.getCategoryIcon(task.category),
                                      size: 12,
                                      color: categoryColor,
                                    ),
                                    const SizedBox(width: 4),
                                    Text(
                                      task.category,
                                      style: TextStyle(
                                        color: categoryColor,
                                        fontSize: 10,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              const SizedBox(width: 8),
                              // Date string
                              Expanded(
                                child: Text(
                                  _formatDateTime(task.dateTime),
                                  style: TextStyle(
                                    fontSize: 11,
                                    color: isDark ? Colors.white38 : Colors.black38,
                                  ),
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                // Priority label on the right side
                Container(
                  alignment: Alignment.center,
                  padding: const EdgeInsets.symmetric(horizontal: 12),
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                      color: priorityColor.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(6),
                    ),
                    child: Text(
                      task.priority.toUpperCase(),
                      style: TextStyle(
                        color: priorityColor,
                        fontSize: 9,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

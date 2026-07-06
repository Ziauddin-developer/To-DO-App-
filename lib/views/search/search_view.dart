import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../controllers/todo_controller.dart';
import '../../models/todo_model.dart';
import '../../utils/theme.dart';
import '../home/widgets/task_card.dart';

class SearchView extends StatefulWidget {
  const SearchView({super.key});

  @override
  State<SearchView> createState() => _SearchViewState();
}

class _SearchViewState extends State<SearchView> {
  final TodoController _todoController = Get.find<TodoController>();
  final TextEditingController _queryController = TextEditingController();

  String _selectedStatus = 'All'; // 'All', 'Completed', 'Pending'
  String _selectedPriority = 'All'; // 'All', 'High', 'Medium', 'Low'
  String _searchQuery = '';

  @override
  void dispose() {
    _queryController.dispose();
    super.dispose();
  }

  // Filter tasks based on query, status, and priority
  List<TodoModel> get _searchResults {
    List<TodoModel> list = _todoController.tasks;

    // 1. Filter by keyword
    if (_searchQuery.trim().isNotEmpty) {
      final query = _searchQuery.toLowerCase().trim();
      list = list.where((task) =>
          task.title.toLowerCase().contains(query) ||
          task.description.toLowerCase().contains(query)).toList();
    }

    // 2. Filter by completion status
    if (_selectedStatus == 'Completed') {
      list = list.where((task) => task.isCompleted).toList();
    } else if (_selectedStatus == 'Pending') {
      list = list.where((task) => !task.isCompleted).toList();
    }

    // 3. Filter by priority
    if (_selectedPriority != 'All') {
      list = list.where((task) => task.priority.toLowerCase() == _selectedPriority.toLowerCase()).toList();
    }

    return list;
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Advanced Search'),
      ),
      body: Column(
        children: [
          // Search Input Field
          Padding(
            padding: const EdgeInsets.all(20),
            child: TextField(
              controller: _queryController,
              onChanged: (value) => setState(() => _searchQuery = value),
              style: TextStyle(color: isDark ? AppTheme.textPrimaryDark : AppTheme.textPrimaryLight),
              decoration: InputDecoration(
                hintText: 'Type keywords (title/desc)...',
                prefixIcon: const Icon(Icons.search_rounded, color: AppTheme.primaryDark),
                suffixIcon: _searchQuery.isNotEmpty
                    ? IconButton(
                        icon: const Icon(Icons.clear_rounded),
                        onPressed: () {
                          _queryController.clear();
                          setState(() => _searchQuery = '');
                          FocusScope.of(context).unfocus();
                        },
                      )
                    : null,
              ),
            ),
          ),

          // Filters Panel
          Container(
            width: double.infinity,
            margin: const EdgeInsets.symmetric(horizontal: 20),
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: isDark ? AppTheme.cardDark : Colors.white,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(
                color: isDark ? Colors.transparent : const Color(0xFFE2E8F0),
              ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Status Filter Row
                const Text(
                  'Task Status',
                  style: TextStyle(fontSize: 13, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 8),
                _buildStatusFilters(isDark),
                const SizedBox(height: 16),

                // Priority Filter Row
                const Text(
                  'Priority Level',
                  style: TextStyle(fontSize: 13, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 8),
                _buildPriorityFilters(isDark),
              ],
            ),
          ),

          // Results List
          Expanded(
            child: Obx(() {
              // Trigger reactive rebuilds whenever tasks change
              final results = _searchResults;

              if (results.isEmpty) {
                return _buildNoResultsState(isDark);
              }

              return ListView.builder(
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
                itemCount: results.length,
                itemBuilder: (context, index) {
                  final task = results[index];
                  return TaskCard(
                    task: task,
                    controller: _todoController,
                    isDark: isDark,
                  );
                },
              );
            }),
          ),
        ],
      ),
    );
  }

  // Row of Status Chips
  Widget _buildStatusFilters(bool isDark) {
    final statuses = ['All', 'Completed', 'Pending'];
    return Row(
      children: statuses.map((status) {
        final isSelected = _selectedStatus == status;
        final activeColor = AppTheme.primaryDark;

        return Expanded(
          child: GestureDetector(
            onTap: () => setState(() => _selectedStatus = status),
            child: Container(
              margin: const EdgeInsets.symmetric(horizontal: 3),
              padding: const EdgeInsets.symmetric(vertical: 8),
              decoration: BoxDecoration(
                color: isSelected
                    ? activeColor.withOpacity(0.15)
                    : (isDark ? const Color(0xFF0F172A) : const Color(0xFFF1F5F9)),
                borderRadius: BorderRadius.circular(8),
                border: Border.all(
                  color: isSelected ? activeColor : Colors.transparent,
                  width: 1.5,
                ),
              ),
              child: Center(
                child: Text(
                  status,
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                    color: isSelected
                        ? activeColor
                        : (isDark ? AppTheme.textSecondaryDark : AppTheme.textSecondaryLight),
                  ),
                ),
              ),
            ),
          ),
        );
      }).toList(),
    );
  }

  // Row of Priority Chips
  Widget _buildPriorityFilters(bool isDark) {
    final priorities = ['All', 'High', 'Medium', 'Low'];
    return Row(
      children: priorities.map((priority) {
        final isSelected = _selectedPriority == priority;
        Color activeColor;
        switch (priority) {
          case 'High':
            activeColor = AppTheme.priorityHigh;
            break;
          case 'Medium':
            activeColor = AppTheme.priorityMedium;
            break;
          case 'Low':
            activeColor = AppTheme.priorityLow;
            break;
          default:
            activeColor = AppTheme.primaryDark;
            break;
        }

        return Expanded(
          child: GestureDetector(
            onTap: () => setState(() => _selectedPriority = priority),
            child: Container(
              margin: const EdgeInsets.symmetric(horizontal: 3),
              padding: const EdgeInsets.symmetric(vertical: 8),
              decoration: BoxDecoration(
                color: isSelected
                    ? activeColor.withOpacity(0.15)
                    : (isDark ? const Color(0xFF0F172A) : const Color(0xFFF1F5F9)),
                borderRadius: BorderRadius.circular(8),
                border: Border.all(
                  color: isSelected ? activeColor : Colors.transparent,
                  width: 1.5,
                ),
              ),
              child: Center(
                child: Text(
                  priority,
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                    color: isSelected
                        ? activeColor
                        : (isDark ? AppTheme.textSecondaryDark : AppTheme.textSecondaryLight),
                  ),
                ),
              ),
            ),
          ),
        );
      }).toList(),
    );
  }

  // No search results UI
  Widget _buildNoResultsState(bool isDark) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(40),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.find_in_page_outlined,
            size: 50,
            color: isDark ? AppTheme.textSecondaryDark : AppTheme.textSecondaryLight,
          ),
          const SizedBox(height: 16),
          Text(
            'No matching tasks',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: isDark ? AppTheme.textPrimaryDark : AppTheme.textPrimaryLight,
            ),
          ),
          const SizedBox(height: 6),
          Text(
            'Try adjusting your keywords or filters.',
            style: TextStyle(
              fontSize: 13,
              color: isDark ? AppTheme.textSecondaryDark : AppTheme.textSecondaryLight,
            ),
          ),
        ],
      ),
    );
  }
}

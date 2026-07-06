import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../controllers/todo_controller.dart';
import '../../models/todo_model.dart';
import '../../utils/theme.dart';

class TodoDetailView extends StatefulWidget {
  final TodoModel? task;

  const TodoDetailView({super.key, this.task});

  @override
  State<TodoDetailView> createState() => _TodoDetailViewState();
}

class _TodoDetailViewState extends State<TodoDetailView> {
  final _formKey = GlobalKey<FormState>();
  final _titleController = TextEditingController();
  final _descController = TextEditingController();

  late DateTime _selectedDate;
  late String _selectedPriority;
  late String _selectedCategory;

  final TodoController _todoController = Get.find<TodoController>();

  bool get isEditMode => widget.task != null;

  @override
  void initState() {
    super.initState();
    if (isEditMode) {
      _titleController.text = widget.task!.title;
      _descController.text = widget.task!.description;
      _selectedDate = widget.task!.dateTime;
      _selectedPriority = widget.task!.priority;
      _selectedCategory = widget.task!.category;
    } else {
      _selectedDate = DateTime.now().add(const Duration(hours: 1)); // Default: 1 hour from now
      _selectedPriority = 'Low';
      _selectedCategory = 'Personal';
    }
  }

  @override
  void dispose() {
    _titleController.dispose();
    _descController.dispose();
    super.dispose();
  }

  Future<void> _selectDateAndTime() async {
    final DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: _selectedDate,
      firstDate: DateTime.now().subtract(const Duration(days: 365)),
      lastDate: DateTime.now().add(const Duration(days: 3650)),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: ColorScheme.dark(
              primary: AppTheme.primaryDark,
              onPrimary: Colors.white,
              surface: Theme.of(context).cardColor,
              onSurface: Theme.of(context).textTheme.bodyLarge!.color!,
            ),
          ),
          child: child!,
        );
      },
    );

    if (pickedDate != null) {
      if (!mounted) return;
      final TimeOfDay? pickedTime = await showTimePicker(
        context: context,
        initialTime: TimeOfDay.fromDateTime(_selectedDate),
      );

      if (pickedTime != null) {
        setState(() {
          _selectedDate = DateTime(
            pickedDate.year,
            pickedDate.month,
            pickedDate.day,
            pickedTime.hour,
            pickedTime.minute,
          );
        });
      }
    }
  }

  void _saveTask() {
    if (_formKey.currentState!.validate()) {
      final task = TodoModel(
        id: widget.task?.id,
        title: _titleController.text.trim(),
        description: _descController.text.trim(),
        dateTime: _selectedDate,
        isCompleted: widget.task?.isCompleted ?? false,
        priority: _selectedPriority,
        category: _selectedCategory,
      );

      if (isEditMode) {
        _todoController.updateTask(task);
        Get.back();
        Get.snackbar(
          'Updated!',
          'Task updated successfully',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: AppTheme.primaryDark.withOpacity(0.9),
          colorText: Colors.white,
          margin: const EdgeInsets.all(16),
        );
      } else {
        _todoController.addTask(task);
        Get.back();
        Get.snackbar(
          'Success!',
          'New task added',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: AppTheme.primaryDark.withOpacity(0.9),
          colorText: Colors.white,
          margin: const EdgeInsets.all(16),
        );
      }
    }
  }

  void _deleteTask() {
    if (widget.task?.id != null) {
      Get.defaultDialog(
        title: 'Delete Task?',
        middleText: 'Are you sure you want to permanently delete this task?',
        textCancel: 'Cancel',
        textConfirm: 'Delete',
        confirmTextColor: Colors.white,
        buttonColor: AppTheme.priorityHigh,
        onConfirm: () {
          _todoController.deleteTask(widget.task!.id!);
          Get.back(); // close dialog
          Get.back(); // go back to home screen
          Get.snackbar(
            'Deleted',
            'Task removed successfully',
            snackPosition: SnackPosition.BOTTOM,
            backgroundColor: AppTheme.priorityHigh.withOpacity(0.9),
            colorText: Colors.white,
            margin: const EdgeInsets.all(16),
          );
        },
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      appBar: AppBar(
        title: Text(isEditMode ? 'Edit Task' : 'Create Task'),
        actions: [
          if (isEditMode)
            IconButton(
              icon: const Icon(Icons.delete_outline_rounded, color: AppTheme.priorityHigh),
              onPressed: _deleteTask,
            ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Title Field
              const Text(
                'Task Title',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),
              TextFormField(
                controller: _titleController,
                style: TextStyle(color: isDark ? AppTheme.textPrimaryDark : AppTheme.textPrimaryLight),
                decoration: const InputDecoration(
                  hintText: 'Enter task title...',
                ),
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'Title is required';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 24),

              // Description Field
              const Text(
                'Description',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),
              TextFormField(
                controller: _descController,
                maxLines: 4,
                style: TextStyle(color: isDark ? AppTheme.textPrimaryDark : AppTheme.textPrimaryLight),
                decoration: const InputDecoration(
                  hintText: 'Enter task description (optional)...',
                  alignLabelWithHint: true,
                ),
              ),
              const SizedBox(height: 24),

              // Priority Selector
              const Text(
                'Priority Level',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),
              Row(
                children: ['Low', 'Medium', 'High'].map((priority) {
                  final isSelected = _selectedPriority == priority;
                  Color priorityColor;
                  switch (priority) {
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

                  return Expanded(
                    child: GestureDetector(
                      onTap: () => setState(() => _selectedPriority = priority),
                      child: Container(
                        margin: const EdgeInsets.symmetric(horizontal: 4),
                        padding: const EdgeInsets.symmetric(vertical: 12),
                        decoration: BoxDecoration(
                          color: isSelected
                              ? priorityColor.withOpacity(0.15)
                              : (isDark ? AppTheme.cardDark : Colors.white),
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(
                            color: isSelected ? priorityColor : (isDark ? Colors.transparent : const Color(0xFFE2E8F0)),
                            width: 2,
                          ),
                        ),
                        child: Center(
                          child: Text(
                            priority,
                            style: TextStyle(
                              color: isSelected
                                  ? priorityColor
                                  : (isDark ? AppTheme.textSecondaryDark : AppTheme.textSecondaryLight),
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                    ),
                  );
                }).toList(),
              ),
              const SizedBox(height: 24),

              // Category Selector
              const Text(
                'Category',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),
              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  children: _todoController.categories.where((c) => c != 'All').map((category) {
                    final isSelected = _selectedCategory == category;
                    final categoryColor = AppTheme.getCategoryColor(category);

                    return GestureDetector(
                      onTap: () => setState(() => _selectedCategory = category),
                      child: Container(
                        margin: const EdgeInsets.only(right: 8),
                        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                        decoration: BoxDecoration(
                          color: isSelected
                              ? categoryColor.withOpacity(0.15)
                              : (isDark ? AppTheme.cardDark : Colors.white),
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(
                            color: isSelected ? categoryColor : (isDark ? Colors.transparent : const Color(0xFFE2E8F0)),
                            width: 2,
                          ),
                        ),
                        child: Row(
                          children: [
                            Icon(
                              AppTheme.getCategoryIcon(category),
                              size: 18,
                              color: isSelected
                                  ? categoryColor
                                  : (isDark ? AppTheme.textSecondaryDark : AppTheme.textSecondaryLight),
                            ),
                            const SizedBox(width: 8),
                            Text(
                              category,
                              style: TextStyle(
                                color: isSelected
                                    ? categoryColor
                                    : (isDark ? AppTheme.textSecondaryDark : AppTheme.textSecondaryLight),
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  }).toList(),
                ),
              ),
              const SizedBox(height: 24),

              // Date Time Selector Card
              const Text(
                'Schedule Date & Time',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),
              GestureDetector(
                onTap: _selectDateAndTime,
                child: Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: isDark ? AppTheme.cardDark : Colors.white,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                      color: isDark ? Colors.transparent : const Color(0xFFE2E8F0),
                    ),
                  ),
                  child: Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: AppTheme.primaryDark.withOpacity(0.1),
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(
                          Icons.calendar_today_rounded,
                          color: AppTheme.primaryDark,
                          size: 20,
                        ),
                      ),
                      const SizedBox(width: 16),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Date & Time',
                            style: TextStyle(
                              fontSize: 12,
                              color: isDark ? AppTheme.textSecondaryDark : AppTheme.textSecondaryLight,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            '${_selectedDate.day}/${_selectedDate.month}/${_selectedDate.year} at ${_selectedDate.hour.toString().padLeft(2, '0')}:${_selectedDate.minute.toString().padLeft(2, '0')}',
                            style: const TextStyle(
                              fontSize: 15,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                      const Spacer(),
                      const Icon(Icons.arrow_forward_ios_rounded, size: 14),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 40),

              // Save Action Button
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: _saveTask,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppTheme.primaryDark,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: Text(
                    isEditMode ? 'Update Task' : 'Save Task',
                    style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

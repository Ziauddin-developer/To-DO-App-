import 'package:get/get.dart';
import '../models/todo_model.dart';
import '../services/db_helper.dart';

class TodoController extends GetxController {
  var tasks = <TodoModel>[].obs;
  var isLoading = true.obs;

  // Filters & Search
  var selectedCategory = 'All'.obs;
  var searchQuery = ''.obs;
  var sortBy = 'date'.obs; // 'date', 'priority', 'status'

  final List<String> categories = ['All', 'Personal', 'Work', 'Health', 'Shopping', 'Others'];

  @override
  void onInit() {
    super.onInit();
    loadTasks();
  }

  // Fetch all tasks from DB
  Future<void> loadTasks() async {
    try {
      isLoading(true);
      final dbTasks = await DatabaseHelper.instance.readAllTasks();
      tasks.assignAll(dbTasks);
    } finally {
      isLoading(false);
    }
  }

  // Insert a task
  Future<void> addTask(TodoModel todo) async {
    await DatabaseHelper.instance.insertTask(todo);
    await loadTasks();
  }

  // Update an existing task
  Future<void> updateTask(TodoModel todo) async {
    await DatabaseHelper.instance.updateTask(todo);
    await loadTasks();
  }

  // Toggle completion status
  Future<void> toggleTaskCompletion(TodoModel todo) async {
    final updated = todo.copyWith(isCompleted: !todo.isCompleted);
    await DatabaseHelper.instance.updateTask(updated);
    await loadTasks();
  }

  // Delete task by ID
  Future<void> deleteTask(int id) async {
    await DatabaseHelper.instance.deleteTask(id);
    await loadTasks();
  }

  // Helper function to map priority string to integer weights for sorting
  int _priorityWeight(String priority) {
    switch (priority.toLowerCase()) {
      case 'high':
        return 3;
      case 'medium':
        return 2;
      case 'low':
        return 1;
      default:
        return 0;
    }
  }

  // Get filtered and sorted tasks list
  List<TodoModel> get filteredTasks {
    // 1. Filter by category
    List<TodoModel> list = tasks;
    if (selectedCategory.value != 'All') {
      list = list.where((task) => task.category.toLowerCase() == selectedCategory.value.toLowerCase()).toList();
    }

    // 2. Filter by search query
    if (searchQuery.value.trim().isNotEmpty) {
      final query = searchQuery.value.toLowerCase().trim();
      list = list.where((task) => 
        task.title.toLowerCase().contains(query) || 
        task.description.toLowerCase().contains(query)
      ).toList();
    }

    // 3. Sort tasks
    List<TodoModel> sortedList = List.from(list);
    if (sortBy.value == 'date') {
      // Sort by date descending (newest first)
      sortedList.sort((a, b) => b.dateTime.compareTo(a.dateTime));
    } else if (sortBy.value == 'priority') {
      // Sort by priority descending (high priority first)
      sortedList.sort((a, b) => _priorityWeight(b.priority).compareTo(_priorityWeight(a.priority)));
    } else if (sortBy.value == 'status') {
      // Sort by completion status (uncompleted tasks first)
      sortedList.sort((a, b) {
        if (a.isCompleted == b.isCompleted) return 0;
        return a.isCompleted ? 1 : -1;
      });
    }

    return sortedList;
  }

  // Statistics
  int get totalTasksCount => tasks.length;
  int get completedTasksCount => tasks.where((task) => task.isCompleted).length;
  double get completionRatio => totalTasksCount == 0 ? 0.0 : completedTasksCount / totalTasksCount;
}

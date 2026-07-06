class TodoModel {
  final int? id;
  final String title;
  final String description;
  final DateTime dateTime;
  final bool isCompleted;
  final String priority; // 'Low', 'Medium', 'High'
  final String category; // 'Personal', 'Work', 'Health', 'Shopping', 'Others'

  TodoModel({
    this.id,
    required this.title,
    required this.description,
    required this.dateTime,
    this.isCompleted = false,
    required this.priority,
    required this.category,
  });

  // Convert a TodoModel into a Map. The keys must correspond to the database columns.
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'dateTime': dateTime.toIso8601String(),
      'isCompleted': isCompleted ? 1 : 0, // SQLite stores boolean as integer (0 or 1)
      'priority': priority,
      'category': category,
    };
  }

  // Extract a TodoModel object from a Map.
  factory TodoModel.fromMap(Map<String, dynamic> map) {
    return TodoModel(
      id: map['id'] as int?,
      title: map['title'] as String,
      description: map['description'] as String,
      dateTime: DateTime.parse(map['dateTime'] as String),
      isCompleted: (map['isCompleted'] as int) == 1,
      priority: map['priority'] as String,
      category: map['category'] as String,
    );
  }

  // Create a copy of TodoModel with some updated fields
  TodoModel copyWith({
    int? id,
    String? title,
    String? description,
    DateTime? dateTime,
    bool? isCompleted,
    String? priority,
    String? category,
  }) {
    return TodoModel(
      id: id ?? this.id,
      title: title ?? this.title,
      description: description ?? this.description,
      dateTime: dateTime ?? this.dateTime,
      isCompleted: isCompleted ?? this.isCompleted,
      priority: priority ?? this.priority,
      category: category ?? this.category,
    );
  }
}

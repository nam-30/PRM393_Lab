class Task {
  final String id;
  String title;
  String description;
  bool isCompleted;

  Task({
    required this.id,
    required this.title,
    this.description = '',
    this.isCompleted = false,
  });

  /// Toggle task completion status
  void toggle() {
    isCompleted = !isCompleted;
  }

  /// Create a copy of Task with modified fields
  Task copyWith({
    String? id,
    String? title,
    String? description,
    bool? isCompleted,
  }) {
    return Task(
      id: id ?? this.id,
      title: title ?? this.title,
      description: description ?? this.description,
      isCompleted: isCompleted ?? this.isCompleted,
    );
  }

  factory Task.fromJson(Map<String, dynamic> json) {
    return Task(
      id: json['id']?.toString() ?? '',
      title: json['title']?.toString() ?? '',
      description: json['description']?.toString() ?? '',
      isCompleted: json['isCompleted'] == true,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'isCompleted': isCompleted,
    };
  }
}

class Task {
  final int? id;
  final String title;
  final String description;
  final bool isCompleted;

  const Task({
    this.id,
    required this.title,
    this.description = '',
    this.isCompleted = false,
  });

  // Instead of using equatable, implement equality manually
  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is Task &&
        other.id == id &&
        other.title == title &&
        other.description == description &&
        other.isCompleted == isCompleted;
  }

  @override
  int get hashCode {
    return id.hashCode ^ 
           title.hashCode ^ 
           description.hashCode ^ 
           isCompleted.hashCode;
  }

  Task copyWith({
    int? id,
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
}

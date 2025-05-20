import 'package:equatable/equatable.dart';

class Tasks extends Equatable {
  final int? id;
  final String title;
  final String description;
  final bool isCompleted;

  const Tasks({
    this.id,
    required this.title,
    this.description = '',
    this.isCompleted = false,
  });

  @override
  List<Object?> get props => [id, title, description, isCompleted];

  Tasks copyWith({
    int? id,
    String? title,
    String? description,
    bool? isCompleted,
  }) {
    return Tasks(
      id: id ?? this.id,
      title: title ?? this.title,
      description: description ?? this.description,
      isCompleted: isCompleted ?? this.isCompleted,
    );
  }
}

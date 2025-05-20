part of 'task_bloc.dart';

abstract class TaskState extends Equatable {
  const TaskState();
  
  @override
  List<Object> get props => [];
}

class TaskInitial extends TaskState {}

class TaskLoading extends TaskState {}

class TasksLoaded extends TaskState {
  final List<Tasks> tasks;

  const TasksLoaded({required this.tasks});

  @override
  List<Object> get props => [tasks];
}

class TaskLoaded extends TaskState {
  final Tasks task;

  const TaskLoaded({required this.task});

  @override
  List<Object> get props => [task];
}

class TaskAdded extends TaskState {
  final int id;

  const TaskAdded({required this.id});

  @override
  List<Object> get props => [id];
}

class TaskUpdated extends TaskState {
  final int rowsAffected;

  const TaskUpdated({required this.rowsAffected});

  @override
  List<Object> get props => [rowsAffected];
}

class TaskDeleted extends TaskState {
  final int rowsAffected;

  const TaskDeleted({required this.rowsAffected});

  @override
  List<Object> get props => [rowsAffected];
}

class TaskError extends TaskState {
  final String message;

  const TaskError({required this.message});

  @override
  List<Object> get props => [message];
}

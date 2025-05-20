part of 'task_bloc.dart';

abstract class TaskEvent extends Equatable {
  const TaskEvent();

  @override
  List<Object> get props => [];
}

class GetAllTasksEvent extends TaskEvent {}

class GetTaskByIdEvent extends TaskEvent {
  final int id;

  const GetTaskByIdEvent({required this.id});

  @override
  List<Object> get props => [id];
}

class AddTaskEvent extends TaskEvent {
  final Tasks task;

  const AddTaskEvent({required this.task});

  @override
  List<Object> get props => [task];
}

class UpdateTaskEvent extends TaskEvent {
  final Tasks task;

  const UpdateTaskEvent({required this.task});

  @override
  List<Object> get props => [task];
}

class DeleteTaskEvent extends TaskEvent {
  final int id;

  const DeleteTaskEvent({required this.id});

  @override
  List<Object> get props => [id];
}

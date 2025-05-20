import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../domain/entities/task.dart';
import '../../domain/usecases/add_task.dart';
import '../../domain/usecases/delete_task.dart';
import '../../domain/usecases/get_all_tasks.dart';
import '../../domain/usecases/get_task_by_id.dart';
import '../../domain/usecases/update_task.dart';

part 'task_event.dart';
part 'task_state.dart';

class TaskBloc extends Bloc<TaskEvent, TaskState> {
  final GetAllTasks getAllTasks;
  final GetTaskById getTaskById;
  final AddTask addTask;
  final UpdateTask updateTask;
  final DeleteTask deleteTask;

  TaskBloc({
    required this.getAllTasks,
    required this.getTaskById,
    required this.addTask,
    required this.updateTask,
    required this.deleteTask,
  }) : super(TaskInitial()) {
    on<GetAllTasksEvent>(_onGetAllTasks);
    on<GetTaskByIdEvent>(_onGetTaskById);
    on<AddTaskEvent>(_onAddTask);
    on<UpdateTaskEvent>(_onUpdateTask);
    on<DeleteTaskEvent>(_onDeleteTask);
  }

  Future<void> _onGetAllTasks(
    GetAllTasksEvent event,
    Emitter<TaskState> emit,
  ) async {
    emit(TaskLoading());
    final result = await getAllTasks();
    result.fold(
      (failure) => emit(TaskError(message: failure.message)),
      (tasks) => emit(TasksLoaded(tasks: tasks)),
    );
  }

  Future<void> _onGetTaskById(
    GetTaskByIdEvent event,
    Emitter<TaskState> emit,
  ) async {
    emit(TaskLoading());
    final result = await getTaskById(event.id);
    result.fold(
      (failure) => emit(TaskError(message: failure.message)),
      (task) => emit(TaskLoaded(task: task)),
    );
  }

  Future<void> _onAddTask(
    AddTaskEvent event,
    Emitter<TaskState> emit,
  ) async {
    emit(TaskLoading());
    final result = await addTask(event.task);
    result.fold(
      (failure) => emit(TaskError(message: failure.message)),
      (id) => emit(TaskAdded(id: id)),
    );
  }

  Future<void> _onUpdateTask(
    UpdateTaskEvent event,
    Emitter<TaskState> emit,
  ) async {
    emit(TaskLoading());
    final result = await updateTask(event.task);
    result.fold(
      (failure) => emit(TaskError(message: failure.message)),
      (rowsAffected) => emit(TaskUpdated(rowsAffected: rowsAffected)),
    );
  }

  Future<void> _onDeleteTask(
    DeleteTaskEvent event,
    Emitter<TaskState> emit,
  ) async {
    emit(TaskLoading());
    final result = await deleteTask(event.id);
    result.fold(
      (failure) => emit(TaskError(message: failure.message)),
      (rowsAffected) => emit(TaskDeleted(rowsAffected: rowsAffected)),
    );
  }
}

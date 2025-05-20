import 'package:flutter_bloc/flutter_bloc.dart';
import '../../data/datasources/local_data_source.dart';
import '../../data/repositories/task_repository_impl.dart';
import '../../domain/entities/task.dart';
import '../../domain/usecases/add_task.dart';
import '../../domain/usecases/delete_task.dart';
import '../../domain/usecases/get_all_tasks.dart';
import '../../domain/usecases/get_task_by_id.dart';
import '../../domain/usecases/update_task.dart';

abstract class TaskEvent {}

class GetAllTasksEvent extends TaskEvent {}

class GetTaskByIdEvent extends TaskEvent {
  final int id;
  GetTaskByIdEvent({required this.id});
}

class AddTaskEvent extends TaskEvent {
  final Task task;
  AddTaskEvent({required this.task});
}

class UpdateTaskEvent extends TaskEvent {
  final Task task;
  UpdateTaskEvent({required this.task});
}

class DeleteTaskEvent extends TaskEvent {
  final int id;
  DeleteTaskEvent({required this.id});
}

abstract class TaskState {}

class TaskInitial extends TaskState {}

class TaskLoading extends TaskState {}

class TasksLoaded extends TaskState {
  final List<Task> tasks;
  TasksLoaded({required this.tasks});
}

class TaskLoaded extends TaskState {
  final Task task;
  TaskLoaded({required this.task});
}

class TaskAdded extends TaskState {
  final int id;
  TaskAdded({required this.id});
}

class TaskUpdated extends TaskState {
  final int rowsAffected;
  TaskUpdated({required this.rowsAffected});
}

class TaskDeleted extends TaskState {
  final int rowsAffected;
  TaskDeleted({required this.rowsAffected});
}

class TaskError extends TaskState {
  final String message;
  TaskError({required this.message});
}


class TaskBloc extends Bloc<TaskEvent, TaskState> {
  late final GetAllTasks _getAllTasks;
  late final GetTaskById _getTaskById;
  late final AddTask _addTask;
  late final UpdateTask _updateTask;
  late final DeleteTask _deleteTask;

  TaskBloc() : super(TaskInitial()) {
    final databaseHelper = DatabaseHelper();
    final taskRepository = TaskRepositoryImpl(localDataSource: databaseHelper);
    
    _getAllTasks = GetAllTasks(taskRepository);
    _getTaskById = GetTaskById(taskRepository);
    _addTask = AddTask(taskRepository);
    _updateTask = UpdateTask(taskRepository);
    _deleteTask = DeleteTask(taskRepository);
    
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
    try {
      final tasks = await _getAllTasks();
      emit(TasksLoaded(tasks: tasks));
    } catch (e) {
      emit(TaskError(message: e.toString()));
    }
  }

  Future<void> _onGetTaskById(
    GetTaskByIdEvent event,
    Emitter<TaskState> emit,
  ) async {
    emit(TaskLoading());
    try {
      final task = await _getTaskById(event.id);
      if (task != null) {
        emit(TaskLoaded(task: task));
      } else {
        emit(TaskError(message: 'Task not found'));
      }
    } catch (e) {
      emit(TaskError(message: e.toString()));
    }
  }

  Future<void> _onAddTask(
    AddTaskEvent event,
    Emitter<TaskState> emit,
  ) async {
    emit(TaskLoading());
    try {
      final id = await _addTask(event.task);
      emit(TaskAdded(id: id));
    } catch (e) {
      emit(TaskError(message: e.toString()));
    }
  }

  Future<void> _onUpdateTask(
      UpdateTaskEvent event,
      Emitter<TaskState> emit,
      ) async {
    emit(TaskLoading());
    try {
      final rowsAffected = await _updateTask(event.task);
      if (rowsAffected > 0) {
        final tasks = await _getAllTasks();
        emit(TasksLoaded(tasks: tasks));
      } else {
        emit(TaskError(message: 'Failed to update task'));
      }
    } catch (e) {
      emit(TaskError(message: e.toString()));
    }
  }

  Future<void> _onDeleteTask(
      DeleteTaskEvent event,
      Emitter<TaskState> emit,
      ) async {
    emit(TaskLoading());
    try {
      final rowsAffected = await _deleteTask(event.id);
      if (rowsAffected > 0) {
        final tasks = await _getAllTasks();
        emit(TasksLoaded(tasks: tasks));
      } else {
        emit(TaskError(message: 'Failed to delete task'));
      }
    } catch (e) {
      emit(TaskError(message: e.toString()));
    }
  }


}

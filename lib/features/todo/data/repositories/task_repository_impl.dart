import '../../domain/entities/task.dart';
import '../../domain/repositories/task_repository.dart';
import '../datasources/local_data_source.dart';
import '../models/task_model.dart';

class TaskRepositoryImpl implements TaskRepository {
  final DatabaseHelper localDataSource;

  TaskRepositoryImpl({required this.localDataSource});

  @override
  Future<List<Task>> getAllTasks() async {
    try {
      final taskMaps = await localDataSource.queryAllTasks();
      return taskMaps.map((map) => TaskModel.fromJson(map)).toList();
    } catch (e) {
      throw Exception('Failed to get tasks: ${e.toString()}');
    }
  }

  @override
  Future<Task?> getTaskById(int id) async {
    try {
      final taskMap = await localDataSource.queryTask(id);
      if (taskMap != null) {
        return TaskModel.fromJson(taskMap);
      } else {
        return null;
      }
    } catch (e) {
      throw Exception('Failed to get task: ${e.toString()}');
    }
  }

  @override
  Future<int> addTask(Task task) async {
    try {
      final taskModel = TaskModel.fromEntity(task);
      return await localDataSource.insertTask(taskModel.toJson());
    } catch (e) {
      throw Exception('Failed to add task: ${e.toString()}');
    }
  }

  @override
  Future<int> updateTask(Task task) async {
    try {
      final taskModel = TaskModel.fromEntity(task);
      return await localDataSource.updateTask(taskModel.toJson());
    } catch (e) {
      throw Exception('Failed to update task: ${e.toString()}');
    }
  }

  @override
  Future<int> deleteTask(int id) async {
    try {
      return await localDataSource.deleteTask(id);
    } catch (e) {
      throw Exception('Failed to delete task: ${e.toString()}');
    }
  }
}

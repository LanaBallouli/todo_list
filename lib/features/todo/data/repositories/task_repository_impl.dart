import 'package:dartz/dartz.dart';

import '../../../../core/error/failures.dart';
import '../../domain/entities/task.dart';
import '../../domain/repositories/task_repository.dart';
import '../datasources/local_data_source.dart';
import '../models/task_model.dart';

class TaskRepositoryImpl implements TaskRepository {
  final DatabaseHelper localDataSource;

  TaskRepositoryImpl({required this.localDataSource});

  @override
  Future<Either<Failure, List<Task>>> getAllTasks() async {
    try {
      final taskMaps = await localDataSource.queryAllTasks();
      final tasks = taskMaps.map((map) => TaskModel.fromJson(map)).toList();
      return Right(tasks);
    } catch (e) {
      return Left(DatabaseFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, Task>> getTaskById(int id) async {
    try {
      final taskMap = await localDataSource.queryTask(id);
      if (taskMap != null) {
        return Right(TaskModel.fromJson(taskMap));
      } else {
        return Left(const DatabaseFailure(message: 'Task not found'));
      }
    } catch (e) {
      return Left(DatabaseFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, int>> addTask(Task task) async {
    try {
      final taskModel = TaskModel.fromEntity(task);
      final id = await localDataSource.insertTask(taskModel.toJson());
      return Right(id);
    } catch (e) {
      return Left(DatabaseFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, int>> updateTask(Task task) async {
    try {
      final taskModel = TaskModel.fromEntity(task);
      final rowsAffected = await localDataSource.updateTask(taskModel.toJson());
      if (rowsAffected > 0) {
        return Right(rowsAffected);
      } else {
        return Left(const DatabaseFailure(message: 'No task updated'));
      }
    } catch (e) {
      return Left(DatabaseFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, int>> deleteTask(int id) async {
    try {
      final rowsAffected = await localDataSource.deleteTask(id);
      if (rowsAffected > 0) {
        return Right(rowsAffected);
      } else {
        return Left(const DatabaseFailure(message: 'No task deleted'));
      }
    } catch (e) {
      return Left(DatabaseFailure(message: e.toString()));
    }
  }
}

import 'package:dartz/dartz.dart';

import '../../../../core/error/failures.dart';
import '../entities/task.dart';

abstract class TaskRepository {
  Future<Either<Failure, List<Task>>> getAllTasks();
  Future<Either<Failure, Task>> getTaskById(int id);
  Future<Either<Failure, int>> addTask(Task task);
  Future<Either<Failure, int>> updateTask(Task task);
  Future<Either<Failure, int>> deleteTask(int id);
}

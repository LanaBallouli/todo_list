import 'package:dartz/dartz.dart';

import '../../../../core/error/failures.dart';
import '../entities/task.dart';
import '../repositories/task_repository.dart';

class GetAllTasks {
  final TaskRepository repository;

  GetAllTasks(this.repository);

  Future<Either<Failure, List<Task>>> call() async {
    return await repository.getAllTasks();
  }
}

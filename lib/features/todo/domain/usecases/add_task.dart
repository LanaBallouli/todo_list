import 'package:dartz/dartz.dart';

import '../../../../core/error/failures.dart';
import '../entities/task.dart';
import '../repositories/task_repository.dart';

class AddTask {
  final TaskRepository repository;

  AddTask(this.repository);

  Future<Either<Failure, int>> call(Task task) async {
    return await repository.addTask(task);
  }
}

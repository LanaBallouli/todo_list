import 'package:dartz/dartz.dart';

import '../../../../core/error/failures.dart';
import '../entities/task.dart';
import '../repositories/task_repository.dart';

class GetTaskById {
  final TaskRepository repository;

  GetTaskById(this.repository);

  Future<Either<Failure, Task>> call(int id) async {
    return await repository.getTaskById(id);
  }
}
